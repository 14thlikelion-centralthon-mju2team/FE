import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";
import "../../core/auth_service.dart";
import "../../network/api_client.dart";
import "../../providers/auth_providers.dart";

/// 이메일 회원가입 직후 진입. Google 로그인 사용자는 이 화면을 거치지 않는다.
/// API 명세 §2.3: POST /auth/email/verify/resend (재발송, 60초 쿨다운)
/// 인증 링크는 브라우저에서 검증되고, 사용자는 앱으로 돌아와 로그인해 세션을 받는다.
class EmailVerificationScreen extends ConsumerStatefulWidget {
  const EmailVerificationScreen({super.key, required this.email});

  final String email;

  @override
  ConsumerState<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState
    extends ConsumerState<EmailVerificationScreen> {
  bool _resending = false;
  String? _message;
  DateTime? _lastResendAt;

  Future<void> _resendEmail() async {
    // 60초 쿨다운 (§2.3)
    if (_lastResendAt != null &&
        DateTime.now().difference(_lastResendAt!) <
            const Duration(seconds: 60)) {
      setState(
          () => _message = "60초 후에 다시 시도할 수 있어요.");
      return;
    }

    setState(() {
      _resending = true;
      _message = null;
    });
    try {
      final authService = ref.read(authServiceProvider);
      await authService.resendVerification(widget.email);
      _lastResendAt = DateTime.now();
      if (!mounted) return;
      setState(() => _message = "인증 메일을 다시 보냈어요.");
    } on ApiException catch (e) {
      if (!mounted) return;
      // TR-14: 계정 유무와 무관하게 항상 200 반환이므로 에러면 네트워크 문제
      setState(() {
        _message = e.retryable
            ? "네트워크에 연결할 수 없어요. 잠시 후 다시 시도해주세요."
            : "메일 재발송에 실패했어요.";
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _message = "메일 재발송에 실패했어요. 잠시 후 다시 시도해주세요.");
    } finally {
      if (mounted) setState(() => _resending = false);
    }
  }

  /// 이메일 링크 인증은 브라우저의 GET /auth/email/verify에서 완료된다.
  /// 이 시점에는 세션 token이 없으므로 bootstrap을 호출하지 않고 로그인으로 보낸다.
  void _goToLogin() {
    context.go("/onboarding/auth");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("이메일 인증")),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.mark_email_unread_outlined, size: 56),
            const SizedBox(height: 16),
            Text(
              "${widget.email}로\n인증 메일을 보냈어요.",
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            const Text(
              "메일함에서 인증 링크를 눌러주세요.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            if (_message != null) ...[
              const SizedBox(height: 16),
              Text(
                _message!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: _message!.contains("보냈") ? Colors.green : Colors.orange,
                ),
              ),
            ],
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _goToLogin,
              child: const Text("인증 후 로그인하기"),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: _resending ? null : _resendEmail,
              child: Text(_resending ? "재발송 중..." : "인증 메일 다시 받기"),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => context.go("/onboarding/auth"),
              child: const Text("다른 방법으로 로그인"),
            ),
          ],
        ),
      ),
    );
  }
}
