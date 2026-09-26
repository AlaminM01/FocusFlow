/// Pure domain entity that holds all productivity-tracking data.
class StreakEntity {
  final int currentStreak;
  final int longestStreak;
  final DateTime? lastActiveDate;
  final int totalFocusMinutes;
  final int totalTasksCompleted;
  final int totalNotesCreated;
  /// Maps 'YYYY-MM-DD' → minutes focused on that day.
  final Map<String, int> dailyFocusMinutes;

  const StreakEntity({
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.lastActiveDate,
    this.totalFocusMinutes = 0,
    this.totalTasksCompleted = 0,
    this.totalNotesCreated = 0,
    this.dailyFocusMinutes = const {},
  });

  StreakEntity copyWith({
    int? currentStreak,
    int? longestStreak,
    DateTime? lastActiveDate,
    int? totalFocusMinutes,
    int? totalTasksCompleted,
    int? totalNotesCreated,
    Map<String, int>? dailyFocusMinutes,
    bool clearLastActiveDate = false,
  }) {
    return StreakEntity(
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      lastActiveDate:
          clearLastActiveDate ? null : (lastActiveDate ?? this.lastActiveDate),
      totalFocusMinutes: totalFocusMinutes ?? this.totalFocusMinutes,
      totalTasksCompleted: totalTasksCompleted ?? this.totalTasksCompleted,
      totalNotesCreated: totalNotesCreated ?? this.totalNotesCreated,
      dailyFocusMinutes: dailyFocusMinutes ?? this.dailyFocusMinutes,
    );
  }

  /// Total hours focused, rounded to one decimal place.
  double get totalFocusHours => totalFocusMinutes / 60.0;

  /// Focus minutes for a specific date formatted as 'YYYY-MM-DD'.
  int focusMinutesForDate(String dateKey) =>
      dailyFocusMinutes[dateKey] ?? 0;

  @override
  String toString() =>
      'StreakEntity(currentStreak: $currentStreak, longestStreak: $longestStreak, '
      'totalFocus: ${totalFocusMinutes}min, tasks: $totalTasksCompleted)';
}
