import "dart:async";

/// 비동기 세션 리소스 설치/해제를 generation 순서로 직렬화한다.
/// initialize 도중 dispose 또는 다음 initialize가 시작되면 늦게 설치된
/// 구독을 즉시 취소해 이전 로그인 세대의 listener가 남지 않게 한다.
class AsyncSessionLifecycle {
  AsyncSessionLifecycle({
    this.cancellationTimeout = const Duration(seconds: 2),
  });

  final Duration cancellationTimeout;
  int _generation = 0;
  List<StreamSubscription<dynamic>> _subscriptions = const [];

  int get generation => _generation;
  int get activeSubscriptionCount => _subscriptions.length;

  bool isCurrent(int generation) => generation == _generation;

  Future<void> initialize(
    Future<List<StreamSubscription<dynamic>>> Function(
      int generation,
      bool Function() isCurrent,
    )
    installer,
  ) async {
    final generation = ++_generation;
    await _clearActiveSubscriptions();
    if (!isCurrent(generation)) return;

    final installed = await installer(generation, () => isCurrent(generation));
    if (!isCurrent(generation)) {
      await _cancelSubscriptions(installed);
      return;
    }

    // 다른 initialize가 활성 구독을 설치했을 수 있으므로 교체 직전에
    // 다시 가져와 취소하고, await 이후에도 현재 generation인지 확인한다.
    await _clearActiveSubscriptions();
    if (!isCurrent(generation)) {
      await _cancelSubscriptions(installed);
      return;
    }
    _subscriptions = installed;
  }

  Future<void> dispose() {
    ++_generation;
    // 진행 중 installer Future와 독립적으로 현재 설치가 끝난 구독만
    // 취소한다. 늦게 반환되는 installer 결과는 initialize 쪽에서 폐기한다.
    return _clearActiveSubscriptions();
  }

  Future<void> _clearActiveSubscriptions() {
    final active = _subscriptions;
    _subscriptions = const [];
    return _cancelSubscriptions(active);
  }

  Future<void> _cancelSubscriptions(
    Iterable<StreamSubscription<dynamic>> subscriptions,
  ) async {
    final cancellations = subscriptions.map((subscription) async {
      try {
        await subscription.cancel();
      } catch (_) {
        // 한 구독의 취소 실패가 나머지 정리를 막지 않는다.
      }
    });
    try {
      await Future.wait(cancellations).timeout(cancellationTimeout);
    } on TimeoutException {
      // plugin subscription 취소가 멈춰도 인증 전이는 bounded time에 끝낸다.
    }
  }
}
