import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:intl/intl.dart";
import "../../models/notification.dart";
import "../../repository/providers.dart";
import "../../theme/ensom_colors.dart";
import "../../widgets/ensom/ensom_top_bar.dart";

/// NOTI-05. 당일 발송된 시간(여유/극한/돌발)+웰니스 알림을 최신순으로
/// 보여준다. API v5.0 §11.1 GET /notifications/today.
///
/// 전용 목업 파일은 없다(ensom_push_notifications.html은 OS 잠금화면
/// 위 알림 카드 5종을 보여주는 정적 목업이라 그대로 옮길 인앱 리스트
/// 화면이 아님) — 캘린더 타임라인 카드와 같은 디자인 토큰으로 맞췄다.
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
      backgroundColor: EnsomColors.canvas,
      appBar: const EnsomTopBar(title: "오늘의 알림"),
      body: SafeArea(
        top: false,
        child: notificationsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, st) => const Center(
            child: Text("불러오지 못했어요.", style: TextStyle(color: EnsomColors.inkMuted)),
          ),
          data: (notifications) {
            if (notifications.isEmpty) {
              return const Center(
                child: Text("오늘 발송된 알림이 없어요.", style: TextStyle(color: EnsomColors.inkFaint)),
              );
            }
            // 최신순 정렬. sentAt이 없는(아직 미발송) 항목은 뒤로.
            final sorted = [...notifications]
              ..sort((a, b) {
                if (a.sentAt == null) return 1;
                if (b.sentAt == null) return -1;
                return b.sentAt!.compareTo(a.sentAt!);
              });

            return ListView.builder(
              padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
              itemCount: sorted.length,
              itemBuilder: (context, index) {
                final n = sorted[index];
                final isWellness = n.notificationCategory == NotificationCategory.wellness;
                return Container(
                  margin: const EdgeInsets.only(bottom: 9),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: EnsomColors.surface1,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: EnsomColors.hairline),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: const BoxDecoration(color: EnsomColors.surface2, shape: BoxShape.circle),
                        child: Icon(
                          isWellness ? Icons.wb_sunny_outlined : Icons.notifications_outlined,
                          size: 15,
                          color: isWellness ? EnsomColors.caution : EnsomColors.inkMuted,
                        ),
                      ),
                      const SizedBox(width: 11),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  _typeLabel(n.notificationType),
                                  style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: EnsomColors.inkMuted),
                                ),
                                const SizedBox(width: 7),
                                if (n.sentAt != null)
                                  Text(
                                    timeFormat.format(n.sentAt!),
                                    style: const TextStyle(fontSize: 11, color: EnsomColors.inkFaint),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            // body는 서버가 내려준 최종 문자열 그대로 표시한다 (TR-09).
                            Text(n.body, style: const TextStyle(fontSize: 13, color: EnsomColors.ink, height: 1.4)),
                            if (n.triggerReason != null) ...[
                              const SizedBox(height: 3),
                              Text(
                                n.triggerReason!,
                                style: const TextStyle(fontSize: 11, color: EnsomColors.inkFaint),
                              ),
                            ],
                            if (n.reaction != null) ...[
                              const SizedBox(height: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                                decoration: BoxDecoration(color: EnsomColors.limeSoft, borderRadius: BorderRadius.circular(999)),
                                child: Text(
                                  "반응: ${n.reaction}",
                                  style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: EnsomColors.limeInk),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
