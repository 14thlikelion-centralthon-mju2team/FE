import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";
import "../../core/logout_helper.dart";
import "../../theme/ensom_colors.dart";

/// PRF-01 프로필 메인 리스트
/// 화면설계서: 계정→PRF-02, 권한→PRF-05, 준비설정→PRF-06,
///           알림→PRF-07, 개인화→PRF-08, 데이터→PRF-09
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text("프로필")),
      body: ListView(
        children: [
          const SizedBox(height: 8),
          _ProfileSection(
            title: "계정",
            items: [
              _ProfileItem(
                icon: Icons.person_outline,
                label: "계정 정보",
                onTap: () => context.push("/profile/account"),
              ),
            ],
          ),
          _ProfileSection(
            title: "설정",
            items: [
              _ProfileItem(
                icon: Icons.tune,
                label: "준비 설정",
                onTap: () => context.push("/profile/prep"),
              ),
              _ProfileItem(
                icon: Icons.notifications_outlined,
                label: "알림 설정",
                onTap: () => context.push("/profile/notifications"),
              ),
              _ProfileItem(
                icon: Icons.spa_outlined,
                label: "웰니스",
                onTap: () => context.push("/settings/wellness-prefs"),
              ),
              _ProfileItem(
                icon: Icons.shield_outlined,
                label: "권한 관리",
                onTap: () => context.push("/profile/permissions"),
              ),
            ],
          ),
          _ProfileSection(
            title: "데이터",
            items: [
              _ProfileItem(
                icon: Icons.auto_graph,
                label: "개인화",
                onTap: () => context.push("/profile/personalization"),
              ),
              _ProfileItem(
                icon: Icons.storage_outlined,
                label: "데이터 관리",
                onTap: () => context.push("/profile/data"),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: OutlinedButton(
              onPressed: () => showLogoutConfirmAndExecute(context, ref),
              style: OutlinedButton.styleFrom(
                foregroundColor: EnsomColors.caution,
              ),
              child: const Text("로그아웃"),
            ),
          ),
          const SizedBox(height: 48),
        ],
      ),
    );
  }
}

class _ProfileSection extends StatelessWidget {
  const _ProfileSection({required this.title, required this.items});

  final String title;
  final List<_ProfileItem> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.labelLarge?.copyWith(color: EnsomColors.inkFaint),
          ),
        ),
        ...items,
        const Divider(height: 1),
      ],
    );
  }
}

class _ProfileItem extends StatelessWidget {
  const _ProfileItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      trailing: const Icon(Icons.chevron_right, color: EnsomColors.inkMuted),
      onTap: onTap,
    );
  }
}
