import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "../../models/plan.dart";
import "../../providers/home_providers.dart";
import "../../repository/providers.dart";

/// MAP-02. MVP 고정 3종(fastest/least_walk/least_transfer) -- 그 이상
/// 확장하지 않는다 (PRD "확장 경로 유형"은 P2, 이 화면 범위 밖).
class RouteSelectionScreen extends ConsumerWidget {
  const RouteSelectionScreen({super.key, required this.planId});

  final String planId;

  String _rankLabel(RouteRank rank) {
    switch (rank) {
      case RouteRank.fastest:
        return "가장 빠른 경로";
      case RouteRank.leastWalk:
        return "도보가 적은 경로";
      case RouteRank.leastTransfer:
        return "환승이 적은 경로";
    }
  }

  Future<void> _select(BuildContext context, WidgetRef ref, RouteOption option) async {
    final repo = ref.read(ensomRepositoryProvider);
    await repo.selectRoute(planId, option.routeId);
    ref.invalidate(latestPlanProvider);
    if (context.mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routesAsync = ref.watch(routeOptionsProvider(planId));

    return Scaffold(
      appBar: AppBar(title: const Text("경로 선택")),
      body: routesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, st) => Center(child: Text("경로를 불러오지 못했어요: $err")),
        data: (routes) => ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: routes.length,
          separatorBuilder: (_, _) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final route = routes[index];
            final minutes = route.totalSec ~/ 60;
            final walkMinutes = route.walkSec ~/ 60;
            return Card(
              child: ListTile(
                title: Text(_rankLabel(route.rank)),
                subtitle: Text(
                  "$minutes분 · 도보 $walkMinutes분 · 환승 ${route.transfers}회",
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _select(context, ref, route),
              ),
            );
          },
        ),
      ),
    );
  }
}