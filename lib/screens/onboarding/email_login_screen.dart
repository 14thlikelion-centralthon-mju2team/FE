import "package:flutter/material.dart";

/// 원본에는 "로그인 화면으로 이동" TODO만 있고 실제 화면이 없었다.
/// 신규 작성.
class EmailLoginScreen extends StatefulWidget {
  const EmailLoginScreen({super.key});

  @override
  State<EmailLoginScreen> createState() => _EmailLoginScreenState();
}

class _EmailLoginScreenState extends State<EmailLoginScreen> {
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
      // TODO(fe-auth-onboarding): 실제 로그인 API 연결
      // await repo.loginWithEmail(
      //   email: _emailController.text.trim(),
      //   password: _passwordController.text,
      // );
    } catch (e) {
      setState(() => _error = "이메일 또는 비밀번호를 확인해주세요.");
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
              if (_error != null) ...[
                const SizedBox(height: 12),
                Text(_error!, style: const TextStyle(color: Colors.red)),
              ],
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submitting ? null : _submit,
                child: Text(_submitting ? "로그인 중..." : "로그인"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}