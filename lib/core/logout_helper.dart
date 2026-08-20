import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:hive_ce_flutter/hive_ce_flutter.dart";
import "../core/local_notification_service.dart";
import "../local/place_cache_entry.dart";
import "../providers/auth_providers.dart";
import "../providers/offline_queue_providers.dart";
import "../theme/ensom_colors.dart";

/// 로그아웃/탈퇴 시 공통으로 수행해야 하는 로컬 리소스 소거.
/// profile_screen, account_screen에서 공용 사용.
Future<void> clearLocalCaches(WidgetRef ref) async {
  // 로컬 알림 전체 취소
  await LocalNotificationService.instance.cancelAll();

  // 오프라인 action queue 전체 삭제
  try {
    final db = ref.read(appDatabaseProvider);
    await db.delete(db.offlineActionQueue).go();
  } catch (_) {
    // DB 접근 실패해도 로그아웃 흐름을 막지 않는다
  }

  // 장소 캐시 클리어
  if (Hive.isBoxOpen("place_cache")) {
    await Hive.box<PlaceCacheEntry>("place_cache").clear();
  }
}

/// 로그아웃 확인 다이얼로그 + 실행.
/// Should-Fix #4: 중복 제거용 공용 함수.
Future<void> showLogoutConfirmAndExecute(
  BuildContext context,
  WidgetRef ref,
) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text("로그아웃할까요?"),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: const Text("취소"),
        ),
        TextButton(
          onPressed: () => Navigator.pop(ctx, true),
          style: TextButton.styleFrom(foregroundColor: EnsomColors.caution),
          child: const Text("로그아웃"),
        ),
      ],
    ),
  );
  if (confirmed != true) return;

  await clearLocalCaches(ref);
  ref.read(authNotifierProvider.notifier).logout();
}
