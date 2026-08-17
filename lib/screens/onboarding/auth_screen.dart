import "package:flutter/material.dart";
import "email_signup_screen.dart";
import "email_login_screen.dart";

/// 진입 선택 화면. 원본 구조(선택 화면 -> 별도 폼 화면)를 그대로 유지한다.
/// 최종 마일스톤 문서(M0) 기준: "이메일 또는 Google 로그인"만 지원.
/// 카카오/Apple 버튼은 스키마에 provider 값이 없어 제거된 상태를 유지.
class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key, required this.onGoogleLogin});

  final Future<void> Function() onGoogleLogin;

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _submitting = false;
  String? _error;

  Future<void> _handleGoogleLogin() async {
    setState(() {
      _submitting = true;
      _error = null;
    });
    try {
      await widget.onGoogleLogin();
    } catch (e) {
      setState(() => _error = "Google 로그인에 실패했어요. 다시 시도해주세요.");
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_error != null) ...[
              Text(_error!, style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 12),
            ],
            ElevatedButton(
              onPressed: _submitting ? null : _handleGoogleLogin,
              child: const Text("Google로 시작하기"),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
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
            // 카카오 버튼 제거 -- users.provider check 제약에 'kakao' 없음
            // Apple 버튼 제거(잠정) -- 스키마에 'apple' 없음, 팀 확인 대기 중
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
    );
  }
}