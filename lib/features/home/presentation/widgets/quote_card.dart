import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focusflow/core/theme/app_theme.dart';
import 'package:focusflow/core/widgets/glass_card.dart';
import 'package:focusflow/features/motivation/presentation/providers/quote_provider.dart';

/// Glassmorphism card displaying a daily motivational quote.
class QuoteCard extends ConsumerWidget {
  const QuoteCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quote = ref.watch(quoteNotifierProvider);
    final tt = Theme.of(context).textTheme;

    return GlassCard(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          AppTheme.primaryColor.withOpacity(0.25),
          AppTheme.secondaryColor.withOpacity(0.15),
        ],
      ),
      border: Border.all(
        color: AppTheme.primaryColor.withOpacity(0.3),
        width: 1.2,
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ShaderMask(
                shaderCallback: (bounds) =>
                    AppTheme.primaryGradient.createShader(bounds),
                child: const Icon(
                  Icons.format_quote_rounded,
                  size: 28,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 8),
              ShaderMask(
                shaderCallback: (bounds) =>
                    AppTheme.primaryGradient.createShader(bounds),
                child: Text(
                  'Daily Inspiration',
                  style: tt.labelLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () =>
                    ref.read(quoteNotifierProvider.notifier).nextQuote(),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    gradient: AppTheme.primaryGradient,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.refresh_rounded,
                    size: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            child: Text(
              '"${quote.quote}"',
              key: ValueKey(quote.quote),
              style: tt.bodyLarge?.copyWith(
                fontStyle: FontStyle.italic,
                height: 1.55,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          const SizedBox(height: 10),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            child: Text(
              '— ${quote.author}',
              key: ValueKey(quote.author),
              style: tt.labelMedium?.copyWith(
                color: AppTheme.primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 500.ms, delay: 150.ms)
        .slideY(begin: 0.15, end: 0, curve: Curves.easeOut);
  }
}
