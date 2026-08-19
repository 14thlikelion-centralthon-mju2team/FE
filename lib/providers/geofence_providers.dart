import "package:flutter/widgets.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "../services/geofence_manager.dart";
import "home_providers.dart";

/// 앱 전체에서 하나만 있어야 하는 지오펜스 매니저(TR-08 "활성 계획 1건").
final geofenceManagerProvider = Provider<GeofenceManager>((ref) {
  return GeofenceManager(ref);
});

/// main.dart의 MaterialApp.router builder에 항상 붙여 두는 보이지 않는
/// 위젯. 다음 일정·계획이 바뀔 때마다 GeofenceManager에 동기화를
/// 트리거한다(활성 창 진입 시 리전 등록, 종료 시 해제).
///
/// syncActivePlan()은 planId가 같으면 바로 반환하는 멱등 연산이라
/// build()에서 매번 호출해도 안전하다 -- WidgetRef.listen은 위젯
/// build 안에서 fireImmediately를 지원하지 않아(Riverpod 3), watch로
/// 얻은 최신 값을 build 안에서 직접 동기화하는 방식을 쓴다.
class GeofenceSync extends ConsumerWidget {
  const GeofenceSync({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventAsync = ref.watch(nextEventProvider);
    final event = eventAsync.value;

    if (event == null) {
      if (eventAsync.hasValue) ref.read(geofenceManagerProvider).clear();
      return const SizedBox.shrink();
    }

    final planAsync = ref.watch(planControllerProvider(event.eventId));
    planAsync.whenData((plan) => ref.read(geofenceManagerProvider).syncActivePlan(event, plan));

    return const SizedBox.shrink();
  }
}
