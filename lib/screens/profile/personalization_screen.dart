import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "../../network/api_client.dart";
import "../../providers/auth_providers.dart";
import "../../providers/bootstrap_provider.dart";
import "../../theme/ensom_colors.dart";
import "../../widgets/ensom/ensom_pill_button.dart";
import "../../widgets/ensom/ensom_top_bar.dart";

/// PRF-08 개인화
/// BE: GET /me/personalization, DELETE /me/personalization,
///     POST /me/personalization/revert (API.md §15)
///
/// ensom_profile.html "6. 개인화" 화면의 비교 카드(cmp) + 되돌리기를
/// 반영한다. 목업은 되돌리기 가능한 보정 "이력"을 여러 줄로 보여주지만,
/// 실제 API는 scopeType별 현재 추정값 하나만 주고(MVP는 global 하나
/// 뿐) revert도 "직전 보정 하나"만 되돌리는 단일 액션이다(§15 "직전
/// 보정 되돌리기") — 그래서 목업처럼 여러 줄 + 줄마다 되돌리기 버튼을
/// 만들지 않고, 현재값 카드 + 되돌리기 버튼 하나로 구성했다.
/// "처음 입력한 준비 시간"은 이 API가 아니라 /me/settings의
/// initialPrepMinutes(부트스트랩에 이미 있음)에서 가져온다 — 개인화
/// 추정값과 시드값은 서로 다른 저장소다.
class PersonalizationScreen extends ConsumerStatefulWidget {
  const PersonalizationScreen({super.key});

  @override
  ConsumerState<PersonalizationScreen> createState() =>
      _PersonalizationScreenState();
}

class _Estimate {
  const _Estimate({
    required this.scopeType,
    required this.estimatedMinutes,
    required this.sampleCount,
    required this.adjustmentReason,
    required this.validFrom,
  });

  final String scopeType;
  final int estimatedMinutes;
  final int? sampleCount;
  final String? adjustmentReason;
  final String? validFrom;

  factory _Estimate.fromJson(Map<String, dynamic> json) => _Estimate(
        scopeType: json["scopeType"] as String? ?? "global",
        estimatedMinutes: json["estimatedMinutes"] as int? ?? 0,
        sampleCount: json["sampleCount"] as int?,
        adjustmentReason: json["adjustmentReason"] as String?,
        validFrom: json["validFrom"] as String?,
      );
}

class _PersonalizationScreenState extends ConsumerState<PersonalizationScreen> {
  bool _loading = true;
  _Estimate? _global;
  String? _error;
  bool _busy = false;

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
      final res = await api.get<Map<String, dynamic>>("/me/personalization");
      final data = res["data"] as Map<String, dynamic>? ?? res;
      final estimates = (data["estimates"] as List<dynamic>? ?? [])
          .cast<Map<String, dynamic>>()
          .map(_Estimate.fromJson)
          .toList();
      final globalMatches = estimates.where((e) => e.scopeType == "global");
      if (mounted) {
        setState(() {
          _global = globalMatches.isEmpty ? null : globalMatches.first;
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

  Future<void> _revert() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("직전 보정을 되돌릴까요?"),
        content: const Text("되돌리면 이 보정에 쓰인 기록은 이후 학습에서 제외돼요."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text("취소")),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: EnsomColors.caution),
            child: const Text("되돌리기"),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    setState(() => _busy = true);
    try {
      final api = ref.read(apiClientProvider);
      await api.post("/me/personalization/revert");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("직전 보정을 되돌렸어요.")));
      }
      await _load();
    } on ApiException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
        setState(() => _busy = false);
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
      }
      await _load();
    } on ApiException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final initialPrepMinutes = ref.watch(bootstrapProvider).value?.settings.initialPrepMinutes;

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
                                value: initialPrepMinutes != null ? "$initialPrepMinutes분" : "미설정",
                              ),
                            ),
                            const Icon(Icons.arrow_forward, size: 16, color: EnsomColors.inkFaint),
                            Expanded(
                              child: _CompareBox(
                                label: "최근 학습된 준비 시간",
                                value: _global != null ? "${_global!.estimatedMinutes}분" : "없음",
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (_global?.adjustmentReason != null) ...[
                        const SizedBox(height: 14),
                        const Text(
                          "최근 보정",
                          style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: EnsomColors.inkFaint, letterSpacing: .4),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(color: EnsomColors.surface2, borderRadius: BorderRadius.circular(18)),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _global!.adjustmentReason!,
                                      style: const TextStyle(fontSize: 12.5, color: EnsomColors.ink, height: 1.5),
                                    ),
                                    if (_global!.sampleCount != null) ...[
                                      const SizedBox(height: 4),
                                      Text(
                                        "최근 ${_global!.sampleCount}회 기록 기준",
                                        style: const TextStyle(fontSize: 10.5, color: EnsomColors.inkFaint),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                              TextButton(
                                onPressed: _busy ? null : _revert,
                                child: const Text(
                                  "되돌리기",
                                  style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: EnsomColors.inkMuted, decoration: TextDecoration.underline),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
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
