import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";
import "../../network/api_client.dart";
import "../../providers/auth_providers.dart";
import "../../theme/ensom_colors.dart";
import "../../widgets/ensom/ensom_top_bar.dart";

/// PRF-09 데이터 관리. ensom_profile.html "7. 데이터" 화면 반영.
class DataManagementScreen extends ConsumerWidget {
  const DataManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: EnsomColors.canvas,
      appBar: const EnsomTopBar(title: "데이터"),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
          children: [
            const Text(
              "행동 기록 삭제",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: EnsomColors.ink),
            ),
            const SizedBox(height: 4),
            const Text(
              "준비·이동 기록을 삭제해요. 개인화 학습에 사용된 데이터가 초기화돼요.",
              style: TextStyle(fontSize: 12, color: EnsomColors.inkMuted, height: 1.55),
            ),
            const SizedBox(height: 10),
            _DangerTextButton(label: "삭제", onTap: () => _confirmDeleteRecords(context, ref)),
            const Divider(height: 30, color: EnsomColors.hairline),
            InkWell(
              onTap: () => context.push("/profile/withdraw"),
              borderRadius: BorderRadius.circular(12),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 11, horizontal: 2),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        "계정 삭제",
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: EnsomColors.ink),
                      ),
                    ),
                    Icon(Icons.chevron_right, size: 15, color: EnsomColors.inkFaint),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDeleteRecords(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("행동 기록을 삭제할까요?"),
        content: const Text("준비 시작·출발·도착 등의 기록이 삭제돼요.\n개인화가 초기 상태로 돌아갈 수 있어요."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("취소")),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              _deleteRecords(context, ref);
            },
            style: TextButton.styleFrom(foregroundColor: EnsomColors.caution),
            child: const Text("삭제"),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteRecords(BuildContext context, WidgetRef ref) async {
    try {
      final api = ref.read(apiClientProvider);
      await api.delete<Map<String, dynamic>>("/me/action-logs");
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("행동 기록을 삭제했어요.")));
      }
    } on ApiException catch (e) {
      if (context.mounted) {
        final msg = e.isNetworkError ? "네트워크에 연결할 수 없어요. 다시 시도해주세요." : e.message;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
      }
    }
  }
}

class _DangerTextButton extends StatelessWidget {
  const _DangerTextButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Text(
        label,
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: EnsomColors.inkMuted),
      ),
    );
  }
}
