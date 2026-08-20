import "package:ensom/models/event.dart";
import "package:ensom/models/plan.dart";
import "package:ensom/providers/map_providers.dart";
import "package:flutter_test/flutter_test.dart";

void main() {
  group("MapDraftEvent route option TTL", () {
    final createdAt = DateTime.parse("2026-08-20T14:00:00+09:00");
    final draft = MapDraftEvent(
      originLat: 37.5665,
      originLng: 126.9780,
      destName: "강남역",
      destLat: 37.498,
      destLng: 127.027,
      selectedRoute: const RouteOption(
        routeOptionId: "route-1",
        routeRank: 1,
        routeType: RouteType.fastest,
        totalMinutes: 42,
        walkMinutes: 11,
        transferCount: 1,
      ),
      anchorMode: EventAnchor.arriveBy,
      at: DateTime.parse("2026-08-20T16:00:00+09:00"),
      createdAt: createdAt,
    );

    test("is valid before 30 minutes and expires at the boundary", () {
      expect(
        draft.isExpiredAt(
          createdAt.add(const Duration(minutes: 29, seconds: 59)),
        ),
        isFalse,
      );
      expect(
        draft.isExpiredAt(createdAt.add(const Duration(minutes: 30))),
        isTrue,
      );
    });

    test("round-trip keeps the creation time used for expiration", () {
      final restored = MapDraftEvent.fromJson(draft.toJson());

      expect(restored.createdAt, createdAt);
      expect(restored.selectedRoute.routeOptionId, "route-1");
      expect(
        restored.isExpiredAt(createdAt.add(const Duration(minutes: 30))),
        isTrue,
      );
    });

    test("legacy drafts without createdAt expire safely", () {
      final legacyJson = Map<String, dynamic>.from(draft.toJson())
        ..remove("createdAt");
      final restored = MapDraftEvent.fromJson(legacyJson);

      expect(restored.isExpiredAt(createdAt), isTrue);
    });
  });
}
