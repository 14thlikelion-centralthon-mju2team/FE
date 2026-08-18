import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "../../models/wellness_pref.dart";
import "../../repository/ensom_repository.dart";
import "../../repository/providers.dart";

/// API 명세 §4.2 wellnessTopic 값 (v5.0 확정):
///   uv | pm | temp | rain | hydration
///
/// 이전 버전에서 사용하던 "heat" / "precipitation"은 폐기되었습니다.
/// 서버가 기대하는 정확한 문자열만 사용합니다.
const _topicLabels = {
  "uv": "자외선",
  "pm": "미세먼지",
  "temp": "기온·체감온도",
  "rain": "강수",
  "hydration": "수분 섭취",
};

const _topicIcons = {
  "uv": Icons.wb_sunny_outlined,
  "pm": Icons.cloud_outlined,
  "temp": Icons.thermostat_outlined,
  "rain": Icons.umbrella_outlined,
  "hydration": Icons.water_drop_outlined,
};

final wellnessPrefsProvider = StateNotifierProvider.autoDispose<
    WellnessPrefsController, AsyncValue<List<WellnessPref>>>((ref) {
  final repo = ref.watch(ensomRepositoryProvider);
  return WellnessPrefsController(repo);
});

class WellnessPrefsController
    extends StateNotifier<AsyncValue<List<WellnessPref>>> {
  WellnessPrefsController(this._repo) : super(const AsyncValue.loading()) {
    _load();
  }

  final EnsomRepository _repo;

  Future<void> _load() async {
    state = const AsyncValue.loading();
    try {
      final prefs = await _repo.fetchWellnessPrefs();
      state = AsyncValue.data(prefs);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> update(WellnessPref updated) async {
    final prefs = state.value;
    if (prefs == null) return;
    final newList = [
      for (final p in prefs) if (p.topic == updated.topic) updated else p,
    ];
    state = AsyncValue.data(newList);
    try {
      await _repo.updateWellnessPrefs(newList);
    } catch (_) {
      state = AsyncValue.data(prefs); // 롤백
    }
  }
}

/// WELL-06. 관심 항목별 on/off + 재알림 주기 설정.
/// PRD §14.7: 재알림 주기는 사용자가 직접 설정한다. 서비스가 판단하지 않는다.
class WellnessPrefsScreen extends ConsumerWidget {
  const WellnessPrefsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefsAsync = ref.watch(wellnessPrefsProvider);
    final controller = ref.read(wellnessPrefsProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text("웰니스 관심 항목")),
      body: prefsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, st) => Center(child: Text("불러오지 못했어요: $err")),
        data: (prefs) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: Text(
                "관심 있는 항목을 켜면 해당 환경 조건에서 행동 제안과 리마인드를 받을 수 있어요.",
                style: TextStyle(color: Colors.grey, fontSize: 13),
              ),
            ),
            for (final pref in prefs)
              _PrefTile(pref: pref, onChanged: controller.update),
          ],
        ),
      ),
    );
  }
}

class _PrefTile extends StatelessWidget {
  const _PrefTile({required this.pref, required this.onChanged});

  final WellnessPref pref;
  final void Function(WellnessPref) onChanged;

  @override
  Widget build(BuildContext context) {
    final icon = _topicIcons[pref.topic] ?? Icons.circle_outlined;
    final label = _topicLabels[pref.topic] ?? pref.topic;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              secondary: Icon(icon, color: pref.isEnabled ? Colors.orange : Colors.grey),
              title: Text(label),
              value: pref.isEnabled,
              onChanged: (v) => onChanged(pref.copyWith(isEnabled: v)),
            ),
            if (pref.isEnabled) ...[
              Padding(
                padding: const EdgeInsets.only(left: 4, bottom: 4),
                child: Text(
                  "재알림 주기: ${pref.remindIntervalMinutes}분",
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),
              Slider(
                value: pref.remindIntervalMinutes.toDouble(),
                min: 30,
                max: 240,
                divisions: 14,
                label: "${pref.remindIntervalMinutes}분",
                onChanged: (v) =>
                    onChanged(pref.copyWith(remindIntervalMinutes: v.round())),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 4, bottom: 8),
                child: Text(
                  "하루 최대 알림: ${pref.dailyEventCap}회",
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
