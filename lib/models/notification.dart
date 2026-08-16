import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification.freezed.dart';
part 'notification.g.dart';

/// 시간 알림(여유/극한/돌발) vs 웰니스 이벤트 알림. 예산이 서로 독립이다
/// — 시간 알림은 일정당 3회, 웰니스는 일정당 1회 (PRD §13, §13.4).
enum NotificationClass {
  @JsonValue('time')
  time,
  @JsonValue('wellness')
  wellness,
}

/// 웰니스 이벤트 알림 응답 액션.
enum WellnessResponseAction {
  @JsonValue('completed')
  completed,
  @JsonValue('snoozed_30m')
  snoozed30m,
  @JsonValue('stop_today')
  stopToday,
}

@freezed
abstract class AppNotification with _$AppNotification {
  const factory AppNotification({
    required String notificationId,
    required NotificationClass notificationClass,
    required String slot, // time: A|B|C, wellness: W
    required DateTime sentAt,
    required String message, // 서버가 내려주는 최종 문자열. 클라이언트가 변형하지 않는다 (TR-09)
    String? reaction,
  }) = _AppNotification;

  factory AppNotification.fromJson(Map<String, dynamic> json) =>
      _$AppNotificationFromJson(json);
}
