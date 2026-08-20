import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "../../network/api_client.dart";
import "../../providers/auth_providers.dart";
import "../../theme/ensom_colors.dart";
import "../../widgets/ensom/ensom_pill_button.dart";
import "../../widgets/ensom/ensom_top_bar.dart";

/// PRF-08 개인화
/// BE: GET /me/personalization, DELETE /me/personalization, POST /me/personalization/revert
///
/// ensom_profile.html "6. 개인화" 화면의 비교 카드(cmp) 반영. 목업의
/// "최근 보정 이력" 되돌리기 리스트는 넣지 않았다 — /me/personalization
/// 응답에 이력 배열이 없고(initialPrepMinutes/currentPrepMinutes 두
/// 값만 옴) 되돌릴 개별 항목이 없어서다.
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
        content: const Text("학습된 준비 시간이 초기값으로 돌아가요.\n행동 기록은 유지돼요."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text("취소")),
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
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("개인화가 초기화됐어요.")));
        _load();
      }
    } on ApiException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: EnsomColors.canvas,
      appBar: const EnsomTopBar(title: "개인화"),
      body: SafeArea(
        top: false,
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : _error != null
                ? Center(child: Text(_error!, style: const TextStyle(color: EnsomColors.inkMuted)))
                : ListView(
                    padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
                    children: [
                      if (_data != null)
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: EnsomColors.surface1,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: EnsomColors.hairline),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: _CompareBox(
                                  label: "처음 입력한 준비 시간",
                                  value: "${_data!["initialPrepMinutes"] ?? "미설정"}분",
                                ),
                              ),
                              const Icon(Icons.arrow_forward, size: 16, color: EnsomColors.inkFaint),
                              Expanded(
                                child: _CompareBox(
                                  label: "최근 학습된 준비 시간",
                                  value: "${_data!["currentPrepMinutes"] ?? "없음"}분",
                                ),
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(height: 22),
                      EnsomPillButton(label: "개인화 초기화", variant: EnsomPillVariant.secondary, onPressed: _reset),
                    ],
                  ),
      ),
    );
  }
}

class _CompareBox extends StatelessWidget {
  const _CompareBox({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 10, color: EnsomColors.inkFaint),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700, letterSpacing: -.4, color: EnsomColors.ink),
        ),
      ],
    );
  }
}
