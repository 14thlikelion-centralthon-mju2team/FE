import "package:flutter/material.dart";
import "package:permission_handler/permission_handler.dart";

/// 권한 요청 중앙 서비스.
///
/// 온보딩 프라이밍 및 기능 진입점에서 OS 권한을 요청하고,
/// 상태에 따라 적절한 안내를 보여준다.
class PermissionService {
  PermissionService._();
  static final instance = PermissionService._();

  /// 알림 권한 요청.
  Future<PermissionStatus> requestNotification() async {
    final status = await Permission.notification.request();
    return status;
  }

  /// 위치 권한 요청.
  /// whenInUse가 허용되면 이어서 always를 요청한다.
  Future<PermissionStatus> requestLocation() async {
    final status = await Permission.location.request();
    if (status.isGranted) {
      // whenInUse가 허용되었으면 always 요청 시도
      final alwaysStatus = await Permission.locationAlways.request();
      return alwaysStatus;
    }
    return status;
  }

  /// 모든 필수 권한이 허용되었는지 확인.
  Future<bool> isAllGranted() async {
    final notification = await Permission.notification.isGranted;
    final location = await Permission.location.isGranted;
    final locationAlways = await Permission.locationAlways.isGranted;
    return notification && location && locationAlways;
  }

  /// 권한이 거부되었을 때 사유 안내 다이얼로그를 표시한다.
  /// permanentlyDenied이면 시스템 설정으로 안내한다.
  Future<void> showRationale(
    BuildContext context,
    PermissionRationaleType type,
  ) async {
    final title = switch (type) {
      PermissionRationaleType.notification => "알림 권한이 필요해요",
      PermissionRationaleType.location => "위치 권한이 필요해요",
    };

    final description = switch (type) {
      PermissionRationaleType.notification =>
        "준비 시작과 출발 시각을 놓치지 않도록 알려드리기 위해 알림 권한이 필요해요. "
            "권한이 없어도 앱은 계속 사용할 수 있지만, 시간 알림을 받을 수 없어요.",
      PermissionRationaleType.location =>
        "출발·도착을 자동으로 감지해서 더 정확한 시간 계획을 세우기 위해 위치 권한이 필요해요. "
            "권한이 없어도 앱은 계속 사용할 수 있지만, 자동 감지 기능이 동작하지 않아요.",
    };

    final permission = switch (type) {
      PermissionRationaleType.notification => Permission.notification,
      PermissionRationaleType.location => Permission.location,
    };

    final status = await permission.status;

    if (!context.mounted) return;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(title),
        content: Text(description),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text("괜찮아요"),
          ),
          if (status.isPermanentlyDenied)
            FilledButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                openAppSettings();
              },
              child: const Text("설정 열기"),
            ),
        ],
      ),
    );
  }
}

enum PermissionRationaleType { notification, location }
