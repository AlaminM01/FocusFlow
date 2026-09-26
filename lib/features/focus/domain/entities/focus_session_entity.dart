/// Pure domain entity for a completed (or in-progress) focus session.
class FocusSessionEntity {
  final String id;
  final DateTime startTime;
  final DateTime endTime;
  final int durationMinutes;
  final String sessionType; // 'pomodoro' | 'deepwork' | 'break'
  final bool isCompleted;

  const FocusSessionEntity({
    required this.id,
    required this.startTime,
    required this.endTime,
    required this.durationMinutes,
    required this.sessionType,
    this.isCompleted = false,
  });

  FocusSessionEntity copyWith({
    String? id,
    DateTime? startTime,
    DateTime? endTime,
    int? durationMinutes,
    String? sessionType,
    bool? isCompleted,
  }) {
    return FocusSessionEntity(
      id: id ?? this.id,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      sessionType: sessionType ?? this.sessionType,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FocusSessionEntity &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'FocusSessionEntity(id: $id, type: $sessionType, duration: ${durationMinutes}min, completed: $isCompleted)';
}
