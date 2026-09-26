// GENERATED CODE - DO NOT MODIFY BY HAND
// Manually written Hive TypeAdapter for StreakModel (typeId: 3)

part of 'streak_model.dart';

class StreakModelAdapter extends TypeAdapter<StreakModel> {
  @override
  final int typeId = 3;

  @override
  StreakModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StreakModel(
      currentStreak: fields[0] as int,
      longestStreak: fields[1] as int,
      lastActiveDate: fields[2] as DateTime?,
      totalFocusMinutes: fields[3] as int,
      totalTasksCompleted: fields[4] as int,
      totalNotesCreated: fields[5] as int,
      dailyFocusMinutes: (fields[6] as Map).cast<String, int>(),
    );
  }

  @override
  void write(BinaryWriter writer, StreakModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.currentStreak)
      ..writeByte(1)
      ..write(obj.longestStreak)
      ..writeByte(2)
      ..write(obj.lastActiveDate)
      ..writeByte(3)
      ..write(obj.totalFocusMinutes)
      ..writeByte(4)
      ..write(obj.totalTasksCompleted)
      ..writeByte(5)
      ..write(obj.totalNotesCreated)
      ..writeByte(6)
      ..write(obj.dailyFocusMinutes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StreakModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
