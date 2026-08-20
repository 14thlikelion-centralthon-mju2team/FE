import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";
import "package:google_sign_in/google_sign_in.dart";
import "../../core/logout_helper.dart";
import "../../network/api_client.dart";
import "../../providers/auth_providers.dart";
import "../../providers/bootstrap_provider.dart";
import "../../theme/ensom_colors.dart";
import "../../widgets/ensom/ensom_pill_button.dart";
import "../../widgets/ensom/ensom_top_bar.dart";

/// PRF-02 계정 정보. ensom_profile.html "1. 계정 정보" 화면을 반영 —
/// 아바타+이름+이메일+가입일 카드, 로그아웃, danger-zone(회원 탈퇴).
class AccountScreen extends ConsumerWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);
    final bootstrap = ref.watch(bootstrapProvider).value;
    final nickname = bootstrap?.user.nickname ?? "";
    final initial = nickname.isNotEmpty ? nickname.substring(0, 1) : "?";

    return Scaffold(
      backgroundColor: EnsomColors.canvas,
      appBar: const EnsomTopBar(title: "계정"),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: EnsomColors.surface1,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: EnsomColors.hairline),
              ),
              child: Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: const BoxDecoration(color: EnsomColors.surface2, shape: BoxShape.circle),
                    alignment: Alignment.center,
                    child: Text(
                      initial,
                      style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: EnsomColors.inkMuted),
                    ),
                  ),
                  const SizedBox(width: 13),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          nickname.isNotEmpty ? "$nickname님" : "회원님",
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: EnsomColors.ink),
                        ),
                        if (authState.email != null) ...[
                          const SizedBox(height: 3),
                          Text(authState.email!, style: const TextStyle(fontSize: 11.5, color: EnsomColors.inkMuted)),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),
            _AccountRow(icon: Icons.lock_outline, label: "비밀번호 변경", onTap: () => context.push("/profile/change-password")),
            _AccountRow(icon: Icons.email_outlined, label: "이메일 변경", onTap: () => context.push("/profile/change-email")),
            _AccountRow(icon: Icons.vpn_key_outlined, label: "로그인 수단", onTap: () => context.push("/profile/providers")),
            _AccountRow(icon: Icons.devices_outlined, label: "로그인 기록", onTap: () => context.push("/profile/sessions")),
            const Divider(height: 26, color: EnsomColors.hairline),
            _AccountRow(icon: Icons.logout, label: "로그아웃", onTap: () => showLogoutConfirmAndExecute(context, ref)),
            Container(
              margin: const EdgeInsets.only(top: 22),
              padding: const EdgeInsets.only(top: 14),
              decoration: const BoxDecoration(border: Border(top: BorderSide(color: EnsomColors.hairline))),
              child: _AccountRow(
                icon: Icons.person_off_outlined,
                label: "회원 탈퇴",
                muted: true,
                onTap: () => context.push("/profile/withdraw"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AccountRow extends StatelessWidget {
  const _AccountRow({required this.icon, required this.label, required this.onTap, this.muted = false});

  final IconData icon;
  final String label;
  final bool muted;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 2),
        child: Row(
          children: [
            Icon(icon, size: 18, color: muted ? EnsomColors.inkFaint : EnsomColors.inkMuted),
            const SizedBox(width: 13),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: muted ? EnsomColors.inkMuted : EnsomColors.ink,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// PRF-03/04 회원 탈퇴 (2단계 → 소셜 재확인 방식)
class WithdrawScreen extends ConsumerStatefulWidget {
  const WithdrawScreen({super.key});

  @override
  ConsumerState<WithdrawScreen> createState() => _WithdrawScreenState();
}

class _WithdrawScreenState extends ConsumerState<WithdrawScreen> {
  int _step = 1; // 1: 경고, 2: 최종확인
  bool _processing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: EnsomColors.canvas,
      appBar: EnsomTopBar(title: _step == 1 ? "회원 탈퇴" : "최종 확인"),
      body: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 8, 18, 18),
          child: _step == 1 ? _buildStep1() : _buildStep2(),
        ),
      ),
    );
  }

  Widget _buildStep1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "정말 탈퇴하시겠어요?",
          style: TextStyle(fontSize: 19, fontWeight: FontWeight.w700, letterSpacing: -.3, color: EnsomColors.ink),
        ),
        const SizedBox(height: 10),
        const Text(
          "탈퇴하면 아래 데이터가 함께 삭제돼요.",
          style: TextStyle(fontSize: 12.5, color: EnsomColors.inkMuted, height: 1.6),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(color: EnsomColors.surface2, borderRadius: BorderRadius.circular(18)),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _BulletLine("일정과 준비 계획"),
              _BulletLine("맞춤 준비 항목과 개인화 기록"),
              _BulletLine("웰니스 설정과 행동 기록"),
            ],
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          "동의 이력은 법정 보존 기간 동안 유지돼요.",
          style: TextStyle(fontSize: 10.5, color: EnsomColors.inkFaint, height: 1.5),
        ),
        const Spacer(),
        EnsomPillButton(label: "취소", variant: EnsomPillVariant.secondary, onPressed: () => Navigator.pop(context)),
        const SizedBox(height: 6),
        EnsomPillButton(
          label: "탈퇴할게요",
          variant: EnsomPillVariant.text,
          onPressed: () => setState(() => _step = 2),
        ),
      ],
    );
  }

  Widget _buildStep2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "재가입해도 이전 데이터는\n복구되지 않아요",
          style: TextStyle(fontSize: 19, fontWeight: FontWeight.w700, letterSpacing: -.3, height: 1.35, color: EnsomColors.ink),
        ),
        const SizedBox(height: 10),
        const Text(
          "본인 확인을 위해 다시 한번 로그인해주세요.",
          style: TextStyle(fontSize: 12.5, color: EnsomColors.inkMuted, height: 1.6),
        ),
        const Spacer(),
        // 소셜 로그인 재확인 (화면설계서 PRF-04: 비밀번호 필드 대신 소셜 재확인)
        EnsomPillButton(
          label: _processing ? "처리 중..." : "탈퇴 확인",
          onPressed: _processing ? null : _withdraw,
        ),
      ],
    );
  }

  Future<void> _withdraw() async {
    setState(() => _processing = true);
    try {
      // Must-Fix #3: 소셜 재인증 — Google 로그인 재확인
      final googleSignIn = GoogleSignIn();
      final account = await googleSignIn.signIn();
      if (account == null) {
        // 사용자가 재인증을 취소
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text("본인 확인이 필요해요.")));
          setState(() => _processing = false);
        }
        return;
      }

      final apiClient = ref.read(apiClientProvider);
      await apiClient.delete("/me");
      // 로컬 리소스 소거 (알림, 오프라인 큐, 장소 캐시)
      await clearLocalCaches(ref);
      if (mounted) {
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (ctx) => AlertDialog(
            title: const Text("탈퇴가 완료됐어요."),
            content: const Text("그동안 이용해주셔서 고마워요."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  ref.read(authNotifierProvider.notifier).logout();
                },
                child: const Text("확인"),
              ),
            ],
          ),
        );
      }
    } on ApiException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.message)));
        setState(() => _processing = false);
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("본인 확인에 실패했어요. 다시 시도해주세요.")),
        );
        setState(() => _processing = false);
      }
    }
  }
}

class _BulletLine extends StatelessWidget {
  const _BulletLine(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 7),
            child: SizedBox(
              width: 4,
              height: 4,
              child: DecoratedBox(decoration: BoxDecoration(color: EnsomColors.inkFaint, shape: BoxShape.circle)),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(text, style: const TextStyle(fontSize: 12.5, color: EnsomColors.inkMuted, height: 1.6)),
          ),
        ],
      ),
    );
  }
}
