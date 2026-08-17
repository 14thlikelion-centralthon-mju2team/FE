import "package:flutter/material.dart";
import "package:go_router/go_router.dart";

/// PRD §11.3 "준비 시간 및 맞춤 준비 항목 입력 화면" 반영.
/// 맞춤 준비 항목은 별도 온보딩 단계가 아니라 이 화면 안의 한 섹션이다
/// -- API 명세 §6에서 이미 확정한 원칙, 화면 분리 금지.
class PrepTimeEntryScreen extends StatefulWidget {
  const PrepTimeEntryScreen({super.key});

  @override
  State<PrepTimeEntryScreen> createState() => _PrepTimeEntryScreenState();
}

class _QuickAddItem {
  _QuickAddItem({required this.label, required this.kind});
  final String label;
  final String kind;
  bool selected = false;
}

class _PrepTimeEntryScreenState extends State<PrepTimeEntryScreen> {
  static const _presets = [10, 20, 30, 45, 60]; // 분. "잘 모르겠어요"는 null로 별도 처리
  int? _selectedPreset;
  bool _unknownSelected = false;

  // 복용약 등 민감 항목은 추천 칩에 노출하지 않는다 (TR-10, PRD §11.3/§14.8).
  // 사용자가 "직접 추가"로 입력한 경우에만 준비 항목으로 받고, 그 항목이
  // 민감한지 여부는 서버가 판단해서 sensitive 플래그를 내려준다 -- 클라이언트가
  // 텍스트를 보고 미리 추측하거나 저장 시점에만 마스킹하지 않는다.
  final List<_QuickAddItem> _quickItems = [
    _QuickAddItem(label: "영양제", kind: "consume"),
    _QuickAddItem(label: "물 텀블러", kind: "carry"),
    _QuickAddItem(label: "선크림", kind: "carry"),
    _QuickAddItem(label: "마스크", kind: "carry"),
    _QuickAddItem(label: "우산", kind: "carry"),
    _QuickAddItem(label: "보조배터리", kind: "carry"),
    _QuickAddItem(label: "커피 차 간식", kind: "purchase"),
  ];

  final _customItemController = TextEditingController();
  bool _submitting = false;

  @override
  void dispose() {
    _customItemController.dispose();
    super.dispose();
  }

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

  Future<void> _submit() async {
    setState(() => _submitting = true);
    try {
      // TODO(fe-plan-route): PATCH /me/settings { initialPrepMinutes }
      //   _unknownSelected면 initialPrepMinutes: null 전송 (시드 없음)
      // TODO(fe-plan-route): POST /prep-items (선택된 quickItems + 직접입력)
      //   각 항목 kind는 carry/consume/purchase만 이 화면에서 다루고,
      //   routine(시간 소요 루틴)은 이 화면 범위 밖 -- 설정에서 추가하도록
      //   API 명세 §6 참고
      //   직접 입력 항목(_customItemController)은 fromChip=false로 전송하고,
      //   sensitive 여부는 클라이언트가 정하지 않는다 -- 서버 응답의
      //   sensitive 플래그를 그대로 받아 잠금화면 마스킹에만 사용한다
      //   (TR-10 3중 경계: 표시/추천/집계 경계 중 "추천 경계"에 해당).
      if (!mounted) return;
      context.go("/onboarding/interest");
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  void _skip() {
    // 맞춤 항목은 선택 사항 -- 건너뛰어도 온보딩 완료를 막지 않는다 (PRD §11.3)
    context.go("/onboarding/interest");
  }

  bool get _canSubmit => _selectedPreset != null || _unknownSelected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("준비시간 입력"),
        actions: [
          TextButton(
            onPressed: _skip,
            child: const Text("나중에 설정할게요"),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Text(
            "평소 외출 준비에 얼마나 걸리나요?",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          const Text(
            "정확하지 않아도 괜찮아요. 실제 준비와 이동 기록을 바탕으로 계속 조정할게요.",
            style: TextStyle(color: Colors.grey, fontSize: 13),
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

          const SizedBox(height: 32),
          const Text(
            "외출 전에 자주 챙기거나 하는 일이 있나요?",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          const Text(
            "선택한 항목은 다음 일정의 준비 체크리스트에 자동 반영됩니다.",
            style: TextStyle(color: Colors.grey, fontSize: 13),
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
              labelText: "직접 추가",
              hintText: "예: 렌즈 착용, 반려동물 밥 주기",
            ),
          ),

          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: (_canSubmit && !_submitting) ? _submit : null,
            child: Text(_submitting ? "저장 중..." : "다음으로"),
          ),
        ],
      ),
    );
  }
}