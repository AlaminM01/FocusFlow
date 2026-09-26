import 'dart:ui';
import 'package:flutter/material.dart';

class GlassCard extends StatelessWidget {
  const GlassCard({
    super.key,
    required this.child,
    this.blur = 16.0,
    this.opacity = 0.12,
    this.borderRadius,
    this.padding,
    this.color,
    this.gradient,
    this.border,
    this.margin,
    this.onTap,
    this.height,
    this.width,
  });

  final Widget child;
  final double blur;
  final double opacity;
  final BorderRadius? borderRadius;
  final EdgeInsets? padding;
  final Color? color;
  final Gradient? gradient;
  final Border? border;
  final EdgeInsets? margin;
  final VoidCallback? onTap;
  final double? height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? BorderRadius.circular(20);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        width: width,
        margin: margin,
        child: ClipRRect(
          borderRadius: radius,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
            child: Container(
              padding: padding ?? const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: gradient,
                color: color ??
                    (isDark
                        ? Colors.white.withOpacity(0.06)
                        : Colors.white.withOpacity(opacity)),
                borderRadius: radius,
                border: border ??
                    Border.all(
                      color: isDark
                          ? Colors.white.withOpacity(0.12)
                          : Colors.white.withOpacity(0.5),
                      width: 1,
                    ),
              ),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
