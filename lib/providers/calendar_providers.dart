import "package:flutter_riverpod/flutter_riverpod.dart";
import "../models/event.dart";
import "../repository/providers.dart";

class EventRange {
  const EventRange({required this.from, required this.to});
  final DateTime from;
  final DateTime to;

  @override
  bool operator ==(Object other) =>
      other is EventRange && other.from == from && other.to == to;

  @override
  int get hashCode => Object.hash(from, to);
}

final eventsInRangeProvider =
    FutureProvider.autoDispose.family<List<Event>, EventRange>((ref, range) async {
  final repo = ref.watch(ensomRepositoryProvider);
  return repo.fetchEvents(from: range.from, to: range.to);
});
