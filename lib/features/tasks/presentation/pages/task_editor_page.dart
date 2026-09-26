import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:focusflow/core/theme/app_theme.dart';
import 'package:uuid/uuid.dart';
import '../providers/tasks_provider.dart';
import '../../domain/entities/task_entity.dart';

class TaskEditorPage extends ConsumerStatefulWidget {
  final TaskEntity? existingTask;

  const TaskEditorPage({super.key, this.existingTask});

  @override
  ConsumerState<TaskEditorPage> createState() => _TaskEditorPageState();
}

class _TaskEditorPageState extends ConsumerState<TaskEditorPage> {
  late final TextEditingController _titleController;
  late final TextEditingController _descController;
  late TaskPriority _priority;
  late DateTime? _dueDate;

  @override
  void initState() {
    super.initState();
    _titleController =
        TextEditingController(text: widget.existingTask?.title ?? '');
    _descController =
        TextEditingController(text: widget.existingTask?.description ?? '');
    _priority = widget.existingTask?.priority ?? TaskPriority.medium;
    _dueDate = widget.existingTask?.dueDate;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final title = _titleController.text.trim();
    if (title.isEmpty) return;

    final notifier = ref.read(tasksProvider.notifier);
    final now = DateTime.now();

    if (widget.existingTask != null) {
      await notifier.updateTask(widget.existingTask!.copyWith(
        title: title,
        description: _descController.text.trim().isEmpty
            ? null
            : _descController.text.trim(),
        priority: _priority,
        dueDate: _dueDate,
      ));
    } else {
      await notifier.addTask(TaskEntity(
        id: const Uuid().v4(),
        title: title,
        description: _descController.text.trim().isEmpty
            ? null
            : _descController.text.trim(),
        createdAt: now,
        priority: _priority,
        dueDate: _dueDate,
      ));
    }

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    final bottomPad = MediaQuery.paddingOf(context).bottom;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.fromLTRB(24, 16, 24, bottomInset + bottomPad + 20),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: colorScheme.onSurface.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Sheet title
            Text(
              widget.existingTask != null ? 'Edit Task' : 'Create Task',
              style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 18),

            // Task title input
            TextField(
              controller: _titleController,
              autofocus: true,
              style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
              decoration: const InputDecoration(
                hintText: 'What needs focus today?',
                labelText: 'Task Title',
              ),
            ),
            const SizedBox(height: 14),

            // Description input
            TextField(
              controller: _descController,
              style: textTheme.bodyMedium,
              maxLines: 2,
              decoration: const InputDecoration(
                hintText: 'Add extra details or sub-steps (optional)',
                labelText: 'Details',
              ),
            ),
            const SizedBox(height: 20),

            // Priority selector
            Text(
              'PRIORITY',
              style: textTheme.labelSmall?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w700,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 10),
            _PrioritySelector(
              selected: _priority,
              onChanged: (p) => setState(() => _priority = p),
            ),
            const SizedBox(height: 20),

            // Due date
            Text(
              'TARGET DATE',
              style: textTheme.labelSmall?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w700,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 10),
            _DueDatePicker(
              selected: _dueDate,
              onChanged: (d) => setState(() => _dueDate = d),
            ),
            const SizedBox(height: 28),

            // Save button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _save,
                child: Text(
                  widget.existingTask != null ? 'Update Task' : 'Add Task',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    ).animate().slideY(
          begin: 0.2,
          curve: Curves.easeOutCubic,
          duration: 300.ms,
        );
  }
}

class _PrioritySelector extends StatelessWidget {
  final TaskPriority selected;
  final ValueChanged<TaskPriority> onChanged;

  const _PrioritySelector({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final priorities = [
      (TaskPriority.low, 'Low', AppTheme.successColor),
      (TaskPriority.medium, 'Medium', AppTheme.primaryColor),
      (TaskPriority.high, 'High', AppTheme.warningColor),
      (TaskPriority.urgent, 'Urgent', AppTheme.errorColor),
    ];

    return Row(
      children: priorities.map((p) {
        final isSelected = selected == p.$1;
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 6),
            child: GestureDetector(
              onTap: () => onChanged(p.$1),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? p.$3 : p.$3.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? Colors.transparent : p.$3.withOpacity(0.3),
                  ),
                ),
                child: Center(
                  child: Text(
                    p.$2,
                    style: TextStyle(
                      color: isSelected ? Colors.white : p.$3,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _DueDatePicker extends StatelessWidget {
  final DateTime? selected;
  final ValueChanged<DateTime?> onChanged;

  const _DueDatePicker({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: selected ?? DateTime.now(),
          firstDate: DateTime.now().subtract(const Duration(days: 7)),
          lastDate: DateTime.now().add(const Duration(days: 365)),
        );
        if (date != null) onChanged(date);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: colorScheme.outline.withOpacity(0.08)),
        ),
        child: Row(
          children: [
            Icon(Icons.calendar_today_rounded,
                size: 18, color: colorScheme.primary),
            const SizedBox(width: 12),
            Text(
              selected == null
                  ? 'Set target due date...'
                  : '${selected!.day}/${selected!.month}/${selected!.year}',
              style: textTheme.bodyMedium?.copyWith(
                color: selected == null
                    ? colorScheme.onSurface.withOpacity(0.5)
                    : colorScheme.onSurface,
              ),
            ),
            const Spacer(),
            if (selected != null)
              GestureDetector(
                onTap: () => onChanged(null),
                child: Icon(Icons.clear_rounded,
                    size: 18,
                    color: colorScheme.onSurface.withOpacity(0.4)),
              ),
          ],
        ),
      ),
    );
  }
}
