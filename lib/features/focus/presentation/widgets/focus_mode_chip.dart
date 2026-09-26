import 'package:flutter/material.dart';
import 'package:focusflow/core/theme/app_theme.dart';
import 'package:focusflow/features/focus/presentation/providers/focus_provider.dart';

/// Mode selector chip for the focus timer.
class FocusModeChip extends StatelessWidget {
  const FocusModeChip({
    super.key,
    required this.mode,
    required this.isSelected,
    required this.onTap,
  });

  final FocusMode mode;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          gradient: isSelected ? AppTheme.focusGradient : null,
          color: isSelected ? null : Colors.white.withOpacity(0.07),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected
                ? Colors.transparent
                : Colors.white.withOpacity(0.15),
            width: 1.2,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _iconFor(mode),
              size: 18,
              color: isSelected ? Colors.white : Colors.white60,
            ),
            const SizedBox(height: 4),
            Text(
              mode.label,
              style: tt.labelSmall?.copyWith(
                color: isSelected ? Colors.white : Colors.white60,
                fontWeight:
                    isSelected ? FontWeight.w700 : FontWeight.w400,
                letterSpacing: 0.3,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              '${mode.defaultMinutes}m',
              style: TextStyle(
                fontSize: 10,
                color: isSelected
                    ? Colors.white70
                    : Colors.white.withOpacity(0.35),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _iconFor(FocusMode m) {
    switch (m) {
      case FocusMode.pomodoro:
        return Icons.timer_rounded;
      case FocusMode.deepWork:
        return Icons.psychology_rounded;
      case FocusMode.custom:
        return Icons.tune_rounded;
    }
  }
}
