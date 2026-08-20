import "package:flutter/material.dart";
import "package:permission_handler/permission_handler.dart";
import "../../theme/ensom_colors.dart";
import "../../widgets/ensom/ensom_pill_button.dart";
import "../../widgets/ensom/ensom_top_bar.dart";

/// PRF-05 권한 관리
/// OS 설정으로 이동하는 간단한 상태 표시 화면
///
/// ensom_profile.html "2. 권한 관리" 화면 반영. 목업엔 캘린더 연동
/// 행도 있지만, 그건 OS 권한이 아니라 OAuth 연동 상태(캘린더 연동
/// 관리 화면이 따로 있음)라 이 permission_handler 기반 화면에는
/// 넣지 않았다 — 이 화면이 실제로 조회할 수 있는 상태만 보여준다.
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
    final current = <Permission, PermissionStatus>{};
    for (final p in [
      Permission.notification,
      Permission.location,
      Permission.locationAlways,
    ]) {
      current[p] = await p.status;
    }
    if (mounted) setState(() => _statuses = current);
  }

  @override
  Widget build(BuildContext context) {
    final alwaysGranted = _statuses[Permission.locationAlways]?.isGranted ?? false;

    return Scaffold(
      backgroundColor: EnsomColors.canvas,
      appBar: const EnsomTopBar(title: "권한"),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
          children: [
            _PermissionRow(
              label: "위치 (사용 중)",
              status: _statuses[Permission.location],
            ),
            const SizedBox(height: 9),
            _PermissionRow(
              label: "알림",
              status: _statuses[Permission.notification],
            ),
            const Divider(height: 30, color: EnsomColors.hairline),
            const Text(
              "자동 출발 · 도착 확인",
              style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: EnsomColors.inkFaint, letterSpacing: .4),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(color: EnsomColors.surface2, borderRadius: BorderRadius.circular(18)),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "항상 위치 허용",
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: EnsomColors.ink),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          "앱을 쓰지 않을 때도 출발·도착을 자동으로 확인해요.",
                          style: TextStyle(fontSize: 11.5, color: EnsomColors.inkMuted, height: 1.5),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    alwaysGranted ? Icons.check_circle : Icons.chevron_right,
                    size: alwaysGranted ? 20 : 16,
                    color: alwaysGranted ? EnsomColors.limeInk : EnsomColors.inkFaint,
                  ),
                ],
              ),
            ),
            if (alwaysGranted) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(13),
                decoration: BoxDecoration(color: EnsomColors.surface2, borderRadius: BorderRadius.circular(14)),
                child: const Text(
                  "위치 정보는 준비·이동 시간 계산에만 사용되고 암호화되어 저장돼요. 언제든 시스템 설정에서 다시 끌 수 있어요.",
                  style: TextStyle(fontSize: 11.5, color: EnsomColors.inkMuted, height: 1.5),
                ),
              ),
            ],
            const SizedBox(height: 22),
            EnsomPillButton(label: "시스템 설정 열기", onPressed: openAppSettings),
          ],
        ),
      ),
    );
  }
}

class _PermissionRow extends StatelessWidget {
  const _PermissionRow({required this.label, this.status});

  final String label;
  final PermissionStatus? status;

  @override
  Widget build(BuildContext context) {
    final granted = status?.isGranted ?? false;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: EnsomColors.surface1,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: EnsomColors.hairline),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600, color: EnsomColors.ink),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: granted ? EnsomColors.limeSoft : EnsomColors.surface2,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              granted ? "허용" : "꺼짐",
              style: TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.w700,
                color: granted ? EnsomColors.limeInk : EnsomColors.inkMuted,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
