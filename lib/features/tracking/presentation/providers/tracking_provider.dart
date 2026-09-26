import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../data/models/streak_model.dart';
import '../../data/repositories/tracking_repository_impl.dart';
import '../../domain/entities/streak_entity.dart';
import '../../domain/repositories/tracking_repository.dart';

// ──────────────────────────────────────────────
// Repository provider
// ──────────────────────────────────────────────

/// Provides the Hive-backed [TrackingRepository].
final trackingRepositoryProvider = Provider<TrackingRepository>((ref) {
  final box = Hive.box<StreakModel>('tracking');
  return TrackingRepositoryImpl(box);
});

// ──────────────────────────────────────────────
// Streak notifier
// ──────────────────────────────────────────────

class StreakNotifier extends StateNotifier<StreakEntity> {
  final TrackingRepository _repository;

  StreakNotifier(this._repository) : super(const StreakEntity()) {
    _load();
  }

  Future<void> _load() async {
    final streak = await _repository.getStreak();
    state = streak;
  }

  /// Recalculates the daily streak based on today's activity.
  Future<void> updateStreak() async {
    state = await _repository.updateStreak();
  }

  /// Adds [minutes] to total and today's focus minutes.
  Future<void> incrementFocusTime(int minutes) async {
    state = await _repository.incrementFocusTime(minutes);
  }

  /// Increments the total tasks completed counter.
  Future<void> incrementTasksCompleted() async {
    state = await _repository.incrementTasksCompleted();
  }

  /// Increments the total notes created counter.
  Future<void> incrementNotesCreated() async {
    state = await _repository.incrementNotesCreated();
  }

  /// Saves the streak entity directly (for custom mutations).
  Future<void> save(StreakEntity streak) async {
    await _repository.saveStreak(streak);
    state = streak;
  }
}

/// Provides the live [StreakEntity] state.
final streakProvider =
    StateNotifierProvider<StreakNotifier, StreakEntity>((ref) {
  final repository = ref.read(trackingRepositoryProvider);
  return StreakNotifier(repository);
});

// ──────────────────────────────────────────────
// Productivity insights derived provider
// ──────────────────────────────────────────────

/// A structured snapshot of productivity metrics for display.
class ProductivityInsights {
  final int currentStreak;
  final int longestStreak;
  final int totalFocusHours;
  final int totalFocusMinutesRemainder;
  final int totalTasksCompleted;
  final int totalNotesCreated;
  final double averageDailyFocusMinutes;
  final int todayFocusMinutes;
  final List<MapEntry<String, int>> last7DaysFocus;

  const ProductivityInsights({
    required this.currentStreak,
    required this.longestStreak,
    required this.totalFocusHours,
    required this.totalFocusMinutesRemainder,
    required this.totalTasksCompleted,
    required this.totalNotesCreated,
    required this.averageDailyFocusMinutes,
    required this.todayFocusMinutes,
    required this.last7DaysFocus,
  });
}

/// Derives [ProductivityInsights] from [streakProvider].
final productivityInsightsProvider = Provider<ProductivityInsights>((ref) {
  final streak = ref.watch(streakProvider);

  final todayKey = _dateKey(DateTime.now());
  final todayMinutes = streak.dailyFocusMinutes[todayKey] ?? 0;

  // Last 7 days entries sorted chronologically.
  final allDays = streak.dailyFocusMinutes.entries.toList()
    ..sort((a, b) => a.key.compareTo(b.key));
  final last7 = allDays.length > 7 ? allDays.sublist(allDays.length - 7) : allDays;

  final totalDays = streak.dailyFocusMinutes.length;
  final avgMinutes = totalDays == 0
      ? 0.0
      : streak.totalFocusMinutes / totalDays;

  return ProductivityInsights(
    currentStreak: streak.currentStreak,
    longestStreak: streak.longestStreak,
    totalFocusHours: streak.totalFocusMinutes ~/ 60,
    totalFocusMinutesRemainder: streak.totalFocusMinutes % 60,
    totalTasksCompleted: streak.totalTasksCompleted,
    totalNotesCreated: streak.totalNotesCreated,
    averageDailyFocusMinutes: avgMinutes,
    todayFocusMinutes: todayMinutes,
    last7DaysFocus: last7,
  );
});

String _dateKey(DateTime dt) =>
    '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
