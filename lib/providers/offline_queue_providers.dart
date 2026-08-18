import "package:flutter_riverpod/flutter_riverpod.dart";
import "../local/app_database.dart";
import "../local/offline_action_queue_service.dart";
import "../repository/providers.dart";

/// 앱 전체에서 하나만 열려야 하는 DB 커넥션이라 autoDispose를 안 쓴다.
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

final offlineActionQueueServiceProvider =
    Provider<OfflineActionQueueService>((ref) {
  final db = ref.watch(appDatabaseProvider);
  final repo = ref.watch(ensomRepositoryProvider);
  return OfflineActionQueueService(db: db, repo: repo);
});