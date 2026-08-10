import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';
import 'package:geofencing_api/geofencing_api.dart';

void main() => runApp(const MaterialApp(home: SpikeScreen()));

class SpikeScreen extends StatefulWidget {
  const SpikeScreen({super.key});
  @override
  State<SpikeScreen> createState() => _SpikeScreenState();
}

class _SpikeScreenState extends State<SpikeScreen> {
  String log = "대기 중";

  // 공식 문서의 권한 요청 함수 그대로
  Future<bool> requestLocationPermission({bool background = false}) async {
    if (!await Geofencing.instance.isLocationServicesEnabled) {
      setState(() => log = "위치 서비스가 꺼져 있음");
      return false;
    }

    LocationPermission permission = await Geofencing.instance.getLocationPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geofencing.instance.requestLocationPermission();
    }

    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      setState(() => log = "권한 거절됨: ${permission.name}");
      return false;
    }

    // 안드로이드는 배경 권한을 한 번 더 요청해야 함
    if (Platform.isAndroid && background && permission == LocationPermission.whileInUse) {
      permission = await Geofencing.instance.requestLocationPermission();
      if (permission != LocationPermission.always) {
        setState(() => log = "배경 권한 획득 실패");
        return false;
      }
    }

    setState(() => log = "권한 상태: ${permission.name}");
    return true;
  }

  void setupAndStart() async {
    Geofencing.instance.setup(
      interval: 5000,
      accuracy: 100,
      statusChangeDelay: 10000,
    );

    final regions = {
      GeofenceRegion.circular(
        id: 'test_place',
        data: {'name': '테스트 장소'},
        center: const LatLng(37.5665, 126.9780), // 본인 현재 위치 좌표로 바꾸기
        radius: 100,
      ),
    };

    Geofencing.instance.addGeofenceStatusChangedListener(_onStatusChanged);
    await Geofencing.instance.start(regions: regions);
    setState(() => log = "지오펜스 시작됨");
  }

  Future<void> _onStatusChanged(
    GeofenceRegion region, GeofenceStatus status, Location location) async {
    debugPrint("[${DateTime.now()}] ${region.id}: ${status.name}");
    setState(() => log = "이벤트: ${region.id} / ${status.name} / ${DateTime.now()}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(log, style: const TextStyle(fontSize: 16), textAlign: TextAlign.center),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => requestLocationPermission(background: true),
              child: const Text("1. 권한 요청(배경 포함)"),
            ),
            ElevatedButton(onPressed: setupAndStart, child: const Text("2. 지오펜스 시작")),
          ],
        ),
      ),
    );
  }
}