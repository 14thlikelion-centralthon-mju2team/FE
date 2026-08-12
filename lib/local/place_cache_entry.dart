import 'package:hive_ce/hive_ce.dart';

part 'place_cache_entry.g.dart';

@HiveType(typeId: 1)
class PlaceCacheEntry extends HiveObject {
  @HiveField(0)
  String userId;

  @HiveField(1)
  String placeId;

  @HiveField(2)
  String label;

  @HiveField(3)
  double lat;

  @HiveField(4)
  double lng;

  @HiveField(5)
  int radiusM;

  PlaceCacheEntry({
    required this.userId,
    required this.placeId,
    required this.label,
    required this.lat,
    required this.lng,
    required this.radiusM,
  });
}