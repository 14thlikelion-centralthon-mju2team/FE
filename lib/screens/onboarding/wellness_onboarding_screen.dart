import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";
import "../../models/wellness_pref.dart";
import "../settings/wellness_prefs_screen.dart";

/// ONB-06 웰니스 관심 항목 설정 (온보딩 context)
/// 기존 WellnessPrefsScreen의 provider를 재사용하되,
/// AppBar에 [완료]/[건너뛰기]를 추가해 /home으로 이동한다.
class WellnessOnboardingScreen extends ConsumerWidget {
  const WellnessOnboardingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefsAsync = ref.watch(wellnessPrefsProvider);
    final controller = ref.read(wellnessPrefsProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text("웰니스 관심 항목"),
        actions: [
          TextButton(
            onPressed: () => context.go("/home"),
            child: const Text("건너뛰기"),
          ),
        ],
      ),
      body: prefsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, st) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("불러오지 못했어요: $err"),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () => context.go("/home"),
                child: const Text("건너뛰고 시작하기"),
              ),
            ],
          ),
        ),
        data: (prefs) => Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  const Text(
                    "관심 있는 환경 항목을 선택해주세요",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "선택하지 않아도 핵심 기능은 정상 동작해요.",
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                  const SizedBox(height: 16),
                  for (final pref in prefs)
                    _OnboardingPrefTile(
                      pref: pref,
                      onChanged: controller.update,
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => context.go("/home"),
                  child: const Text("완료"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingPrefTile extends StatelessWidget {
  const _OnboardingPrefTile({required this.pref, required this.onChanged});

  final WellnessPref pref;
  final void Function(WellnessPref) onChanged;

  static const _labels = {
    "uv": "자외선",
    "pm": "미세먼지",
    "temp": "기온·체감온도",
    "rain": "강수",
    "hydration": "수분 섭취",
  };

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: Text(_labels[pref.topic] ?? pref.topic),
      value: pref.isEnabled,
      onChanged: (v) => onChanged(pref.copyWith(isEnabled: v)),
    );
  }
}
