import "package:flutter/material.dart";
import "../../theme/ensom_colors.dart";

/// ONB-07/08/08b 권한 프라이밍 공용 화면
/// PRD §11.4: "왜 필요한지" 설명 후 OS 권한 다이얼로그 트리거.
/// [나중에]는 항상 허용 (거부 후 재안내는 기능 진입점에서 1회만).
///
/// 사용법:
/// ```dart
/// PermissionPrimingScreen(
///   type: PermissionPrimingType.notification,
///   onAllow: () => requestPermission(),
///   onSkip: () => context.go("/next"),
/// )
/// ```
enum PermissionPrimingType { notification, location, calendar }

class PermissionPrimingScreen extends StatelessWidget {
  const PermissionPrimingScreen({
    super.key,
    required this.type,
    required this.onAllow,
    required this.onSkip,
  });

  final PermissionPrimingType type;
  final VoidCallback onAllow;
  final VoidCallback onSkip;

  String get _title {
    switch (type) {
      case PermissionPrimingType.notification:
        return "알림을 보내도 될까요?";
      case PermissionPrimingType.location:
        return "위치 정보를 사용해도 될까요?";
      case PermissionPrimingType.calendar:
        return "캘린더를 연동할까요?";
    }
  }

  String get _description {
    switch (type) {
      case PermissionPrimingType.notification:
        return "준비 시작과 출발 시각을 놓치지 않도록\n시간에 맞춰 알려드려요.";
      case PermissionPrimingType.location:
        return "출발과 도착을 자동으로 감지해서\n더 정확한 시간 계획을 세울 수 있어요.";
      case PermissionPrimingType.calendar:
        return "다음 일정과 장소를 자동으로 인식해서\n따로 입력하지 않아도 준비 계획을 세워드려요.";
    }
  }

  IconData get _icon {
    switch (type) {
      case PermissionPrimingType.notification:
        return Icons.notifications_outlined;
      case PermissionPrimingType.location:
        return Icons.location_on_outlined;
      case PermissionPrimingType.calendar:
        return Icons.calendar_today_outlined;
    }
  }

  String get _allowLabel {
    switch (type) {
      case PermissionPrimingType.notification:
        return "알림 켜기";
      case PermissionPrimingType.location:
        return "위치 허용";
      case PermissionPrimingType.calendar:
        return "캘린더 연동하기";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),
              Icon(
                _icon,
                size: 80,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 32),
              Text(
                _title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                _description,
                style: const TextStyle(
                  color: EnsomColors.inkMuted,
                  fontSize: 15,
                ),
                textAlign: TextAlign.center,
              ),
              const Spacer(flex: 3),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: onAllow,
                  child: Text(_allowLabel),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: TextButton(onPressed: onSkip, child: const Text("나중에")),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
