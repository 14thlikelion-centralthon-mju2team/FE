import "package:flutter/material.dart";
import "package:go_router/go_router.dart";

/// 이메일 회원가입 직후 진입. Google 로그인 사용자는 이 화면을 거치지
/// 않는다(email_verified_at 개념 자체가 이메일 가입자에게만 해당).
///
/// TODO(fe-auth-onboarding): 아래 정책이 BE(박찬)와 아직 미확정.
/// - 인증 전 /me/bootstrap 호출 시 서버가 핵심 화면 진입을 막는지,
///   배지만 띄우는지
/// - 인증 완료를 폴링으로 확인할지, 딥링크로 앱에 돌아오게 할지
class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({super.key, required this.email});

  final String email;

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  bool _resending = false;
  bool _checking = false;
  String? _message;

  Future<void> _resendEmail() async {
    setState(() {
      _resending = true;
      _message = null;
    });
    try {
      // TODO: POST /auth/email/resend-verification 연동
      // (엔드포인트가 M0에 포함되는지 BE 확인 필요)
      await Future.delayed(const Duration(milliseconds: 300));
      if (!mounted) return;
      setState(() => _message = "인증 메일을 다시 보냈어요.");
    } catch (e) {
      if (!mounted) return;
      setState(() => _message = "메일 재발송에 실패했어요. 잠시 후 다시 시도해주세요.");
    } finally {
      if (mounted) setState(() => _resending = false);
    }
  }

  Future<void> _checkVerified() async {
    setState(() {
      _checking = true;
      _message = null;
    });
    try {
      // TODO: GET /me/bootstrap 등으로 emailVerifiedAt 확인
      // 인증 완료 확인되면 다음 온보딩 단계로 이동:
      // if (verified) { context.go("/onboarding/consent"); return; }
      await Future.delayed(const Duration(milliseconds: 300));
      if (!mounted) return;
      setState(() => _message = "아직 인증이 확인되지 않았어요. 메일함을 확인해주세요.");
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
              Text(_message!, textAlign: TextAlign.center),
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