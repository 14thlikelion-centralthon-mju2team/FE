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
import "email_login_screen.dart";

/// PRD §11.3 / API 명세 §2.1 POST /auth/email/signup
/// 비밀번호 정책: 최소 10자, 이메일 로컬파트·서비스명 포함 금지 (서버에서도 검증)
///
/// ensom_signup.html 목업의 이름·닉네임 입력, 화면 내 인라인 인증코드
/// 입력, 폼 안에 끼워진 약관 동의는 적용하지 않았다 — 실제 가입
/// API(§2.1)는 이메일·비밀번호만 받고, 이름/닉네임 필드나 회원가입
/// 시점의 이메일 인증코드 입력을 지원하지 않는다(인증은 링크 클릭
/// 방식, EmailVerificationScreen 참고). 약관 동의도 가입 이후 별도
/// 화면(ConsentScreen, S-02)에서 처리한다. 없는 API를 흉내 내는 대신
/// 목업의 시각 언어(필드·버튼·오류 배너 스타일)만 가져왔다.
class EmailSignupScreen extends ConsumerStatefulWidget {
  const EmailSignupScreen({super.key});

  @override
  ConsumerState<EmailSignupScreen> createState() => _EmailSignupScreenState();
}

class _EmailSignupScreenState extends ConsumerState<EmailSignupScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _submitting = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(() => setState(() {}));
    _passwordController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String get _email => _emailController.text.trim();
  String get _password => _passwordController.text;

  bool get _emailLooksValid => RegExp(r"^[^@\s]+@[^@\s]+\.[^@\s]+$").hasMatch(_email);

  bool get _pwHasLength => _password.length >= 10;
  bool get _pwNoEmailLocal {
    final local = _email.split("@").first.toLowerCase();
    return local.isEmpty || !_password.toLowerCase().contains(local);
  }

  bool get _pwNoServiceName => !_password.toLowerCase().contains("ensom");

  bool get _pwValid => _password.isNotEmpty && _pwHasLength && _pwNoEmailLocal && _pwNoServiceName;

  bool get _canSubmit => _emailLooksValid && _pwValid && !_submitting;

  Future<void> _submit() async {
    if (!_canSubmit) return;
    setState(() {
      _submitting = true;
      _error = null;
    });
    try {
      final authNotifier = ref.read(authNotifierProvider.notifier);
      await authNotifier.signupWithEmail(email: _email, password: _password);

      if (!mounted) return;
      // 가입 성공 → 이메일 인증 안내 화면으로 이동
      context.go("/onboarding/email-verification?email=${Uri.encodeComponent(_email)}");
    } on ApiException catch (e) {
      setState(() {
        switch (e.code) {
          case "EMAIL_ALREADY_LINKED":
            _error = "이미 Google로 가입된 이메일이에요. Google로 로그인해주세요.";
          case "WEAK_PASSWORD":
            _error = "비밀번호가 너무 쉬워요. 다른 비밀번호를 사용해주세요.";
          case "VALIDATION_ERROR":
            _error = e.message;
          case "NETWORK_ERROR":
            _error = "네트워크에 연결할 수 없어요. 잠시 후 다시 시도해주세요.";
          default:
            _error = "회원가입에 실패했어요. 다시 시도해주세요.";
        }
      });
    } catch (_) {
      setState(() => _error = "회원가입에 실패했어요. 다시 시도해주세요.");
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: EnsomColors.canvas,
      appBar: const EnsomTopBar(title: "회원가입"),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(18, 8, 18, 16),
                children: [
                  if (_error != null) ...[
                    EnsomErrorBanner(title: _error!),
                    const SizedBox(height: 14),
                  ],
                  EnsomTextField(
                    label: "이메일",
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    helperText: _email.isEmpty || _emailLooksValid ? null : "이메일 형식을 확인해주세요.",
                    helperTone: EnsomFieldTone.bad,
                  ),
                  const SizedBox(height: 14),
                  EnsomTextField(
                    label: "비밀번호",
                    controller: _passwordController,
                    obscureText: true,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => _submit(),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(color: EnsomColors.surface2, borderRadius: BorderRadius.circular(14)),
                    child: Column(
                      children: [
                        _PasswordCheck(label: "10자 이상", ok: _pwHasLength),
                        _PasswordCheck(label: "이메일 주소 미포함", ok: _pwNoEmailLocal),
                        _PasswordCheck(label: "서비스명(ensom) 미포함", ok: _pwNoServiceName),
                      ],
                    ),
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
              child: Column(
                children: [
                  EnsomPillButton(
                    label: _submitting ? "가입 중..." : "회원가입",
                    onPressed: _canSubmit ? _submit : null,
                  ),
                  const SizedBox(height: 4),
                  TextButton(
                    onPressed: _submitting
                        ? null
                        : () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (_) => const EmailLoginScreen()),
                            );
                          },
                    child: const Text(
                      "이미 계정이 있으신가요? 로그인",
                      style: TextStyle(fontSize: 11.5, color: EnsomColors.inkMuted),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PasswordCheck extends StatelessWidget {
  const _PasswordCheck({required this.label, required this.ok});

  final String label;
  final bool ok;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.5),
      child: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 120),
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              color: ok ? EnsomColors.cta : Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: ok ? EnsomColors.cta : EnsomColors.hairline, width: 1.6),
            ),
            child: ok ? const Icon(Icons.check, size: 11, color: Colors.white) : null,
          ),
          const SizedBox(width: 9),
          Text(
            label,
            style: TextStyle(fontSize: 12, color: ok ? EnsomColors.ink : EnsomColors.inkMuted),
          ),
        ],
      ),
    );
  }
}
