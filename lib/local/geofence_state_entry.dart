import 'package:hive_ce/hive_ce.dart';

part 'geofence_state_entry.g.dart';

@HiveType(typeId: 2)
class GeofenceStateEntry extends HiveObject {
  @HiveField(0)
  String userId;

  @HiveField(1)
  String geofenceId;

  @HiveField(2)
  bool isRegistered;

  GeofenceStateEntry({
    required this.userId,
    required this.geofenceId,
    required this.isRegistered,
  });
}