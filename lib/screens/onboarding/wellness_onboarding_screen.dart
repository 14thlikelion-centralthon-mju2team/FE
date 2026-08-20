import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";
import "../../models/wellness_pref.dart";
import "../../providers/auth_providers.dart";
import "../settings/wellness_prefs_screen.dart";
import "../../theme/ensom_colors.dart";
import "../../widgets/ensom/ensom_pill_button.dart";
import "../../widgets/ensom/ensom_toggle.dart";

/// ONB-06 웰니스 관심 항목 설정 (온보딩 context)
/// 기존 WellnessPrefsScreen의 provider를 재사용하되,
/// AppBar에 [완료]/[건너뛰기]를 추가해 /home으로 이동한다.
///
/// ensom_onboarding_flow.html STEP 7의 h1/sub + 토글 리스트 레이아웃을
/// 반영한다(아이콘 없이 제목·설명·토글만 있는 단순 행).
class WellnessOnboardingScreen extends ConsumerWidget {
  const WellnessOnboardingScreen({super.key});

  void _finish(WidgetRef ref, BuildContext context) {
    ref.read(secureStorageProvider).setOnboardingStep("permissions");
    context.go("/onboarding/complete");
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefsAsync = ref.watch(wellnessPrefsProvider);
    final controller = ref.read(wellnessPrefsProvider.notifier);

    return Scaffold(
      backgroundColor: EnsomColors.canvas,
      appBar: AppBar(
        backgroundColor: EnsomColors.canvas,
        surfaceTintColor: EnsomColors.canvas,
        elevation: 0,
        title: const Text(
          "웰니스 관심 항목",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: EnsomColors.ink),
        ),
        actions: [
          TextButton(
            onPressed: () => _finish(ref, context),
            child: const Text(
              "건너뛰기",
              style: TextStyle(fontSize: 13, color: EnsomColors.inkMuted),
            ),
          ),
        ],
      ),
      body: prefsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, st) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("불러오지 못했어요: $err", style: const TextStyle(color: EnsomColors.inkMuted)),
              const SizedBox(height: 14),
              EnsomPillButton(
                label: "건너뛰고 시작하기",
                expand: false,
                onPressed: () => _finish(ref, context),
              ),
            ],
          ),
        ),
        data: (prefs) => Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(18, 8, 18, 8),
                children: [
                  const Text(
                    "관심 있는 환경 정보가 있나요?",
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, letterSpacing: -.3, color: EnsomColors.ink),
                  ),
                  const SizedBox(height: 7),
                  const Text(
                    "선택한 항목만 준비 제안에 반영돼요. 지금 설정하지 않아도 핵심 기능은 그대로 동작해요.",
                    style: TextStyle(fontSize: 12.5, color: EnsomColors.inkMuted, height: 1.6),
                  ),
                  const SizedBox(height: 8),
                  for (final pref in prefs)
                    _WellnessPrefRow(pref: pref, onChanged: controller.update),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 8, 18, 16),
              child: EnsomPillButton(label: "완료", onPressed: () => _finish(ref, context)),
            ),
          ],
        ),
      ),
    );
  }
}

class _WellnessPrefRow extends StatelessWidget {
  const _WellnessPrefRow({required this.pref, required this.onChanged});

  final WellnessPref pref;
  final void Function(WellnessPref) onChanged;

  static const _labels = {
    "uv": "자외선",
    "pm": "미세먼지",
    "temp": "기온·체감온도",
    "rain": "강수",
    "hydration": "수분",
  };

  static const _subtitles = {
    "uv": "자외선이 강한 날 선크림을 제안해요",
    "pm": "공기가 나쁜 날 마스크를 제안해요",
    "temp": "기온에 맞는 옷차림을 제안해요",
    "rain": "비·눈 예보가 있으면 우산을 제안해요",
    "hydration": "외출 전 물 챙기기를 제안해요",
  };

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(pref.copyWith(isEnabled: !pref.isEnabled)),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _labels[pref.topic] ?? pref.topic,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: EnsomColors.ink),
                  ),
                  if (_subtitles[pref.topic] != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      _subtitles[pref.topic]!,
                      style: const TextStyle(fontSize: 11, color: EnsomColors.inkFaint),
                    ),
                  ],
                ],
              ),
            ),
            EnsomToggle(value: pref.isEnabled, onChanged: (v) => onChanged(pref.copyWith(isEnabled: v))),
          ],
        ),
      ),
    );
  }
}
