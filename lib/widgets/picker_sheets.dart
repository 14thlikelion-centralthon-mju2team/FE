import "package:flutter/material.dart";
import "../theme/ensom_colors.dart";

/// PICK-01 날짜 선택 시트
/// PICK-02 시간 선택 시트
/// PICK-03 소요시간 선택 시트
///
/// CAL-04, PRF-06 등에서 호출하는 공용 피커 컴포넌트.
/// showModalBottomSheet로 사용.

/// PICK-01: 날짜 선택 → DateTime 반환
Future<DateTime?> showDatePickerSheet(
  BuildContext context, {
  DateTime? initial,
}) {
  return showDatePicker(
    context: context,
    initialDate: initial ?? DateTime.now(),
    firstDate: DateTime.now().subtract(const Duration(days: 30)),
    lastDate: DateTime.now().add(const Duration(days: 365)),
  );
}

/// PICK-02: 시간 선택 → TimeOfDay 반환
Future<TimeOfDay?> showTimePickerSheet(
  BuildContext context, {
  TimeOfDay? initial,
}) {
  return showTimePicker(
    context: context,
    initialTime: initial ?? TimeOfDay.now(),
  );
}

/// PICK-03: 소요시간 선택 바텀시트 → int(분) 반환
Future<int?> showDurationPickerSheet(
  BuildContext context, {
  int initialMinutes = 30,
}) {
  return showModalBottomSheet<int>(
    context: context,
    builder: (_) => _DurationPickerSheet(initialMinutes: initialMinutes),
  );
}

class _DurationPickerSheet extends StatefulWidget {
  const _DurationPickerSheet({required this.initialMinutes});
  final int initialMinutes;

  @override
  State<_DurationPickerSheet> createState() => _DurationPickerSheetState();
}

class _DurationPickerSheetState extends State<_DurationPickerSheet> {
  late int _minutes;

  static const _quickOptions = [10, 15, 20, 30, 45, 60, 90, 120];

  @override
  void initState() {
    super.initState();
    _minutes = widget.initialMinutes;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
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
          Text("소요 시간", style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _quickOptions
                .map(
                  (min) => ChoiceChip(
                    label: Text("$min분"),
                    selected: _minutes == min,
                    onSelected: (_) => setState(() => _minutes = min),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.remove_circle_outline),
                onPressed: _minutes > 5
                    ? () => setState(() => _minutes -= 5)
                    : null,
              ),
              Text(
                "$_minutes분",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add_circle_outline),
                onPressed: _minutes < 180
                    ? () => setState(() => _minutes += 5)
                    : null,
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () => Navigator.pop(context, _minutes),
              child: const Text("확인"),
            ),
          ),
        ],
      ),
    );
  }
}
