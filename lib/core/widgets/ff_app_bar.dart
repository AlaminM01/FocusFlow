import 'package:flutter/material.dart';
import 'package:focusflow/core/theme/app_theme.dart';

/// A custom app bar with FocusFlow's brand styling.
///
/// Transparent background, optional trailing actions, no elevation.
class FFAppBar extends StatelessWidget implements PreferredSizeWidget {
  const FFAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.showBack = false,
    this.centerTitle = false,
    this.titleStyle,
    this.backgroundColor = Colors.transparent,
    this.bottom,
  });

  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool showBack;
  final bool centerTitle;
  final TextStyle? titleStyle;
  final Color backgroundColor;
  final PreferredSizeWidget? bottom;

  @override
  Size get preferredSize => Size.fromHeight(
        bottom != null ? kToolbarHeight + bottom!.preferredSize.height : kToolbarHeight,
      );

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return AppBar(
      backgroundColor: backgroundColor,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: centerTitle,
      leading: showBack
          ? IconButton(
              icon: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: cs.surface.withOpacity(0.9),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: cs.outline.withOpacity(0.2),
                  ),
                ),
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 16,
                  color: cs.onSurface,
                ),
              ),
              onPressed: () => Navigator.of(context).pop(),
            )
          : leading,
      title: ShaderMask(
        shaderCallback: (bounds) => AppTheme.primaryGradient.createShader(bounds),
        blendMode: BlendMode.srcIn,
        child: Text(
          title,
          style: titleStyle ??
              tt.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
                letterSpacing: -0.5,
              ),
        ),
      ),
      actions: actions,
      bottom: bottom,
    );
  }
}
