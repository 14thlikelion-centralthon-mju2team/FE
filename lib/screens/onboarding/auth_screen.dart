import 'package:flutter/material.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {}, // TODO: Google OAuth 연동
              child: const Text('Google로 시작하기'),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () {}, // TODO: 이메일 가입 폼으로 이동
              child: const Text('이메일로 시작하기'),
            ),
            // 카카오 버튼 제거 — users.provider check 제약에 'kakao' 없음
            // Apple 버튼 제거(잠정) — 스키마에 'apple' 없음, 팀 확인 대기 중
            const SizedBox(height: 24),
            TextButton(
              onPressed: () {}, // TODO: 로그인 화면으로 이동
              child: const Text('이미 계정이 있으신가요? 로그인'),
            ),
          ],
        ),
      ),
    );
  }
}

class EmailSignupForm extends StatelessWidget {
  const EmailSignupForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(decoration: const InputDecoration(labelText: '이메일')),
        TextField(decoration: const InputDecoration(labelText: '비밀번호'), obscureText: true),
        TextField(decoration: const InputDecoration(labelText: '닉네임')),
        // 전화번호 입력란 없음 — 스키마에 컬럼 자체가 없음
      ],
    );
  }
}