import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focusflow/core/theme/app_theme.dart';
import 'package:focusflow/features/focus/presentation/providers/focus_provider.dart';
import 'package:focusflow/features/tasks/presentation/providers/tasks_provider.dart';
import 'package:focusflow/features/tracking/presentation/providers/tracking_provider.dart';

/// A three-column row showing streak days, tasks done today, and focus minutes today.
class QuickStatsRow extends ConsumerWidget {
  const QuickStatsRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final streak = ref.watch(streakProvider);
    final tasks = ref.watch(tasksProvider).valueOrNull ?? [];
    final focusMinutesToday = ref.watch(todayFocusMinutesProvider);

    final completedToday = tasks.where((t) => t.isCompleted).length;

    return Row(
      children: [
        Expanded(
          child: _StatTile(
            icon: Icons.local_fire_department_rounded,
            iconGradient: AppTheme.energyGradient,
            value: '${streak.currentStreak}',
            label: 'Day Streak',
            delay: 0,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatTile(
            icon: Icons.check_circle_rounded,
            iconGradient: AppTheme.successGradient,
            value: '$completedToday',
            label: 'Done Today',
            delay: 80,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatTile(
            icon: Icons.timer_rounded,
            iconGradient: AppTheme.focusGradient,
            value: '${focusMinutesToday}m',
            label: 'Focus Time',
            delay: 160,
          ),
        ),
      ],
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.icon,
    required this.iconGradient,
    required this.value,
    required this.label,
    this.delay = 0,
  });

  final IconData icon;
  final LinearGradient iconGradient;
  final String value;
  final String label;
  final int delay;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: cs.outline.withOpacity(0.08)),
      ),
      child: Column(
        children: [
          ShaderMask(
            shaderCallback: (bounds) => iconGradient.createShader(bounds),
            child: Icon(icon, size: 24, color: Colors.white),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: tt.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: tt.labelSmall?.copyWith(
              color: cs.onSurface.withOpacity(0.55),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 400.ms, delay: Duration(milliseconds: 300 + delay))
        .slideY(begin: 0.2, end: 0, curve: Curves.easeOut);
  }
}
