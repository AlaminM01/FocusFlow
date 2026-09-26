import 'package:hive/hive.dart';
import '../../domain/entities/focus_session_entity.dart';
import '../../domain/repositories/focus_repository.dart';
import '../models/focus_session_model.dart';

/// Hive-backed implementation of [FocusRepository].
class FocusRepositoryImpl implements FocusRepository {
  final Box<FocusSessionModel> _box;

  const FocusRepositoryImpl(this._box);

  @override
  Future<List<FocusSessionEntity>> getAllSessions() async {
    final models = _box.values.toList();
    models.sort((a, b) => b.startTime.compareTo(a.startTime));
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<void> saveSession(FocusSessionEntity session) async {
    final model = FocusSessionModel.fromEntity(session);
    await _box.put(session.id, model);
  }

  @override
  Future<void> deleteSession(String id) async {
    await _box.delete(id);
  }

  @override
  Future<void> updateSession(FocusSessionEntity session) async {
    final model = FocusSessionModel.fromEntity(session);
    await _box.put(session.id, model);
  }

  @override
  Future<List<FocusSessionEntity>> getTodaySessions() async {
    final now = DateTime.now();
    return _box.values
        .where((m) =>
            m.startTime.year == now.year &&
            m.startTime.month == now.month &&
            m.startTime.day == now.day)
        .map((m) => m.toEntity())
        .toList();
  }

  @override
  Future<int> getFocusMinutesForDate(DateTime date) async {
    final sessions = _box.values.where((m) =>
        m.isCompleted &&
        m.startTime.year == date.year &&
        m.startTime.month == date.month &&
        m.startTime.day == date.day);
    return sessions.fold<int>(0, (sum, m) => sum + m.durationMinutes);
  }
}
