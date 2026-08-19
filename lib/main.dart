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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    // google-services.json / GoogleService-Info.plist이 프로젝트에 포함돼
    // 있으면 자동 감지. 없으면 예외 → catch에서 FCM 비활성 처리.
    // firebase_options.dart는 Git에 기록하지 않으므로(팀 API키 정책)
    // 옵션 없이 초기화하고 플랫폼 설정 파일에 의존한다.
    await Firebase.initializeApp();
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
