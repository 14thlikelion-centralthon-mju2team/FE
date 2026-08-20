import "dart:async";
import "dart:convert";
import "dart:io" show Platform;

import "package:firebase_messaging/firebase_messaging.dart";
import "package:flutter_local_notifications/flutter_local_notifications.dart";
import "package:shared_preferences/shared_preferences.dart";
import "../network/api_client.dart";
import "async_session_lifecycle.dart";
import "local_notification_service.dart";
import "retrying_async_cleanup.dart";

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

  static const _pendingTokenCleanupKey = "fcm_token_cleanup_pending";

  final _messaging = FirebaseMessaging.instance;
  final _localPlugin = FlutterLocalNotificationsPlugin();
  final _sessionLifecycle = AsyncSessionLifecycle();
  late final RetryingAsyncCleanup _tokenCleanup = RetryingAsyncCleanup(
    cleanup: _messaging.deleteToken,
    loadPending: () async {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_pendingTokenCleanupKey) ?? false;
    },
    savePending: (pending) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_pendingTokenCleanupKey, pending);
    },
  );

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
  }) {
    return _sessionLifecycle.initialize((generation, isCurrent) async {
      try {
        _tokenCleanup.setRecoveryCallback(
          () => _recoverCurrentToken(
            apiClient: apiClient,
            installationId: installationId,
            isCurrent: isCurrent,
          ),
        );
        await _tokenCleanup.retryPending();
        if (!isCurrent()) return const [];

        const androidSettings = AndroidInitializationSettings(
          "@mipmap/ic_launcher",
        );
        const iosSettings = DarwinInitializationSettings();
        const initSettings = InitializationSettings(
          android: androidSettings,
          iOS: iosSettings,
        );
        await _localPlugin.initialize(
          settings: initSettings,
          onDidReceiveNotificationResponse: _onNotificationResponse,
        );
        if (!isCurrent()) return const [];

        final androidPlugin = _localPlugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();
        if (androidPlugin != null) {
          await androidPlugin.createNotificationChannel(
            const AndroidNotificationChannel(
              "ensom_push",
              "Ensom 알림",
              description: "서버에서 발송된 알림",
              importance: Importance.high,
            ),
          );
          await androidPlugin.createNotificationChannel(
            const AndroidNotificationChannel(
              "ensom_prep",
              "준비 알림",
              description: "준비 시작 및 출발 시각 안내",
              importance: Importance.high,
            ),
          );
        }
        if (!isCurrent()) return const [];

        await _messaging.requestPermission(
          alert: true,
          badge: true,
          sound: true,
        );
        if (!isCurrent()) return const [];

        final token = await _messaging.getToken();
        if (token != null && isCurrent()) {
          await _registerTokenAndResolveCleanup(
            token,
            apiClient: apiClient,
            installationId: installationId,
            isCurrent: isCurrent,
          );
        }
        if (!isCurrent()) return const [];

        final subscriptions = <StreamSubscription<dynamic>>[
          _messaging.onTokenRefresh.listen((token) {
            if (!isCurrent()) return;
            unawaited(
              _registerTokenAndResolveCleanup(
                token,
                apiClient: apiClient,
                installationId: installationId,
                isCurrent: isCurrent,
              ),
            );
          }),
          FirebaseMessaging.onMessage.listen((message) {
            if (isCurrent()) _handleForegroundMessage(message);
          }),
          FirebaseMessaging.onMessageOpenedApp.listen((message) {
            if (isCurrent()) _handleNotificationTap(message);
          }),
        ];

        // 초기 메시지 조회는 stream 설치 완료를 막지 않는다. plugin 호출이
        // 끝나지 않아도 lifecycle은 구독을 즉시 추적하고 dispose할 수 있다.
        unawaited(() async {
          try {
            final initial = await _messaging.getInitialMessage();
            if (initial != null && isCurrent()) {
              _handleNotificationTap(initial);
            }
          } catch (_) {
            // 초기 메시지 조회 실패는 실시간 stream 수명주기와 분리한다.
          }
        }());
        return subscriptions;
      } catch (_) {
        // Firebase 미설정 환경 — FCM 비활성, 로컬 알림 폴백만 동작
        // 앱 시작을 중단하지 않는다.
        return const [];
      }
    });
  }

  /// bootstrap 설정 반영.
  void updateSettings({required bool lockscreenHideSensitive}) {
    _lockscreenHideSensitive = lockscreenHideSensitive;
  }

  /// POST /push-devices — FCM 토큰 등록·갱신 (API 명세 §2.7)
  /// installationId가 UNIQUE이므로 재설치 전까지 같은 기기는 한 행을 갱신.
  Future<bool> _registerToken(
    String token, {
    required ApiClient apiClient,
    required String installationId,
    required bool Function() isCurrent,
  }) async {
    if (!isCurrent()) return false;
    try {
      await apiClient.post<Map<String, dynamic>>(
        "/push-devices",
        body: {
          "installationId": installationId,
          "currentToken": token,
          "platform": _getPlatform(),
        },
      );
      return isCurrent();
    } catch (_) {
      // 토큰 등록 실패는 치명적이지 않음 — 다음 앱 실행 시 재시도
      return false;
    }
  }

  Future<void> _registerTokenAndResolveCleanup(
    String token, {
    required ApiClient apiClient,
    required String installationId,
    required bool Function() isCurrent,
  }) async {
    final registered = await _registerToken(
      token,
      apiClient: apiClient,
      installationId: installationId,
      isCurrent: isCurrent,
    );
    if (registered) await _tokenCleanup.markResolvedByServerRebind();
  }

  Future<void> _recoverCurrentToken({
    required ApiClient apiClient,
    required String installationId,
    required bool Function() isCurrent,
  }) async {
    if (!isCurrent()) return;
    final token = await _messaging.getToken();
    if (token == null || !isCurrent()) return;
    await _registerTokenAndResolveCleanup(
      token,
      apiClient: apiClient,
      installationId: installationId,
      isCurrent: isCurrent,
    );
  }

  /// 앱 시작 시 이전 프로세스에서 남은 token cleanup을 bounded retry한다.
  Future<void> retryPendingTokenCleanup() => _tokenCleanup.retryPending();

  /// 포그라운드 메시지 수신 처리.
  ///
  /// BE FCM 계약: data에는 notification_id, plan_id, type만 들어간다.
  /// 표시 문구는 서버가 이미 마스킹한 FCM notification title/body를 사용하며,
  /// client data로 원문·좌표·준비 항목명을 전송하지 않는다.
  void _handleForegroundMessage(RemoteMessage message) {
    final data = message.data;
    final dedupKey = data["dedupKey"] as String?;

    // dedupKey가 있으면 로컬 알림 취소 — 서버 푸시가 우선 (TR-07)
    if (dedupKey != null) {
      LocalNotificationService.instance.cancelByDedupKey(dedupKey);
    }

    // 포그라운드에서는 시스템 알림이 자동 표시되지 않으므로
    // flutter_local_notifications로 직접 표시한다.
    _showForegroundNotification(message);

    // UI 레이어에도 전달 (인앱 배너 등)
    _foregroundMessageController?.call(message);
  }

  /// 포그라운드에서 수신한 FCM을 로컬 알림으로 표시.
  /// TR-10: lockscreenHideSensitive이면 bodyMasked를 사용하고 visibility를 제한.
  Future<void> _showForegroundNotification(RemoteMessage message) async {
    final data = message.data;
    final title = message.notification?.title ?? "Ensom";
    final body = message.notification?.body ?? "새 알림이 도착했어요.";

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

    // 탭 시 라우팅에 필요한 메타데이터를 payload로 전달
    final payloadData = <String, String>{
      for (final entry in data.entries)
        if ({"notification_id", "plan_id", "type"}.contains(entry.key))
          entry.key: entry.value.toString(),
    };

    await _localPlugin.show(
      id: notificationId,
      title: title,
      body: body,
      notificationDetails: details,
      payload: jsonEncode(payloadData),
    );
  }

  /// UI 레이어가 포그라운드 메시지를 수신하기 위한 콜백.
  void Function(RemoteMessage)? _foregroundMessageController;
  void Function(Map<String, String>)? _notificationTapHandler;

  void _handleNotificationTap(RemoteMessage message) {
    final data = <String, String>{
      for (final entry in message.data.entries)
        if ({"notification_id", "plan_id", "type"}.contains(entry.key))
          entry.key: entry.value,
    };
    if (data["notification_id"] != null) _notificationTapHandler?.call(data);
  }

  /// Router는 notification metadata만 받고, FCM payload의 표시 문구나 민감 데이터를 받지 않는다.
  void setNotificationTapHandler(void Function(Map<String, String>) handler) {
    _notificationTapHandler = handler;
  }

  /// 홈 화면 등에서 포그라운드 메시지 콜백을 등록한다.
  void setForegroundMessageHandler(void Function(RemoteMessage) handler) {
    _foregroundMessageController = handler;
  }

  /// 로그아웃/terminal expiry 시 세션 구독과 FCM installation token을 정리한다.
  /// token 삭제로 Dart stream 밖에서 OS가 표시하는 이전 계정 push도 차단한다.
  /// router tap handler는 앱 수명 callback이므로 재로그인 복구를 위해 유지한다.
  Future<void> dispose() async {
    _foregroundMessageController = null;
    _tokenCleanup.setRecoveryCallback(null);
    await Future.wait([
      _sessionLifecycle.dispose(),
      _tokenCleanup.requestCleanup(),
    ]);
  }

  /// 알림 탭 시 딥링크 처리 — notificationTapHandler로 전달.
  void _onNotificationResponse(NotificationResponse response) {
    final payload = response.payload;
    if (payload == null || payload.isEmpty) return;
    try {
      final data = Map<String, String>.from(jsonDecode(payload) as Map);
      if (data['notification_id'] != null) _notificationTapHandler?.call(data);
    } catch (_) {
      // malformed payload — ignore
    }
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
    await plugin.cancel(id: _fnv1a32Background(dedupKey));
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
