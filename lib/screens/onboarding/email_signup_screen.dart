import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";
import "../../network/api_client.dart";
import "../../providers/auth_providers.dart";

/// PRD §11.3 / API 명세 §2.1 POST /auth/email/signup
/// 비밀번호 정책: 최소 10자, 이메일 로컬파트·서비스명 포함 금지 (서버에서도 검증)
class EmailSignupScreen extends ConsumerStatefulWidget {
  const EmailSignupScreen({super.key});

  @override
  ConsumerState<EmailSignupScreen> createState() => _EmailSignupScreenState();
}

class _EmailSignupScreenState extends ConsumerState<EmailSignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nicknameController = TextEditingController();

  bool _submitting = false;
  String? _error;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nicknameController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) return "이메일을 입력해주세요.";
    final ok = RegExp(r"^[^@\s]+@[^@\s]+\.[^@\s]+$").hasMatch(value.trim());
    if (!ok) return "이메일 형식을 확인해주세요.";
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return "비밀번호를 입력해주세요.";
    if (value.length < 10) return "비밀번호는 10자 이상이어야 해요.";
    // 이메일 로컬파트 포함 여부 (클라이언트 사전 검사)
    final emailLocal = _emailController.text.split("@").first.toLowerCase();
    if (emailLocal.isNotEmpty && value.toLowerCase().contains(emailLocal)) {
      return "이메일 주소를 비밀번호에 포함할 수 없어요.";
    }
    if (value.toLowerCase().contains("ensom")) {
      return "서비스명을 비밀번호에 포함할 수 없어요.";
    }
    return null;
  }

  String? _validateNickname(String? value) {
    if (value == null || value.trim().isEmpty) return "닉네임을 입력해주세요.";
    return null;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _submitting = true;
      _error = null;
    });
    try {
      final authNotifier = ref.read(authNotifierProvider.notifier);
      await authNotifier.signupWithEmail(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (!mounted) return;
      // 가입 성공 → 이메일 인증 안내 화면으로 이동
      context.go(
        "/onboarding/email-verification?email=${Uri.encodeComponent(_emailController.text.trim())}",
      );
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
      appBar: AppBar(title: const Text("이메일로 시작하기")),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: "이메일"),
                validator: _validateEmail,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "비밀번호",
                  helperText: "10자 이상, 이메일·서비스명 포함 불가",
                ),
                validator: _validatePassword,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _nicknameController,
                decoration: const InputDecoration(labelText: "닉네임"),
                validator: _validateNickname,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _submit(),
              ),
              if (_error != null) ...[
                const SizedBox(height: 16),
                Text(_error!, style: const TextStyle(color: Colors.red)),
              ],
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submitting ? null : _submit,
                child: Text(_submitting ? "가입 중..." : "가입하기"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
