// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'offline_queue_entry.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OfflineQueueEntryAdapter extends TypeAdapter<OfflineQueueEntry> {
  @override
  final typeId = 0;

  @override
  OfflineQueueEntry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OfflineQueueEntry(
      userId: fields[0] as String,
      eventType: fields[1] as String,
      payload: (fields[2] as Map).cast<String, dynamic>(),
      queuedAt: fields[3] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, OfflineQueueEntry obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.userId)
      ..writeByte(1)
      ..write(obj.eventType)
      ..writeByte(2)
      ..write(obj.payload)
      ..writeByte(3)
      ..write(obj.queuedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OfflineQueueEntryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
