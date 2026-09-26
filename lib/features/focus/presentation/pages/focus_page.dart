import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:focusflow/core/theme/app_theme.dart';
import '../providers/focus_provider.dart';

class FocusPage extends ConsumerWidget {
  const FocusPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timerState = ref.watch(activeFocusTimerProvider);
    final todayMinutes = ref.watch(todayFocusMinutesProvider);
    final pomodoroCount = ref.watch(todayPomodoroCountProvider);
    final textTheme = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 110,
            pinned: true,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 24, bottom: 16),
              title: Text(
                'Focus Sanctuary',
                style: textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(height: 10),
                // Mode selector
                _ModeSelector(
                  currentMode: timerState.sessionType,
                  onChanged: (mode) {
                    if (!timerState.isRunning) {
                      ref.read(activeFocusTimerProvider.notifier).setMode(mode);
                    }
                  },
                ),
                const SizedBox(height: 40),

                // Circular timer
                Center(
                  child: CircularTimerWidget(
                    remaining: timerState.remainingSeconds,
                    total: timerState.totalSeconds,
                    sessionType: timerState.sessionType,
                    isRunning: timerState.isRunning,
                  ),
                ),
                const SizedBox(height: 40),

                // Controls
                _TimerControls(
                  state: timerState,
                  onStart: () =>
                      ref.read(activeFocusTimerProvider.notifier).start(),
                  onPause: () =>
                      ref.read(activeFocusTimerProvider.notifier).pause(),
                  onResume: () =>
                      ref.read(activeFocusTimerProvider.notifier).resume(),
                  onStop: () =>
                      ref.read(activeFocusTimerProvider.notifier).stop(),
                ),
                const SizedBox(height: 40),

                // Stats row
                _TodayStats(
                  focusMinutes: todayMinutes,
                  pomodoroCount: pomodoroCount,
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

// ── Mode Selector ─────────────────────────────────────────────────────────────
class _ModeSelector extends StatelessWidget {
  final String currentMode;
  final ValueChanged<String> onChanged;

  const _ModeSelector({required this.currentMode, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final modes = [
      ('pomodoro', '🍅', 'Pomodoro', '25 min'),
      ('deepwork', '🧠', 'Deep Work', '90 min'),
      ('shortbreak', '☕', 'Break', '5 min'),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'FOCUS MODE',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                letterSpacing: 1.5,
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w700,
              ),
        ),
        const SizedBox(height: 12),
        Row(
          children: modes.map((m) {
            final isSelected = currentMode == m.$1;
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: GestureDetector(
                  onTap: () => onChanged(m.$1),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      gradient: isSelected ? AppTheme.primaryGradient : null,
                      color: isSelected
                          ? null
                          : Theme.of(context).colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: isSelected
                            ? Colors.transparent
                            : Theme.of(context)
                                .colorScheme
                                .outline
                                .withOpacity(0.1),
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: AppTheme.primaryColor.withOpacity(0.3),
                                blurRadius: 16,
                                offset: const Offset(0, 6),
                              ),
                            ]
                          : null,
                    ),
                    child: Column(
                      children: [
                        Text(m.$2, style: const TextStyle(fontSize: 22)),
                        const SizedBox(height: 6),
                        Text(
                          m.$3,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: isSelected
                                ? FontWeight.w700
                                : FontWeight.w500,
                            color: isSelected
                                ? Colors.white
                                : Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        Text(
                          m.$4,
                          style: TextStyle(
                            fontSize: 10,
                            color: isSelected
                                ? Colors.white70
                                : Theme.of(context)
                                    .colorScheme
                                    .onSurface
                                    .withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.05);
  }
}

// ── Circular Timer Widget ─────────────────────────────────────────────────────
class CircularTimerWidget extends StatelessWidget {
  final int remaining;
  final int total;
  final String sessionType;
  final bool isRunning;

  const CircularTimerWidget({
    super.key,
    required this.remaining,
    required this.total,
    required this.sessionType,
    required this.isRunning,
  });

  String get _timeDisplay {
    final m = remaining ~/ 60;
    final s = remaining % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final progress = total > 0 ? 1.0 - (remaining / total) : 0.0;
    final textTheme = Theme.of(context).textTheme;

    return Stack(
      alignment: Alignment.center,
      children: [
        // Pulsing glow when running
        if (isRunning)
          Container(
            width: 250,
            height: 250,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppTheme.accentColor.withOpacity(0.2),
                  blurRadius: 60,
                  spreadRadius: 15,
                ),
              ],
            ),
          ),

        // Custom painter ring
        SizedBox(
          width: 260,
          height: 260,
          child: CustomPaint(
            painter: _TimerRingPainter(
              progress: progress,
              isDark: Theme.of(context).brightness == Brightness.dark,
            ),
          ),
        ),

        // Timer text
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _timeDisplay,
              style: textTheme.displayMedium?.copyWith(
                fontWeight: FontWeight.w800,
                letterSpacing: 2,
                fontSize: 52,
              ),
            ),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                sessionType == 'pomodoro'
                    ? '🍅 Focus Mode'
                    : sessionType == 'deepwork'
                        ? '🧠 Deep Flow'
                        : '☕ Recharge',
                style: textTheme.labelSmall?.copyWith(
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _TimerRingPainter extends CustomPainter {
  final double progress;
  final bool isDark;

  _TimerRingPainter({required this.progress, required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - 16) / 2;

    // Track
    final trackPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..color = isDark
          ? Colors.white.withOpacity(0.06)
          : AppTheme.primaryColor.withOpacity(0.08);

    canvas.drawCircle(center, radius, trackPaint);

    // Progress arc
    if (progress > 0) {
      final progressPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 10
        ..strokeCap = StrokeCap.round
        ..shader = const LinearGradient(
          colors: [AppTheme.accentColor, AppTheme.primaryColor, AppTheme.secondaryColor],
        ).createShader(Rect.fromCircle(center: center, radius: radius));

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -math.pi / 2,
        2 * math.pi * progress,
        false,
        progressPaint,
      );

      // Dot at progress end
      final angle = -math.pi / 2 + 2 * math.pi * progress;
      final dotX = center.dx + radius * math.cos(angle);
      final dotY = center.dy + radius * math.sin(angle);
      final dotPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset(dotX, dotY), 6, dotPaint);
    }
  }

  @override
  bool shouldRepaint(_TimerRingPainter old) =>
      old.progress != progress || old.isDark != isDark;
}

// ── Timer Controls ────────────────────────────────────────────────────────────
class _TimerControls extends StatelessWidget {
  final FocusTimerState state;
  final VoidCallback onStart;
  final VoidCallback onPause;
  final VoidCallback onResume;
  final VoidCallback onStop;

  const _TimerControls({
    required this.state,
    required this.onStart,
    required this.onPause,
    required this.onResume,
    required this.onStop,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (state.isRunning || state.isPaused) ...[
          _ControlButton(
            icon: Icons.stop_rounded,
            onTap: onStop,
            color: cs.surfaceContainerHighest,
            iconColor: cs.onSurface.withOpacity(0.7),
            size: 56,
          ),
          const SizedBox(width: 24),
        ],
        _ControlButton(
          icon: state.isRunning
              ? Icons.pause_rounded
              : state.isPaused
                  ? Icons.play_arrow_rounded
                  : Icons.play_arrow_rounded,
          onTap: state.isRunning
              ? onPause
              : state.isPaused
                  ? onResume
                  : onStart,
          gradient: AppTheme.primaryGradient,
          iconColor: Colors.white,
          size: 78,
        ),
      ],
    ).animate().fadeIn(duration: 500.ms, delay: 200.ms);
  }
}

class _ControlButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Gradient? gradient;
  final Color? color;
  final Color iconColor;
  final double size;

  const _ControlButton({
    required this.icon,
    required this.onTap,
    this.gradient,
    this.color,
    required this.iconColor,
    this.size = 64,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          gradient: gradient,
          color: color,
          shape: BoxShape.circle,
          boxShadow: gradient != null
              ? [
                  BoxShadow(
                    color: AppTheme.primaryColor.withOpacity(0.4),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ]
              : null,
        ),
        child: Center(
          child: Icon(icon, color: iconColor, size: size * 0.45),
        ),
      ),
    );
  }
}

// ── Today Stats ───────────────────────────────────────────────────────────────
class _TodayStats extends StatelessWidget {
  final int focusMinutes;
  final int pomodoroCount;

  const _TodayStats({
    required this.focusMinutes,
    required this.pomodoroCount,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: cs.outline.withOpacity(0.08)),
      ),
      child: Row(
        children: [
          Expanded(
            child: _StatItem(
              icon: Icons.timer_rounded,
              value: '${focusMinutes}m',
              label: 'Focus Time',
              color: AppTheme.accentColor,
            ),
          ),
          Container(
            width: 1,
            height: 48,
            color: cs.outline.withOpacity(0.12),
          ),
          Expanded(
            child: _StatItem(
              icon: Icons.local_fire_department_rounded,
              value: '$pomodoroCount',
              label: 'Sessions Done',
              color: AppTheme.warningColor,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms, delay: 300.ms).slideY(begin: 0.1);
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _StatItem({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 6),
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.55),
              ),
        ),
      ],
    );
  }
}
