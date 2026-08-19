import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";
import "package:hive_ce_flutter/hive_ce_flutter.dart";
import "../../core/local_notification_service.dart";
import "../../local/place_cache_entry.dart";
import "../../providers/auth_providers.dart";
import "../../providers/offline_queue_providers.dart";
import "../../repository/providers.dart";

/// SET-03 · 계정 수명주기(로그아웃/개인화 초기화/탈퇴, §16).
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  /// 로그아웃/탈퇴 시 사용자별 로컬 상태 전부 제거.
  /// - 예약된 로컬 알림 전체 취소 (이전 사용자의 알림이 울리지 않도록)
  /// - 오프라인 action queue 전체 삭제 (이전 사용자의 미전송 행동이 다음 세션에서 전송되지 않도록)
  /// - 장소 캐시 클리어
  Future<void> _clearLocalCaches(WidgetRef ref) async {
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

  Future<void> _resetPersonalization(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text("개인화 초기화"),
        content: const Text("준비 시간 학습 결과와 웰니스 설정이 초기값으로 돌아가요. 계속할까요?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext, false), child: const Text("취소")),
          FilledButton(onPressed: () => Navigator.pop(dialogContext, true), child: const Text("초기화")),
        ],
      ),
    );
    if (confirmed != true) return;

    try {
      await ref.read(ensomRepositoryProvider).resetPersonalization();
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("개인화 설정을 초기화했어요.")),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("초기화하지 못했어요. 다시 시도해주세요.")),
      );
    }
  }

  Future<void> _logout(BuildContext context, WidgetRef ref) async {
    await ref.read(authNotifierProvider.notifier).logout();
    await _clearLocalCaches(ref);
    if (!context.mounted) return;
    context.go("/onboarding/auth");
  }

  Future<void> _deleteAccount(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text("탈퇴하시겠어요?"),
        content: const Text("일정, 계획, 준비 항목, 개인화 데이터가 모두 삭제되고 되돌릴 수 없어요. 동의 이력만 법정 보존 기간 동안 남아요."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext, false), child: const Text("취소")),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text("탈퇴"),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    try {
      await ref.read(ensomRepositoryProvider).deleteAccount();
      await ref.read(authNotifierProvider.notifier).logout();
      await _clearLocalCaches(ref);
      if (!context.mounted) return;
      context.go("/onboarding/auth");
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("탈퇴를 처리하지 못했어요. 다시 시도해주세요.")),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text("설정")),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.wb_sunny_outlined),
            title: const Text("웰니스 관심 항목 설정"),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push("/settings/wellness-prefs"),
          ),
          ListTile(
            leading: const Icon(Icons.place_outlined),
            title: const Text("등록 장소 관리"),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push("/places/manage"),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.restart_alt),
            title: const Text("개인화 초기화"),
            onTap: () => _resetPersonalization(context, ref),
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("로그아웃"),
            onTap: () => _logout(context, ref),
          ),
          ListTile(
            leading: const Icon(Icons.person_remove_outlined, color: Colors.red),
            title: const Text("탈퇴", style: TextStyle(color: Colors.red)),
            onTap: () => _deleteAccount(context, ref),
          ),
        ],
      ),
    );
  }
}
