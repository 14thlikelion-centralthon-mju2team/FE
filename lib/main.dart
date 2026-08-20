import "dart:async";

import "package:flutter/foundation.dart" show kIsWeb;
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:hive_ce_flutter/hive_ce_flutter.dart";
import "package:kakao_map_sdk/kakao_map_sdk.dart";
import "package:firebase_core/firebase_core.dart";
import "package:firebase_messaging/firebase_messaging.dart";
import "core/app_config.dart";
import "core/fcm_service.dart";
import "core/local_notification_service.dart";
import "hive_registrar.g.dart";
import "local/offline_queue_entry.dart";
import "local/place_cache_entry.dart";
import "providers/geofence_providers.dart";
import "router/app_router.dart";
import "theme/ensom_colors.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // 웹은 firebase_options.dart/웹 Firebase 설정이 없어 시도조차 하지 않는다.
  // FirebaseMessaging.instance(FcmService의 필드 초기화자)가 기본 앱 없이
  // 접근되면 [core/no-app] 예외가 이 try 바깥(위젯 빌드 중)에서 다시
  // 터져 runApp() 이후에도 화면이 비는 문제가 있었다.
  if (!kIsWeb) {
    try {
      // google-services.json / GoogleService-Info.plist이 프로젝트에 포함돼
      // 있으면 자동 감지. 없으면 예외 → catch에서 FCM 비활성 처리.
      // firebase_options.dart는 Git에 기록하지 않으므로(팀 API키 정책)
      // 옵션 없이 초기화하고 플랫폼 설정 파일에 의존한다.
      await Firebase.initializeApp();
      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
      unawaited(FcmService.instance.retryPendingTokenCleanup());
    } catch (e) {
      debugPrint("[firebase] 초기화 실패 — FCM 비활성, 로컬 알림 폴백만 동작: $e");
    }
  }

  await Hive.initFlutter();

  Hive.registerAdapters();

  await Hive.openBox<OfflineQueueEntry>("offline_queue");
  await Hive.openBox<PlaceCacheEntry>("place_cache");

  // 로컬 알림 초기화 (TR-07)
  await LocalNotificationService.instance.initialize();

  // kakao_map_sdk는 MethodChannel(네이티브 전용) 기반이라 웹에는 핸들러가
  // 없다 — 웹에서 호출하면 MissingPluginException이 runApp() 이전에
  // 발생해 앱이 아예 뜨지 못하고 흰 화면만 남는다 (지도 화면 자체의 웹
  // 지원 여부와는 별개 문제).
  if (!kIsWeb && kKakaoNativeAppKey.isNotEmpty) {
    await KakaoMapSdk.instance.initialize(kKakaoNativeAppKey);
  }

  runApp(const ProviderScope(child: EnsomApp()));
}

/// 앱 루트. go_router를 Riverpod provider로 관리해 AuthState 변화 시
/// 자동 리다이렉트가 동작한다.
class EnsomApp extends ConsumerWidget {
  const EnsomApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    if (!kIsWeb) {
      FcmService.instance.setNotificationTapHandler((metadata) {
        // notificationId/planId/type만 받은 뒤 서버 notification log에서 최신 상태를 조회한다.
        router.go("/notifications/today");
      });
    }
    return MaterialApp.router(
      title: "Ensom",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: EnsomColors.cta,
          brightness: Brightness.light,
          primary: EnsomColors.cta,
          secondary: EnsomColors.lime,
          surface: EnsomColors.surface1,
          error: EnsomColors.caution,
        ),
        scaffoldBackgroundColor: EnsomColors.canvas,
        dividerColor: EnsomColors.hairline,
        appBarTheme: const AppBarTheme(
          backgroundColor: EnsomColors.canvas,
          foregroundColor: EnsomColors.ink,
          surfaceTintColor: Colors.transparent,
        ),
        useMaterial3: true,
      ),
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      // GeofenceSync는 nextEvent를 구독하고 GeofenceManager(geofencing_api,
      // 네이티브 전용)를 건드린다. 웹에는 지오펜스가 없고, 이 위젯이 앱 전역
      // builder에서 항상 렌더되며 /events/next를 호출해 미인증 상태에서도
      // 401 + 네이티브 플러그인 접근으로 흰 화면을 유발했다. 웹에서는 뺀다.
      builder: (context, child) => kIsWeb
          ? (child ?? const SizedBox.shrink())
          : Stack(children: [?child, const GeofenceSync()]),
    );
  }
}
