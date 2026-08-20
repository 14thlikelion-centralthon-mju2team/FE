import "dart:async";

import "package:ensom/core/retrying_async_cleanup.dart";
import "package:flutter_test/flutter_test.dart";

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
      await _settle();
      expect(persistedPending, isFalse);
    });

    test("a never-completing cleanup does not start nested deletes", () async {
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

      await cleanup.requestCleanup().timeout(const Duration(milliseconds: 200));
      await cleanup.retryPending().timeout(const Duration(milliseconds: 200));

      // in-flight delete가 살아 있는 동안 중첩 delete를 시작하지 않는다.
      expect(attempts, 1);
      expect(cleanup.isPending, isTrue);
      expect(persistedPending, isTrue);
    });

    // ─── [P1] pending load 실패 자체를 자동 재시도 ─────────────────
    test(
      "an unknown pending-load retries itself without an external second call",
      () async {
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
          loadRetryDelay: const Duration(milliseconds: 15),
        );
        addTearDown(cleanup.dispose);

        // startup 경로처럼 retryPending()을 한 번만 호출한다.
        await cleanup.retryPending();
        expect(loadCalls, 1);
        expect(attempts, 0);

        // 외부의 두 번째 호출 없이, 내부 timer가 스스로 재조회해 cleanup 수행.
        await _waitUntil(() => attempts == 1);
        expect(loadCalls, greaterThanOrEqualTo(2));
        await _settle();
        expect(persistedPending, isFalse);
      },
    );

    // ─── [P1] request 교체 경계: late completion 인계 ──────────────
    test(
      "a replacing requestCleanup owns its own delete after the previous times out",
      () async {
        var persistedPending = false;
        final gates = <Completer<void>>[];
        var starts = 0;
        final cleanup = RetryingAsyncCleanup(
          cleanup: () {
            starts++;
            final gate = Completer<void>();
            gates.add(gate);
            return gate.future;
          },
          loadPending: () async => persistedPending,
          savePending: (pending) async => persistedPending = pending,
          attemptTimeout: const Duration(milliseconds: 20),
          retryDelay: const Duration(milliseconds: 10),
        );
        addTearDown(cleanup.dispose);

        // request 1(logout A): delete D1 timeout된 채 진행 중.
        await cleanup.requestCleanup().timeout(
          const Duration(milliseconds: 200),
        );
        expect(starts, 1);

        // request 2(logout B): 새 requestCleanup — 자체 delete를 소유해야 한다.
        await cleanup.requestCleanup().timeout(
          const Duration(milliseconds: 200),
        );

        // 이전 D1이 늦게 끝나도 request 2가 새 delete를 시작/완료할 수 있어야
        // pending이 영구 고정되지 않는다.
        gates[0].complete(); // D1 late completion
        await _waitUntil(() => starts >= 2);
        gates[1].complete(); // D2 완료
        await _waitUntil(() => !cleanup.isPending);
        expect(cleanup.isPending, isFalse);
        await _settle();
        expect(persistedPending, isFalse);
      },
    );

    // ─── [P1] persistence 직렬화/version 보호 ─────────────────────
    test(
      "stale pending-write cannot overwrite the newer request state",
      () async {
        var persisted = false;
        final firstSaveGate = Completer<void>();
        var gateUsed = false;
        final writes = <bool>[];
        final cleanup = RetryingAsyncCleanup(
          cleanup: () => Completer<void>().future, // never completes
          loadPending: () async => persisted,
          savePending: (pending) async {
            if (!gateUsed) {
              // 첫 write(request 1의 pending=true)를 붙잡아 뒤늦게 끝낸다.
              gateUsed = true;
              await firstSaveGate.future;
            }
            writes.add(pending);
            persisted = pending;
          },
          attemptTimeout: const Duration(milliseconds: 20),
          retryDelay: const Duration(seconds: 1),
        );
        addTearDown(cleanup.dispose);

        // request 1: save(true) 시작 → gate에 붙잡힘.
        await cleanup.requestCleanup().timeout(
          const Duration(milliseconds: 200),
        );
        // rebind로 해소 → 목표 false. 아직 첫 write가 gate에 붙잡혀 미완.
        await cleanup.markResolvedByServerRebind();
        // request 2: 새 cleanup → 목표 true(끝나지 않는 delete).
        await cleanup.requestCleanup().timeout(
          const Duration(milliseconds: 200),
        );

        // 붙잡아 둔 첫 write를 이제 완료시킨다. drain은 항상 최신 목표를
        // 반영하므로 최종 persisted는 request 2의 true여야 한다.
        firstSaveGate.complete();
        await _settle(const Duration(milliseconds: 40));

        expect(cleanup.isPending, isTrue);
        expect(persisted, isTrue);
        // 마지막으로 기록된 값이 최신 목표(true)와 일치한다.
        expect(writes.isNotEmpty, isTrue);
        expect(writes.last, isTrue);
      },
    );

    // ─── [P1] in-flight delete 오류가 대기 호출자로 전파되지 않음 ──
    test(
      "an in-flight delete error is absorbed and does not propagate to waiters",
      () async {
        var persistedPending = false;
        final firstDelete = Completer<void>();
        var starts = 0;
        final cleanup = RetryingAsyncCleanup(
          cleanup: () {
            starts++;
            if (starts == 1) return firstDelete.future;
            return Future<void>.value();
          },
          loadPending: () async => persistedPending,
          savePending: (pending) async => persistedPending = pending,
          attemptTimeout: const Duration(milliseconds: 20),
          retryDelay: const Duration(milliseconds: 10),
        );
        addTearDown(cleanup.dispose);

        // requestCleanup timeout → 대기 호출자(initialize의 retryPending 등)가
        // 같은 in-flight Future에 attach.
        await cleanup.requestCleanup().timeout(
          const Duration(milliseconds: 200),
        );
        final waiter = cleanup.retryPending();

        // 기존 Future가 오류로 끝나도 waiter로 전파되지 않아야 한다.
        firstDelete.completeError(StateError("delete failed"));
        await expectLater(
          waiter.timeout(const Duration(milliseconds: 200)),
          completes,
        );

        // 내부 retry로 흡수 → 이후 재시도로 cleanup 성공, pending 해제.
        await _waitUntil(() => !cleanup.isPending);
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
      await _settle();
      expect(persistedPending, isFalse);
      expect(recoveries, 0);
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
        deleteGate.complete(); // delete가 rebind보다 먼저 완료
        await Future<void>.delayed(const Duration(milliseconds: 20));
        expect(recoveries, 0);

        await cleanup.markResolvedByServerRebind();
        await _waitUntil(() => recoveries == 1);
        expect(recoveries, 1);
        expect(cleanup.isPending, isFalse);
      },
    );

    test(
      "recovery runs once when server rebind precedes the late delete",
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
        await cleanup.markResolvedByServerRebind(); // rebind 먼저
        deleteGate.complete(); // late delete
        await _waitUntil(() => recoveries == 1);
        expect(recoveries, 1);
        expect(cleanup.isPending, isFalse);
      },
    );

    // 다중 미해결 request 경계: 이전 request가 rebind 없이 완료된 뒤 새
    // request가 rebind되면, recovery는 최신(현재) request에 대해 정확히 한 번만.
    test(
      "recovery binds to the current request across successive cleanups",
      () async {
        var persistedPending = false;
        final gates = <Completer<void>>[];
        var recoveries = 0;
        final cleanup = RetryingAsyncCleanup(
          cleanup: () {
            final gate = Completer<void>();
            gates.add(gate);
            return gate.future;
          },
          loadPending: () async => persistedPending,
          savePending: (pending) async => persistedPending = pending,
          attemptTimeout: const Duration(milliseconds: 20),
          retryDelay: const Duration(milliseconds: 10),
        );
        cleanup.setRecoveryCallback(() async => recoveries++);
        addTearDown(cleanup.dispose);

        // request 1: delete D1 timeout된 채 진행.
        await cleanup.requestCleanup().timeout(
          const Duration(milliseconds: 200),
        );
        // request 2 교체.
        await cleanup.requestCleanup().timeout(
          const Duration(milliseconds: 200),
        );
        // 이전 D1이 rebind 없이 완료(recovery 대상 아님).
        gates[0].complete();
        await _settle(const Duration(milliseconds: 20));
        expect(recoveries, 0);

        // request 2가 rebind + delete 완료 → recovery 정확히 1회.
        await cleanup.markResolvedByServerRebind();
        await _waitUntil(() => gates.length >= 2);
        gates[1].complete();
        await _waitUntil(() => recoveries == 1);
        expect(recoveries, 1);
        expect(cleanup.isPending, isFalse);
      },
    );
    // ─── [P1] requestCleanup은 pending write 완료 후 반환(crash-safety) ──
    test(
      "requestCleanup awaits the pending write even when it is delayed",
      () async {
        var persisted = false;
        final saveGate = Completer<void>();
        var firstSave = true;
        final cleanup = RetryingAsyncCleanup(
          cleanup: () => Completer<void>().future, // never completes
          loadPending: () async => persisted,
          savePending: (pending) async {
            if (firstSave) {
              firstSave = false;
              await saveGate.future; // 로그아웃 write를 지연.
            }
            persisted = pending;
          },
          attemptTimeout: const Duration(milliseconds: 20),
          retryDelay: const Duration(seconds: 1),
        );
        addTearDown(cleanup.dispose);

        var returned = false;
        final future = cleanup.requestCleanup().then((_) => returned = true);

        // write가 아직 디스크에 닿지 않았으면 requestCleanup은 반환하지 않는다.
        await _settle(const Duration(milliseconds: 30));
        expect(returned, isFalse);
        expect(persisted, isFalse);

        // write가 완료되면 그제서야 반환하며, 이때 pending=true가 영속화돼 있다.
        saveGate.complete();
        await future.timeout(const Duration(milliseconds: 200));
        expect(returned, isTrue);
        expect(persisted, isTrue);
        expect(cleanup.isPending, isTrue);
      },
    );

    // ─── [P1] unknown load + rebind → 디스크 pending 고아 방지 ────
    test(
      "server rebind during unknown load clears the persisted pending flag",
      () async {
        var persisted = true; // 이전 프로세스가 남긴 플래그.
        var loadCalls = 0;
        final cleanup = RetryingAsyncCleanup(
          cleanup: () async {},
          loadPending: () async {
            loadCalls++;
            // 이 시나리오 내내 SharedPreferences read가 실패한다.
            throw StateError("prefs unavailable");
          },
          savePending: (pending) async => persisted = pending,
          attemptTimeout: const Duration(milliseconds: 20),
          retryDelay: const Duration(seconds: 1),
          loadRetryDelay: const Duration(seconds: 30),
        );
        addTearDown(cleanup.dispose);

        // startup: load 실패 → unknown, 재조회 timer 예약.
        await cleanup.retryPending();
        expect(loadCalls, 1);
        expect(persisted, isTrue);

        // 새 계정 로그인에서 rebind 성공(load는 여전히 실패 상태).
        await cleanup.markResolvedByServerRebind();

        // rebind는 load 성공 여부와 무관하게 pending을 해소해야 한다.
        await _settle();
        expect(persisted, isFalse);
        expect(cleanup.isPending, isFalse);
      },
    );

    // ─── [P2] 교체돼 버려진 request는 rebind 결합 대상이 아님 ──────
    test(
      "a superseded completed request does not trigger recovery on later rebind",
      () async {
        var persistedPending = false;
        final gates = <Completer<void>>[];
        var recoveries = 0;
        final cleanup = RetryingAsyncCleanup(
          cleanup: () {
            final gate = Completer<void>();
            gates.add(gate);
            return gate.future;
          },
          loadPending: () async => persistedPending,
          savePending: (pending) async => persistedPending = pending,
          attemptTimeout: const Duration(milliseconds: 20),
          retryDelay: const Duration(milliseconds: 10),
        );
        cleanup.setRecoveryCallback(() async => recoveries++);
        addTearDown(cleanup.dispose);

        // request 1: D1 timeout된 채 진행.
        await cleanup.requestCleanup().timeout(
          const Duration(milliseconds: 200),
        );
        // request 2로 교체(D2 진행 중, 아직 미완료 — current 유지).
        await cleanup.requestCleanup().timeout(
          const Duration(milliseconds: 200),
        );
        await _waitUntil(() => gates.length >= 2);

        // 버려진 request 1의 D1이 늦게 완료(rebind 없이 끝난 유령 request).
        gates[0].complete();
        await _settle(const Duration(milliseconds: 20));

        // rebind가 와도 유령 request 1을 집어 재등록하면 안 된다.
        // (recovery는 현재 request의 rebind 이후 delete 완료 시에만)
        await cleanup.markResolvedByServerRebind();
        await _settle(const Duration(milliseconds: 20));
        expect(recoveries, 0);
      },
    );

    // ─── Non-blocking: load 재조회 backoff 상한 ───────────────────
    test("unknown load auto-retry is bounded by a max attempt count", () async {
      var loadCalls = 0;
      final cleanup = RetryingAsyncCleanup(
        cleanup: () async {},
        loadPending: () async {
          loadCalls++;
          throw StateError("always fails");
        },
        savePending: (_) async {},
        attemptTimeout: const Duration(milliseconds: 10),
        loadRetryDelay: const Duration(milliseconds: 5),
        maxLoadRetryDelay: const Duration(milliseconds: 20),
        maxLoadRetries: 3,
      );
      addTearDown(cleanup.dispose);

      await cleanup.retryPending(); // 1회 + 최대 3회 자동 재조회
      await _settle(const Duration(milliseconds: 200));
      expect(loadCalls, lessThanOrEqualTo(4));
      expect(loadCalls, greaterThanOrEqualTo(2));
    });

    // ─── Non-blocking: dispose가 pending 상태를 정리 ──────────────
    test("dispose clears pending state", () async {
      final cleanup = RetryingAsyncCleanup(
        cleanup: () => Completer<void>().future,
        loadPending: () async => false,
        savePending: (_) async {},
        attemptTimeout: const Duration(milliseconds: 20),
        retryDelay: const Duration(seconds: 1),
      );

      await cleanup.requestCleanup().timeout(const Duration(milliseconds: 200));
      expect(cleanup.isPending, isTrue);

      cleanup.dispose();
      expect(cleanup.isPending, isFalse);
    });
  });
}

Future<void> _settle([
  Duration duration = const Duration(milliseconds: 10),
]) async {
  await Future<void>.delayed(duration);
}

Future<void> _waitUntil(bool Function() predicate) async {
  final deadline = DateTime.now().add(const Duration(seconds: 1));
  while (!predicate()) {
    if (DateTime.now().isAfter(deadline)) {
      fail("condition was not met before timeout");
    }
    await Future<void>.delayed(const Duration(milliseconds: 5));
  }
}
