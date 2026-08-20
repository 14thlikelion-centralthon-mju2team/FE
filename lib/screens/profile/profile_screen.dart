import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";
import "../../theme/ensom_colors.dart";

/// PRF-01 프로필 메인 리스트 — v6 프로토타입 기준 redesign
/// 디자인 기준: Ensom_프로토타입_v6_최종/05_설정/ensom_profile.html
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: EnsomColors.canvas,
      body: SafeArea(
        child: Column(
          children: [
            _TopBar(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  const SizedBox(height: 4),
                  // 프로필 헤더
                  _ProfileHeader(
                    initial: "도",
                    name: "김도현님",
                    email: "dohyun@ensom.app",
                  ),
                  const SizedBox(height: 8),

                  // 계정 섹션
                  const _SectionLabel("계정"),
                  _SettingsRow(
                    icon: Icons.person_outline,
                    title: "로그인 계정 정보",
                    onTap: () => context.push("/profile/account"),
                  ),

                  // 권한·설정 섹션
                  const _SectionLabel("권한 · 설정"),
                  _SettingsRow(
                    icon: Icons.shield_outlined,
                    title: "권한 관리",
                    trailing: _PillBadge("2건 허용", PillType.positive),
                    onTap: () => context.push("/profile/permissions"),
                  ),
                  _SettingsRow(
                    icon: Icons.access_time,
                    title: "준비 설정",
                    onTap: () => context.push("/profile/prep"),
                  ),
                  _SettingsRow(
                    icon: Icons.notifications_outlined,
                    title: "알림",
                    onTap: () => context.push("/profile/notifications"),
                  ),
                  _SettingsRow(
                    icon: Icons.wb_sunny_outlined,
                    title: "웰니스",
                    onTap: () => context.push("/settings/wellness-prefs"),
                  ),

                  // 기록 섹션
                  const _SectionLabel("기록"),
                  _SettingsRow(
                    icon: Icons.bar_chart,
                    title: "주간 리포트",
                    subtitle: "준비·도착 흐름과 환경 노출 요약",
                    onTap: () => context.push("/calendar/report"),
                  ),

                  // 개인화·데이터 섹션
                  const _SectionLabel("개인화 · 데이터"),
                  _SettingsRow(
                    icon: Icons.show_chart,
                    title: "개인화",
                    onTap: () => context.push("/profile/personalization"),
                  ),
                  _SettingsRow(
                    icon: Icons.storage_outlined,
                    title: "데이터",
                    onTap: () => context.push("/profile/data"),
                  ),

                  const SizedBox(height: 48),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Top Bar (워드마크) ───

class _TopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      alignment: Alignment.centerLeft,
      child: Text(
        "ENSOM",
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.6,
          color: EnsomColors.ink,
        ),
      ),
    );
  }
}

// ─── Profile Header ───

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({
    required this.initial,
    required this.name,
    required this.email,
  });

  final String initial;
  final String name;
  final String email;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 18),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: EnsomColors.surface2,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              initial,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: EnsomColors.inkMuted,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: EnsomColors.ink,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                email,
                style: TextStyle(
                  fontSize: 11.5,
                  color: EnsomColors.inkMuted,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Section Label ───

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 18, bottom: 4),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
          fontSize: 10.5,
          fontWeight: FontWeight.w700,
          color: EnsomColors.inkFaint,
          letterSpacing: 0.4,
        ),
      ),
    );
  }
}

// ─── Settings Row ───

class _SettingsRow extends StatelessWidget {
  const _SettingsRow({
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 13),
        child: Row(
          children: [
            // 아이콘 원형 배경
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: EnsomColors.surface2,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Icon(icon, size: 15, color: EnsomColors.inkMuted),
            ),
            const SizedBox(width: 12),
            // 텍스트
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: EnsomColors.ink,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle!,
                      style: TextStyle(
                        fontSize: 11,
                        color: EnsomColors.inkFaint,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            // trailing (pill badge 등)
            if (trailing != null) ...[
              trailing!,
              const SizedBox(width: 6),
            ],
            // chevron
            Icon(
              Icons.chevron_right,
              size: 14,
              color: EnsomColors.inkFaint,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Pill Badge ───

enum PillType { positive, neutral, caution }

class _PillBadge extends StatelessWidget {
  const _PillBadge(this.text, this.type);
  final String text;
  final PillType type;

  @override
  Widget build(BuildContext context) {
    final (bg, fg) = switch (type) {
      PillType.positive => (EnsomColors.limeSoft, EnsomColors.limeInk),
      PillType.neutral => (EnsomColors.surface2, EnsomColors.inkMuted),
      PillType.caution => (EnsomColors.caution, EnsomColors.ink),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10.5,
          fontWeight: FontWeight.w700,
          color: fg,
        ),
      ),
    );
  }
}
