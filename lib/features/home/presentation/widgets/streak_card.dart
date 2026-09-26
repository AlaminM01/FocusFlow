import 'package:flutter/material.dart';
import 'package:focusflow/core/theme/app_theme.dart';

/// A single stat card showing an emoji/icon, a value, and a label.
class StreakCard extends StatelessWidget {
  const StreakCard({
    super.key,
    required this.emoji,
    required this.value,
    required this.label,
    this.gradient,
  });

  final String emoji;
  final String value;
  final String label;
  final Gradient? gradient;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        gradient: gradient,
        color: gradient == null ? cs.surfaceContainerHighest : null,
        borderRadius: BorderRadius.circular(18),
        border: gradient == null
            ? Border.all(color: cs.outline.withOpacity(0.12))
            : null,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 26)),
          const SizedBox(height: 6),
          Text(
            value,
            style: tt.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: gradient != null ? Colors.white : null,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: tt.labelSmall?.copyWith(
              color: gradient != null
                  ? Colors.white70
                  : cs.onSurface.withOpacity(0.55),
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
