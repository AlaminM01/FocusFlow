import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focusflow/core/extensions/date_extensions.dart';
import 'package:focusflow/core/theme/app_theme.dart';
import 'package:focusflow/features/tasks/domain/entities/task_entity.dart';
import 'package:focusflow/features/tasks/presentation/providers/tasks_provider.dart';

/// A premium animated task list tile.
class TaskTile extends ConsumerWidget {
  const TaskTile({
    super.key,
    required this.task,
    this.index = 0,
    this.onTap,
    this.onToggle,
    this.onDelete,
  });

  final TaskEntity task;
  final int index;
  final VoidCallback? onTap;
  final VoidCallback? onToggle;
  final VoidCallback? onDelete;

  Color _priorityColor(TaskPriority p) {
    switch (p) {
      case TaskPriority.urgent:
        return AppTheme.errorColor;
      case TaskPriority.high:
        return AppTheme.warningColor;
      case TaskPriority.medium:
        return AppTheme.primaryColor;
      case TaskPriority.low:
        return AppTheme.successColor;
    }
  }

  String _priorityLabel(TaskPriority p) {
    switch (p) {
      case TaskPriority.urgent:
        return 'Urgent';
      case TaskPriority.high:
        return 'High';
      case TaskPriority.medium:
        return 'Medium';
      case TaskPriority.low:
        return 'Low';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final priorityColor = _priorityColor(task.priority);
    final isDone = task.isCompleted;

    return Dismissible(
      key: Key(task.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: AppTheme.errorColor.withOpacity(0.15),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(
          Icons.delete_outline_rounded,
          color: AppTheme.errorColor,
          size: 26,
        ),
      ),
      onDismissed: (_) {
        if (onDelete != null) {
          onDelete!();
        } else {
          ref.read(tasksProvider.notifier).deleteTask(task.id);
        }
      },
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 300),
          opacity: isDone ? 0.55 : 1.0,
          child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: cs.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(16),
              border: Border(
                left: BorderSide(
                  color: priorityColor,
                  width: 3.5,
                ),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Animated checkbox
                  GestureDetector(
                    onTap: onToggle ??
                        () => ref
                            .read(tasksProvider.notifier)
                            .toggleTask(task.id),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: isDone ? AppTheme.successGradient : null,
                        border: isDone
                            ? null
                            : Border.all(
                                color: cs.onSurface.withOpacity(0.3),
                                width: 2,
                              ),
                      ),
                      child: isDone
                          ? const Icon(Icons.check_rounded,
                              size: 14, color: Colors.white)
                          : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          task.title,
                          style: tt.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                            decoration: isDone
                                ? TextDecoration.lineThrough
                                : null,
                            decorationColor:
                                cs.onSurface.withOpacity(0.4),
                            color: isDone
                                ? cs.onSurface.withOpacity(0.4)
                                : null,
                          ),
                        ),
                        if (task.description != null &&
                            task.description!.isNotEmpty) ...[
                          const SizedBox(height: 3),
                          Text(
                            task.description!,
                            style: tt.bodySmall?.copyWith(
                              color: cs.onSurface.withOpacity(0.5),
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                        if (task.dueDate != null) ...[
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Icon(
                                Icons.schedule_rounded,
                                size: 13,
                                color: task.isOverdue && !isDone
                                    ? AppTheme.errorColor
                                    : cs.onSurface.withOpacity(0.4),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                task.dueDate!.friendlyDate,
                                style: tt.labelSmall?.copyWith(
                                  color: task.isOverdue && !isDone
                                      ? AppTheme.errorColor
                                      : cs.onSurface.withOpacity(0.5),
                                  fontWeight: task.isOverdue && !isDone
                                      ? FontWeight.w600
                                      : FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Priority badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: priorityColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _priorityLabel(task.priority),
                      style: tt.labelSmall?.copyWith(
                        color: priorityColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(
          duration: 350.ms,
          delay: Duration(milliseconds: index * 40),
        )
        .slideX(begin: 0.08, end: 0, curve: Curves.easeOut);
  }
}
