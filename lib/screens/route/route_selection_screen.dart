import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "../../models/plan.dart";
import "../../network/api_client.dart";
import "../../providers/home_providers.dart";

/// MAP-02. MVP 고정 3종. API v5.0 §10.1 필드명(routeOptionId/routeType/
/// totalMinutes/walkMinutes/transferCount, 단위는 분) 반영.
class RouteSelectionScreen extends ConsumerWidget {
  const RouteSelectionScreen({
    super.key,
    required this.planId,
    required this.eventId,
  });

  final String planId;
  final String eventId;

  String _rankLabel(RouteType type) {
    switch (type) {
      case RouteType.fastest:
        return "가장 빠른 경로";
      case RouteType.leastWalk:
        return "도보가 적은 경로";
      case RouteType.leastTransfer:
        return "환승이 적은 경로";
    }
  }

  Future<void> _select(BuildContext context, WidgetRef ref, RouteOption option) async {
    final controller = ref.read(planControllerProvider(eventId).notifier);
    try {
      await controller.selectRoute(option.routeOptionId);
      if (!context.mounted) return;
      Navigator.of(context).pop();
    } catch (e) {
      if (!context.mounted) return;
      final expired = e is ApiException && {
        "ROUTE_OPTION_EXPIRED",
        "ROUTE_OPTION_NOT_FOUND",
        "ROUTE_OPTION_ALREADY_USED",
      }.contains(e.code);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(expired
            ? "선택한 경로가 만료되었어요. 경로를 다시 검색해주세요."
            : "경로 선택에 실패했어요. 다시 시도해주세요.")),
      );
    }
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
            return Card(
              child: ListTile(
                title: Text(_rankLabel(route.routeType)),
                subtitle: Text(
                  "${route.totalMinutes}분 · 도보 ${route.walkMinutes}분 · 환승 ${route.transferCount}회",
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