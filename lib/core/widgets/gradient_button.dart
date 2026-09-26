import 'package:flutter/material.dart';

class GradientButton extends StatefulWidget {
  const GradientButton({
    super.key,
    required this.onPressed,
    this.child,
    this.label,
    this.icon,
    this.gradient,
    this.borderRadius,
    this.padding,
    this.height = 56,
    this.width,
    this.disabled = false,
  });

  final VoidCallback? onPressed;
  final Widget? child;
  final String? label;
  final IconData? icon;
  final Gradient? gradient;
  final BorderRadius? borderRadius;
  final EdgeInsets? padding;
  final double height;
  final double? width;
  final bool disabled;

  @override
  State<GradientButton> createState() => _GradientButtonState();
}

class _GradientButtonState extends State<GradientButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final gradient = widget.gradient ??
        const LinearGradient(
          colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
        );

    Widget content;
    if (widget.child != null) {
      content = widget.child!;
    } else {
      content = Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (widget.icon != null) ...[
            Icon(widget.icon, color: Colors.white, size: 20),
            const SizedBox(width: 8),
          ],
          if (widget.label != null)
            Text(
              widget.label!,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.2,
              ),
            ),
        ],
      );
    }

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        if (!widget.disabled) widget.onPressed?.call();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.96 : 1.0,
        duration: const Duration(milliseconds: 120),
        child: Container(
          height: widget.height,
          width: widget.width,
          padding: widget.padding ?? const EdgeInsets.symmetric(horizontal: 24),
          decoration: BoxDecoration(
            gradient: widget.disabled
                ? LinearGradient(
                    colors: [
                      Colors.grey.shade400,
                      Colors.grey.shade500,
                    ],
                  )
                : gradient,
            borderRadius: widget.borderRadius ?? BorderRadius.circular(18),
            boxShadow: widget.disabled
                ? null
                : [
                    BoxShadow(
                      color: const Color(0xFF6366F1).withOpacity(0.35),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
          ),
          child: Center(child: content),
        ),
      ),
    );
  }
}
