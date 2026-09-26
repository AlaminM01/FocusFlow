import 'package:hive/hive.dart';
import '../../domain/entities/focus_session_entity.dart';

part 'focus_session_model.g.dart';

@HiveType(typeId: 2)
class FocusSessionModel extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late DateTime startTime;

  @HiveField(2)
  late DateTime endTime;

  @HiveField(3)
  late int durationMinutes;

  @HiveField(4)
  late String sessionType; // 'pomodoro' | 'deepwork' | 'break'

  @HiveField(5)
  late bool isCompleted;

  FocusSessionModel({
    required this.id,
    required this.startTime,
    required this.endTime,
    required this.durationMinutes,
    required this.sessionType,
    this.isCompleted = false,
  });

  /// Convert this model to a domain [FocusSessionEntity].
  FocusSessionEntity toEntity() {
    return FocusSessionEntity(
      id: id,
      startTime: startTime,
      endTime: endTime,
      durationMinutes: durationMinutes,
      sessionType: sessionType,
      isCompleted: isCompleted,
    );
  }

  /// Build a [FocusSessionModel] from a domain [FocusSessionEntity].
  factory FocusSessionModel.fromEntity(FocusSessionEntity entity) {
    return FocusSessionModel(
      id: entity.id,
      startTime: entity.startTime,
      endTime: entity.endTime,
      durationMinutes: entity.durationMinutes,
      sessionType: entity.sessionType,
      isCompleted: entity.isCompleted,
    );
  }
}
