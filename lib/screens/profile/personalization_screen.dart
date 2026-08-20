import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";
import "../../providers/auth_providers.dart";
import "../../theme/ensom_colors.dart";

/// PRF-08 개인화 — v6 프로토타입 기준 redesign
/// 디자인 기준: Ensom_프로토타입_v6_최종/05_설정/ensom_profile.html (v-personal)
class PersonalizationScreen extends ConsumerStatefulWidget {
  const PersonalizationScreen({super.key});

  @override
  ConsumerState<PersonalizationScreen> createState() =>
      _PersonalizationScreenState();
}

class _PersonalizationScreenState
    extends ConsumerState<PersonalizationScreen> {
  bool _loading = true;
  int _seedMinutes = 30;
  int _currentMinutes = 30;
  List<_AdjustmentRecord> _history = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final api = ref.read(apiClientProvider);
      final data = await api.get<Map<String, dynamic>>("/me/personalization");
      if (mounted) {
        final estimates = data["estimates"] as List? ?? [];
        final latest = estimates.isNotEmpty ? estimates.first : null;
        setState(() {
          _seedMinutes = (latest?["seedMinutes"] ?? 30) as int;
          _currentMinutes = (latest?["estimatedMinutes"] ?? 30) as int;
          _history = estimates
              .take(5)
              .map((e) => _AdjustmentRecord(
                    description: e["adjustmentReason"] ?? "",
                    date: e["validFrom"]?.toString().substring(0, 10) ?? "",
                  ))
              .toList();
          _loading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _revert() async {
    final confirmed = await _showDialog(
      title: "이 기록을 되돌릴까요?",
      description: "되돌리면 이 기록은 이후 학습에서 제외돼요.",
      confirm: "되돌리기",
    );
    if (confirmed != true) return;
    // TODO: API call to revert
  }

  Future<void> _reset() async {
    final confirmed = await _showDialog(
      title: "개인화를 초기화할까요?",
      description: "학습된 준비 시간이 초기값으로 돌아가요.\n행동 기록은 유지돼요.",
      confirm: "초기화",
    );
    if (confirmed != true) return;
    try {
      final api = ref.read(apiClientProvider);
      await api.delete("/me/personalization");
      if (mounted) _load();
    } catch (_) {}
  }

  Future<bool?> _showDialog({
    required String title,
    required String description,
    required String confirm,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: EnsomColors.ink)),
              const SizedBox(height: 8),
              Text(description,
                  style: TextStyle(
                      fontSize: 12.5,
                      color: EnsomColors.inkMuted,
                      height: 1.55)),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: _SecondaryButton(
                      label: "취소",
                      onTap: () => Navigator.pop(ctx, false),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _PrimaryButton(
                      label: confirm,
                      onTap: () => Navigator.pop(ctx, true),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        backgroundColor: EnsomColors.canvas,
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      backgroundColor: EnsomColors.canvas,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(context),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  const SizedBox(height: 16),
                  // 비교 카드
                  _CompareCard(
                    seedMinutes: _seedMinutes,
                    currentMinutes: _currentMinutes,
                  ),

                  // 보정 이력
                  Padding(
                    padding: const EdgeInsets.only(top: 18, bottom: 4),
                    child: Text(
                      "최근 보정 이력",
                      style: TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w700,
                        color: EnsomColors.inkFaint,
                        letterSpacing: 0.4,
                      ),
                    ),
                  ),
                  _HistoryCard(
                    records: _history,
                    onRevert: _revert,
                  ),

                  const SizedBox(height: 22),
                  // 초기화 버튼
                  _SecondaryButton(
                    label: "개인화 초기화",
                    onTap: _reset,
                    full: true,
                  ),
                  const SizedBox(height: 48),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => context.pop(),
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: EnsomColors.surface2,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Icon(Icons.chevron_left, size: 14, color: EnsomColors.ink),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            "개인화",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: EnsomColors.ink,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Compare Card ───

class _CompareCard extends StatelessWidget {
  const _CompareCard({required this.seedMinutes, required this.currentMinutes});
  final int seedMinutes;
  final int currentMinutes;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: EnsomColors.surface1,
        border: Border.all(color: EnsomColors.hairline),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Text("처음 입력한 준비 시간",
                    style: TextStyle(fontSize: 10, color: EnsomColors.inkFaint)),
                const SizedBox(height: 4),
                Text("${seedMinutes}분",
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: EnsomColors.ink)),
              ],
            ),
          ),
          Icon(Icons.arrow_forward, size: 16, color: EnsomColors.inkFaint),
          Expanded(
            child: Column(
              children: [
                Text("최근 학습된 준비 시간",
                    style: TextStyle(fontSize: 10, color: EnsomColors.inkFaint)),
                const SizedBox(height: 4),
                Text("${currentMinutes}분",
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: EnsomColors.ink)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── History Card ───

class _HistoryCard extends StatelessWidget {
  const _HistoryCard({required this.records, required this.onRevert});
  final List<_AdjustmentRecord> records;
  final VoidCallback onRevert;

  @override
  Widget build(BuildContext context) {
    if (records.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: EnsomColors.surface1,
          border: Border.all(color: EnsomColors.hairline),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Text("아직 보정 이력이 없어요",
            style: TextStyle(fontSize: 12, color: EnsomColors.inkMuted)),
      );
    }
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: EnsomColors.surface1,
        border: Border.all(color: EnsomColors.hairline),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: records
            .map((r) => _HistoryRow(record: r, onRevert: onRevert))
            .toList(),
      ),
    );
  }
}

class _HistoryRow extends StatelessWidget {
  const _HistoryRow({required this.record, required this.onRevert});
  final _AdjustmentRecord record;
  final VoidCallback onRevert;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 11),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: EnsomColors.hairline, width: 1),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(record.description,
                    style: TextStyle(fontSize: 12, color: EnsomColors.ink)),
                const SizedBox(height: 2),
                Text(record.date,
                    style:
                        TextStyle(fontSize: 10, color: EnsomColors.inkFaint)),
              ],
            ),
          ),
          GestureDetector(
            onTap: onRevert,
            child: Text(
              "되돌리기",
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w700,
                color: EnsomColors.inkMuted,
                decoration: TextDecoration.underline,
                decorationColor: EnsomColors.inkMuted,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Buttons ───

class _PrimaryButton extends StatelessWidget {
  const _PrimaryButton({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 16),
        decoration: BoxDecoration(
          color: EnsomColors.cta,
          borderRadius: BorderRadius.circular(999),
        ),
        alignment: Alignment.center,
        child: Text(label,
            style: TextStyle(
                fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white)),
      ),
    );
  }
}

class _SecondaryButton extends StatelessWidget {
  const _SecondaryButton({
    required this.label,
    required this.onTap,
    this.full = false,
  });
  final String label;
  final VoidCallback onTap;
  final bool full;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: full ? double.infinity : null,
        padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 16),
        decoration: BoxDecoration(
          color: EnsomColors.surface2,
          borderRadius: BorderRadius.circular(999),
        ),
        alignment: Alignment.center,
        child: Text(label,
            style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: EnsomColors.ink)),
      ),
    );
  }
}

// ─── Model ───

class _AdjustmentRecord {
  const _AdjustmentRecord({required this.description, required this.date});
  final String description;
  final String date;
}
