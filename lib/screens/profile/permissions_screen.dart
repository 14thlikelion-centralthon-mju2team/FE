import "package:flutter/material.dart";
import "package:permission_handler/permission_handler.dart";

/// PRF-05 권한 관리
/// OS 설정으로 이동하는 간단한 상태 표시 화면
class PermissionsScreen extends StatefulWidget {
  const PermissionsScreen({super.key});

  @override
  State<PermissionsScreen> createState() => _PermissionsScreenState();
}

class _PermissionsScreenState extends State<PermissionsScreen>
    with WidgetsBindingObserver {
  Map<Permission, PermissionStatus> _statuses = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkPermissions();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // OS 설정에서 돌아오면 상태 새로고침
    if (state == AppLifecycleState.resumed) {
      _checkPermissions();
    }
  }

  Future<void> _checkPermissions() async {
    final statuses = await [
      Permission.notification,
      Permission.location,
      Permission.locationAlways,
    ].request();
    // request 대신 status만 확인 (요청하지 않고 현재 상태만 조회)
    final current = <Permission, PermissionStatus>{};
    for (final p in [Permission.notification, Permission.location, Permission.locationAlways]) {
      current[p] = await p.status;
    }
    if (mounted) setState(() => _statuses = current);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("권한 관리")),
      body: ListView(
        children: [
          _PermissionTile(
            icon: Icons.notifications_outlined,
            label: "알림",
            status: _statuses[Permission.notification],
          ),
          _PermissionTile(
            icon: Icons.location_on_outlined,
            label: "위치 (사용 중)",
            status: _statuses[Permission.location],
          ),
          _PermissionTile(
            icon: Icons.location_on,
            label: "위치 (항상 허용)",
            status: _statuses[Permission.locationAlways],
            description: "자동 출발·도착 감지에 필요해요",
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton.icon(
              onPressed: openAppSettings,
              icon: const Icon(Icons.settings),
              label: const Text("시스템 설정 열기"),
            ),
          ),
        ],
      ),
    );
  }
}

class _PermissionTile extends StatelessWidget {
  const _PermissionTile({
    required this.icon,
    required this.label,
    this.status,
    this.description,
  });

  final IconData icon;
  final String label;
  final PermissionStatus? status;
  final String? description;

  @override
  Widget build(BuildContext context) {
    final granted = status?.isGranted ?? false;
    return ListTile(
      leading: Icon(icon, color: granted ? Colors.green : Colors.grey),
      title: Text(label),
      subtitle: description != null ? Text(description!) : null,
      trailing: Chip(
        label: Text(
          granted ? "허용" : "꺼짐",
          style: TextStyle(
            color: granted ? Colors.green : Colors.orange,
            fontSize: 12,
          ),
        ),
        backgroundColor: granted
            ? Colors.green.withOpacity(0.1)
            : Colors.orange.withOpacity(0.1),
      ),
    );
  }
}
