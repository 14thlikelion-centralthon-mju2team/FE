import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";
import "../../network/api_client.dart";
import "../../providers/auth_providers.dart";
import "../../theme/ensom_colors.dart";
import "../../widgets/ensom/ensom_error_banner.dart";
import "../../widgets/ensom/ensom_pill_button.dart";
import "../../widgets/ensom/ensom_text_field.dart";
import "../../widgets/ensom/ensom_top_bar.dart";

/// S-19/S-20 비밀번호 재설정 요청. ensom_signup.html 목업의 "화면4
/// 비밀번호 찾기"를 반영한다. 목업의 "화면5 비밀번호 재설정"(새
/// 비밀번호 입력 + 조건 체크리스트)은 이 앱에 대응 화면이 없다 —
/// 재설정 링크를 누르면 서버가 호스팅하는 웹 페이지에서 새 비밀번호를
/// 입력하고, 앱은 그 결과를 모른다(이메일 인증과 같은 링크 기반
/// 패턴). 없는 화면을 새로 만들지 않고 이 요청 화면만 스타일링했다.
class PasswordResetScreen extends ConsumerStatefulWidget {
  const PasswordResetScreen({super.key});

  @override
  ConsumerState<PasswordResetScreen> createState() =>
      _PasswordResetScreenState();
}

class _PasswordResetScreenState extends ConsumerState<PasswordResetScreen> {
  final _emailCtrl = TextEditingController();
  bool _submitting = false;
  bool _sent = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _emailCtrl.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  Future<void> _requestReset() async {
    final email = _emailCtrl.text.trim();
    if (email.isEmpty) return;

    setState(() {
      _submitting = true;
      _error = null;
    });

    try {
      final api = ref.read(apiClientProvider);
      await api.postPublic<Map<String, dynamic>>(
        "/auth/password/reset-request",
        body: {"email": email},
      );
    } on ApiException catch (e) {
      if (e.isNetworkError || e.retryable) {
        setState(() {
          _submitting = false;
          _error = e.isNetworkError
              ? "네트워크에 연결할 수 없어요. 다시 시도해주세요."
              : "요청을 처리하지 못했어요. 잠시 후 다시 시도해주세요.";
        });
        return;
      }
      // 그 외(400 계열) — 계정 존재 은닉을 위해 서버가 항상 200을 주므로
      // 여기 도달하면 예상치 못한 오류. 사용자에게 재시도 안내.
      setState(() {
        _submitting = false;
        _error = "요청을 처리하지 못했어요. 다시 시도해주세요.";
      });
      return;
    } finally {
      if (mounted && _error == null) {
        setState(() {
          _submitting = false;
          _sent = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: EnsomColors.canvas,
      appBar: const EnsomTopBar(title: "비밀번호 찾기"),
      body: SafeArea(
        top: false,
        child: _sent ? _buildSentState() : _buildInputState(),
      ),
    );
  }

  Widget _buildInputState() {
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(18, 14, 18, 16),
            children: [
              const Text(
                "가입하신 이메일을\n입력해 주세요",
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -.45,
                  height: 1.35,
                  color: EnsomColors.ink,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "비밀번호를 재설정할 수 있는 링크를 보내드릴게요.",
                style: TextStyle(
                  fontSize: 12.5,
                  color: EnsomColors.inkMuted,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 22),
              EnsomTextField(
                label: "이메일",
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _requestReset(),
              ),
              if (_error != null) ...[
                const SizedBox(height: 14),
                EnsomErrorBanner(title: _error!),
              ],
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(18, 12, 18, 18),
          decoration: const BoxDecoration(
            color: EnsomColors.surface1,
            border: Border(top: BorderSide(color: EnsomColors.hairline)),
          ),
          child: EnsomPillButton(
            label: _submitting ? "보내는 중..." : "재설정 메일 보내기",
            onPressed: (_emailCtrl.text.trim().isNotEmpty && !_submitting)
                ? _requestReset
                : null,
          ),
        ),
      ],
    );
  }

  Widget _buildSentState() {
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(26, 24, 26, 16),
            children: [
              Container(
                width: 64,
                height: 64,
                margin: const EdgeInsets.symmetric(horizontal: 0),
                decoration: const BoxDecoration(
                  color: EnsomColors.surface2,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.mark_email_read_outlined,
                  size: 26,
                  color: EnsomColors.ink,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "메일을 보냈어요",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -.45,
                  color: EnsomColors.ink,
                ),
              ),
              const SizedBox(height: 8),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 12.5,
                    color: EnsomColors.inkMuted,
                    height: 1.65,
                  ),
                  children: [
                    TextSpan(
                      text: _emailCtrl.text.trim(),
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: EnsomColors.ink,
                      ),
                    ),
                    const TextSpan(text: " 로 재설정 링크를 보냈어요.\n링크는 30분간 유효해요."),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: TextButton(
                  onPressed: () => setState(() => _sent = false),
                  child: const Text(
                    "다시 보내기",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                "메일이 오지 않으면 스팸함을 확인해 주세요",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 10.5, color: EnsomColors.inkFaint),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(18, 12, 18, 18),
          decoration: const BoxDecoration(
            color: EnsomColors.surface1,
            border: Border(top: BorderSide(color: EnsomColors.hairline)),
          ),
          child: EnsomPillButton(
            label: "로그인하러 가기",
            onPressed: () => context.go("/onboarding/auth"),
          ),
        ),
      ],
    );
  }
}
