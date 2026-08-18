import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:flutter_riverpod/legacy.dart";
import "../../models/wellness_pref.dart";
import "../../repository/ensom_repository.dart";
import "../../repository/providers.dart";

const _topicLabels = {
  "uv": "자외선",
  "pm": "미세먼지",
  "temp": "기온·체감온도",
  "rain": "강수",
  "hydration": "수분 섭취",
};

final wellnessPrefsProvider =
    StateNotifierProvider.autoDispose<WellnessPrefsController, AsyncValue<List<WellnessPref>>>(
        (ref) {
  final repo = ref.watch(ensomRepositoryProvider);
  return WellnessPrefsController(repo);
});

class WellnessPrefsController extends StateNotifier<AsyncValue<List<WellnessPref>>> {
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
            for (final pref in prefs) _PrefTile(pref: pref, onChanged: controller.update),
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
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(_topicLabels[pref.topic] ?? pref.topic),
              value: pref.isEnabled,
              onChanged: (v) => onChanged(pref.copyWith(isEnabled: v)),
            ),
            if (pref.isEnabled) ...[
              Text(
                "재알림 주기: ${pref.remindIntervalMinutes ?? 120}분",
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              Slider(
                value: (pref.remindIntervalMinutes ?? 120).toDouble(),
                min: 30,
                max: 240,
                divisions: 14,
                label: "${pref.remindIntervalMinutes ?? 120}분",
                onChanged: (v) =>
                    onChanged(pref.copyWith(remindIntervalMinutes: v.round())),
              ),
              const SizedBox(height: 8),
            ],
          ],
        ),
      ),
    );
  }
}