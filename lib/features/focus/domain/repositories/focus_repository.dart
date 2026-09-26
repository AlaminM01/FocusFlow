import '../entities/focus_session_entity.dart';

/// Abstract contract for focus-session persistence operations.
abstract class FocusRepository {
  /// Returns all recorded focus sessions, newest first.
  Future<List<FocusSessionEntity>> getAllSessions();

  /// Persists a new focus session.
  Future<void> saveSession(FocusSessionEntity session);

  /// Permanently removes the session with [id].
  Future<void> deleteSession(String id);

  /// Overwrites an existing session with [session.id].
  Future<void> updateSession(FocusSessionEntity session);

  /// Returns only sessions completed today.
  Future<List<FocusSessionEntity>> getTodaySessions();

  /// Returns total minutes focused within the given [date] (UTC day).
  Future<int> getFocusMinutesForDate(DateTime date);
}
