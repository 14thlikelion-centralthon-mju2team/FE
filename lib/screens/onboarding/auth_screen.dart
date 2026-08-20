import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";
import "../../core/app_config.dart";
import "../../core/google_auth_helper.dart";
import "../../network/api_client.dart";
import "../../providers/auth_providers.dart";
import "../../theme/ensom_colors.dart";
import "email_signup_screen.dart";
import "email_login_screen.dart";

/// 진입 선택 화면. API 명세 §2.5 POST /auth/login (Google)
/// Google 로그인은 idToken을 서버에 보내면 서버가 계정 확정·세션 발급.
/// Google 로그인은 항상 emailVerificationRequired: false (§2.5).
class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  bool _submitting = false;
  String? _error;

  Future<void> _handleGoogleLogin() async {
    setState(() {
      _submitting = true;
      _error = null;
    });
    try {
      final idToken = await GoogleAuthHelper.instance.signInForLogin();
      if (idToken == null) {
        // 사용자가 취소
        setState(() => _submitting = false);
        return;
      }

      final installationId = await ref
          .read(secureStorageProvider)
          .installationId;
      final authNotifier = ref.read(authNotifierProvider.notifier);
      await authNotifier.loginWithGoogle(
        idToken: idToken,
        installationId: installationId,
      );

      if (!mounted) return;

      final authState = ref.read(authNotifierProvider);
      switch (authState.status) {
        case AuthStatus.consentRequired:
          context.go("/onboarding/consent");
        case AuthStatus.onboarding:
          context.go("/onboarding/prep-time");
        case AuthStatus.authenticated:
          context.go("/home");
        default:
          // Google 로그인은 emailVerificationRequired가 되지 않음
          context.go("/home");
      }
    } on ApiException catch (e) {
      setState(() {
        switch (e.code) {
          case "NETWORK_ERROR":
            _error = "네트워크에 연결할 수 없어요. 잠시 후 다시 시도해주세요.";
          default:
            _error = "Google 로그인에 실패했어요. 다시 시도해주세요.";
        }
      });
    } catch (e) {
      setState(() => _error = "Google 로그인에 실패했어요. 다시 시도해주세요.");
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Ensom",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                "늦지 않게, 서두르지 않게.",
                style: TextStyle(color: EnsomColors.inkMuted),
              ),
              const SizedBox(height: 48),
              if (_error != null) ...[
                Text(
                  _error!,
                  style: const TextStyle(color: EnsomColors.caution),
                ),
                const SizedBox(height: 16),
              ],
              if (kGoogleServerClientId.isNotEmpty) ...[
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _submitting ? null : _handleGoogleLogin,
                    icon: const Icon(Icons.g_mobiledata, size: 24),
                    label: const Text("Google로 시작하기"),
                  ),
                ),
                const SizedBox(height: 12),
              ],
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: _submitting
                      ? null
                      : () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const EmailSignupScreen(),
                            ),
                          );
                        },
                  child: const Text("이메일로 시작하기"),
                ),
              ),
              const SizedBox(height: 24),
              TextButton(
                onPressed: _submitting
                    ? null
                    : () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const EmailLoginScreen(),
                          ),
                        );
                      },
                child: const Text("이미 계정이 있으신가요? 로그인"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
