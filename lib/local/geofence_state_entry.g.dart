// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'geofence_state_entry.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GeofenceStateEntryAdapter extends TypeAdapter<GeofenceStateEntry> {
  @override
  final typeId = 2;

  @override
  GeofenceStateEntry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GeofenceStateEntry(
      userId: fields[0] as String,
      geofenceId: fields[1] as String,
      isRegistered: fields[2] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, GeofenceStateEntry obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.userId)
      ..writeByte(1)
      ..write(obj.geofenceId)
      ..writeByte(2)
      ..write(obj.isRegistered);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GeofenceStateEntryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
