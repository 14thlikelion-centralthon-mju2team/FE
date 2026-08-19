import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "../../network/api_client.dart";
import "../../providers/auth_providers.dart";
import "../../theme/ensom_colors.dart";

/// PRF-08 개인화
/// BE: GET /me/personalization, DELETE /me/personalization, POST /me/personalization/revert
class PersonalizationScreen extends ConsumerStatefulWidget {
  const PersonalizationScreen({super.key});

  @override
  ConsumerState<PersonalizationScreen> createState() =>
      _PersonalizationScreenState();
}

class _PersonalizationScreenState extends ConsumerState<PersonalizationScreen> {
  bool _loading = true;
  Map<String, dynamic>? _data;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final api = ref.read(apiClientProvider);
      final data = await api.get<Map<String, dynamic>>("/me/personalization");
      if (mounted) {
        setState(() {
          _data = data;
          _loading = false;
        });
      }
    } on ApiException catch (e) {
      if (mounted) {
        setState(() {
          _error = e.message;
          _loading = false;
        });
      }
    }
  }

  Future<void> _reset() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("개인화를 초기화할까요?"),
        content: const Text("학습된 준비 시간 보정이 초기화돼요.\n행동 기록은 유지됩니다."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text("취소"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: EnsomColors.caution),
            child: const Text("초기화"),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    try {
      final api = ref.read(apiClientProvider);
      await api.delete("/me/personalization");
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("개인화가 초기화됐어요.")));
        _load();
      }
    } on ApiException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.message)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("개인화")),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(child: Text(_error!))
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (_data != null) ...[
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "준비 시간 보정",
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "초기 설정: ${_data!["initialPrepMinutes"] ?? "미설정"}분",
                          ),
                          Text(
                            "현재 학습값: ${_data!["currentPrepMinutes"] ?? "없음"}분",
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 24),
                OutlinedButton.icon(
                  onPressed: _reset,
                  icon: const Icon(Icons.restart_alt),
                  label: const Text("개인화 초기화"),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: EnsomColors.caution,
                  ),
                ),
              ],
            ),
    );
  }
}
