import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "../../network/api_client.dart";
import "../../providers/auth_providers.dart";
import "../../theme/ensom_colors.dart";

/// S-26 이메일 변경
class ChangeEmailScreen extends ConsumerStatefulWidget {
  const ChangeEmailScreen({super.key});

  @override
  ConsumerState<ChangeEmailScreen> createState() => _ChangeEmailScreenState();
}

class _ChangeEmailScreenState extends ConsumerState<ChangeEmailScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  bool _submitting = false;
  bool _sent = false;
  String? _error;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _error = null);
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _submitting = true);
    try {
      final api = ref.read(apiClientProvider);
      await api.post<Map<String, dynamic>>(
        "/me/email/change-request",
        body: {
          "newEmail": _emailCtrl.text.trim(),
          "password": _passwordCtrl.text,
        },
      );
      if (mounted) {
        setState(() {
          _submitting = false;
          _sent = true;
        });
      }
    } on ApiException catch (e) {
      if (mounted) {
        if (e.isNetworkError) {
          setState(() => _error = "네트워크에 연결할 수 없어요. 다시 시도해주세요.");
        } else {
          setState(() => _error = e.message);
        }
        setState(() => _submitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("이메일 변경")),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: _sent ? _buildSentState() : _buildFormState(),
      ),
    );
  }

  Widget _buildFormState() {
    return Form(
      key: _formKey,
      child: ListView(
        children: [
          const Text("새로운 이메일 주소로 인증 메일을 보내드려요."),
          const SizedBox(height: 24),
          TextFormField(
            controller: _emailCtrl,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(labelText: "새 이메일"),
            validator: (v) {
              if (v == null || v.trim().isEmpty) return "이메일을 입력해주세요.";
              if (!v.contains("@")) return "올바른 이메일 형식이 아니에요.";
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _passwordCtrl,
            obscureText: true,
            decoration: const InputDecoration(labelText: "현재 비밀번호"),
            validator: (v) => (v == null || v.isEmpty) ? "비밀번호를 입력해주세요." : null,
          ),
          if (_error != null) ...[
            const SizedBox(height: 16),
            Text(_error!, style: const TextStyle(color: EnsomColors.caution)),
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
                  : const Text("인증 메일 보내기"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSentState() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.mark_email_read_outlined, size: 48),
        const SizedBox(height: 16),
        Text("인증 메일을 보냈어요", style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 12),
        Text("${_emailCtrl.text.trim()}으로 인증 메일을 보냈어요."),
        const SizedBox(height: 8),
        const Text("메일의 인증 링크를 클릭하면 이메일이 변경돼요."),
        const SizedBox(height: 8),
        Text(
          "메일이 오지 않으면 스팸함을 확인해주세요.",
          style: TextStyle(color: EnsomColors.inkMuted, fontSize: 13),
        ),
      ],
    );
  }
}
