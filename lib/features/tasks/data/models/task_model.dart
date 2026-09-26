import 'package:hive/hive.dart';
import '../../domain/entities/task_entity.dart';

part 'task_model.g.dart';

@HiveType(typeId: 1)
class TaskModel extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String title;

  @HiveField(2)
  String? description;

  @HiveField(3)
  late DateTime createdAt;

  @HiveField(4)
  DateTime? dueDate;

  @HiveField(5)
  late bool isCompleted;

  @HiveField(6)
  late TaskPriority priority;

  @HiveField(7)
  DateTime? completedAt;

  TaskModel({
    required this.id,
    required this.title,
    this.description,
    required this.createdAt,
    this.dueDate,
    this.isCompleted = false,
    this.priority = TaskPriority.medium,
    this.completedAt,
  });

  /// Convert this model to a domain [TaskEntity].
  TaskEntity toEntity() {
    return TaskEntity(
      id: id,
      title: title,
      description: description,
      createdAt: createdAt,
      dueDate: dueDate,
      isCompleted: isCompleted,
      priority: priority,
      completedAt: completedAt,
    );
  }

  /// Build a [TaskModel] from a domain [TaskEntity].
  factory TaskModel.fromEntity(TaskEntity entity) {
    return TaskModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      createdAt: entity.createdAt,
      dueDate: entity.dueDate,
      isCompleted: entity.isCompleted,
      priority: entity.priority,
      completedAt: entity.completedAt,
    );
  }
}
