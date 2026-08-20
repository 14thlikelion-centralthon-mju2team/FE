import "dart:async";

/// 네트워크 의존 cleanup을 인증 상태 전이와 분리해 영속적으로 재시도한다.
///
/// 각 attempt는 [attemptTimeout]까지만 호출자를 기다리게 하고, 실패/timeout은
/// [retryDelay] 뒤 다시 시도한다. 새 session이 같은 device를 서버에 rebind하면
/// pending 상태를 해제할 수 있고, 이미 진행 중이던 cleanup이 늦게 성공하면
/// recovery callback으로 새 token을 다시 등록한다.
///
/// 불변조건:
/// - pending 상태 load가 실패하면 "cleanup 없음"으로 캐시하지 않고 unknown으로
///   두어 다음 retryPending()/timer가 다시 읽는다.
/// - 같은 cleanup request의 실제 attempt는 직렬화한다. timeout으로 호출자를
///   풀어주더라도 in-flight Future가 끝나기 전에는 다음 attempt를 시작하지
///   않는다.
/// - server rebind와 destructive delete 완료 중 어느 쪽이 먼저 발생하든,
///   두 이벤트가 모두 관찰된 뒤 정확히 한 번 최신 token을 재등록한다.
class RetryingAsyncCleanup {
  RetryingAsyncCleanup({
    required Future<void> Function() cleanup,
    required Future<bool> Function() loadPending,
    required Future<void> Function(bool pending) savePending,
    this.attemptTimeout = const Duration(seconds: 2),
    this.retryDelay = const Duration(seconds: 5),
  }) : _cleanup = cleanup,
       _loadPending = loadPending,
       _savePending = savePending;

  final Future<void> Function() _cleanup;
  final Future<bool> Function() _loadPending;
  final Future<void> Function(bool pending) _savePending;
  final Duration attemptTimeout;
  final Duration retryDelay;

  bool _pending = false;

  /// pending 값을 신뢰할 수 있게 load했는지. load가 throw/timeout하면 false로
  /// 남겨 다음 retryPending()이 다시 읽게 한다("cleanup 없음"으로 캐시 금지).
  bool _pendingLoaded = false;

  int _requestId = 0;

  /// 현재 request에서 실제 in-flight인 attempt Future. 살아 있으면 새 attempt를
  /// 시작하지 않고 이 Future의 완료에 후속 처리를 연결한다.
  Future<void>? _inFlight;

  /// 현재 request의 destructive delete가 실제로 완료됐는지.
  bool _deleteCompleted = false;

  /// 현재 request가 server rebind로 해소됐는지.
  bool _resolvedByServerRebind = false;

  /// 현재 request에서 rebind+delete 결합 recovery를 이미 실행했는지.
  bool _recoveryDone = false;

  Timer? _retryTimer;
  Future<void> Function()? _recoveryCallback;

  bool get isPending => _pending;

  void setRecoveryCallback(Future<void> Function()? callback) {
    _recoveryCallback = callback;
  }

  Future<void> requestCleanup() async {
    _startNewRequest(pending: true);
    await _persistPending(true);
    await _attempt(_requestId);
  }

  Future<void> retryPending() async {
    if (!_pendingLoaded) {
      final loaded = await _loadPending2();
      if (loaded == null) {
        // load 실패 — unknown으로 유지한다. _pendingLoaded를 세우지 않아
        // 다음 retryPending()이 다시 읽는다.
        return;
      }
      _pendingLoaded = true;
      if (loaded && !_pending) {
        _startNewRequest(pending: true);
      }
    }
    if (!_pending) return;
    await _attempt(_requestId);
  }

  /// 새 session의 push-device 등록이 성공하면 이전 사용자와의 서버 연결은
  /// 해제된 것으로 간주한다. 다만 이미 진행 중인 destructive delete가 늦게
  /// 끝나면 방금 등록한 token까지 지울 수 있으므로, delete 완료와 결합해
  /// 정확히 한 번 최신 token을 재등록한다.
  Future<void> markResolvedByServerRebind() async {
    _resolvedByServerRebind = true;
    _pending = false;
    _pendingLoaded = true;
    _retryTimer?.cancel();
    _retryTimer = null;
    await _persistPending(false);
    await _maybeRecover();
  }

  void _startNewRequest({required bool pending}) {
    _pending = pending;
    _pendingLoaded = true;
    _requestId++;
    _deleteCompleted = false;
    _resolvedByServerRebind = false;
    _recoveryDone = false;
  }

  Future<void> _attempt(int requestId) async {
    if (!_pending || requestId != _requestId) return;

    // 같은 request의 in-flight attempt가 있으면 새 delete를 시작하지 않는다.
    // timeout으로 호출자를 풀어주되 실제 delete는 직렬로 한 번만 수행한다.
    final existing = _inFlight;
    if (existing != null) {
      try {
        await existing.timeout(attemptTimeout);
      } on TimeoutException {
        _scheduleRetry(requestId);
      }
      return;
    }

    final attempt = Future<void>.sync(_cleanup);
    _inFlight = attempt;
    unawaited(
      attempt.then(
        (_) => _handleDeleteComplete(requestId),
        onError: (Object _, StackTrace _) => _handleDeleteError(requestId),
      ),
    );
    try {
      await attempt.timeout(attemptTimeout);
    } on TimeoutException {
      // in-flight는 유지된다. 후속 attempt는 위 branch에서 이 Future에
      // 다시 붙으므로 중첩 delete가 생기지 않는다.
      _scheduleRetry(requestId);
    } catch (_) {
      // 실제 오류는 _handleDeleteError에서 처리한다.
    }
  }

  Future<void> _handleDeleteComplete(int requestId) async {
    if (requestId != _requestId) return;
    _inFlight = null;
    _deleteCompleted = true;
    _pending = false;
    _retryTimer?.cancel();
    _retryTimer = null;
    await _persistPending(false);
    await _maybeRecover();
  }

  void _handleDeleteError(int requestId) {
    if (requestId != _requestId) return;
    _inFlight = null;
    _scheduleRetry(requestId);
  }

  /// server rebind와 destructive delete가 모두 관찰된 뒤 정확히 한 번
  /// 최신 token을 재등록한다. 두 이벤트의 도착 순서와 무관하다.
  Future<void> _maybeRecover() async {
    if (_recoveryDone) return;
    if (!(_resolvedByServerRebind && _deleteCompleted)) return;
    _recoveryDone = true;
    final recovery = _recoveryCallback;
    if (recovery == null) return;
    try {
      await recovery();
    } catch (_) {
      // recovery 실패는 다음 로그인/토큰 refresh 등록에서 다시 복구한다.
    }
  }

  void _scheduleRetry(int requestId) {
    if (!_pending || requestId != _requestId || _retryTimer != null) return;
    _retryTimer = Timer(retryDelay, () {
      _retryTimer = null;
      if (!_pending || requestId != _requestId) return;
      unawaited(_attempt(requestId));
    });
  }

  /// pending 값을 읽는다. 성공하면 bool, 실패(throw/timeout)하면 null을 반환해
  /// 호출자가 unknown으로 처리하게 한다.
  Future<bool?> _loadPending2() async {
    try {
      return await _loadPending().timeout(attemptTimeout);
    } catch (_) {
      return null;
    }
  }

  Future<void> _persistPending(bool pending) async {
    try {
      await _savePending(pending).timeout(attemptTimeout);
    } catch (_) {
      // 영속 저장 실패가 cleanup attempt나 인증 전이를 막지 않는다.
    }
  }

  void dispose() {
    _retryTimer?.cancel();
    _retryTimer = null;
    _recoveryCallback = null;
  }
}
