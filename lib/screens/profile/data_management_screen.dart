import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";
import "../../network/api_client.dart";
import "../../providers/auth_providers.dart";

/// PRF-09 데이터 관리
class DataManagementScreen extends ConsumerWidget {
  const DataManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text("데이터 관리")),
      body: ListView(
        children: [
          const SizedBox(height: 8),
          ListTile(
            leading: const Icon(Icons.delete_sweep_outlined),
            title: const Text("행동 기록 삭제"),
            subtitle: const Text("학습에 사용된 행동 기록을 삭제해요"),
            onTap: () => _confirmDeleteRecords(context, ref),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.delete_forever, color: Colors.red),
            title: const Text("계정 삭제", style: TextStyle(color: Colors.red)),
            subtitle: const Text("모든 데이터를 삭제하고 탈퇴해요"),
            onTap: () => context.push("/profile/withdraw"),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteRecords(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("행동 기록을 삭제할까요?"),
        content: const Text(
          "준비 시작·출발·도착 등의 기록이 삭제돼요.\n개인화가 초기 상태로 돌아갈 수 있어요.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("취소"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              _deleteRecords(context, ref);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text("삭제"),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteRecords(BuildContext context, WidgetRef ref) async {
    try {
      final api = ref.read(apiClientProvider);
      await api.delete("/me/personalization");
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("행동 기록을 삭제했어요.")),
        );
      }
    } on ApiException catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message)),
        );
      }
    }
  }
}
