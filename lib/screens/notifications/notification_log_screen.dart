import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:intl/intl.dart";
import "../../models/notification.dart";
import "../../repository/providers.dart";
import "../../theme/ensom_colors.dart";

/// NOTI-05. 당일 발송된 시간(여유/극한/돌발)+웰니스 알림을 최신순으로
/// 보여준다. API v5.0 §11.1 GET /notifications/today.
final todayNotificationsProvider =
    FutureProvider.autoDispose<List<AppNotification>>((ref) async {
      final repo = ref.watch(ensomRepositoryProvider);
      return repo.fetchTodayNotifications();
    });

class NotificationLogScreen extends ConsumerWidget {
  const NotificationLogScreen({super.key});

  String _typeLabel(NotificationType type) {
    switch (type) {
      case NotificationType.relaxed:
        return "여유 알림";
      case NotificationType.critical:
        return "극한 알림";
      case NotificationType.disruption:
        return "돌발 알림";
      case NotificationType.wellnessEvent:
        return "웰니스 알림";
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationsAsync = ref.watch(todayNotificationsProvider);
    final timeFormat = DateFormat("a h:mm", "ko_KR");

    return Scaffold(
      appBar: AppBar(title: const Text("오늘의 알림")),
      body: notificationsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, st) => Center(child: Text("불러오지 못했어요: $err")),
        data: (notifications) {
          if (notifications.isEmpty) {
            return const Center(child: Text("오늘 발송된 알림이 없어요."));
          }
          // 최신순 정렬. sentAt이 없는(아직 미발송) 항목은 뒤로.
          final sorted = [...notifications]
            ..sort((a, b) {
              if (a.sentAt == null) return 1;
              if (b.sentAt == null) return -1;
              return b.sentAt!.compareTo(a.sentAt!);
            });

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: sorted.length,
            separatorBuilder: (_, _) => const Divider(height: 24),
            itemBuilder: (context, index) {
              final n = sorted[index];
              final isWellness =
                  n.notificationCategory == NotificationCategory.wellness;
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    isWellness
                        ? Icons.wb_sunny_outlined
                        : Icons.notifications_outlined,
                    size: 18,
                    color: isWellness
                        ? EnsomColors.caution
                        : EnsomColors.inkMuted,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              _typeLabel(n.notificationType),
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 8),
                            if (n.sentAt != null)
                              Text(
                                timeFormat.format(n.sentAt!),
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: EnsomColors.inkMuted,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        // body는 서버가 내려준 최종 문자열 그대로 표시한다 (TR-09).
                        Text(n.body),
                        if (n.triggerReason != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            n.triggerReason!,
                            style: const TextStyle(
                              fontSize: 12,
                              color: EnsomColors.inkMuted,
                            ),
                          ),
                        ],
                        if (n.reaction != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            "반응: ${n.reaction}",
                            style: TextStyle(
                              fontSize: 12,
                              color: EnsomColors.limeInk,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
