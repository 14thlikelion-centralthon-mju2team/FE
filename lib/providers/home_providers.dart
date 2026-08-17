import "package:flutter_riverpod/flutter_riverpod.dart";
import "../models/event.dart";
import "../models/plan.dart";
import "../repository/providers.dart";

/// 다음 일정 조회. EventClassification 확인 흐름은 캘린더 화면(M4) 담당,
/// 여기서는 홈 카드 표시에만 쓴다.
final nextEventProvider = FutureProvider.autoDispose<Event?>((ref) async {
  final repo = ref.watch(ensomRepositoryProvider);
  return repo.fetchNextEvent();
});

/// eventId 기준 최신 계획 조회. 계획 응답의 trace/checklist는 서버가
/// 정렬해주지 않으므로(API 명세 §9) 화면에서 받은 순서 그대로 표시한다.
final latestPlanProvider =
    FutureProvider.autoDispose.family<Plan, String>((ref, eventId) async {
  final repo = ref.watch(ensomRepositoryProvider);
  return repo.fetchLatestPlan(eventId);
});

/// 경로 후보 3종.
final routeOptionsProvider =
    FutureProvider.autoDispose.family<List<RouteOption>, String>(
        (ref, planId) async {
  final repo = ref.watch(ensomRepositoryProvider);
  return repo.fetchRouteOptions(planId);
});