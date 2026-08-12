import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'hive_registrar.g.dart'; // build_runner가 자동 생성
import 'router/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapters(); // 박스가 늘어나도 이 줄 하나로 자동 반영

  await Hive.openBox('offline_queue');
  await Hive.openBox('place_cache');
  await Hive.openBox('geofence_state');

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