import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";
import "../../network/api_client.dart";
import "../../providers/auth_providers.dart";
import "../../theme/ensom_colors.dart";

/// S-25 비밀번호 변경
class ChangePasswordScreen extends ConsumerStatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  ConsumerState<ChangePasswordScreen> createState() =>
      _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends ConsumerState<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordCtrl = TextEditingController();
  final _newPasswordCtrl = TextEditingController();
  final _confirmPasswordCtrl = TextEditingController();

  bool _submitting = false;
  String? _fieldError; // 인라인 에러 메시지

  @override
  void dispose() {
    _currentPasswordCtrl.dispose();
    _newPasswordCtrl.dispose();
    _confirmPasswordCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _fieldError = null);

    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _submitting = true);
    try {
      final api = ref.read(apiClientProvider);
      await api.patch<Map<String, dynamic>>(
        "/me/password",
        body: {
          // Google-only 계정 최초 설정 시 currentPassword 생략 (§2.4)
          if (_currentPasswordCtrl.text.isNotEmpty)
            "currentPassword": _currentPasswordCtrl.text,
          "newPassword": _newPasswordCtrl.text,
        },
      );
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("비밀번호를 변경했어요.")));
        context.pop();
      }
    } on ApiException catch (e) {
      if (e.isNetworkError) {
        setState(() => _fieldError = "네트워크에 연결할 수 없어요. 다시 시도해주세요.");
      } else if (e.code == "INVALID_PASSWORD") {
        setState(() => _fieldError = "현재 비밀번호가 일치하지 않아요.");
      } else if (e.code == "WEAK_PASSWORD") {
        setState(
          () => _fieldError = "새 비밀번호가 너무 약해요. 10자 이상의 안전한 비밀번호를 사용해주세요.",
        );
      } else {
        setState(() => _fieldError = e.message);
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("비밀번호 변경")),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _currentPasswordCtrl,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "현재 비밀번호",
                  helperText: "Google로만 가입한 경우 비워두세요",
                ),
                // Google-only 계정은 currentPassword 생략 가능 (§2.4)
                // BE가 provider 확인 후 판단
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _newPasswordCtrl,
                obscureText: true,
                decoration: const InputDecoration(labelText: "새 비밀번호"),
                validator: (v) {
                  if (v == null || v.isEmpty) return "새 비밀번호를 입력해주세요.";
                  if (v.length < 10) return "10자 이상 입력해주세요.";
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _confirmPasswordCtrl,
                obscureText: true,
                decoration: const InputDecoration(labelText: "새 비밀번호 확인"),
                validator: (v) {
                  if (v == null || v.isEmpty) return "비밀번호를 다시 입력해주세요.";
                  if (v != _newPasswordCtrl.text) return "비밀번호가 일치하지 않아요.";
                  return null;
                },
              ),
              if (_fieldError != null) ...[
                const SizedBox(height: 16),
                Text(
                  _fieldError!,
                  style: const TextStyle(color: EnsomColors.caution),
                ),
              ],
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _submitting ? null : _submit,
                  child: _submitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text("변경하기"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
