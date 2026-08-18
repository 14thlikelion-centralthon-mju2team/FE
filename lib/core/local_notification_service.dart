import "dart:convert";

import "package:flutter_local_notifications/flutter_local_notifications.dart";
import "package:timezone/timezone.dart" as tz;
import "package:timezone/data/latest_all.dart" as tz_data;

/// TR-07 로컬 알림 이중화 서비스.
///
/// FCM은 전송 시각을 보장하지 않으므로, 클라이언트가 **준비 시작·출발 임박
/// 2건을 로컬 알림으로 미리 예약**하고 서버 푸시가 먼저 오면 로컬을 취소한다.
///
/// 식별자 전략 (API 명세 §11.3):
///   dedupKey = sha1(eventId + ":" + slot + ":" + revisionNo)
///   → 이 문자열의 hashCode를 notification ID로 사용 (int 필요)
///   → 서버 푸시가 같은 dedupKey로 도착하면 동일 ID로 cancel
class LocalNotificationService {
  LocalNotificationService._();
  static final instance = LocalNotificationService._();

  final _plugin = FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  /// 앱 시작 시 1회 호출.
  Future<void> initialize() async {
    if (_initialized) return;

    tz_data.initializeTimeZones();

    const androidSettings =
        AndroidInitializationSettings("@mipmap/ic_launcher");
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _plugin.initialize(
      settings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    _initialized = true;
  }

  /// 계획 기반 로컬 알림 2건 예약 (준비 시작 + 출발 임박).
  /// 기존 같은 eventId의 알림이 있으면 먼저 취소하고 재예약한다.
  Future<void> schedulePlanNotifications({
    required String eventId,
    required int revisionNo,
    required DateTime prepStartAt,
    required DateTime recommendedDepartAt,
    required String eventDisplayName,
  }) async {
    // 이전 리비전의 알림 취소 (리비전이 바뀌면 시각도 바뀌었을 수 있음)
    await cancelPlanNotifications(eventId: eventId);

    final now = DateTime.now();

    // 슬롯 A: 준비 시작 알림
    if (prepStartAt.isAfter(now)) {
      await _scheduleOne(
        id: _notificationId(eventId, "A", revisionNo),
        scheduledAt: prepStartAt,
        title: "준비를 시작할 시간이에요",
        body: "$eventDisplayName — 지금부터 천천히 준비해 보세요.",
        payload: jsonEncode({
          "type": "prep_start",
          "eventId": eventId,
        }),
      );
    }

    // 슬롯 B: 출발 임박 알림
    if (recommendedDepartAt.isAfter(now)) {
      await _scheduleOne(
        id: _notificationId(eventId, "B", revisionNo),
        scheduledAt: recommendedDepartAt,
        title: "이제 출발할 시간이에요",
        body: "$eventDisplayName — 현재 경로 기준으로 출발하세요.",
        payload: jsonEncode({
          "type": "depart",
          "eventId": eventId,
        }),
      );
    }
  }

  /// 서버 푸시가 먼저 도착했을 때 동일 dedupKey의 로컬 알림 취소.
  /// dedupKey 형식: sha1(eventId:slot:revisionNo) — 서버가 내려줌.
  Future<void> cancelByDedupKey(String dedupKey) async {
    final id = dedupKey.hashCode;
    await _plugin.cancel(id);
  }

  /// 특정 일정의 모든 로컬 알림 취소 (리비전 무관).
  /// A·B 슬롯 모두 취소하기 위해 현재 리비전 + 이전 리비전까지 커버.
  /// 실제로는 이전 리비전을 알 수 없으므로 pending 목록에서 eventId로 필터.
  Future<void> cancelPlanNotifications({required String eventId}) async {
    final pending = await _plugin.pendingNotificationRequests();
    for (final request in pending) {
      if (request.payload != null) {
        try {
          final data = jsonDecode(request.payload!) as Map<String, dynamic>;
          if (data["eventId"] == eventId) {
            await _plugin.cancel(request.id);
          }
        } catch (_) {
          // payload 파싱 실패면 무시
        }
      }
    }
  }

  /// 전체 알림 취소 (로그아웃 시).
  Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }

  // ─── Internal ──────────────────────────────────────────────────────

  /// dedupKey 방식과 호환되는 notification ID 생성.
  /// API 명세 §11.3: dedupKey = sha1(eventId + ":" + slot + ":" + revisionNo)
  /// 여기서는 같은 문자열의 hashCode를 쓴다 (int32 범위).
  int _notificationId(String eventId, String slot, int revisionNo) {
    return "$eventId:$slot:$revisionNo".hashCode;
  }

  Future<void> _scheduleOne({
    required int id,
    required DateTime scheduledAt,
    required String title,
    required String body,
    required String payload,
  }) async {
    final tzScheduledAt = tz.TZDateTime.from(scheduledAt, tz.local);

    const androidDetails = AndroidNotificationDetails(
      "ensom_plan",
      "준비·출발 알림",
      channelDescription: "일정 준비 시작과 출발 시각 안내",
      importance: Importance.high,
      priority: Priority.high,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _plugin.zonedSchedule(
      id,
      title,
      body,
      tzScheduledAt,
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: payload,
      matchDateTimeComponents: null,
    );
  }

  void _onNotificationTapped(NotificationResponse response) {
    // 알림 탭 시 딥링크 처리 — go_router로 해당 일정 상세로 이동
    // 이 부분은 main.dart에서 navigatorKey를 공유해야 완성되지만
    // 알림 예약/취소 흐름과는 독립적이므로 M4에서 완성한다.
  }
}
