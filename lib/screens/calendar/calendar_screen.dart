import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";
import "package:intl/intl.dart";
import "../../models/event.dart";
import "../../providers/bootstrap_provider.dart";
import "../../providers/calendar_providers.dart";
import "../../theme/ensom_colors.dart";
import "../../widgets/permission_degraded_banner.dart";

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
    final bootstrap = ref.watch(bootstrapProvider).value;
    final calendarStatuses = bootstrap?.permissions.where(
      (permission) => permission.permissionType == "calendar",
    );
    final calendarDenied =
        calendarStatuses?.any(
          (permission) =>
              permission.status == "denied" ||
              permission.status == "restricted",
        ) ??
        false;
    final dateFormat = DateFormat("M/d (E) HH:mm", "ko_KR");

    return Scaffold(
      appBar: AppBar(
        title: const Text("캘린더"),
        actions: [
          IconButton(
            tooltip: "캘린더 연동 관리",
            onPressed: () => context.push("/calendar/sync"),
            icon: const Icon(Icons.sync),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push("/calendar/new"),
        child: const Icon(Icons.add),
      ),
      body: eventsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, st) => Center(child: Text("불러오지 못했어요: $err")),
        data: (events) {
          final sorted = [...events]
            ..sort((a, b) => a.startsAt.compareTo(b.startsAt));
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              PermissionDegradedBanner(
                type: DegradedPermissionType.calendar,
                deniedOverride: calendarDenied,
              ),
              if (sorted.isEmpty) ...[
                const SizedBox(height: 64),
                const Icon(
                  Icons.event_available,
                  size: 48,
                  color: EnsomColors.inkMuted,
                ),
                const SizedBox(height: 12),
                const Center(child: Text("이번 달 일정이 없어요.")),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: () => context.push("/calendar/new"),
                  child: const Text("일정 만들기"),
                ),
                OutlinedButton(
                  onPressed: () => context.push("/calendar/sync"),
                  child: const Text("캘린더 연동하기"),
                ),
              ] else
                for (var index = 0; index < sorted.length; index++) ...[
                  if (index > 0) const Divider(height: 1),
                  ListTile(
                    title: Text(sorted[index].displayName),
                    subtitle: Text(dateFormat.format(sorted[index].startsAt)),
                    trailing: _locationStateChip(sorted[index].locationState),
                    onTap: () =>
                        context.push("/events/${sorted[index].eventId}"),
                  ),
                ],
            ],
          );
        },
      ),
    );
  }

  Widget? _locationStateChip(LocationState state) {
    if (state == LocationState.notRequired) return null;
    final needsPlace = state == LocationState.requiredMissing;
    return needsPlace
        ? const Icon(Icons.error_outline, color: EnsomColors.caution, size: 18)
        : const Icon(
            Icons.place_outlined,
            color: EnsomColors.inkMuted,
            size: 18,
          );
  }
}
