import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focusflow/features/tracking/domain/entities/streak_entity.dart';

class StreakNotifier extends StateNotifier<StreakEntity> {
  StreakNotifier() : super(const StreakEntity(currentStreak: 7, longestStreak: 14));

  void recordActivity({int focusMinutes = 0, int tasksCompleted = 0}) {
    final today = DateTime.now();
    final todayKey =
        '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

    final updatedDaily = Map<String, int>.from(state.dailyFocusMinutes);
    updatedDaily[todayKey] = (updatedDaily[todayKey] ?? 0) + focusMinutes;

    state = state.copyWith(
      totalFocusMinutes: state.totalFocusMinutes + focusMinutes,
      totalTasksCompleted: state.totalTasksCompleted + tasksCompleted,
      dailyFocusMinutes: updatedDaily,
      lastActiveDate: today,
    );
  }
}

final streakProvider =
    StateNotifierProvider<StreakNotifier, StreakEntity>(
  (ref) => StreakNotifier(),
);
