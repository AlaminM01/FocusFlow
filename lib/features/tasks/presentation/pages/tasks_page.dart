import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:focusflow/core/widgets/empty_state_widget.dart';
import 'package:focusflow/core/extensions/date_extensions.dart';
import '../providers/tasks_provider.dart';
import '../widgets/task_tile.dart';
import '../../domain/entities/task_entity.dart';
import 'task_editor_page.dart';

class TasksPage extends ConsumerStatefulWidget {
  const TasksPage({super.key});

  @override
  ConsumerState<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends ConsumerState<TasksPage> {
  int _filterIndex = 0; // 0=All, 1=Active, 2=Done

  @override
  Widget build(BuildContext context) {
    final tasksAsync = ref.watch(tasksProvider);
    final progress = ref.watch(taskProgressProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final now = DateTime.now();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openTaskEditor(context, null),
        backgroundColor: colorScheme.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_task_rounded),
        label: const Text('Add Task'),
        elevation: 4,
      )
          .animate()
          .fadeIn(delay: 300.ms)
          .scale(begin: const Offset(0.8, 0.8), curve: Curves.easeOutBack),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 120,
            pinned: true,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 24, bottom: 16),
              title: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tasks & Goals',
                    style: textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    now.friendlyDate,
                    style: textTheme.labelSmall?.copyWith(
                      color: colorScheme.onSurface.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Progress banner
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: _ProgressCard(progress: progress),
            ),
          ),

          // Filter chips
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              child: Row(
                children: ['All Tasks', 'Active', 'Completed']
                    .asMap()
                    .entries
                    .map((e) {
                  final isSelected = _filterIndex == e.key;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () => setState(() => _filterIndex = e.key),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? colorScheme.primary
                              : colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? Colors.transparent
                                : colorScheme.outline.withOpacity(0.08),
                          ),
                        ),
                        child: Text(
                          e.value,
                          style: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : colorScheme.onSurface.withOpacity(0.7),
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.w500,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          // Tasks list
          tasksAsync.when(
            loading: () => const SliverToBoxAdapter(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(60),
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
            error: (e, _) =>
                SliverToBoxAdapter(child: Center(child: Text('Error: $e'))),
            data: (tasks) {
              final filtered = _filterTasks(tasks);
              if (filtered.isEmpty) {
                return SliverToBoxAdapter(
                  child: EmptyStateWidget(
                    icon: Icons.check_circle_outline_rounded,
                    title: _filterIndex == 2
                        ? 'No completed tasks yet'
                        : 'No active tasks found',
                    subtitle: _filterIndex == 0
                        ? 'Create your first goal to kickstart your day'
                        : 'Keep checking off your priorities',
                    actionLabel: _filterIndex == 0 ? 'Create Task' : null,
                    onAction: _filterIndex == 0
                        ? () => _openTaskEditor(context, null)
                        : null,
                  ),
                );
              }
              return SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 120),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (ctx, i) => TaskTile(
                      task: filtered[i],
                      index: i,
                      onToggle: () => ref
                          .read(tasksProvider.notifier)
                          .toggleTask(filtered[i].id),
                      onTap: () => _openTaskEditor(context, filtered[i]),
                      onDelete: () => ref
                          .read(tasksProvider.notifier)
                          .deleteTask(filtered[i].id),
                    ),
                    childCount: filtered.length,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  List<TaskEntity> _filterTasks(List<TaskEntity> tasks) {
    switch (_filterIndex) {
      case 1:
        return tasks.where((t) => !t.isCompleted).toList()
          ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
      case 2:
        return tasks.where((t) => t.isCompleted).toList()
          ..sort((a, b) => (b.completedAt ?? b.createdAt)
              .compareTo(a.completedAt ?? a.createdAt));
      default:
        return tasks
          ..sort((a, b) {
            if (!a.isCompleted && b.isCompleted) return -1;
            if (a.isCompleted && !b.isCompleted) return 1;
            return b.createdAt.compareTo(a.createdAt);
          });
    }
  }

  void _openTaskEditor(BuildContext context, TaskEntity? task) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => TaskEditorPage(existingTask: task),
    );
  }
}

class _ProgressCard extends StatelessWidget {
  final double progress;
  const _ProgressCard({required this.progress});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final pct = (progress * 100).toInt();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: colorScheme.outline.withOpacity(0.08)),
      ),
      child: Row(
        children: [
          CircularPercentIndicator(
            radius: 34,
            lineWidth: 6,
            percent: progress.clamp(0.0, 1.0),
            center: Text(
              '$pct%',
              style: textTheme.labelLarge?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w800,
              ),
            ),
            progressColor: colorScheme.primary,
            backgroundColor: colorScheme.primary.withOpacity(0.12),
            circularStrokeCap: CircularStrokeCap.round,
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Daily Velocity',
                  style: textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  pct == 0
                      ? 'No tasks completed yet today'
                      : pct == 100
                          ? '🎉 All goals conquered today!'
                          : '$pct% of planned goals finished',
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurface.withOpacity(0.55),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1);
  }
}
