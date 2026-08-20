import "dart:async";

/// 네트워크 의존 cleanup을 인증 상태 전이와 분리해 영속적으로 재시도한다.
///
/// 각 attempt는 [attemptTimeout]까지만 호출자를 기다리게 하고, 실패/timeout은
/// [retryDelay] 뒤 다시 시도한다. 새 session이 같은 device를 서버에 rebind하면
/// pending 상태를 해제할 수 있고, 이미 진행 중이던 cleanup이 늦게 성공하면
/// recovery callback으로 새 token을 다시 등록한다.
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
  bool _loaded = false;
  int _requestId = 0;
  bool _successHandled = false;
  bool _resolvedByServerRebind = false;
  Timer? _retryTimer;
  Future<void> Function()? _recoveryCallback;

  bool get isPending => _pending;

  void setRecoveryCallback(Future<void> Function()? callback) {
    _recoveryCallback = callback;
  }

  Future<void> requestCleanup() async {
    _loaded = true;
    _pending = true;
    _successHandled = false;
    _resolvedByServerRebind = false;
    _requestId++;
    await _persistPending(true);
    await _attempt(_requestId);
  }

  Future<void> retryPending() async {
    if (!_loaded) {
      _pending = await _loadPendingBestEffort();
      _loaded = true;
      if (_pending) {
        _successHandled = false;
        _requestId++;
      }
    }
    if (!_pending) return;
    await _attempt(_requestId);
  }

  /// 새 session의 push-device 등록이 성공하면 이전 사용자와의 서버 연결은
  /// 해제된 것으로 간주한다. 진행 중 delete가 늦게 성공할 수 있으므로 해당
  /// attempt의 completion callback은 유지해 새 token recovery를 허용한다.
  Future<void> markResolvedByServerRebind() async {
    _resolvedByServerRebind = true;
    _pending = false;
    _retryTimer?.cancel();
    _retryTimer = null;
    await _persistPending(false);
  }

  Future<void> _attempt(int requestId) async {
    if (!_pending) return;
    final actual = Future<void>.sync(_cleanup);
    unawaited(
      actual.then(
        (_) => _handleSuccess(requestId),
        onError: (Object _, StackTrace _) => _scheduleRetry(requestId),
      ),
    );
    try {
      await actual.timeout(attemptTimeout);
    } on TimeoutException {
      _scheduleRetry(requestId);
    } catch (_) {
      _scheduleRetry(requestId);
    }
  }

  Future<void> _handleSuccess(int requestId) async {
    if (requestId != _requestId || _successHandled) return;
    _successHandled = true;
    _pending = false;
    _retryTimer?.cancel();
    _retryTimer = null;
    await _persistPending(false);
    final recovery = _resolvedByServerRebind ? _recoveryCallback : null;
    if (recovery != null) {
      try {
        await recovery();
      } catch (_) {
        // recovery 실패는 다음 로그인/토큰 refresh 등록에서 다시 복구한다.
      }
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

  Future<bool> _loadPendingBestEffort() async {
    try {
      return await _loadPending().timeout(attemptTimeout);
    } catch (_) {
      return false;
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
