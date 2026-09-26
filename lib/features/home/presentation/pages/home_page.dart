import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focusflow/core/theme/app_theme.dart';
import 'package:focusflow/core/widgets/gradient_button.dart';
import 'package:focusflow/features/home/presentation/widgets/quick_stats_row.dart';
import 'package:focusflow/features/home/presentation/widgets/quote_card.dart';
import 'package:focusflow/features/notes/domain/entities/note_entity.dart';
import 'package:focusflow/features/notes/presentation/pages/note_editor_page.dart';
import 'package:focusflow/features/notes/presentation/providers/notes_provider.dart';
import 'package:focusflow/features/tasks/domain/entities/task_entity.dart';
import 'package:focusflow/features/tasks/presentation/providers/tasks_provider.dart';
import 'package:intl/intl.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  String _greeting() {
    final h = DateTime.now().hour;
    if (h < 12) return 'Good Morning';
    if (h < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allTasks = ref.watch(tasksProvider).valueOrNull ?? [];
    final tasks = allTasks.take(3).toList();
    final allNotes = ref.watch(notesProvider).valueOrNull ?? [];
    final notes = allNotes.take(5).toList();
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        // ── Header ──────────────────────────────────────────────────────────
        SliverToBoxAdapter(
          child: _buildHeader(context, tt, cs, isDark),
        ),

        // ── Quote ────────────────────────────────────────────────────────────
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: QuoteCard(),
          ),
        ),

        // ── Quick Stats ──────────────────────────────────────────────────────
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Overview',
                  style: tt.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 12),
                const QuickStatsRow(),
              ],
            ),
          ),
        ),

        // ── Today's Tasks ────────────────────────────────────────────────────
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
            child: _TodayTasksSection(tasks: tasks),
          ),
        ),

        // ── Recent Notes ─────────────────────────────────────────────────────
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 24, 0, 0),
            child: _RecentNotesSection(notes: notes),
          ),
        ),

        // ── Start Focus CTA ──────────────────────────────────────────────────
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 120),
            child: _FocusCTA(),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(
    BuildContext context,
    TextTheme tt,
    ColorScheme cs,
    bool isDark,
  ) {
    final now = DateTime.now();
    final topPad = MediaQuery.paddingOf(context).top;

    return Container(
      padding: EdgeInsets.fromLTRB(20, topPad + 16, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _greeting(),
                      style: tt.bodyMedium?.copyWith(
                        color: cs.onSurface.withOpacity(0.55),
                        fontWeight: FontWeight.w500,
                      ),
                    )
                        .animate()
                        .fadeIn(duration: 400.ms)
                        .slideX(begin: -0.1, end: 0),
                    const SizedBox(height: 4),
                    ShaderMask(
                      shaderCallback: (bounds) =>
                          AppTheme.primaryGradient.createShader(bounds),
                      child: Text(
                        'FocusFlow',
                        style: tt.headlineLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                          letterSpacing: -1,
                          color: Colors.white,
                        ),
                      ),
                    )
                        .animate()
                        .fadeIn(duration: 500.ms, delay: 50.ms)
                        .slideX(begin: -0.1, end: 0),
                  ],
                ),
              ),
              // Date badge
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  gradient: AppTheme.primaryGradient,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  children: [
                    Text(
                      DateFormat('d').format(now),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      DateFormat('MMM').format(now).toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              )
                  .animate()
                  .fadeIn(duration: 500.ms, delay: 100.ms)
                  .scale(
                      begin: const Offset(0.8, 0.8),
                      curve: Curves.easeOutBack),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            DateFormat('EEEE, MMMM d').format(now),
            style: tt.bodySmall?.copyWith(
              color: cs.onSurface.withOpacity(0.45),
            ),
          ).animate().fadeIn(duration: 400.ms, delay: 150.ms),
        ],
      ),
    );
  }
}

// ── Today's Tasks Section ─────────────────────────────────────────────────────
class _TodayTasksSection extends StatelessWidget {
  const _TodayTasksSection({required this.tasks});
  final List<TaskEntity> tasks;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              "Today's Tasks",
              style: tt.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (tasks.isEmpty)
          _EmptyTasks()
        else
          ...tasks.asMap().entries.map(
                (e) => _HomeMiniTaskTile(
                  task: e.value,
                  delay: e.key * 60,
                ),
              ),
      ],
    );
  }
}

class _EmptyTasks extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.outline.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Icon(Icons.check_circle_outline_rounded,
              color: cs.onSurface.withOpacity(0.3), size: 32),
          const SizedBox(width: 14),
          Text(
            'No tasks today – enjoy the calm!',
            style:
                tt.bodyMedium?.copyWith(color: cs.onSurface.withOpacity(0.5)),
          ),
        ],
      ),
    );
  }
}

class _HomeMiniTaskTile extends ConsumerWidget {
  const _HomeMiniTaskTile({required this.task, this.delay = 0});
  final TaskEntity task;
  final int delay;

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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: () => ref.read(tasksProvider.notifier).toggleTask(task.id),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: cs.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(14),
          border: Border(
            left: BorderSide(
              color: _priorityColor(task.priority),
              width: 3,
            ),
          ),
        ),
        child: Row(
          children: [
            Icon(
              task.isCompleted
                  ? Icons.check_circle_rounded
                  : Icons.radio_button_unchecked_rounded,
              size: 20,
              color: task.isCompleted
                  ? AppTheme.successColor
                  : cs.onSurface.withOpacity(0.35),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                task.title,
                style: tt.bodyMedium?.copyWith(
                  decoration:
                      task.isCompleted ? TextDecoration.lineThrough : null,
                  color: task.isCompleted
                      ? cs.onSurface.withOpacity(0.4)
                      : null,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      )
          .animate()
          .fadeIn(duration: 400.ms, delay: Duration(milliseconds: 400 + delay))
          .slideX(begin: 0.1, end: 0, curve: Curves.easeOut),
    );
  }
}

// ── Recent Notes ──────────────────────────────────────────────────────────────
class _RecentNotesSection extends StatelessWidget {
  const _RecentNotesSection({required this.notes});
  final List<NoteEntity> notes;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final appColors =
        Theme.of(context).extension<AppColors>() ?? AppColors.dark;
    final noteColors = [
      appColors.noteCard1,
      appColors.noteCard2,
      appColors.noteCard3,
      appColors.noteCard4,
      appColors.noteCard5,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Recent Notes',
            style: tt.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
        ),
        const SizedBox(height: 12),
        if (notes.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'No notes yet. Tap Notes to create one!',
              style: tt.bodySmall,
            ),
          )
        else
          SizedBox(
            height: 120,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              physics: const BouncingScrollPhysics(),
              itemCount: notes.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, i) {
                final note = notes[i];
                final bg = noteColors[note.colorIndex % noteColors.length];
                return GestureDetector(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => NoteEditorPage(existingNote: note),
                    ),
                  ),
                  child: _MiniNoteCard(note: note, color: bg),
                )
                    .animate()
                    .fadeIn(
                      duration: 400.ms,
                      delay: Duration(milliseconds: 500 + i * 70),
                    )
                    .slideX(begin: 0.15, end: 0, curve: Curves.easeOut);
              },
            ),
          ),
      ],
    );
  }
}

class _MiniNoteCard extends StatelessWidget {
  const _MiniNoteCard({required this.note, required this.color});
  final NoteEntity note;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Container(
      width: 140,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (note.isPinned)
            const Icon(Icons.push_pin_rounded, size: 14, color: Colors.grey),
          if (note.title.isNotEmpty)
            Text(
              note.title,
              style: tt.labelLarge?.copyWith(fontWeight: FontWeight.w600),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          const SizedBox(height: 4),
          Expanded(
            child: Text(
              note.content,
              style: tt.bodySmall,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Focus CTA ─────────────────────────────────────────────────────────────────
class _FocusCTA extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GradientButton(
      label: 'Focus Session Ready',
      icon: Icons.timer_rounded,
      gradient: AppTheme.focusGradient,
      height: 58,
      onPressed: () {},
    )
        .animate()
        .fadeIn(duration: 500.ms, delay: 700.ms)
        .slideY(begin: 0.2, end: 0, curve: Curves.easeOut);
  }
}
