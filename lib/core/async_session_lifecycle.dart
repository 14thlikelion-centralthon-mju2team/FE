import "dart:async";

/// 비동기 세션 리소스 설치/해제를 generation 순서로 직렬화한다.
/// initialize 도중 dispose 또는 다음 initialize가 시작되면 늦게 설치된
/// 구독을 즉시 취소해 이전 로그인 세대의 listener가 남지 않게 한다.
class AsyncSessionLifecycle {
  int _generation = 0;
  Future<void> _tail = Future<void>.value();
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
  ) {
    final generation = ++_generation;
    return _enqueue(() async {
      await _cancelSubscriptions(_subscriptions);
      _subscriptions = const [];
      if (!isCurrent(generation)) return;

      final installed = await installer(
        generation,
        () => isCurrent(generation),
      );
      if (!isCurrent(generation)) {
        await _cancelSubscriptions(installed);
        return;
      }
      _subscriptions = installed;
    });
  }

  Future<void> dispose() {
    ++_generation;
    return _enqueue(() async {
      await _cancelSubscriptions(_subscriptions);
      _subscriptions = const [];
    });
  }

  Future<void> _enqueue(Future<void> Function() operation) {
    final completer = Completer<void>();
    _tail = _tail.catchError((_) {}).then((_) async {
      try {
        await operation();
        completer.complete();
      } catch (error, stackTrace) {
        completer.completeError(error, stackTrace);
      }
    });
    return completer.future;
  }

  Future<void> _cancelSubscriptions(
    Iterable<StreamSubscription<dynamic>> subscriptions,
  ) async {
    for (final subscription in subscriptions) {
      try {
        await subscription.cancel();
      } catch (_) {
        // 한 구독의 취소 실패가 나머지 정리를 막지 않는다.
      }
    }
  }
}
