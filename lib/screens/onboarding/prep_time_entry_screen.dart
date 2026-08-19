import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";
import "../../models/prep_item.dart";
import "../../network/api_client.dart";
import "../../providers/auth_providers.dart";
import "../../repository/providers.dart";
import "../../theme/ensom_colors.dart";

/// PRD §11.3 "준비 시간 및 맞춤 준비 항목 입력 화면" 반영.
/// 맞춤 준비 항목은 별도 온보딩 단계가 아니라 이 화면 안의 한 섹션이다
/// — API 명세 §6에서 이미 확정한 원칙, 화면 분리 금지.
///
/// 이 화면에서 처리하는 API 호출:
///   1. PATCH /me/settings { initialPrepMinutes } — §4.1
///   2. POST /prep-items (선택된 빠른 추가 + 직접 입력 + 시간 루틴) — §6.1
class PrepTimeEntryScreen extends ConsumerStatefulWidget {
  const PrepTimeEntryScreen({super.key});

  @override
  ConsumerState<PrepTimeEntryScreen> createState() =>
      _PrepTimeEntryScreenState();
}

// ─── 빠른 추가 항목 (carry/consume/purchase) ────────────────────────

class _QuickAddItem {
  _QuickAddItem({
    required this.label,
    required this.kind,
    this.sensitive = false,
  });

  final String label;
  final PrepKind kind;
  final bool sensitive;
  bool selected = false;
}

// ─── 시간 소요 루틴 항목 (timed_routine) ────────────────────────────

class _RoutineItem {
  _RoutineItem({required this.label, required this.minutes});

  final String label;
  int minutes;
  bool selected = false;
}

// ─── 화면 상태 ──────────────────────────────────────────────────────

class _PrepTimeEntryScreenState extends ConsumerState<PrepTimeEntryScreen> {
  // ── 준비 시간 프리셋 ──────────────────────────────────────────────
  static const _presets = [10, 20, 30, 45, 60];
  int? _selectedPreset;
  bool _unknownSelected = false;

  // ── 빠른 추가 칩 (carry/consume/purchase) ─────────────────────────
  // 민감 항목(복용약)은 추천 칩에 노출하지 않음 (TR-10 추천 경계)
  final List<_QuickAddItem> _quickItems = [
    _QuickAddItem(label: "영양제", kind: PrepKind.consume),
    _QuickAddItem(label: "물·텀블러", kind: PrepKind.carry),
    _QuickAddItem(label: "선크림", kind: PrepKind.carry),
    _QuickAddItem(label: "마스크", kind: PrepKind.carry),
    _QuickAddItem(label: "우산", kind: PrepKind.carry),
    _QuickAddItem(label: "보조배터리", kind: PrepKind.carry),
    _QuickAddItem(label: "커피·차·간식", kind: PrepKind.purchase),
  ];

  // ── 시간 소요 루틴 칩 (timed_routine) ─────────────────────────────
  // PRD §11.3: "렌즈, 화장, 식사, 반려동물 돌보기"
  // 시간이 필요한 루틴 → 설정한 분만큼 준비 시간에 합산됨
  final List<_RoutineItem> _routineItems = [
    _RoutineItem(label: "렌즈 착용", minutes: 5),
    _RoutineItem(label: "화장·스킨케어", minutes: 15),
    _RoutineItem(label: "식사", minutes: 15),
    _RoutineItem(label: "샤워", minutes: 15),
    _RoutineItem(label: "반려동물 돌보기", minutes: 10),
  ];

  // ── 직접 입력 ─────────────────────────────────────────────────────
  final _customItemController = TextEditingController();
  final _customRoutineController = TextEditingController();
  int _customRoutineMinutes = 10;

  bool _submitting = false;
  String? _error;

  @override
  void dispose() {
    _customItemController.dispose();
    _customRoutineController.dispose();
    super.dispose();
  }

  // ── 준비 시간 선택 ────────────────────────────────────────────────

  void _selectPreset(int minutes) {
    setState(() {
      _selectedPreset = minutes;
      _unknownSelected = false;
    });
  }

  void _selectUnknown() {
    setState(() {
      _unknownSelected = true;
      _selectedPreset = null;
    });
  }

  // ── 제출 ──────────────────────────────────────────────────────────

  bool get _canSubmit => _selectedPreset != null || _unknownSelected;

  Future<void> _submit() async {
    setState(() {
      _submitting = true;
      _error = null;
    });
    try {
      final repo = ref.read(ensomRepositoryProvider);

      // 1. PATCH /me/settings — 준비 시간 시드 저장
      //    "잘 모르겠어요"는 null 전송 (§4.1: initialPrepMinutes는 null 허용)
      await repo.updateSettings({
        "initialPrepMinutes": _unknownSelected ? null : _selectedPreset,
      });

      // 2~5. POST /prep-items — 부분 실패 허용
      //    settings 저장은 성공했으므로 prep-items 중 일부가 실패해도
      //    성공한 건은 유지하고 실패 건수를 사용자에게 안내한다.
      final itemsToCreate = <PrepItem>[];

      // 선택된 빠른 추가 항목
      for (final item in _quickItems.where((i) => i.selected)) {
        itemsToCreate.add(
          PrepItem(
            id: "",
            label: item.label,
            kind: item.kind,
            sensitive: item.sensitive,
            fromChip: true,
          ),
        );
      }

      // 선택된 시간 소요 루틴
      for (final routine in _routineItems.where((r) => r.selected)) {
        itemsToCreate.add(
          PrepItem(
            id: "",
            label: routine.label,
            kind: PrepKind.routine,
            extraMin: routine.minutes,
            fromChip: true,
          ),
        );
      }

      // 직접 입력한 일반 항목
      final customText = _customItemController.text.trim();
      if (customText.isNotEmpty) {
        itemsToCreate.add(
          PrepItem(
            id: "",
            label: customText,
            kind: PrepKind.carry,
            fromChip: false,
          ),
        );
      }

      // 직접 입력한 루틴
      final customRoutineText = _customRoutineController.text.trim();
      if (customRoutineText.isNotEmpty) {
        itemsToCreate.add(
          PrepItem(
            id: "",
            label: customRoutineText,
            kind: PrepKind.routine,
            extraMin: _customRoutineMinutes,
            fromChip: false,
          ),
        );
      }

      // 순차 호출 — 부분 실패 추적
      int successCount = 0;
      int failCount = 0;
      for (final item in itemsToCreate) {
        try {
          await repo.createPrepItem(item);
          successCount++;
        } catch (_) {
          failCount++;
        }
      }

      if (!mounted) return;

      if (failCount > 0 && successCount == 0) {
        // 전부 실패
        setState(() => _error = "준비 항목 저장에 실패했어요. 네트워크를 확인하고 다시 시도해주세요.");
        return;
      }

      if (failCount > 0) {
        // 부분 실패 — 안내 후 진행 허용
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "$successCount개 저장됨 · $failCount개 실패 — 설정에서 다시 추가할 수 있어요.",
            ),
            duration: const Duration(seconds: 4),
          ),
        );
      }

      ref.read(secureStorageProvider).setOnboardingStep("places");
      context.go("/onboarding/places");
    } on ApiException catch (e) {
      // settings PATCH 자체가 실패한 경우
      setState(() {
        if (e.isNetworkError) {
          _error = "네트워크에 연결할 수 없어요. 잠시 후 다시 시도해주세요.";
        } else {
          _error = e.message;
        }
      });
    } catch (_) {
      setState(() => _error = "저장에 실패했어요. 다시 시도해주세요.");
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  void _skip() {
    // 맞춤 항목은 선택 사항 — 건너뛰어도 온보딩 완료를 막지 않음 (PRD §11.3)
    ref.read(secureStorageProvider).setOnboardingStep("places");
    context.go("/onboarding/places");
  }

  // ── UI ────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("준비 시간"),
        actions: [
          TextButton(
            onPressed: _submitting ? null : _skip,
            child: const Text("나중에 설정할게요"),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          // ── 섹션 1: 준비 시간 ─────────────────────────────────────
          const Text(
            "평소 외출 준비에 얼마나 걸리나요?",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          const Text(
            "정확하지 않아도 괜찮아요. 실제 기록을 바탕으로 계속 조정할게요.",
            style: TextStyle(color: EnsomColors.inkMuted, fontSize: 13),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final minutes in _presets)
                ChoiceChip(
                  label: Text("$minutes분"),
                  selected: _selectedPreset == minutes,
                  onSelected: (_) => _selectPreset(minutes),
                ),
              ChoiceChip(
                label: const Text("잘 모르겠어요"),
                selected: _unknownSelected,
                onSelected: (_) => _selectUnknown(),
              ),
            ],
          ),

          const SizedBox(height: 36),

          // ── 섹션 2: 빠른 추가 (챙기기/사용/구매) ──────────────────
          const Text(
            "외출 전에 자주 챙기는 것이 있나요?",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          const Text(
            "선택한 항목은 준비 체크리스트에 자동 반영됩니다.",
            style: TextStyle(color: EnsomColors.inkMuted, fontSize: 13),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final item in _quickItems)
                FilterChip(
                  label: Text(item.label),
                  selected: item.selected,
                  onSelected: (v) => setState(() => item.selected = v),
                ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _customItemController,
            decoration: const InputDecoration(
              labelText: "직접 추가 (챙기기)",
              hintText: "예: 지갑, 이어폰",
              prefixIcon: Icon(Icons.add_circle_outline),
            ),
          ),

          const SizedBox(height: 36),

          // ── 섹션 3: 시간 소요 루틴 (timed_routine) ────────────────
          const Text(
            "시간이 필요한 루틴이 있나요?",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          const Text(
            "선택한 루틴 시간이 준비 시작 시각에 반영됩니다.",
            style: TextStyle(color: EnsomColors.inkMuted, fontSize: 13),
          ),
          const SizedBox(height: 16),
          for (final routine in _routineItems)
            _RoutineTile(
              routine: routine,
              onToggle: (v) => setState(() => routine.selected = v),
              onMinutesChanged: (m) => setState(() => routine.minutes = m),
            ),

          const SizedBox(height: 12),
          _CustomRoutineInput(
            labelController: _customRoutineController,
            minutes: _customRoutineMinutes,
            onMinutesChanged: (m) => setState(() => _customRoutineMinutes = m),
          ),

          // ── 합산 미리보기 ─────────────────────────────────────────
          _RoutineSummary(
            prepMinutes: _selectedPreset,
            routineItems: _routineItems,
            customRoutineLabel: _customRoutineController.text.trim(),
            customRoutineMinutes: _customRoutineMinutes,
          ),

          // ── 에러 메시지 ───────────────────────────────────────────
          if (_error != null) ...[
            const SizedBox(height: 16),
            Text(_error!, style: const TextStyle(color: EnsomColors.caution)),
          ],

          const SizedBox(height: 32),

          // ── 제출 버튼 ─────────────────────────────────────────────
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: (_canSubmit && !_submitting) ? _submit : null,
              child: Text(_submitting ? "저장 중..." : "다음으로"),
            ),
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

// ─── 루틴 항목 타일 ──────────────────────────────────────────────────

class _RoutineTile extends StatelessWidget {
  const _RoutineTile({
    required this.routine,
    required this.onToggle,
    required this.onMinutesChanged,
  });

  final _RoutineItem routine;
  final ValueChanged<bool> onToggle;
  final ValueChanged<int> onMinutesChanged;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: Row(
          children: [
            Checkbox(
              value: routine.selected,
              onChanged: (v) => onToggle(v ?? false),
            ),
            Expanded(child: Text(routine.label)),
            if (routine.selected) ...[
              IconButton(
                icon: const Icon(Icons.remove_circle_outline, size: 20),
                onPressed: routine.minutes > 5
                    ? () => onMinutesChanged(routine.minutes - 5)
                    : null,
              ),
              Text(
                "${routine.minutes}분",
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              IconButton(
                icon: const Icon(Icons.add_circle_outline, size: 20),
                onPressed: routine.minutes < 60
                    ? () => onMinutesChanged(routine.minutes + 5)
                    : null,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ─── 직접 입력 루틴 ──────────────────────────────────────────────────

class _CustomRoutineInput extends StatelessWidget {
  const _CustomRoutineInput({
    required this.labelController,
    required this.minutes,
    required this.onMinutesChanged,
  });

  final TextEditingController labelController;
  final int minutes;
  final ValueChanged<int> onMinutesChanged;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: labelController,
                decoration: const InputDecoration(
                  labelText: "직접 추가 (루틴)",
                  hintText: "예: 스트레칭",
                  isDense: true,
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 12),
            IconButton(
              icon: const Icon(Icons.remove_circle_outline, size: 20),
              onPressed: minutes > 5
                  ? () => onMinutesChanged(minutes - 5)
                  : null,
            ),
            Text(
              "$minutes분",
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            IconButton(
              icon: const Icon(Icons.add_circle_outline, size: 20),
              onPressed: minutes < 60
                  ? () => onMinutesChanged(minutes + 5)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── 합산 미리보기 ───────────────────────────────────────────────────

class _RoutineSummary extends StatelessWidget {
  const _RoutineSummary({
    required this.prepMinutes,
    required this.routineItems,
    required this.customRoutineLabel,
    required this.customRoutineMinutes,
  });

  final int? prepMinutes;
  final List<_RoutineItem> routineItems;
  final String customRoutineLabel;
  final int customRoutineMinutes;

  @override
  Widget build(BuildContext context) {
    final selectedRoutines = routineItems.where((r) => r.selected);
    final routineTotal =
        selectedRoutines.fold<int>(0, (sum, r) => sum + r.minutes) +
        (customRoutineLabel.isNotEmpty ? customRoutineMinutes : 0);

    if (prepMinutes == null && routineTotal == 0) {
      return const SizedBox.shrink();
    }

    final totalMin = (prepMinutes ?? 0) + routineTotal;

    return Container(
      margin: const EdgeInsets.only(top: 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: EnsomColors.cta.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: EnsomColors.cta.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "예상 준비 시간 미리보기",
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
          const SizedBox(height: 8),
          if (prepMinutes != null)
            Text(
              "기본 준비: ${prepMinutes}분",
              style: const TextStyle(fontSize: 13),
            ),
          if (routineTotal > 0) ...[
            Text(
              "루틴 합산: ${routineTotal}분",
              style: const TextStyle(fontSize: 13),
            ),
            for (final r in selectedRoutines)
              Text(
                "  · ${r.label}: ${r.minutes}분",
                style: const TextStyle(
                  fontSize: 12,
                  color: EnsomColors.inkMuted,
                ),
              ),
            if (customRoutineLabel.isNotEmpty)
              Text(
                "  · $customRoutineLabel: ${customRoutineMinutes}분",
                style: const TextStyle(
                  fontSize: 12,
                  color: EnsomColors.inkMuted,
                ),
              ),
          ],
          const Divider(height: 16),
          Text(
            "총 약 ${totalMin}분",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: EnsomColors.cta,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            "실제 이동 시간과 여유 시간은 일정별로 따로 계산됩니다.",
            style: TextStyle(fontSize: 11, color: EnsomColors.inkMuted),
          ),
        ],
      ),
    );
  }
}
