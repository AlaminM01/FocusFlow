/// Priority levels for tasks, ordered from lowest to highest.
enum TaskPriority { low, medium, high, urgent }

/// Pure domain entity for a task – no Hive / Flutter dependencies.
class TaskEntity {
  final String id;
  final String title;
  final String? description;
  final DateTime createdAt;
  final DateTime? dueDate;
  final bool isCompleted;
  final TaskPriority priority;
  final DateTime? completedAt;

  const TaskEntity({
    required this.id,
    required this.title,
    this.description,
    required this.createdAt,
    this.dueDate,
    this.isCompleted = false,
    this.priority = TaskPriority.medium,
    this.completedAt,
  });

  TaskEntity copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? createdAt,
    DateTime? dueDate,
    bool? isCompleted,
    TaskPriority? priority,
    DateTime? completedAt,
    bool clearDueDate = false,
    bool clearCompletedAt = false,
    bool clearDescription = false,
  }) {
    return TaskEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      description:
          clearDescription ? null : (description ?? this.description),
      createdAt: createdAt ?? this.createdAt,
      dueDate: clearDueDate ? null : (dueDate ?? this.dueDate),
      isCompleted: isCompleted ?? this.isCompleted,
      priority: priority ?? this.priority,
      completedAt:
          clearCompletedAt ? null : (completedAt ?? this.completedAt),
    );
  }

  /// Whether the task's due date has passed and it is not yet completed.
  bool get isOverdue {
    if (dueDate == null || isCompleted) return false;
    return DateTime.now().isAfter(dueDate!);
  }

  /// Whether the task is due today.
  bool get isDueToday {
    if (dueDate == null) return false;
    final now = DateTime.now();
    return dueDate!.year == now.year &&
        dueDate!.month == now.month &&
        dueDate!.day == now.day;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskEntity &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'TaskEntity(id: $id, title: $title, priority: $priority, isCompleted: $isCompleted)';
}
