import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geofencing_api/geofencing_api.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/vium_button.dart';
import '../../widgets/vium_card.dart';

enum _PermissionStep {
  intro,
  requestingForeground,
  foregroundGranted,
  requestingBackground,
  done,
  denied,
}

class LocationPermissionScreen extends StatefulWidget {
  const LocationPermissionScreen({super.key});

  @override
  State<LocationPermissionScreen> createState() => _LocationPermissionScreenState();
}

class _LocationPermissionScreenState extends State<LocationPermissionScreen> {
  _PermissionStep step = _PermissionStep.intro;
  String? statusMessage;

  // 1단계: 전경(When In Use) 권한 먼저
  Future<void> _startPermissionFlow() async {
    setState(() {
      step = _PermissionStep.requestingForeground;
      statusMessage = null;
    });

    if (!await Geofencing.instance.isLocationServicesEnabled) {
      setState(() {
        step = _PermissionStep.denied;
        statusMessage = '위치 서비스가 꺼져 있어요. 기기 설정에서 켜주세요.';
      });
      return;
    }

    LocationPermission permission = await Geofencing.instance.getLocationPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geofencing.instance.requestLocationPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      setState(() {
        step = _PermissionStep.denied;
        statusMessage = '위치 권한이 거절됐어요. 시간 기반으로 계속 이용하실 수 있어요.';
      });
      return;
    }

    setState(() => step = _PermissionStep.foregroundGranted);

    // 가치 체감 후 재요청 원칙 — 바로 이어서 묻지 않고 잠깐 텀을 둠
    await Future.delayed(const Duration(milliseconds: 600));
    await _requestBackground(permission);
  }

  // 2단계: 배경(Always) 권한 — 안드로이드는 별도 재요청 필요
  Future<void> _requestBackground(LocationPermission current) async {
    setState(() => step = _PermissionStep.requestingBackground);

    if (Platform.isAndroid && current == LocationPermission.whileInUse) {
      final upgraded = await Geofencing.instance.requestLocationPermission();
      if (upgraded != LocationPermission.always) {
        setState(() {
          step = _PermissionStep.done;
          statusMessage = '앱 사용 중에만 위치가 허용됐어요. 나중에 설정에서 바꿀 수 있어요.';
        });
        return;
      }
    }
    // iOS는 시스템이 알아서 "항상 허용" 업그레이드 다이얼로그를 보여줌

    setState(() {
      step = _PermissionStep.done;
      statusMessage = '위치 설정이 완료됐어요';
    });
  }

  void _skip() {
    setState(() {
      step = _PermissionStep.denied;
      statusMessage = null;
    });
  }

  void _goNext() {
    context.go('/onboarding/location-modal');
  }

  @override
  Widget build(BuildContext context) {
    final showActionButtons =
        step == _PermissionStep.intro || step == _PermissionStep.done || step == _PermissionStep.denied;

    return Scaffold(
      appBar: AppBar(title: const Text('위치 권한 안내')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ViumCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    '회사에 도착하면, 그날 할 수 있는 걸 알려드려요',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '위치는 기기 안에서만 계산되고, 서버에는 장소 이름만 저장돼요',
                    style: TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _buildStatusRow(),
            const Spacer(),
            if (step == _PermissionStep.intro) ...[
              ViumButton(label: '위치 허용하기', onPressed: _startPermissionFlow),
              const SizedBox(height: 8),
              ViumButton(label: '나중에 할게요', isPrimary: false, onPressed: _skip),
            ] else if (showActionButtons) ...[
              ViumButton(label: '다음으로', onPressed: _goNext),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatusRow() {
    final (text, showSpinner) = switch (step) {
      _PermissionStep.intro => ('', false),
      _PermissionStep.requestingForeground => ('권한을 확인하고 있어요...', true),
      _PermissionStep.foregroundGranted => ('좋아요! 이어서 배경 권한도 확인할게요', false),
      _PermissionStep.requestingBackground => ('배경 위치 권한을 확인하고 있어요...', true),
      _PermissionStep.done => (statusMessage ?? '설정이 완료됐어요', false),
      _PermissionStep.denied => (statusMessage ?? '', false),
    };
    if (text.isEmpty) return const SizedBox.shrink();
    return Row(
      children: [
        if (showSpinner)
          const Padding(
            padding: EdgeInsets.only(right: 8),
            child: SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
        Expanded(child: Text(text)),
      ],
    );
  }
}