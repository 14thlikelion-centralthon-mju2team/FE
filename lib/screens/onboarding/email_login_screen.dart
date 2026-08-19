import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";
import "../../network/api_client.dart";
import "../../providers/auth_providers.dart";

/// API 명세 §2.2 POST /auth/email/login
/// 실패 시 AUTH_INVALID_CREDENTIALS (이메일 없음·비밀번호 불일치 구분 안 함, TR-14)
/// 연속 5회 실패 시 ACCOUNT_LOCKED (423) + retryAfterSec
class EmailLoginScreen extends ConsumerStatefulWidget {
  const EmailLoginScreen({super.key});

  @override
  ConsumerState<EmailLoginScreen> createState() => _EmailLoginScreenState();
}

class _EmailLoginScreenState extends ConsumerState<EmailLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _submitting = false;
  String? _error;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) return "이메일을 입력해주세요.";
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return "비밀번호를 입력해주세요.";
    return null;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _submitting = true;
      _error = null;
    });
    try {
      final installationId = await ref.read(secureStorageProvider).installationId;
      final authNotifier = ref.read(authNotifierProvider.notifier);
      await authNotifier.loginWithEmail(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        installationId: installationId,
      );

      if (!mounted) return;

      // AuthNotifier가 상태를 전이시켰으므로 라우터가 리다이렉트 처리.
      // 하지만 명시적 분기도 둬서 go_router redirect가 아직 안 붙었을 때도 동작.
      final authState = ref.read(authNotifierProvider);
      switch (authState.status) {
        case AuthStatus.emailVerificationRequired:
          context.go(
            "/onboarding/email-verification?email=${Uri.encodeComponent(_emailController.text.trim())}",
          );
        case AuthStatus.consentRequired:
          context.go("/onboarding/consent");
        case AuthStatus.authenticated:
          context.go("/home");
        default:
          break;
      }
    } on ApiException catch (e) {
      setState(() {
        switch (e.code) {
          case "AUTH_INVALID_CREDENTIALS":
            _error = "이메일 또는 비밀번호를 확인해주세요.";
          case "ACCOUNT_LOCKED":
            _error = "로그인 시도가 너무 많아요. 잠시 후 다시 시도해주세요.";
          case "NETWORK_ERROR":
            _error = "네트워크에 연결할 수 없어요. 잠시 후 다시 시도해주세요.";
          default:
            _error = e.message;
        }
      });
    } catch (_) {
      setState(() => _error = "로그인에 실패했어요. 다시 시도해주세요.");
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("로그인")),
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
                decoration: const InputDecoration(labelText: "비밀번호"),
                validator: _validatePassword,
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
                child: Text(_submitting ? "로그인 중..." : "로그인"),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: _submitting
                    ? null
                    : () => context.push("/onboarding/password-reset"),
                child: const Text("비밀번호를 잊으셨나요?"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
