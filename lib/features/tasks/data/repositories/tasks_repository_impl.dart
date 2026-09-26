import 'package:hive/hive.dart';
import '../../domain/entities/task_entity.dart';
import '../../domain/repositories/tasks_repository.dart';
import '../models/task_model.dart';

/// Hive-backed implementation of [TasksRepository].
class TasksRepositoryImpl implements TasksRepository {
  final Box<TaskModel> _box;

  const TasksRepositoryImpl(this._box);

  @override
  Future<List<TaskEntity>> getAllTasks() async {
    final models = _box.values.toList();
    // Incomplete tasks first, then sort by createdAt descending.
    models.sort((a, b) {
      if (!a.isCompleted && b.isCompleted) return -1;
      if (a.isCompleted && !b.isCompleted) return 1;
      return b.createdAt.compareTo(a.createdAt);
    });
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<void> saveTask(TaskEntity task) async {
    final model = TaskModel.fromEntity(task);
    await _box.put(task.id, model);
  }

  @override
  Future<void> deleteTask(String id) async {
    await _box.delete(id);
  }

  @override
  Future<void> updateTask(TaskEntity task) async {
    final model = TaskModel.fromEntity(task);
    await _box.put(task.id, model);
  }

  @override
  Future<void> completeTask(String id) async {
    final model = _box.get(id);
    if (model == null) return;
    model
      ..isCompleted = true
      ..completedAt = DateTime.now();
    await model.save();
  }

  @override
  Future<void> uncompleteTask(String id) async {
    final model = _box.get(id);
    if (model == null) return;
    model
      ..isCompleted = false
      ..completedAt = null;
    await model.save();
  }
}
