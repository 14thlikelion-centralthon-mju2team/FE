import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";
import "package:intl/intl.dart";
import "../../models/event.dart";
import "../../providers/calendar_providers.dart";

/// CAL-01. 이번 달 일정 목록만 보여준다 — 월/주간 그리드 뷰, 구글
/// 캘린더 연동 화면은 이번 패스 범위 밖(PRD §10.4 중 목록·생성만).
class CalendarScreen extends ConsumerWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = DateTime.now();
    final range = EventRange(
      from: DateTime(now.year, now.month, 1),
      to: DateTime(now.year, now.month + 1, 1),
    );
    final eventsAsync = ref.watch(eventsInRangeProvider(range));
    final dateFormat = DateFormat("M/d (E) HH:mm", "ko_KR");

    return Scaffold(
      appBar: AppBar(title: const Text("캘린더")),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push("/calendar/new"),
        child: const Icon(Icons.add),
      ),
      body: eventsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, st) => Center(child: Text("불러오지 못했어요: $err")),
        data: (events) {
          if (events.isEmpty) {
            return const Center(child: Text("이번 달 일정이 없어요."));
          }
          final sorted = [...events]..sort((a, b) => a.startsAt.compareTo(b.startsAt));
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: sorted.length,
            separatorBuilder: (_, _) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final event = sorted[index];
              return ListTile(
                title: Text(event.displayName),
                subtitle: Text(dateFormat.format(event.startsAt)),
                trailing: _locationStateChip(event.locationState),
              );
            },
          );
        },
      ),
    );
  }

  Widget? _locationStateChip(LocationState state) {
    if (state == LocationState.notRequired) return null;
    final needsPlace = state == LocationState.requiredMissing;
    return needsPlace
        ? const Icon(Icons.error_outline, color: Colors.orange, size: 18)
        : const Icon(Icons.place_outlined, color: Colors.grey, size: 18);
  }
}
