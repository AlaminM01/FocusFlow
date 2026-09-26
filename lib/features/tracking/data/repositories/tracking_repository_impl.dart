import 'package:hive/hive.dart';
import '../../domain/entities/streak_entity.dart';
import '../../domain/repositories/tracking_repository.dart';
import '../models/streak_model.dart';

/// Hive-backed implementation of [TrackingRepository].
///
/// The streak data is stored as a single record under the key `'streak'`.
class TrackingRepositoryImpl implements TrackingRepository {
  final Box<StreakModel> _box;
  static const _key = 'streak';

  const TrackingRepositoryImpl(this._box);

  // ──────────────────────────────────────────────
  // Helpers
  // ──────────────────────────────────────────────

  StreakModel _getOrCreate() {
    return _box.get(_key) ?? StreakModel();
  }

  String _dateKey(DateTime dt) =>
      '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';

  // ──────────────────────────────────────────────
  // Interface implementation
  // ──────────────────────────────────────────────

  @override
  Future<StreakEntity> getStreak() async {
    return _getOrCreate().toEntity();
  }

  @override
  Future<void> saveStreak(StreakEntity streak) async {
    final model = StreakModel.fromEntity(streak);
    await _box.put(_key, model);
  }

  @override
  Future<StreakEntity> incrementFocusTime(int minutes) async {
    final model = _getOrCreate();
    final todayKey = _dateKey(DateTime.now());
    model.totalFocusMinutes += minutes;
    model.dailyFocusMinutes = Map<String, int>.from(model.dailyFocusMinutes)
      ..[todayKey] = (model.dailyFocusMinutes[todayKey] ?? 0) + minutes;
    await _box.put(_key, model);
    return model.toEntity();
  }

  @override
  Future<StreakEntity> incrementTasksCompleted() async {
    final model = _getOrCreate();
    model.totalTasksCompleted += 1;
    await _box.put(_key, model);
    return model.toEntity();
  }

  @override
  Future<StreakEntity> incrementNotesCreated() async {
    final model = _getOrCreate();
    model.totalNotesCreated += 1;
    await _box.put(_key, model);
    return model.toEntity();
  }

  @override
  Future<StreakEntity> updateStreak() async {
    final model = _getOrCreate();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    if (model.lastActiveDate == null) {
      // First ever activity.
      model
        ..currentStreak = 1
        ..longestStreak = 1
        ..lastActiveDate = today;
    } else {
      final last = model.lastActiveDate!;
      final lastDay = DateTime(last.year, last.month, last.day);
      final diff = today.difference(lastDay).inDays;

      if (diff == 0) {
        // Already updated today – nothing to change.
      } else if (diff == 1) {
        // Consecutive day.
        model.currentStreak += 1;
        if (model.currentStreak > model.longestStreak) {
          model.longestStreak = model.currentStreak;
        }
        model.lastActiveDate = today;
      } else {
        // Streak broken.
        model
          ..currentStreak = 1
          ..lastActiveDate = today;
      }
    }

    await _box.put(_key, model);
    return model.toEntity();
  }
}
