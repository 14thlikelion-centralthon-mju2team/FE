import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "../repository/providers.dart";
import "../models/prep_item.dart";
import "../theme/ensom_colors.dart";

/// PREP-01 준비 항목 추가 시트
/// 호출: HM-01 [+ 추가], DTL-01 [+ 추가], PRF-06
/// BE: POST /prep-items
///
/// 사용법:
/// ```dart
/// showModalBottomSheet(
///   context: context,
///   isScrollControlled: true,
///   builder: (_) => const PrepItemAddSheet(),
/// );
/// ```
class PrepItemAddSheet extends ConsumerStatefulWidget {
  const PrepItemAddSheet({super.key});

  @override
  ConsumerState<PrepItemAddSheet> createState() => _PrepItemAddSheetState();
}

class _PrepItemAddSheetState extends ConsumerState<PrepItemAddSheet> {
  final _labelController = TextEditingController();
  PrepKind _kind = PrepKind.carry;
  int _minutes = 10;
  bool _sensitive = false;
  bool _saving = false;

  @override
  void dispose() {
    _labelController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final label = _labelController.text.trim();
    if (label.isEmpty) return;

    setState(() => _saving = true);
    try {
      final repo = ref.read(ensomRepositoryProvider);
      await repo.createPrepItem(
        PrepItem(
          id: "",
          label: label,
          kind: _kind,
          sensitive: _sensitive,
          extraMin: _kind == PrepKind.routine ? _minutes : 0,
          fromChip: false,
        ),
      );
      if (mounted) Navigator.pop(context, true);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("저장에 실패했어요. 다시 시도해주세요.")));
        setState(() => _saving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 32,
              height: 4,
              decoration: BoxDecoration(
                color: EnsomColors.hairline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text("준비 항목 추가", style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 16),
          TextField(
            controller: _labelController,
            autofocus: true,
            decoration: const InputDecoration(
              labelText: "항목 이름",
              hintText: "예: 지갑, 스트레칭",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          Text("구분", style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 8),
          SegmentedButton<PrepKind>(
            segments: const [
              ButtonSegment(value: PrepKind.carry, label: Text("챙기기")),
              ButtonSegment(value: PrepKind.consume, label: Text("사용·섭취")),
              ButtonSegment(value: PrepKind.purchase, label: Text("구매")),
              ButtonSegment(value: PrepKind.routine, label: Text("루틴")),
            ],
            selected: {_kind},
            onSelectionChanged: (s) => setState(() => _kind = s.first),
          ),
          if (_kind == PrepKind.routine) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                const Text("소요 시간:"),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline),
                  onPressed: _minutes > 5
                      ? () => setState(() => _minutes -= 5)
                      : null,
                ),
                Text(
                  "$_minutes분",
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  onPressed: _minutes < 60
                      ? () => setState(() => _minutes += 5)
                      : null,
                ),
              ],
            ),
          ],
          const SizedBox(height: 8),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text("잠금화면에서 숨기기"),
            subtitle: const Text("민감한 항목은 알림에서 '개인 준비'로 표시돼요"),
            value: _sensitive,
            onChanged: (v) => setState(() => _sensitive = v),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _saving ? null : _save,
              child: Text(_saving ? "저장 중..." : "추가"),
            ),
          ),
        ],
      ),
    );
  }
}
