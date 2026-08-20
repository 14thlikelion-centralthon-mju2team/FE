import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";
import "../../core/logout_helper.dart";
import "../../theme/ensom_colors.dart";

/// PRF-02 계정 정보 — v6 프로토타입 기준 redesign
/// 디자인 기준: Ensom_프로토타입_v6_최종/05_설정/ensom_account.html (v0)
class AccountScreen extends ConsumerWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: EnsomColors.canvas,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(context),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  const SizedBox(height: 16),
                  // 프로필 카드
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: EnsomColors.surface1,
                      border: Border.all(color: EnsomColors.hairline),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 52,
                          height: 52,
                          decoration: const BoxDecoration(
                            color: EnsomColors.surface2,
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: const Text("도",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: EnsomColors.inkMuted)),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text("김도현님",
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: EnsomColors.ink)),
                            SizedBox(height: 3),
                            Text("dohyun@ensom.app",
                                style: TextStyle(
                                    fontSize: 11.5,
                                    color: EnsomColors.inkMuted)),
                            SizedBox(height: 4),
                            Text("2025년 3월 가입",
                                style: TextStyle(
                                    fontSize: 10.5,
                                    color: EnsomColors.inkFaint)),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // 로그인 정보 섹션
                  _SectionLabel("로그인 정보"),
                  _AccountRow(
                    icon: Icons.email_outlined,
                    title: "아이디(이메일)",
                    value: "dohyun@ensom.app",
                    onTap: () => context.push("/profile/change-email"),
                  ),
                  _AccountRow(
                    icon: Icons.lock_outline,
                    title: "비밀번호",
                    value: "마지막 변경 3개월 전",
                    onTap: () => context.push("/profile/change-password"),
                  ),
                  _AccountRow(
                    icon: Icons.link,
                    title: "연결된 로그인 수단",
                    trailing: _PillBadge("2개 연결됨"),
                    onTap: () => context.push("/profile/providers"),
                  ),

                  // 구분선
                  Container(
                    height: 1,
                    margin: const EdgeInsets.only(top: 20),
                    color: EnsomColors.hairline,
                  ),
                  _SimpleRow(
                    title: "로그아웃",
                    onTap: () => showLogoutConfirmAndExecute(context, ref),
                  ),

                  // 탈퇴 영역
                  Container(
                    margin: const EdgeInsets.only(top: 30),
                    padding: const EdgeInsets.only(top: 16),
                    decoration: const BoxDecoration(
                      border: Border(
                        top: BorderSide(color: EnsomColors.hairline),
                      ),
                    ),
                    child: _SimpleRow(
                      title: "회원 탈퇴",
                      titleColor: EnsomColors.inkMuted,
                      onTap: () => context.push("/profile/withdraw"),
                    ),
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

  Widget _buildTopBar(BuildContext context) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => context.pop(),
            child: Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                color: EnsomColors.surface2,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: const Icon(Icons.chevron_left, size: 14, color: EnsomColors.ink),
            ),
          ),
          const SizedBox(width: 10),
          const Text(
            "계정",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: EnsomColors.ink,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Components ───

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);
  final String text;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 18, bottom: 4),
      child: Text(
        text.toUpperCase(),
        style: const TextStyle(
          fontSize: 10.5,
          fontWeight: FontWeight.w700,
          color: EnsomColors.inkFaint,
          letterSpacing: 0.4,
        ),
      ),
    );
  }
}

class _AccountRow extends StatelessWidget {
  const _AccountRow({
    required this.icon,
    required this.title,
    this.value,
    this.trailing,
    required this.onTap,
  });
  final IconData icon;
  final String title;
  final String? value;
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
            Container(
              width: 34,
              height: 34,
              decoration: const BoxDecoration(
                color: EnsomColors.surface2,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Icon(icon, size: 15, color: EnsomColors.inkMuted),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(title,
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: EnsomColors.ink)),
            ),
            if (value != null)
              Text(value!,
                  style: const TextStyle(
                      fontSize: 11, color: EnsomColors.inkMuted)),
            if (trailing != null) trailing!,
            const SizedBox(width: 6),
            const Icon(Icons.chevron_right, size: 14, color: EnsomColors.inkFaint),
          ],
        ),
      ),
    );
  }
}

class _SimpleRow extends StatelessWidget {
  const _SimpleRow({
    required this.title,
    this.titleColor,
    required this.onTap,
  });
  final String title;
  final Color? titleColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 13),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: titleColor ?? EnsomColors.ink,
          ),
        ),
      ),
    );
  }
}

class _PillBadge extends StatelessWidget {
  const _PillBadge(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: EnsomColors.limeSoft,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 10.5,
          fontWeight: FontWeight.w700,
          color: EnsomColors.limeInk,
        ),
      ),
    );
  }
}
