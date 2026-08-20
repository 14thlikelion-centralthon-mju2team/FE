import "dart:async";

/// 네트워크 의존 cleanup을 인증 상태 전이와 분리해 영속적으로 재시도한다.
///
/// 각 attempt는 [attemptTimeout]까지만 호출자를 기다리게 하고, 실패/timeout은
/// [retryDelay] 뒤 다시 시도한다. 새 session이 같은 device를 서버에 rebind하면
/// pending 상태를 해제할 수 있고, 이미 진행 중이던 cleanup이 늦게 성공하면
/// recovery callback으로 새 token을 다시 등록한다.
///
/// 불변조건:
/// - pending 상태 load가 실패(throw/timeout)하면 "cleanup 없음"으로 캐시하지
///   않는다. unknown으로 두고 bounded timer로 스스로 재조회한다.
/// - cleanup request는 [_CleanupRequest]로 캡슐화하며 in-flight delete와 retry
///   timer, completion 상태를 request별로 소유한다. request가 교체되면 새
///   request가 자신의 delete/timer를 독립적으로 소유하고, 이전 request의 늦은
///   completion은 그 request의 handler가 안전하게 인계한다.
/// - server rebind와 destructive delete 완료 중 어느 쪽이 먼저 발생하든, 두
///   이벤트가 모두 관찰된 뒤 정확히 한 번 최신 token을 재등록한다.
/// - pending persistence write는 단조 증가 version으로 보호한 단일 직렬 큐에서
///   수행해, 오래된 write가 최신 상태를 덮어쓰지 않는다.
/// - 진행 중 delete가 오류로 끝나더라도 대기 중인 호출자(FCM initialize 등)로
///   오류를 전파하지 않고 내부 retry 상태로 흡수한다.
class RetryingAsyncCleanup {
  RetryingAsyncCleanup({
    required Future<void> Function() cleanup,
    required Future<bool> Function() loadPending,
    required Future<void> Function(bool pending) savePending,
    this.attemptTimeout = const Duration(seconds: 2),
    this.retryDelay = const Duration(seconds: 5),
    this.loadRetryDelay = const Duration(seconds: 5),
  }) : _cleanup = cleanup,
       _loadPending = loadPending,
       _savePending = savePending;

  final Future<void> Function() _cleanup;
  final Future<bool> Function() _loadPending;
  final Future<void> Function(bool pending) _savePending;
  final Duration attemptTimeout;
  final Duration retryDelay;
  final Duration loadRetryDelay;

  /// 현재 활성 cleanup request. null이면 pending 없음.
  _CleanupRequest? _current;

  /// delete가 rebind보다 먼저 완료되어 _current에서 비워졌지만 아직 rebind
  /// 결합을 기다리는 request. rebind가 나중에 와도 recovery를 결합한다.
  _CleanupRequest? _awaitingRebind;

  /// pending 값을 신뢰할 수 있게 load했는지. load가 throw/timeout하면 false로
  /// 두어 다음 조회가 다시 읽게 한다("cleanup 없음"으로 캐시 금지).
  bool _pendingLoaded = false;

  /// unknown load를 스스로 재조회하기 위한 bounded timer.
  Timer? _loadRetryTimer;

  int _requestSeq = 0;
  Future<void> Function()? _recoveryCallback;

  // ─── version-guarded 직렬 persistence ───────────────────────────
  int _persistVersion = 0;
  bool _persistTarget = false;
  bool _persistTargetSet = false;
  bool _persistDraining = false;
  bool _disposed = false;

  bool get isPending => _current != null;

  void setRecoveryCallback(Future<void> Function()? callback) {
    _recoveryCallback = callback;
  }

  Future<void> requestCleanup() async {
    final request = _startNewRequest();
    _persistPending(true);
    await _attempt(request);
  }

  Future<void> retryPending() async {
    if (!_pendingLoaded) {
      final loaded = await _loadPendingBounded();
      if (loaded == null) {
        // load 실패 — unknown. 캐시하지 않고 bounded timer로 자가 재조회한다.
        _scheduleLoadRetry();
        return;
      }
      _pendingLoaded = true;
      if (loaded && _current == null) {
        _startNewRequest();
      }
    }
    final request = _current;
    if (request == null) return;
    await _attempt(request);
  }

  /// 새 session의 push-device 등록이 성공하면 이전 사용자와의 서버 연결은
  /// 해제된 것으로 간주한다. 다만 이미 진행 중인 destructive delete가 늦게
  /// 끝나면 방금 등록한 token까지 지울 수 있으므로, delete 완료와 결합해
  /// 정확히 한 번 최신 token을 재등록한다.
  Future<void> markResolvedByServerRebind() async {
    _pendingLoaded = true;
    final request = _current ?? _awaitingRebind;
    if (request == null) return;
    request.resolvedByRebind = true;
    request.retryTimer?.cancel();
    request.retryTimer = null;
    if (identical(_current, request)) {
      _current = null;
      _persistPending(false);
    }
    await _maybeRecover(request);
  }

  _CleanupRequest _startNewRequest() {
    // 이전 request의 retry/load timer를 정리한다. 이전 in-flight Future는
    // 그 request 객체가 계속 소유하므로 late completion은 자체 handler가
    // 처리한다(새 request 상태를 오염시키지 않는다).
    _current?.retryTimer?.cancel();
    _current?.retryTimer = null;
    _loadRetryTimer?.cancel();
    _loadRetryTimer = null;

    _pendingLoaded = true;
    final request = _CleanupRequest(++_requestSeq);
    _current = request;
    return request;
  }

  Future<void> _attempt(_CleanupRequest request) async {
    if (!identical(_current, request)) return;

    // 같은 request의 in-flight delete가 있으면 새 delete를 시작하지 않고 그
    // Future에 재부착한다. timeout으로 호출자를 풀어주되 실제 delete는 직렬로
    // 한 번만 수행한다. 진행 중 delete가 오류로 끝나도 호출자에게 전파하지
    // 않고 내부 retry로 흡수한다(FCM initialize 비중단).
    final existing = request.inFlight;
    if (existing != null) {
      try {
        await existing.timeout(attemptTimeout);
      } on TimeoutException {
        _scheduleRetry(request);
      } catch (_) {
        // 오류는 request의 completion handler가 이미 retry로 흡수했다.
      }
      return;
    }

    final attempt = Future<void>.sync(_cleanup);
    request.inFlight = attempt;
    unawaited(
      attempt.then(
        (_) => _handleDeleteComplete(request),
        onError: (Object _, StackTrace _) => _handleDeleteError(request),
      ),
    );
    try {
      await attempt.timeout(attemptTimeout);
    } on TimeoutException {
      _scheduleRetry(request);
    } catch (_) {
      // 실제 오류는 _handleDeleteError에서 처리한다.
    }
  }

  Future<void> _handleDeleteComplete(_CleanupRequest request) async {
    request.inFlight = null;
    request.deleteCompleted = true;
    request.retryTimer?.cancel();
    request.retryTimer = null;
    if (identical(_current, request)) {
      _current = null;
      _persistPending(false);
    }
    // rebind가 아직 안 왔으면 이 request를 보존해 나중에 결합한다. 단, 이미
    // 다른 request가 rebind를 기다리고 있으면 가장 최근 완료 request만 남긴다
    // (이전 대기 request는 rebind 없이 완료된 것이므로 recovery 대상 아님).
    if (!request.resolvedByRebind && !request.recoveryDone) {
      _awaitingRebind = request;
    }
    await _maybeRecover(request);
  }

  void _handleDeleteError(_CleanupRequest request) {
    request.inFlight = null;
    if (identical(_current, request)) {
      _scheduleRetry(request);
    }
  }

  /// server rebind와 destructive delete가 모두 관찰된 뒤 정확히 한 번 최신
  /// token을 재등록한다. 두 이벤트의 도착 순서와 무관하다.
  Future<void> _maybeRecover(_CleanupRequest request) async {
    if (request.recoveryDone) return;
    if (!(request.resolvedByRebind && request.deleteCompleted)) return;
    request.recoveryDone = true;
    if (identical(_awaitingRebind, request)) _awaitingRebind = null;
    final recovery = _recoveryCallback;
    if (recovery == null) return;
    try {
      await recovery();
    } catch (_) {
      // recovery 실패는 다음 로그인/토큰 refresh 등록에서 다시 복구한다.
    }
  }

  void _scheduleRetry(_CleanupRequest request) {
    if (!identical(_current, request) || request.retryTimer != null) return;
    request.retryTimer = Timer(retryDelay, () {
      request.retryTimer = null;
      if (!identical(_current, request)) return;
      unawaited(_attempt(request));
    });
  }

  void _scheduleLoadRetry() {
    if (_disposed || _pendingLoaded || _loadRetryTimer != null) return;
    _loadRetryTimer = Timer(loadRetryDelay, () {
      _loadRetryTimer = null;
      if (_disposed || _pendingLoaded) return;
      unawaited(retryPending());
    });
  }

  /// pending 값을 읽는다. 성공하면 bool, 실패(throw/timeout)하면 null을 반환해
  /// 호출자가 unknown으로 처리하게 한다.
  Future<bool?> _loadPendingBounded() async {
    try {
      return await _loadPending().timeout(attemptTimeout);
    } catch (_) {
      return null;
    }
  }

  /// pending 영속 write를 단일 drain 루프로 직렬화한다. 항상 "가장 최신
  /// 목표 상태"만 반영하므로, 오래된 write가 진행 중이더라도 완료 후 목표가
  /// 바뀌었으면 최신 목표값으로 다시 쓴다. 메모리와 disk가 역전되지 않는다.
  void _persistPending(bool pending) {
    _persistVersion++;
    _persistTarget = pending;
    _persistTargetSet = true;
    if (_persistDraining) return;
    _persistDraining = true;
    unawaited(_drainPersist());
  }

  Future<void> _drainPersist() async {
    while (_persistTargetSet && !_disposed) {
      final versionAtWrite = _persistVersion;
      final target = _persistTarget;
      _persistTargetSet = false;
      try {
        await _savePending(target).timeout(attemptTimeout);
      } catch (_) {
        // 영속 저장 실패가 cleanup attempt나 인증 전이를 막지 않는다.
      }
      // write 도중 더 최신 목표가 생겼으면 루프가 다시 최신값을 반영한다.
      if (versionAtWrite != _persistVersion) {
        _persistTargetSet = true;
      }
    }
    _persistDraining = false;
  }

  void dispose() {
    _disposed = true;
    _current?.retryTimer?.cancel();
    _current?.retryTimer = null;
    _loadRetryTimer?.cancel();
    _loadRetryTimer = null;
    _recoveryCallback = null;
  }
}

/// 단일 cleanup request의 수명주기 상태를 소유한다. request가 교체되면 새
/// 객체로 완전히 대체되어, 이전 request의 in-flight delete와 retry timer가
/// 새 request 상태를 오염시키지 않는다.
class _CleanupRequest {
  _CleanupRequest(this.id);

  final int id;

  /// 이 request의 실제 in-flight delete Future.
  Future<void>? inFlight;

  /// 이 request 전용 retry timer.
  Timer? retryTimer;

  /// destructive delete가 실제로 완료됐는지.
  bool deleteCompleted = false;

  /// server rebind로 해소됐는지.
  bool resolvedByRebind = false;

  /// rebind+delete 결합 recovery를 이미 실행했는지.
  bool recoveryDone = false;
}
