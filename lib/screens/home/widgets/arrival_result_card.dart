import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "../../../models/execution.dart";
import "../../../repository/providers.dart";
import "../../../theme/ensom_colors.dart";

/// REPORT-01. 도착 처리 이후("도착 → 결과 확정" 루프의 마지막 조각) 도착
/// 결과를 보여주고 짧은 사후 평가를 받는다. 도착 처리(지오펜스·수동
/// 버튼) 로직과는 별도 위젯으로 분리해서 결합도를 낮췄다.
class ArrivalResultCard extends ConsumerStatefulWidget {
  const ArrivalResultCard({super.key, required this.eventId});

  final String eventId;

  @override
  ConsumerState<ArrivalResultCard> createState() => _ArrivalResultCardState();
}

class _ArrivalResultCardState extends ConsumerState<ArrivalResultCard> {
  EventExecution? _execution;
  bool _loading = true;
  bool _submitted = false;
  bool _submitting = false;
  PrepTimingAssessment? _prepTiming;
  RushAssessment? _rush;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final execution = await ref
          .read(ensomRepositoryProvider)
          .fetchExecution(widget.eventId);
      if (mounted) setState(() => _execution = execution);
    } catch (_) {
      // 실행 결과를 못 가져와도 카드만 조용히 생략한다 (홈 흐름은 막지 않는다).
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _submit() async {
    final prepTiming = _prepTiming;
    final rush = _rush;
    final execution = _execution;
    if (prepTiming == null || rush == null || execution == null) return;

    setState(() => _submitting = true);
    try {
      await ref
          .read(ensomRepositoryProvider)
          .submitFeedback(
            widget.eventId,
            prepTimingAssessment: prepTiming,
            arrivalResult: execution.arrivalResult,
            rushAssessment: rush,
          );
      if (mounted) setState(() => _submitted = true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("저장하지 못했어요. 다시 시도해주세요.")));
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  String _arrivalResultLabel(ArrivalResult result) {
    switch (result) {
      case ArrivalResult.early:
        return "여유 있게 도착했어요.";
      case ArrivalResult.onTime:
        return "제시간에 도착했어요.";
      case ArrivalResult.rushed:
        return "조금 서둘러 도착했어요.";
      case ArrivalResult.late_:
        return "예정보다 늦게 도착했어요.";
      case ArrivalResult.unknown:
        return "도착 결과를 확인했어요.";
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading || _execution == null || _submitted)
      return const SizedBox.shrink();
    final execution = _execution!;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "오늘 이동은 어땠나요?",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            // rushLoadScore는 운영 지표 전용이라 여기 표시하지 않는다 (PRD 절대 원칙 3).
            Text(
              _arrivalResultLabel(execution.arrivalResult),
              style: const TextStyle(color: EnsomColors.inkMuted),
            ),
            const SizedBox(height: 12),
            const Text(
              "준비 시간은 어땠나요?",
              style: TextStyle(fontSize: 12, color: EnsomColors.inkMuted),
            ),
            const SizedBox(height: 4),
            Wrap(
              spacing: 8,
              children: [
                ChoiceChip(
                  label: const Text("너무 일렀어요"),
                  selected: _prepTiming == PrepTimingAssessment.tooEarly,
                  onSelected: (_) => setState(
                    () => _prepTiming = PrepTimingAssessment.tooEarly,
                  ),
                ),
                ChoiceChip(
                  label: const Text("적절했어요"),
                  selected: _prepTiming == PrepTimingAssessment.appropriate,
                  onSelected: (_) => setState(
                    () => _prepTiming = PrepTimingAssessment.appropriate,
                  ),
                ),
                ChoiceChip(
                  label: const Text("촉박했어요"),
                  selected: _prepTiming == PrepTimingAssessment.tooLate,
                  onSelected: (_) => setState(
                    () => _prepTiming = PrepTimingAssessment.tooLate,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              "서두른 정도는요?",
              style: TextStyle(fontSize: 12, color: EnsomColors.inkMuted),
            ),
            const SizedBox(height: 4),
            Wrap(
              spacing: 8,
              children: [
                ChoiceChip(
                  label: const Text("여유로웠어요"),
                  selected: _rush == RushAssessment.notRushed,
                  onSelected: (_) =>
                      setState(() => _rush = RushAssessment.notRushed),
                ),
                ChoiceChip(
                  label: const Text("서둘렀어요"),
                  selected: _rush == RushAssessment.rushed,
                  onSelected: (_) =>
                      setState(() => _rush = RushAssessment.rushed),
                ),
              ],
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: (_prepTiming != null && _rush != null && !_submitting)
                  ? _submit
                  : null,
              child: Text(_submitting ? "저장 중..." : "저장"),
            ),
          ],
        ),
      ),
    );
  }
}
