import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:focusflow/core/theme/app_theme.dart';
import 'package:focusflow/core/extensions/date_extensions.dart';
import '../providers/tracking_provider.dart';
import 'package:focusflow/features/tasks/presentation/providers/tasks_provider.dart';
import 'package:focusflow/features/focus/presentation/providers/focus_provider.dart';

class InsightsPage extends ConsumerWidget {
  const InsightsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final streak = ref.watch(streakProvider);
    final insights = ref.watch(productivityInsightsProvider);
    final taskProgress = ref.watch(taskProgressProvider);
    final todayMinutes = ref.watch(todayFocusMinutesProvider);
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
              title: Text(
                'Productivity Insights',
                style: textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Streak hero section
                _StreakSection(
                  currentStreak: streak.currentStreak,
                  longestStreak: streak.longestStreak,
                ),
                const SizedBox(height: 20),

                // Today overview metric cards
                _TodayOverview(
                  focusMinutes: todayMinutes,
                  taskProgress: taskProgress,
                ),
                const SizedBox(height: 20),

                // Weekly focus chart
                _WeeklyFocusChart(insights: insights),
                const SizedBox(height: 20),

                // Productivity composite score
                _ProductivityScore(
                  taskProgress: taskProgress,
                  focusMinutes: todayMinutes,
                ),
                const SizedBox(height: 120),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Streak Section ────────────────────────────────────────────────────────────
class _StreakSection extends StatelessWidget {
  final int currentStreak;
  final int longestStreak;

  const _StreakSection({
    required this.currentStreak,
    required this.longestStreak,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: AppTheme.energyGradient,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppTheme.warningColor.withOpacity(0.35),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text('🔥', style: TextStyle(fontSize: 32)),
                  const SizedBox(width: 8),
                  Text(
                    '$currentStreak',
                    style: textTheme.displaySmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              Text(
                'Day Habit Streak',
                style: textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                currentStreak == 0
                    ? 'Complete a task or timer to start!'
                    : 'Unstoppable momentum! Keep going 💪',
                style: textTheme.bodySmall?.copyWith(
                  color: Colors.white.withOpacity(0.85),
                ),
              ),
            ],
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Text(
                  '$longestStreak',
                  style: textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  'Record',
                  style: textTheme.labelSmall?.copyWith(
                    color: Colors.white70,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.1);
  }
}

// ── Today Overview ────────────────────────────────────────────────────────────
class _TodayOverview extends StatelessWidget {
  final int focusMinutes;
  final double taskProgress;

  const _TodayOverview({
    required this.focusMinutes,
    required this.taskProgress,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Today's Velocity",
          style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _MetricCard(
                icon: Icons.timer_rounded,
                value: '${focusMinutes}m',
                label: 'Focus Time',
                color: AppTheme.accentColor,
                gradient: AppTheme.focusGradient,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _MetricCard(
                icon: Icons.check_circle_rounded,
                value: '${(taskProgress * 100).toInt()}%',
                label: 'Goals Completed',
                color: AppTheme.successColor,
                gradient: AppTheme.successGradient,
              ),
            ),
          ],
        ),
      ],
    ).animate().fadeIn(duration: 400.ms, delay: 100.ms).slideY(begin: 0.1);
  }
}

class _MetricCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;
  final LinearGradient gradient;

  const _MetricCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.28),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white.withOpacity(0.95), size: 26),
          const SizedBox(height: 12),
          Text(
            value,
            style: textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
          Text(
            label,
            style: textTheme.labelSmall?.copyWith(
              color: Colors.white.withOpacity(0.85),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Weekly Focus Chart ────────────────────────────────────────────────────────
class _WeeklyFocusChart extends StatelessWidget {
  final ProductivityInsights insights;
  const _WeeklyFocusChart({required this.insights});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    final now = DateTime.now();

    final bars = List.generate(7, (i) {
      final targetDate = now.subtract(Duration(days: 6 - i));
      final dateKey =
          '${targetDate.year}-${targetDate.month.toString().padLeft(2, '0')}-${targetDate.day.toString().padLeft(2, '0')}';
      final matching = insights.last7DaysFocus.where((e) => e.key == dateKey);
      final minutes = matching.isNotEmpty ? matching.first.value : 0;

      return BarChartGroupData(
        x: i,
        barRods: [
          BarChartRodData(
            toY: (minutes > 0 ? minutes : 2).toDouble(),
            gradient: minutes > 0 ? AppTheme.primaryGradient : null,
            color: minutes == 0
                ? colorScheme.outline.withOpacity(0.12)
                : null,
            width: 18,
            borderRadius: BorderRadius.circular(6),
          ),
        ],
      );
    });

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: colorScheme.outline.withOpacity(0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Weekly Focus Trend',
                style:
                    textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
              ),
              const Spacer(),
              Text(
                'Avg: ${insights.averageDailyFocusMinutes.toInt()}m/day',
                style: textTheme.labelSmall?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 150,
            child: BarChart(
              BarChartData(
                maxY: 120,
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 30,
                  getDrawingHorizontalLine: (_) => FlLine(
                    color: colorScheme.outline.withOpacity(0.06),
                    strokeWidth: 1,
                  ),
                ),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, _) {
                        final i = value.toInt();
                        if (i < 0 || i >= 7) return const SizedBox.shrink();
                        final date = now.subtract(Duration(days: 6 - i));
                        final isToday = date.isToday;
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            days[date.weekday - 1],
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight:
                                  isToday ? FontWeight.w800 : FontWeight.w500,
                              color: isToday
                                  ? colorScheme.primary
                                  : colorScheme.onSurface.withOpacity(0.4),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                barGroups: bars,
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms, delay: 200.ms).slideY(begin: 0.1);
  }
}

// ── Productivity Score ────────────────────────────────────────────────────────
class _ProductivityScore extends StatelessWidget {
  final double taskProgress;
  final int focusMinutes;

  const _ProductivityScore({
    required this.taskProgress,
    required this.focusMinutes,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final focusScore = (focusMinutes / 60).clamp(0.0, 1.0);
    final totalScore = ((taskProgress + focusScore) / 2).clamp(0.0, 1.0);
    final scoreLabel = totalScore >= 0.8
        ? '🔥 Peak Performance'
        : totalScore >= 0.5
            ? '💪 Solid Momentum'
            : totalScore > 0
                ? '🌱 Steady Progress'
                : '🚀 Ready to start!';

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: colorScheme.outline.withOpacity(0.08)),
      ),
      child: Row(
        children: [
          CircularPercentIndicator(
            radius: 42,
            lineWidth: 8,
            percent: totalScore,
            center: Text(
              '${(totalScore * 100).toInt()}',
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
                color: colorScheme.primary,
              ),
            ),
            progressColor: colorScheme.primary,
            backgroundColor: colorScheme.primary.withOpacity(0.12),
            circularStrokeCap: CircularStrokeCap.round,
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Productivity Index',
                  style: textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  scoreLabel,
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Calculated from focus sessions and completed goals',
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurface.withOpacity(0.5),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms, delay: 300.ms).slideY(begin: 0.1);
  }
}
