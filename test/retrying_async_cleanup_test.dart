import "dart:async";

import "package:flutter_test/flutter_test.dart";
import "package:ensom/core/retrying_async_cleanup.dart";

void main() {
  group("RetryingAsyncCleanup", () {
    test("a failed cleanup is persisted and retried until success", () async {
      var persistedPending = false;
      var attempts = 0;
      final cleanup = RetryingAsyncCleanup(
        cleanup: () async {
          attempts++;
          if (attempts == 1) throw StateError("offline");
        },
        loadPending: () async => persistedPending,
        savePending: (pending) async => persistedPending = pending,
        attemptTimeout: const Duration(milliseconds: 20),
        retryDelay: const Duration(milliseconds: 10),
      );
      addTearDown(cleanup.dispose);

      await cleanup.requestCleanup();
      expect(cleanup.isPending, isTrue);
      expect(persistedPending, isTrue);

      await _waitUntil(() => attempts >= 2 && !cleanup.isPending);
      expect(attempts, 2);
      expect(persistedPending, isFalse);
    });

    test(
      "a never-completing cleanup cannot block later initialization",
      () async {
        var persistedPending = false;
        var attempts = 0;
        final cleanup = RetryingAsyncCleanup(
          cleanup: () {
            attempts++;
            return Completer<void>().future;
          },
          loadPending: () async => persistedPending,
          savePending: (pending) async => persistedPending = pending,
          attemptTimeout: const Duration(milliseconds: 20),
          retryDelay: const Duration(seconds: 1),
        );
        addTearDown(cleanup.dispose);

        await cleanup.requestCleanup().timeout(
          const Duration(milliseconds: 200),
        );
        var installerStarted = false;
        await cleanup.retryPending().timeout(const Duration(milliseconds: 200));
        installerStarted = true;

        // 호출자는 bounded time에 풀려나지만, in-flight delete가 살아 있는
        // 동안 중첩 delete를 시작하지 않는다(직렬화). 따라서 실제 attempt는 1.
        expect(installerStarted, isTrue);
        expect(attempts, 1);
        expect(cleanup.isPending, isTrue);
        expect(persistedPending, isTrue);
      },
    );

    test("a pending-load failure is not cached as no cleanup", () async {
      var persistedPending = true;
      var loadCalls = 0;
      var failNextLoad = true;
      var attempts = 0;
      final cleanup = RetryingAsyncCleanup(
        cleanup: () async => attempts++,
        loadPending: () async {
          loadCalls++;
          if (failNextLoad) {
            failNextLoad = false;
            throw StateError("prefs unavailable");
          }
          return persistedPending;
        },
        savePending: (pending) async => persistedPending = pending,
        attemptTimeout: const Duration(milliseconds: 20),
        retryDelay: const Duration(seconds: 1),
      );
      addTearDown(cleanup.dispose);

      // 첫 조회 실패 → unknown 유지, cleanup 미실행.
      await cleanup.retryPending();
      expect(loadCalls, 1);
      expect(attempts, 0);
      expect(cleanup.isPending, isFalse);

      // 같은 프로세스에서 재조회하면 pending을 다시 읽어 cleanup을 수행한다.
      await cleanup.retryPending();
      expect(loadCalls, 2);
      expect(attempts, 1);
      expect(persistedPending, isFalse);
    });

    test(
      "recovery runs once when delete completes before server rebind",
      () async {
        var persistedPending = false;
        final deleteGate = Completer<void>();
        var recoveries = 0;
        final cleanup = RetryingAsyncCleanup(
          cleanup: () => deleteGate.future,
          loadPending: () async => persistedPending,
          savePending: (pending) async => persistedPending = pending,
          attemptTimeout: const Duration(milliseconds: 20),
          retryDelay: const Duration(seconds: 1),
        );
        cleanup.setRecoveryCallback(() async => recoveries++);
        addTearDown(cleanup.dispose);

        await cleanup.requestCleanup().timeout(
          const Duration(milliseconds: 200),
        );
        // delete가 rebind보다 먼저 완료된다.
        deleteGate.complete();
        await Future<void>.delayed(const Duration(milliseconds: 20));
        expect(recoveries, 0); // 아직 rebind 없음 → 파괴적 삭제만 관찰

        await cleanup.markResolvedByServerRebind();
        await _waitUntil(() => recoveries == 1);
        expect(recoveries, 1);
        expect(cleanup.isPending, isFalse);
      },
    );

    test(
      "serialized attempts recover once across timeout and late completions",
      () async {
        // A timeout → B 시작 → rebind → A 완료/recovery → B 완료.
        // 직렬화로 실제 delete는 1회, recovery도 정확히 1회.
        var persistedPending = false;
        var deleteStarts = 0;
        final firstDelete = Completer<void>();
        final cleanup = RetryingAsyncCleanup(
          cleanup: () {
            deleteStarts++;
            return firstDelete.future;
          },
          loadPending: () async => persistedPending,
          savePending: (pending) async => persistedPending = pending,
          attemptTimeout: const Duration(milliseconds: 20),
          retryDelay: const Duration(milliseconds: 10),
        );
        var recoveries = 0;
        cleanup.setRecoveryCallback(() async => recoveries++);
        addTearDown(cleanup.dispose);

        await cleanup.requestCleanup().timeout(
          const Duration(milliseconds: 200),
        ); // attempt A timeout
        await cleanup.retryPending().timeout(
          const Duration(milliseconds: 200),
        ); // attempt B는 in-flight A에 재부착
        await cleanup.markResolvedByServerRebind(); // rebind 먼저

        firstDelete.complete(); // 살아 있던 유일한 delete 완료
        await _waitUntil(() => recoveries == 1);
        expect(deleteStarts, 1); // 중첩 delete 없음
        expect(recoveries, 1); // 단 한 번의 recovery
        expect(cleanup.isPending, isFalse);
      },
    );

    test("startup retries cleanup persisted by a previous process", () async {
      var persistedPending = true;
      var attempts = 0;
      var recoveries = 0;
      final cleanup = RetryingAsyncCleanup(
        cleanup: () async => attempts++,
        loadPending: () async => persistedPending,
        savePending: (pending) async => persistedPending = pending,
        attemptTimeout: const Duration(milliseconds: 20),
        retryDelay: const Duration(seconds: 1),
      );
      cleanup.setRecoveryCallback(() async => recoveries++);
      addTearDown(cleanup.dispose);

      await cleanup.retryPending();
      expect(attempts, 1);
      expect(cleanup.isPending, isFalse);
      expect(persistedPending, isFalse);
      expect(recoveries, 0);
    });

    test(
      "late delete after server rebind triggers token recovery once",
      () async {
        var persistedPending = false;
        final deleteGate = Completer<void>();
        var recoveries = 0;
        final cleanup = RetryingAsyncCleanup(
          cleanup: () => deleteGate.future,
          loadPending: () async => persistedPending,
          savePending: (pending) async => persistedPending = pending,
          attemptTimeout: const Duration(milliseconds: 20),
          retryDelay: const Duration(seconds: 1),
        );
        cleanup.setRecoveryCallback(() async => recoveries++);
        addTearDown(cleanup.dispose);

        await cleanup.requestCleanup();
        expect(cleanup.isPending, isTrue);
        await cleanup.markResolvedByServerRebind();
        expect(cleanup.isPending, isFalse);
        expect(persistedPending, isFalse);

        deleteGate.complete();
        await _waitUntil(() => recoveries == 1);
        expect(recoveries, 1);
      },
    );
  });
}

Future<void> _waitUntil(bool Function() predicate) async {
  final deadline = DateTime.now().add(const Duration(milliseconds: 500));
  while (!predicate()) {
    if (DateTime.now().isAfter(deadline)) {
      fail("condition was not met before timeout");
    }
    await Future<void>.delayed(const Duration(milliseconds: 5));
  }
}
