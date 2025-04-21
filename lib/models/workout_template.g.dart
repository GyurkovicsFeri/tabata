// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_template.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WorkoutTemplateAdapter extends TypeAdapter<WorkoutTemplate> {
  @override
  final int typeId = 0;

  @override
  WorkoutTemplate read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WorkoutTemplate(
      id: fields[0] as String?,
      name: fields[1] as String,
      warmupDuration: fields[2] as int,
      workDuration: fields[3] as int,
      restDuration: fields[4] as int,
      rounds: fields[5] as int,
      cooldownDuration: fields[6] as int,
    );
  }

  @override
  void write(BinaryWriter writer, WorkoutTemplate obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.warmupDuration)
      ..writeByte(3)
      ..write(obj.workDuration)
      ..writeByte(4)
      ..write(obj.restDuration)
      ..writeByte(5)
      ..write(obj.rounds)
      ..writeByte(6)
      ..write(obj.cooldownDuration);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WorkoutTemplateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class WorkoutPhaseAdapter extends TypeAdapter<WorkoutPhase> {
  @override
  final int typeId = 1;

  @override
  WorkoutPhase read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return WorkoutPhase.warmup;
      case 1:
        return WorkoutPhase.work;
      case 2:
        return WorkoutPhase.rest;
      case 3:
        return WorkoutPhase.cooldown;
      case 4:
        return WorkoutPhase.completed;
      default:
        return WorkoutPhase.warmup;
    }
  }

  @override
  void write(BinaryWriter writer, WorkoutPhase obj) {
    switch (obj) {
      case WorkoutPhase.warmup:
        writer.writeByte(0);
        break;
      case WorkoutPhase.work:
        writer.writeByte(1);
        break;
      case WorkoutPhase.rest:
        writer.writeByte(2);
        break;
      case WorkoutPhase.cooldown:
        writer.writeByte(3);
        break;
      case WorkoutPhase.completed:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WorkoutPhaseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
