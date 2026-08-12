// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'place_cache_entry.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PlaceCacheEntryAdapter extends TypeAdapter<PlaceCacheEntry> {
  @override
  final typeId = 1;

  @override
  PlaceCacheEntry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PlaceCacheEntry(
      userId: fields[0] as String,
      placeId: fields[1] as String,
      label: fields[2] as String,
      lat: (fields[3] as num).toDouble(),
      lng: (fields[4] as num).toDouble(),
      radius: (fields[5] as num).toDouble(),
    );
  }

  @override
  void write(BinaryWriter writer, PlaceCacheEntry obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.userId)
      ..writeByte(1)
      ..write(obj.placeId)
      ..writeByte(2)
      ..write(obj.label)
      ..writeByte(3)
      ..write(obj.lat)
      ..writeByte(4)
      ..write(obj.lng)
      ..writeByte(5)
      ..write(obj.radius);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlaceCacheEntryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
