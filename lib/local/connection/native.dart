import "dart:io";

import "package:drift/drift.dart";
import "package:drift/native.dart";
import "package:path/path.dart" as p;
import "package:path_provider/path_provider.dart";

/// 모바일·데스크톱: 앱 문서 디렉토리에 SQLite 파일을 두고 FFI로 연다.
///
/// LazyDatabase: 실제 사용 시점까지 파일 오픈을 미룬다 (앱 시작 지연 방지).
QueryExecutor openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, "ensom_offline_queue.sqlite"));
    return NativeDatabase.createInBackground(file);
  });
}
