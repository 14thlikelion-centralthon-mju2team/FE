import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";
import "../../models/prep_item.dart";
import "../../network/api_client.dart";
import "../../providers/auth_providers.dart";
import "../../repository/providers.dart";
import "../../theme/ensom_colors.dart";
import "../../widgets/ensom/ensom_error_banner.dart";
import "../../widgets/ensom/ensom_pill_button.dart";

/// PRD §11.3 "준비 시간 및 맞춤 준비 항목 입력 화면" 반영.
/// 맞춤 준비 항목은 별도 온보딩 단계가 아니라 이 화면 안의 한 섹션이다
/// — API 명세 §6에서 이미 확정한 원칙, 화면 분리 금지.
///
/// ensom_onboarding_flow.html STEP 2의 qlabel/sub/chiprow 시각 언어를
/// 반영했다. "시간이 필요한 루틴"(timed_routine) 섹션은 목업엔 없지만
/// 실제 API(§6.1 PrepKind.routine)가 지원하는 기능이라 같은 톤으로
/// 유지했다.
///
/// 이 화면에서 처리하는 API 호출:
///   1. PATCH /me/settings { initialPrepMinutes } — §4.1
///   2. POST /prep-items (선택된 빠른 추가 + 직접 입력 + 시간 루틴) — §6.1
class PrepTimeEntryScreen extends ConsumerStatefulWidget {
  const PrepTimeEntryScreen({super.key});

  @override
  ConsumerState<PrepTimeEntryScreen> createState() => _PrepTimeEntryScreenState();
}

// ─── 빠른 추가 항목 (carry/consume/purchase) ────────────────────────

class _QuickAddItem {
  _QuickAddItem({required this.label, required this.kind, this.sensitive = false});

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
  bool _customItemFieldOpen = false;
  bool _customRoutineFieldOpen = false;

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
          PrepItem(id: "", label: item.label, kind: item.kind, sensitive: item.sensitive, fromChip: true),
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
        itemsToCreate.add(PrepItem(id: "", label: customText, kind: PrepKind.carry, fromChip: false));
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
            content: Text("$successCount개 저장됨 · $failCount개 실패 — 설정에서 다시 추가할 수 있어요."),
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
      backgroundColor: EnsomColors.canvas,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 8, 8, 0),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      "준비 시간",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, letterSpacing: -.2, color: EnsomColors.ink),
                    ),
                  ),
                  TextButton(
                    onPressed: _submitting ? null : _skip,
                    child: const Text(
                      "나중에 설정할게요",
                      style: TextStyle(fontSize: 12, color: EnsomColors.inkMuted),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(18, 10, 18, 16),
                children: [
                  // ── 섹션 1: 준비 시간 ─────────────────────────────────
                  const _SectionLabel("평소 외출 준비에 얼마나 걸리나요?", "정확하지 않아도 괜찮아요. 실제 기록을 바탕으로 계속 조정할게요."),
                  const SizedBox(height: 14),
                  Wrap(
                    spacing: 7,
                    runSpacing: 8,
                    children: [
                      for (final minutes in _presets)
                        _EnsomChip(
                          label: "$minutes분",
                          selected: _selectedPreset == minutes,
                          onTap: () => _selectPreset(minutes),
                        ),
                      _EnsomChip(label: "잘 모르겠어요", selected: _unknownSelected, onTap: _selectUnknown),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // ── 섹션 2: 빠른 추가 (챙기기/사용/구매) ──────────────
                  const _SectionLabel("외출 전에 자주 챙기는 것이 있나요?", "선택한 항목은 준비 체크리스트에 자동 반영됩니다."),
                  const SizedBox(height: 14),
                  Wrap(
                    spacing: 7,
                    runSpacing: 8,
                    children: [
                      for (final item in _quickItems)
                        _EnsomChip(
                          label: item.label,
                          selected: item.selected,
                          onTap: () => setState(() => item.selected = !item.selected),
                        ),
                      _EnsomChip(
                        label: "+ 직접 추가",
                        selected: false,
                        dashed: true,
                        onTap: () => setState(() => _customItemFieldOpen = !_customItemFieldOpen),
                      ),
                    ],
                  ),
                  if (_customItemFieldOpen) ...[
                    const SizedBox(height: 10),
                    _InlineAddField(
                      controller: _customItemController,
                      hintText: "예: 지갑, 이어폰",
                      onSubmit: () => setState(() {}),
                    ),
                  ],

                  const SizedBox(height: 32),

                  // ── 섹션 3: 시간 소요 루틴 (timed_routine) ────────────
                  const _SectionLabel("시간이 필요한 루틴이 있나요?", "선택한 루틴 시간이 준비 시작 시각에 반영됩니다."),
                  const SizedBox(height: 12),
                  for (final routine in _routineItems)
                    _RoutineRow(
                      routine: routine,
                      onToggle: (v) => setState(() => routine.selected = v),
                      onMinutesChanged: (m) => setState(() => routine.minutes = m),
                    ),
                  const SizedBox(height: 6),
                  if (!_customRoutineFieldOpen)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: _EnsomChip(
                        label: "+ 직접 추가",
                        selected: false,
                        dashed: true,
                        onTap: () => setState(() => _customRoutineFieldOpen = true),
                      ),
                    )
                  else
                    _InlineRoutineAddField(
                      controller: _customRoutineController,
                      minutes: _customRoutineMinutes,
                      onMinutesChanged: (m) => setState(() => _customRoutineMinutes = m),
                    ),

                  // ── 합산 미리보기 ─────────────────────────────────────
                  _RoutineSummary(
                    prepMinutes: _selectedPreset,
                    routineItems: _routineItems,
                    customRoutineLabel: _customRoutineController.text.trim(),
                    customRoutineMinutes: _customRoutineMinutes,
                  ),

                  // ── 에러 메시지 ───────────────────────────────────────
                  if (_error != null) ...[
                    const SizedBox(height: 16),
                    EnsomErrorBanner(title: _error!),
                  ],

                  const SizedBox(height: 24),

                  // ── 제출 버튼 ─────────────────────────────────────────
                  EnsomPillButton(
                    label: _submitting ? "저장 중..." : "다음으로",
                    onPressed: (_canSubmit && !_submitting) ? _submit : null,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.title, this.subtitle);

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, letterSpacing: -.2, color: EnsomColors.ink),
        ),
        const SizedBox(height: 6),
        Text(
          subtitle,
          style: const TextStyle(fontSize: 12.5, color: EnsomColors.inkMuted, height: 1.6),
        ),
      ],
    );
  }
}

/// 목업 `.chip` — 미선택 surface2, 선택 cta 배경.
class _EnsomChip extends StatelessWidget {
  const _EnsomChip({required this.label, required this.selected, required this.onTap, this.dashed = false});

  final String label;
  final bool selected;
  final bool dashed;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? EnsomColors.cta : Colors.transparent,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 9),
          decoration: BoxDecoration(
            color: selected ? null : EnsomColors.surface2,
            borderRadius: BorderRadius.circular(12),
            border: dashed ? Border.all(color: EnsomColors.hairline, width: 1.4) : null,
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: selected ? Colors.white : EnsomColors.inkMuted,
            ),
          ),
        ),
      ),
    );
  }
}

class _InlineAddField extends StatelessWidget {
  const _InlineAddField({required this.controller, required this.hintText, required this.onSubmit});

  final TextEditingController controller;
  final String hintText;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 42,
            padding: const EdgeInsets.symmetric(horizontal: 13),
            decoration: BoxDecoration(
              color: EnsomColors.surface1,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: EnsomColors.hairline, width: 1.4),
            ),
            child: TextField(
              controller: controller,
              onSubmitted: (_) => onSubmit(),
              style: const TextStyle(fontSize: 13, color: EnsomColors.ink),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hintText,
                isCollapsed: true,
                hintStyle: const TextStyle(color: EnsomColors.inkFaint),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Material(
          color: EnsomColors.cta,
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            onTap: onSubmit,
            borderRadius: BorderRadius.circular(12),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Text("추가", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white)),
            ),
          ),
        ),
      ],
    );
  }
}

class _InlineRoutineAddField extends StatelessWidget {
  const _InlineRoutineAddField({required this.controller, required this.minutes, required this.onMinutesChanged});

  final TextEditingController controller;
  final int minutes;
  final ValueChanged<int> onMinutesChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 6),
      decoration: BoxDecoration(
        color: EnsomColors.surface1,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: EnsomColors.hairline, width: 1.4),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              style: const TextStyle(fontSize: 13, color: EnsomColors.ink),
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: "예: 스트레칭",
                isCollapsed: true,
                hintStyle: TextStyle(color: EnsomColors.inkFaint),
              ),
            ),
          ),
          _MinuteStepper(minutes: minutes, onChanged: onMinutesChanged),
        ],
      ),
    );
  }
}

class _MinuteStepper extends StatelessWidget {
  const _MinuteStepper({required this.minutes, required this.onChanged});

  final int minutes;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _StepperButton(icon: Icons.remove, onTap: minutes > 5 ? () => onChanged(minutes - 5) : null),
        SizedBox(
          width: 38,
          child: Text(
            "$minutes분",
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: EnsomColors.ink),
          ),
        ),
        _StepperButton(icon: Icons.add, onTap: minutes < 60 ? () => onChanged(minutes + 5) : null),
      ],
    );
  }
}

class _StepperButton extends StatelessWidget {
  const _StepperButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: EnsomColors.surface2,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 26,
          height: 26,
          child: Icon(icon, size: 14, color: onTap == null ? EnsomColors.inkFaint : EnsomColors.ink),
        ),
      ),
    );
  }
}

// ─── 루틴 항목 행 ────────────────────────────────────────────────────

class _RoutineRow extends StatelessWidget {
  const _RoutineRow({required this.routine, required this.onToggle, required this.onMinutesChanged});

  final _RoutineItem routine;
  final ValueChanged<bool> onToggle;
  final ValueChanged<int> onMinutesChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: InkWell(
        onTap: () => onToggle(!routine.selected),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 2),
          child: Row(
            children: [
              _RoutineCheckbox(checked: routine.selected),
              const SizedBox(width: 11),
              Expanded(
                child: Text(
                  routine.label,
                  style: const TextStyle(fontSize: 13.5, color: EnsomColors.ink),
                ),
              ),
              if (routine.selected) _MinuteStepper(minutes: routine.minutes, onChanged: onMinutesChanged),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoutineCheckbox extends StatelessWidget {
  const _RoutineCheckbox({required this.checked});

  final bool checked;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 120),
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: checked ? EnsomColors.cta : Colors.white,
        borderRadius: BorderRadius.circular(7),
        border: Border.all(color: checked ? EnsomColors.cta : EnsomColors.hairline, width: 1.6),
      ),
      child: checked ? const Icon(Icons.check, size: 13, color: Colors.white) : null,
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
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(color: EnsomColors.surface2, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "예상 준비 시간 미리보기",
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: EnsomColors.ink),
          ),
          const SizedBox(height: 9),
          if (prepMinutes != null)
            Text("기본 준비: $prepMinutes분", style: const TextStyle(fontSize: 12.5, color: EnsomColors.inkMuted)),
          if (routineTotal > 0) ...[
            Text("루틴 합산: $routineTotal분", style: const TextStyle(fontSize: 12.5, color: EnsomColors.inkMuted)),
            for (final r in selectedRoutines)
              Text(
                "  · ${r.label}: ${r.minutes}분",
                style: const TextStyle(fontSize: 11.5, color: EnsomColors.inkFaint),
              ),
            if (customRoutineLabel.isNotEmpty)
              Text(
                "  · $customRoutineLabel: $customRoutineMinutes분",
                style: const TextStyle(fontSize: 11.5, color: EnsomColors.inkFaint),
              ),
          ],
          const Divider(height: 20, color: EnsomColors.hairline),
          Text(
            "총 약 $totalMin분",
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16, letterSpacing: -.3, color: EnsomColors.ink),
          ),
          const SizedBox(height: 5),
          const Text(
            "실제 이동 시간과 여유 시간은 일정별로 따로 계산됩니다.",
            style: TextStyle(fontSize: 10.5, color: EnsomColors.inkFaint),
          ),
        ],
      ),
    );
  }
}
