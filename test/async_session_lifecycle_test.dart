import "dart:async";

import "package:ensom/core/async_session_lifecycle.dart";
import "package:flutter_test/flutter_test.dart";

void main() {
  group("AsyncSessionLifecycle", () {
    test("reinitialize cancels the previous subscriptions", () async {
      final lifecycle = AsyncSessionLifecycle();
      final events = StreamController<int>.broadcast();
      var received = 0;

      Future<List<StreamSubscription<dynamic>>> install(
        int generation,
        bool Function() isCurrent,
      ) async {
        return <StreamSubscription<dynamic>>[
          events.stream.listen((_) {
            if (isCurrent()) received++;
          }),
        ];
      }

      await lifecycle.initialize(install);
      events.add(1);
      await Future<void>.delayed(Duration.zero);
      expect(received, 1);

      await lifecycle.initialize(install);
      expect(lifecycle.activeSubscriptionCount, 1);
      events.add(2);
      await Future<void>.delayed(Duration.zero);
      expect(received, 2);

      await lifecycle.dispose();
      await events.close();
    });

    test("dispose invalidates an initialize still in progress", () async {
      final lifecycle = AsyncSessionLifecycle();
      final installGate = Completer<void>();
      final installStarted = Completer<void>();
      final events = StreamController<int>.broadcast();
      var received = 0;

      final initializing = lifecycle.initialize((generation, isCurrent) async {
        installStarted.complete();
        await installGate.future;
        return <StreamSubscription<dynamic>>[
          events.stream.listen((_) {
            if (isCurrent()) received++;
          }),
        ];
      });
      await installStarted.future;

      final disposing = lifecycle.dispose();
      installGate.complete();
      await Future.wait([initializing, disposing]);

      expect(lifecycle.activeSubscriptionCount, 0);
      events.add(1);
      await Future<void>.delayed(Duration.zero);
      expect(received, 0);
      await events.close();
    });
  });
}
