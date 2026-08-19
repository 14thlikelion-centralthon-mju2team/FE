import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";
import "../../network/api_client.dart";
import "../../providers/auth_providers.dart";
import "../../theme/ensom_colors.dart";

/// S-19/S-20 비밀번호 재설정 요청
class PasswordResetScreen extends ConsumerStatefulWidget {
  const PasswordResetScreen({super.key});

  @override
  ConsumerState<PasswordResetScreen> createState() =>
      _PasswordResetScreenState();
}

class _PasswordResetScreenState extends ConsumerState<PasswordResetScreen> {
  final _emailCtrl = TextEditingController();
  bool _submitting = false;
  bool _sent = false; // 발송 완료 상태
  String? _error;

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  Future<void> _requestReset() async {
    final email = _emailCtrl.text.trim();
    if (email.isEmpty) {
      setState(() => _error = "이메일을 입력해주세요.");
      return;
    }

    setState(() {
      _submitting = true;
      _error = null;
    });

    try {
      final api = ref.read(apiClientProvider);
      await api.post<Map<String, dynamic>>(
        "/auth/password/reset-request",
        body: {"email": email},
      );
    } on ApiException catch (e) {
      // 계정 열거 방지: 에러가 나도 항상 "메일을 보냈어요" 안내
      if (e.isNetworkError) {
        setState(() {
          _submitting = false;
          _error = "네트워크에 연결할 수 없어요. 다시 시도해주세요.";
        });
        return;
      }
    } finally {
      if (mounted && _error == null) {
        setState(() {
          _submitting = false;
          _sent = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("비밀번호 재설정")),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: _sent ? _buildSentState() : _buildInputState(),
      ),
    );
  }

  Widget _buildInputState() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("비밀번호를 잊으셨나요?", style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 12),
        const Text("가입한 이메일을 입력하면 비밀번호 재설정 링크를 보내드려요."),
        const SizedBox(height: 24),
        TextField(
          controller: _emailCtrl,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            labelText: "이메일",
            hintText: "example@email.com",
          ),
        ),
        if (_error != null) ...[
          const SizedBox(height: 12),
          Text(_error!, style: const TextStyle(color: EnsomColors.caution)),
        ],
        const SizedBox(height: 32),
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: _submitting ? null : _requestReset,
            child: _submitting
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text("재설정 메일 보내기"),
          ),
        ),
      ],
    );
  }

  Widget _buildSentState() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.mark_email_read_outlined, size: 48),
        const SizedBox(height: 16),
        Text("메일을 보냈어요", style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 12),
        const Text("입력하신 이메일로 비밀번호 재설정 링크를 보냈어요.\n메일함을 확인해주세요."),
        const SizedBox(height: 8),
        Text(
          "메일이 오지 않으면 스팸함을 확인하거나 다시 시도해주세요.",
          style: TextStyle(color: EnsomColors.inkMuted, fontSize: 13),
        ),
        const SizedBox(height: 32),
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: () => context.go("/onboarding/auth"),
            child: const Text("로그인하러 가기"),
          ),
        ),
      ],
    );
  }
}
