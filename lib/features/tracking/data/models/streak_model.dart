import 'package:hive/hive.dart';
import '../../domain/entities/streak_entity.dart';

part 'streak_model.g.dart';

@HiveType(typeId: 3)
class StreakModel extends HiveObject {
  @HiveField(0)
  late int currentStreak;

  @HiveField(1)
  late int longestStreak;

  @HiveField(2)
  DateTime? lastActiveDate;

  @HiveField(3)
  late int totalFocusMinutes;

  @HiveField(4)
  late int totalTasksCompleted;

  @HiveField(5)
  late int totalNotesCreated;

  /// Maps 'YYYY-MM-DD' → minutes focused on that day.
  @HiveField(6)
  late Map<String, int> dailyFocusMinutes;

  StreakModel({
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.lastActiveDate,
    this.totalFocusMinutes = 0,
    this.totalTasksCompleted = 0,
    this.totalNotesCreated = 0,
    Map<String, int>? dailyFocusMinutes,
  }) : dailyFocusMinutes = dailyFocusMinutes ?? {};

  /// Convert this model to a domain [StreakEntity].
  StreakEntity toEntity() {
    return StreakEntity(
      currentStreak: currentStreak,
      longestStreak: longestStreak,
      lastActiveDate: lastActiveDate,
      totalFocusMinutes: totalFocusMinutes,
      totalTasksCompleted: totalTasksCompleted,
      totalNotesCreated: totalNotesCreated,
      dailyFocusMinutes: Map<String, int>.from(dailyFocusMinutes),
    );
  }

  /// Build a [StreakModel] from a domain [StreakEntity].
  factory StreakModel.fromEntity(StreakEntity entity) {
    return StreakModel(
      currentStreak: entity.currentStreak,
      longestStreak: entity.longestStreak,
      lastActiveDate: entity.lastActiveDate,
      totalFocusMinutes: entity.totalFocusMinutes,
      totalTasksCompleted: entity.totalTasksCompleted,
      totalNotesCreated: entity.totalNotesCreated,
      dailyFocusMinutes: Map<String, int>.from(entity.dailyFocusMinutes),
    );
  }
}
