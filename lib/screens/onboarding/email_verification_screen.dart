import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";
import "../../core/auth_service.dart";
import "../../network/api_client.dart";
import "../../providers/auth_providers.dart";

/// 이메일 회원가입 직후 진입. Google 로그인 사용자는 이 화면을 거치지 않는다.
/// API 명세 §2.3: POST /auth/email/verify/resend (재발송, 60초 쿨다운)
///
/// 인증 완료 확인: 사용자가 "인증 완료했어요" → 이메일 로그인을 시도해서
/// emailVerificationRequired가 false면 성공. 폴링이나 딥링크가 아님.
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
  bool _checking = false;
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

  /// "인증 완료했어요" — 이메일 인증이 됐는지 확인하기 위해 로그인을 시도한다.
  /// 서버가 emailVerificationRequired: false를 주면 성공.
  Future<void> _checkVerified() async {
    setState(() {
      _checking = true;
      _message = null;
    });
    try {
      // 인증 완료 확인을 위해 로그인 시도는 적절하지 않으므로
      // 대신 bootstrap을 호출해본다. 인증 완료되었으면 정상 응답,
      // 미인증이면 403 EMAIL_VERIFICATION_REQUIRED.
      final apiClient = ref.read(apiClientProvider);
      await apiClient.get<Map<String, dynamic>>("/me/bootstrap");

      // 여기까지 왔으면 인증 완료
      if (!mounted) return;
      ref.read(authNotifierProvider.notifier).onEmailVerified();
      context.go("/onboarding/consent");
    } on ApiException catch (e) {
      if (!mounted) return;
      if (e.code == "EMAIL_VERIFICATION_REQUIRED" ||
          e.code == "FORBIDDEN") {
        setState(
            () => _message = "아직 인증이 확인되지 않았어요. 메일함을 확인해주세요.");
      } else if (e.code == "UNAUTHORIZED") {
        // 토큰이 없거나 만료됨 — 로그인부터 다시
        setState(() => _message = "세션이 만료됐어요. 다시 로그인해주세요.");
      } else {
        setState(() => _message = "확인에 실패했어요. 잠시 후 다시 시도해주세요.");
      }
    } catch (_) {
      if (!mounted) return;
      setState(() => _message = "확인에 실패했어요. 잠시 후 다시 시도해주세요.");
    } finally {
      if (mounted) setState(() => _checking = false);
    }
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
              onPressed: _checking ? null : _checkVerified,
              child: Text(_checking ? "확인 중..." : "인증 완료했어요"),
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
