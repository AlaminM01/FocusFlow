import '../entities/task_entity.dart';

/// Abstract contract for task persistence operations.
abstract class TasksRepository {
  /// Returns all tasks.
  Future<List<TaskEntity>> getAllTasks();

  /// Persists a new task.
  Future<void> saveTask(TaskEntity task);

  /// Permanently removes the task with [id].
  Future<void> deleteTask(String id);

  /// Overwrites an existing task with [task.id].
  Future<void> updateTask(TaskEntity task);

  /// Marks a task as complete and records [completedAt].
  Future<void> completeTask(String id);

  /// Marks a completed task as incomplete and clears [completedAt].
  Future<void> uncompleteTask(String id);
}
