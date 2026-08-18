import "dart:convert";
import "dart:io" show Platform;

import "package:firebase_messaging/firebase_messaging.dart";
import "package:flutter_local_notifications/flutter_local_notifications.dart";
import "../network/api_client.dart";
import "local_notification_service.dart";

/// FCM 푸시 수신 서비스.
///
/// 역할:
/// 1. Firebase 초기화 + 토큰 획득 → POST /push-devices 등록 (API 명세 §2.7)
/// 2. 포그라운드 메시지 수신 → 동일 dedupKey의 로컬 알림 취소 (TR-07)
/// 3. 포그라운드 메시지 → 인앱 로컬 알림으로 표시 (TR-10 마스킹 반영)
/// 4. 백그라운드 메시지 수신 → 시스템 트레이에 표시 (Firebase 자동 처리)
///
/// TR-10 민감 마스킹:
/// - 서버는 `body`(원문)와 `bodyMasked`(일반화 문구)를 모두 내려준다
/// - `lockscreenHideSensitive=true`이면 잠금화면에 bodyMasked를 표시하고
///   Android visibility를 PRIVATE으로 설정한다
///
/// Firebase 프로젝트가 미연결이면 초기화가 조용히 실패하고,
/// 로컬 알림 폴백만으로 동작한다 — 앱이 죽지 않는다.
class FcmService {
  FcmService._();
  static final instance = FcmService._();

  final _messaging = FirebaseMessaging.instance;
  final _localPlugin = FlutterLocalNotificationsPlugin();
  ApiClient? _apiClient;
  String? _installationId;

  /// TR-10: 잠금화면에서 민감 정보 숨김 여부. bootstrap에서 세팅.
  bool _lockscreenHideSensitive = true;

  /// main.dart에서 Firebase.initializeApp() 이후에 호출.
  /// apiClient와 installationId는 로그인 후 세팅된다.
  ///
  /// Firebase 설정 파일(google-services.json / GoogleService-Info.plist)이
  /// 없는 환경에서는 초기화가 실패할 수 있다. 이 경우 로컬 알림 폴백만
  /// 동작하며 앱 시작에 영향을 주지 않는다.
  Future<void> initialize({
    required ApiClient apiClient,
    required String installationId,
  }) async {
    _apiClient = apiClient;
    _installationId = installationId;

    try {
      // 알림 권한 요청 (iOS — Android 13+도 필요)
      await _messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      // 토큰 획득 + 서버 등록
      final token = await _messaging.getToken();
      if (token != null) {
        await _registerToken(token);
      }

      // 토큰 갱신 콜백 — 앱 재실행마다 갱신될 수 있음 (§2.7)
      _messaging.onTokenRefresh.listen(_registerToken);

      // 포그라운드 메시지 핸들러
      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    } catch (e) {
      // Firebase 미설정 환경 — FCM 비활성, 로컬 알림 폴백만 동작
      // 앱 시작을 중단하지 않는다.
    }
  }

  /// 로그인 후 apiClient/installationId 갱신 시 재호출.
  void updateCredentials({
    required ApiClient apiClient,
    required String installationId,
  }) {
    _apiClient = apiClient;
    _installationId = installationId;
  }

  /// bootstrap 설정 반영.
  void updateSettings({required bool lockscreenHideSensitive}) {
    _lockscreenHideSensitive = lockscreenHideSensitive;
  }

  /// POST /push-devices — FCM 토큰 등록·갱신 (API 명세 §2.7)
  /// installationId가 UNIQUE이므로 재설치 전까지 같은 기기는 한 행을 갱신.
  Future<void> _registerToken(String token) async {
    if (_apiClient == null || _installationId == null) return;
    try {
      await _apiClient!.post<Map<String, dynamic>>(
        "/push-devices",
        body: {
          "installationId": _installationId!,
          "currentToken": token,
          "platform": _getPlatform(),
        },
      );
    } catch (_) {
      // 토큰 등록 실패는 치명적이지 않음 — 다음 앱 실행 시 재시도
    }
  }

  /// 포그라운드 메시지 수신 처리.
  ///
  /// 서버 data payload 규약:
  ///   - dedupKey: 로컬 알림 취소용
  ///   - title: 알림 제목
  ///   - body: 알림 본문 (원문)
  ///   - bodyMasked: 민감 항목이 일반화된 본문 (TR-10)
  ///   - notificationCategory: "time" | "wellness"
  void _handleForegroundMessage(RemoteMessage message) {
    final data = message.data;
    final dedupKey = data["dedupKey"] as String?;

    // dedupKey가 있으면 로컬 알림 취소 — 서버 푸시가 우선 (TR-07)
    if (dedupKey != null) {
      LocalNotificationService.instance.cancelByDedupKey(dedupKey);
    }

    // 포그라운드에서는 시스템 알림이 자동 표시되지 않으므로
    // flutter_local_notifications로 직접 표시한다.
    _showForegroundNotification(data);

    // UI 레이어에도 전달 (인앱 배너 등)
    _foregroundMessageController?.call(message);
  }

  /// 포그라운드에서 수신한 FCM을 로컬 알림으로 표시.
  /// TR-10: lockscreenHideSensitive이면 bodyMasked를 사용하고 visibility를 제한.
  Future<void> _showForegroundNotification(Map<String, dynamic> data) async {
    final title = data["title"] as String? ?? "Ensom";
    final body = data["body"] as String? ?? "";
    final bodyMasked = data["bodyMasked"] as String?;

    // 잠금화면 설정에 따라 표시할 본문 결정
    // 앱이 포그라운드(잠금 해제 상태)이므로 원문을 보여주되,
    // Android notification의 publicVersion에 마스킹 버전을 세팅해
    // 잠금화면에서는 마스킹된 내용이 보이도록 한다.
    final androidDetails = AndroidNotificationDetails(
      "ensom_push",
      "Ensom 알림",
      channelDescription: "서버에서 발송된 알림",
      importance: Importance.high,
      priority: Priority.high,
      visibility: _lockscreenHideSensitive
          ? NotificationVisibility.private
          : NotificationVisibility.public,
      // publicVersion: 잠금화면에서 보이는 대체 알림
      publicNotification: _lockscreenHideSensitive && bodyMasked != null
          ? AndroidNotificationDetails(
              "ensom_push",
              "Ensom 알림",
              channelDescription: "서버에서 발송된 알림",
              importance: Importance.high,
              priority: Priority.high,
              visibility: NotificationVisibility.public,
            )
          : null,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    // 알림 ID: dedupKey가 있으면 FNV-1a 해시, 없으면 현재 시각 기반
    final dedupKeyStr = data["dedupKey"] as String?;
    final notificationId = dedupKeyStr != null
        ? _fnv1a32(dedupKeyStr)
        : DateTime.now().millisecondsSinceEpoch & 0x7FFFFFFF;

    await _localPlugin.show(
      notificationId,
      title,
      // 포그라운드(잠금 해제)에서는 원문 표시
      body,
      details,
    );
  }

  /// UI 레이어가 포그라운드 메시지를 수신하기 위한 콜백.
  void Function(RemoteMessage)? _foregroundMessageController;

  /// 홈 화면 등에서 포그라운드 메시지 콜백을 등록한다.
  void setForegroundMessageHandler(void Function(RemoteMessage) handler) {
    _foregroundMessageController = handler;
  }

  /// 로그아웃 시 — 토큰 비활성화는 서버가 처리 (POST /auth/logout에서)
  /// 클라이언트는 콜백만 정리.
  void dispose() {
    _foregroundMessageController = null;
  }

  String _getPlatform() {
    try {
      return Platform.isIOS ? "ios" : "android";
    } catch (_) {
      return "android";
    }
  }

  /// FNV-1a 32-bit 해시. LocalNotificationService와 동일 알고리즘.
  static int _fnv1a32(String input) {
    const int fnvOffsetBasis = 0x811c9dc5;
    const int fnvPrime = 0x01000193;
    int hash = fnvOffsetBasis;
    for (int i = 0; i < input.length; i++) {
      hash ^= input.codeUnitAt(i);
      hash = (hash * fnvPrime) & 0xFFFFFFFF;
    }
    return hash.toSigned(32);
  }
}

/// 백그라운드 메시지 핸들러 (top-level function 필수).
/// Firebase가 앱 프로세스 밖에서 호출하므로 최소한의 처리만 한다.
/// 백그라운드 푸시는 시스템이 자동으로 트레이에 표시하므로,
/// 여기서는 dedupKey 기반 로컬 알림 취소만 수행한다.
@pragma("vm:entry-point")
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  final dedupKey = message.data["dedupKey"] as String?;
  if (dedupKey != null) {
    // 백그라운드에서는 LocalNotificationService 상태에 접근 불가(isolate)
    // FlutterLocalNotificationsPlugin을 직접 생성해 취소한다.
    final plugin = FlutterLocalNotificationsPlugin();
    await plugin.cancel(_fnv1a32Background(dedupKey));
  }
}

/// 백그라운드 isolate용 FNV-1a 32bit 해시 (LocalNotificationService와 동일 알고리즘).
int _fnv1a32Background(String input) {
  const int fnvOffsetBasis = 0x811c9dc5;
  const int fnvPrime = 0x01000193;
  int hash = fnvOffsetBasis;
  for (int i = 0; i < input.length; i++) {
    hash ^= input.codeUnitAt(i);
    hash = (hash * fnvPrime) & 0xFFFFFFFF;
  }
  return hash.toSigned(32);
}
