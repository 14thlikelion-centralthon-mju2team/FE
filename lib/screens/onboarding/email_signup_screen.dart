import "package:flutter/material.dart";

/// 원본 EmailSignupForm(필드 3개, 미완성)을 실제 제출 가능한 화면으로
/// 완성했다. 전화번호 입력란은 원본 의도대로 넣지 않았다 --
/// 스키마에 해당 컬럼 자체가 없기 때문.
class EmailSignupScreen extends StatefulWidget {
  const EmailSignupScreen({super.key});

  @override
  State<EmailSignupScreen> createState() => _EmailSignupScreenState();
}

class _EmailSignupScreenState extends State<EmailSignupScreen> {
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
    // TRD §10.2 서버 정책과 일치 -- 클라이언트 검증이 서버보다 느슨하면
    // 사용자가 통과했다고 믿은 입력이 서버에서 거부되는 불일치가 생긴다.
    if (value.length < 10) return "비밀번호는 10자 이상이어야 해요.";
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
      // TODO(fe-auth-onboarding): 실제 회원가입 API 연결
      // await repo.signUpWithEmail(
      //   email: _emailController.text.trim(),
      //   password: _passwordController.text,
      //   nickname: _nicknameController.text.trim(),
      // );
      // 가입 성공 후 이메일 인증 안내 화면으로 이동 -- 라우트/정책은
      // BE(박찬)와 확인 필요 (email_verified_at 처리 방식 미확정)
    } catch (e) {
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
          child: Column(
            children: [
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: "이메일"),
                validator: _validateEmail,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: "비밀번호"),
                validator: _validatePassword,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _nicknameController,
                decoration: const InputDecoration(labelText: "닉네임"),
                validator: _validateNickname,
              ),
              // 전화번호 입력란 없음 -- 스키마에 컬럼 자체가 없음
              if (_error != null) ...[
                const SizedBox(height: 12),
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