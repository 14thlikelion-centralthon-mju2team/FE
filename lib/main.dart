import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:hive_ce_flutter/hive_ce_flutter.dart";
import "package:kakao_map_sdk/kakao_map_sdk.dart";
import "core/app_config.dart";
import "core/local_notification_service.dart";
import "hive_registrar.g.dart";
import "local/offline_queue_entry.dart";
import "local/place_cache_entry.dart";
import "providers/geofence_providers.dart";
import "router/app_router.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
