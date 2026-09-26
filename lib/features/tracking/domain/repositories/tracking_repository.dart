import '../entities/streak_entity.dart';

/// Abstract contract for productivity-tracking persistence operations.
abstract class TrackingRepository {
  /// Returns the current streak / tracking snapshot.
  Future<StreakEntity> getStreak();

  /// Persists (or overwrites) the streak snapshot.
  Future<void> saveStreak(StreakEntity streak);

  /// Increments [totalFocusMinutes] by [minutes] and updates [dailyFocusMinutes].
  Future<StreakEntity> incrementFocusTime(int minutes);

  /// Increments [totalTasksCompleted] by 1.
  Future<StreakEntity> incrementTasksCompleted();

  /// Increments [totalNotesCreated] by 1.
  Future<StreakEntity> incrementNotesCreated();

  /// Recalculates the current and longest streak based on [lastActiveDate].
  Future<StreakEntity> updateStreak();
}
