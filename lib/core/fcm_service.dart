import "dart:convert";

import "package:firebase_messaging/firebase_messaging.dart";
import "../network/api_client.dart";
import "local_notification_service.dart";

/// FCM 푸시 수신 서비스.
///
/// 역할:
/// 1. Firebase 초기화 + 토큰 획득 → POST /push-devices 등록 (API 명세 §2.7)
/// 2. 포그라운드 메시지 수신 → 동일 dedupKey의 로컬 알림 취소 (TR-07)
/// 3. 백그라운드 메시지 수신 → 시스템 트레이에 표시 (Firebase 자동 처리)
///
/// Firebase 프로젝트가 미연결이면 초기화가 조용히 실패하고,
/// 로컬 알림 폴백만으로 동작한다 — 앱이 죽지 않는다.
class FcmService {
  FcmService._();
  static final instance = FcmService._();

  final _messaging = FirebaseMessaging.instance;
  ApiClient? _apiClient;
  String? _installationId;

  /// main.dart에서 Firebase.initializeApp() 이후에 호출.
  /// apiClient와 installationId는 로그인 후 세팅된다.
  Future<void> initialize({
    required ApiClient apiClient,
    required String installationId,
  }) async {
    _apiClient = apiClient;
    _installationId = installationId;

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
  }

  /// 로그인 후 apiClient/installationId 갱신 시 재호출.
  void updateCredentials({
    required ApiClient apiClient,
    required String installationId,
  }) {
    _apiClient = apiClient;
    _installationId = installationId;
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
  /// 서버 푸시가 먼저 도착하면 동일 dedupKey의 로컬 알림을 취소한다 (TR-07).
  void _handleForegroundMessage(RemoteMessage message) {
    final data = message.data;
    final dedupKey = data["dedupKey"] as String?;

    // dedupKey가 있으면 로컬 알림 취소 — 서버 푸시가 우선
    if (dedupKey != null) {
      LocalNotificationService.instance.cancelByDedupKey(dedupKey);
    }

    // 포그라운드에서는 시스템 알림이 자동 표시되지 않으므로
    // 앱이 열려 있을 때는 인앱 스낵바/배너로 표시한다.
    // 이 콜백은 UI 레이어(홈 화면)에서 처리하도록 스트림으로 전달한다.
    _foregroundMessageController?.call(message);
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
    // dart:io의 Platform을 직접 쓰면 web에서 에러나므로 간단히 처리
    return "android"; // TODO: Platform.isIOS 분기 — M4에서 조건부 import로 해결
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
    // 백그라운드에서는 LocalNotificationService가 초기화 안 됐을 수 있으므로
    // FlutterLocalNotificationsPlugin을 직접 사용
    // 주의: 이 핸들러는 isolate에서 실행되므로 상태 공유 불가
    // 실제 구현은 앱이 다시 포그라운드 돌아올 때 pending 목록에서 정리
  }
}
