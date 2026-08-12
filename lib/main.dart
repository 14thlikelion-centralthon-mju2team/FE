import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'local/offline_queue_entry.dart';
import 'local/place_cache_entry.dart';
import 'local/geofence_state_entry.dart';
import 'router/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(OfflineQueueEntryAdapter());
  Hive.registerAdapter(PlaceCacheEntryAdapter());
  Hive.registerAdapter(GeofenceStateEntryAdapter());

  await Hive.openBox<OfflineQueueEntry>('offline_queue');
  await Hive.openBox<PlaceCacheEntry>('place_cache');
  await Hive.openBox<GeofenceStateEntry>('geofence_state');

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Vium',
      routerConfig: appRouter,
    );
  }
}