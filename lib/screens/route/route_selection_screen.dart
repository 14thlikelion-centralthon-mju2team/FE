import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "../../models/plan.dart";
import "../../providers/home_providers.dart";

/// MAP-02. MVP 고정 3종 -- 그 이상 확장하지 않는다.
///
/// 리뷰 High-1 반영: 선택 결과(authoritative Plan)를 PlanController를
/// 통해 직접 반영한다. family provider를 단순 invalidate만 하지 않는다 --
/// 그러면 화면이 새 계획을 받기까지 로딩 상태로 되돌아가고, 실패 시
/// 사용자에게 알려줄 방법도 없었다.
class RouteSelectionScreen extends ConsumerWidget {
  const RouteSelectionScreen({
    super.key,
    required this.planId,
    required this.eventId,
  });

  final String planId;
  final String eventId;

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
    final controller = ref.read(planControllerProvider(eventId).notifier);
    await controller.selectRoute(option.routeId);

    if (!context.mounted) return;

    final result = ref.read(planControllerProvider(eventId));
    if (result.hasError) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("경로 선택에 실패했어요. 다시 시도해주세요.")),
      );
      return;
    }
    Navigator.of(context).pop();
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