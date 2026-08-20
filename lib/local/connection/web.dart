import "package:drift/drift.dart";
import "package:drift/wasm.dart";

/// Web: sqlite3.wasm + drift worker 로 IndexedDB에 영속한다.
///
/// 정적 자산 요구사항 (web/ 폴더에 배치):
///   - web/sqlite3.wasm
///   - web/drift_worker.js
/// 두 파일은 배포 산출물(build/web)에 그대로 복사되어야 한다.
///
/// LazyDatabase로 감싸 실제 사용 시점까지 초기화를 미룬다.
QueryExecutor openConnection() {
  return LazyDatabase(() async {
    final result = await WasmDatabase.open(
      databaseName: "ensom_offline_queue",
      sqlite3Uri: Uri.parse("sqlite3.wasm"),
      driftWorkerUri: Uri.parse("drift_worker.js"),
    );
    return result.resolvedExecutor;
  });
}
