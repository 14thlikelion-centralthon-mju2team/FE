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

    test(
      "dispose does not wait for an installer that never completes",
      () async {
        final lifecycle = AsyncSessionLifecycle(
          cancellationTimeout: const Duration(milliseconds: 20),
        );
        final installStarted = Completer<void>();
        final neverInstalled = Completer<List<StreamSubscription<dynamic>>>();

        final initializing = lifecycle.initialize((generation, isCurrent) {
          installStarted.complete();
          return neverInstalled.future;
        });
        unawaited(initializing);
        await installStarted.future;

        await lifecycle.dispose().timeout(const Duration(milliseconds: 200));

        expect(lifecycle.activeSubscriptionCount, 0);
        expect(lifecycle.generation, 2);
      },
    );

    test(
      "dispose times out a subscription cancel that never completes",
      () async {
        final lifecycle = AsyncSessionLifecycle(
          cancellationTimeout: const Duration(milliseconds: 20),
        );
        final cancelGate = Completer<void>();
        final events = StreamController<int>(onCancel: () => cancelGate.future);

        await lifecycle.initialize((generation, isCurrent) async {
          return <StreamSubscription<dynamic>>[events.stream.listen((_) {})];
        });

        await lifecycle.dispose().timeout(const Duration(milliseconds: 200));

        expect(lifecycle.activeSubscriptionCount, 0);
        cancelGate.complete();
        await events.close();
      },
    );

    test(
      "device cleanup is invoked and bounded by the lifecycle timeout",
      () async {
        final lifecycle = AsyncSessionLifecycle(
          cancellationTimeout: const Duration(milliseconds: 20),
        );
        final cleanupStarted = Completer<void>();
        final cleanupGate = Completer<void>();

        await lifecycle
            .dispose(
              deviceCleanup: () {
                cleanupStarted.complete();
                return cleanupGate.future;
              },
            )
            .timeout(const Duration(milliseconds: 200));

        expect(cleanupStarted.isCompleted, isTrue);
        expect(lifecycle.generation, 1);
        cleanupGate.complete();
      },
    );

    test("initialize waits for the actual timed-out device cleanup", () async {
      final lifecycle = AsyncSessionLifecycle(
        cancellationTimeout: const Duration(milliseconds: 20),
      );
      final cleanupGate = Completer<void>();
      await lifecycle.dispose(deviceCleanup: () => cleanupGate.future);

      var installerStarted = false;
      final initializing = lifecycle.initialize((generation, isCurrent) async {
        installerStarted = true;
        return const <StreamSubscription<dynamic>>[];
      });
      await Future<void>.delayed(Duration.zero);
      expect(installerStarted, isFalse);

      cleanupGate.complete();
      await initializing;
      expect(installerStarted, isTrue);
    });
  });
}
