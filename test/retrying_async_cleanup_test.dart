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

        expect(installerStarted, isTrue);
        expect(attempts, 2);
        expect(cleanup.isPending, isTrue);
        expect(persistedPending, isTrue);
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
