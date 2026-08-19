import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:hive_ce_flutter/hive_ce_flutter.dart";
import "package:kakao_map_sdk/kakao_map_sdk.dart";
import "package:firebase_core/firebase_core.dart";
import "package:firebase_messaging/firebase_messaging.dart";
import "firebase_options.dart";
import "core/app_config.dart";
import "core/fcm_service.dart";
import "core/local_notification_service.dart";
import "hive_registrar.g.dart";
import "local/offline_queue_entry.dart";
import "local/place_cache_entry.dart";
import "providers/geofence_providers.dart";
import "router/app_router.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    // 플랫폼 설정 파일(google-services.json / GoogleService-Info.plist)이
    // 아직 없는 플랫폼에서도 앱 시작 자체는 막지 않는다 — FCM 없이
    // 로컬 알림만으로 계속 동작한다(fcm_service.dart와 동일한 원칙).
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    // 백그라운드 핸들러는 최상위 함수여야 하고, runApp 전에 등록해야
    // 앱이 종료된 상태에서 온 푸시도 처리할 수 있다.
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  } catch (e) {
    debugPrint("[firebase] 초기화 실패 — FCM 비활성, 로컬 알림 폴백만 동작: $e");
  }

  await Hive.initFlutter();

  Hive.registerAdapters();

  await Hive.openBox<OfflineQueueEntry>("offline_queue");
  await Hive.openBox<PlaceCacheEntry>("place_cache");

  // 로컬 알림 초기화 (TR-07)
  await LocalNotificationService.instance.initialize();

  if (kKakaoNativeAppKey.isNotEmpty) {
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
    return MaterialApp.router(
      title: "Ensom",
      theme: ThemeData(
        colorSchemeSeed: const Color(0xFF4A6CF7),
        useMaterial3: true,
      ),
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      builder: (context, child) => Stack(
        children: [
          ?child,
          const GeofenceSync(),
        ],
      ),
    );
  }
}
