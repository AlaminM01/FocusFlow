import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import '../../data/models/task_model.dart';
import '../../data/repositories/tasks_repository_impl.dart';
import '../../domain/entities/task_entity.dart';
import '../../domain/repositories/tasks_repository.dart';

// ──────────────────────────────────────────────
// Repository provider
// ──────────────────────────────────────────────

/// Provides the Hive-backed [TasksRepository].
final tasksRepositoryProvider = Provider<TasksRepository>((ref) {
  final box = Hive.box<TaskModel>('tasks');
  return TasksRepositoryImpl(box);
});

// ──────────────────────────────────────────────
// State notifier
// ──────────────────────────────────────────────

class TasksNotifier extends StateNotifier<AsyncValue<List<TaskEntity>>> {
  final TasksRepository _repository;
  final _uuid = const Uuid();

  TasksNotifier(this._repository) : super(const AsyncValue.loading()) {
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    try {
      state = const AsyncValue.loading();
      final tasks = await _repository.getAllTasks();
      state = AsyncValue.data(tasks);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Refresh from local store.
  Future<void> refresh() => _loadTasks();

  /// Creates and saves a new task.
  Future<void> addTask({
    required String title,
    String? description,
    DateTime? dueDate,
    TaskPriority priority = TaskPriority.medium,
  }) async {
    final task = TaskEntity(
      id: _uuid.v4(),
      title: title,
      description: description,
      createdAt: DateTime.now(),
      dueDate: dueDate,
      priority: priority,
    );
    await _repository.saveTask(task);
    await _loadTasks();
  }

  /// Updates an existing task.
  Future<void> updateTask(TaskEntity task) async {
    await _repository.updateTask(task);
    await _loadTasks();
  }

  /// Marks a task as complete.
  Future<void> completeTask(String id) async {
    await _repository.completeTask(id);
    await _loadTasks();
  }

  /// Marks a completed task as incomplete.
  Future<void> uncompleteTask(String id) async {
    await _repository.uncompleteTask(id);
    await _loadTasks();
  }

  /// Toggles completion state.
  Future<void> toggleTask(String id) async {
    final tasks = state.valueOrNull ?? [];
    final task = tasks.firstWhere((t) => t.id == id);
    if (task.isCompleted) {
      await uncompleteTask(id);
    } else {
      await completeTask(id);
    }
  }

  /// Permanently deletes a task.
  Future<void> deleteTask(String id) async {
    await _repository.deleteTask(id);
    await _loadTasks();
  }
}

// ──────────────────────────────────────────────
// Public providers
// ──────────────────────────────────────────────

/// Provides the full tasks list as [AsyncValue<List<TaskEntity>>].
final tasksProvider =
    StateNotifierProvider<TasksNotifier, AsyncValue<List<TaskEntity>>>((ref) {
  final repository = ref.read(tasksRepositoryProvider);
  return TasksNotifier(repository);
});

/// Derived: tasks that are due today (complete or not).
final todayTasksProvider = Provider<List<TaskEntity>>((ref) {
  final all = ref.watch(tasksProvider).valueOrNull ?? [];
  return all.where((t) => t.isDueToday).toList();
});

/// Derived: ratio of completed tasks (0.0 – 1.0). Returns 0 when list empty.
final taskProgressProvider = Provider<double>((ref) {
  final all = ref.watch(tasksProvider).valueOrNull ?? [];
  if (all.isEmpty) return 0.0;
  final done = all.where((t) => t.isCompleted).length;
  return done / all.length;
});

/// Derived: incomplete tasks sorted by priority then dueDate.
final pendingTasksProvider = Provider<List<TaskEntity>>((ref) {
  final all = ref.watch(tasksProvider).valueOrNull ?? [];
  final pending = all.where((t) => !t.isCompleted).toList();
  pending.sort((a, b) {
    final priorityCmp = b.priority.index.compareTo(a.priority.index);
    if (priorityCmp != 0) return priorityCmp;
    if (a.dueDate == null && b.dueDate == null) return 0;
    if (a.dueDate == null) return 1;
    if (b.dueDate == null) return -1;
    return a.dueDate!.compareTo(b.dueDate!);
  });
  return pending;
});

/// Derived: overdue incomplete tasks.
final overdueTasksProvider = Provider<List<TaskEntity>>((ref) {
  final all = ref.watch(tasksProvider).valueOrNull ?? [];
  return all.where((t) => t.isOverdue).toList();
});
