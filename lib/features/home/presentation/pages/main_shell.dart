import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focusflow/core/theme/app_theme.dart';
import 'package:focusflow/features/focus/presentation/pages/focus_page.dart';
import 'package:focusflow/features/home/presentation/pages/home_page.dart';
import 'package:focusflow/features/notes/presentation/pages/notes_page.dart';
import 'package:focusflow/features/settings/presentation/pages/settings_page.dart';
import 'package:focusflow/features/tasks/presentation/pages/tasks_page.dart';
import 'package:focusflow/features/tracking/presentation/pages/insights_page.dart';

// ---------------------------------------------------------------------------
// Nav item model
// ---------------------------------------------------------------------------
class _NavItem {
  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
  final IconData icon;
  final IconData activeIcon;
  final String label;
}

const _navItems = [
  _NavItem(
    icon: Icons.home_outlined,
    activeIcon: Icons.home_rounded,
    label: 'Home',
  ),
  _NavItem(
    icon: Icons.sticky_note_2_outlined,
    activeIcon: Icons.sticky_note_2_rounded,
    label: 'Notes',
  ),
  _NavItem(
    icon: Icons.check_circle_outline_rounded,
    activeIcon: Icons.check_circle_rounded,
    label: 'Tasks',
  ),
  _NavItem(
    icon: Icons.timer_outlined,
    activeIcon: Icons.timer_rounded,
    label: 'Focus',
  ),
  _NavItem(
    icon: Icons.insights_outlined,
    activeIcon: Icons.insights_rounded,
    label: 'Insights',
  ),
];

// ---------------------------------------------------------------------------
// MainShell
// ---------------------------------------------------------------------------
class MainShell extends ConsumerStatefulWidget {
  const MainShell({super.key});

  @override
  ConsumerState<MainShell> createState() => _MainShellState();
}

class _MainShellState extends ConsumerState<MainShell>
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = const [
      HomePage(),
      NotesPage(),
      TasksPage(),
      FocusPage(),
      InsightsPage(),
    ];
  }

  void _onNavTap(int index) {
    if (index == _currentIndex) return;
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 320),
        switchInCurve: Curves.easeOutCubic,
        switchOutCurve: Curves.easeInCubic,
        transitionBuilder: (child, animation) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.03, 0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            ),
          );
        },
        child: KeyedSubtree(
          key: ValueKey<int>(_currentIndex),
          child: _pages[_currentIndex],
        ),
      ),
      bottomNavigationBar: _FloatingNavBar(
        currentIndex: _currentIndex,
        onTap: _onNavTap,
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Floating glassmorphism nav bar
// ---------------------------------------------------------------------------
class _FloatingNavBar extends StatelessWidget {
  const _FloatingNavBar({
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bottomPad = MediaQuery.paddingOf(context).bottom;
    final appColors = Theme.of(context).extension<AppColors>()!;

    return Padding(
      padding: EdgeInsets.fromLTRB(20, 0, 20, bottomPad + 12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            height: 68,
            decoration: BoxDecoration(
              color: appColors.navBar,
              borderRadius: BorderRadius.circular(32),
              border: Border.all(
                color: appColors.navBarBorder,
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? Colors.black.withOpacity(0.4)
                      : AppTheme.primaryColor.withOpacity(0.12),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(
                _navItems.length,
                (i) => _NavBarItem(
                  item: _navItems[i],
                  isActive: i == currentIndex,
                  onTap: () => onTap(i),
                ),
              ),
            ),
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 600.ms, delay: 200.ms)
        .slideY(begin: 1.0, end: 0, duration: 500.ms, curve: Curves.easeOutCubic);
  }
}

class _NavBarItem extends StatelessWidget {
  const _NavBarItem({
    required this.item,
    required this.isActive,
    required this.onTap,
  });

  final _NavItem item;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: isActive ? AppTheme.primaryGradient : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                isActive ? item.activeIcon : item.icon,
                key: ValueKey<bool>(isActive),
                size: 22,
                color: isActive
                    ? Colors.white
                    : Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
              ),
            ),
            const SizedBox(height: 3),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                fontSize: 10,
                fontWeight:
                    isActive ? FontWeight.w600 : FontWeight.w400,
                color: isActive
                    ? Colors.white
                    : Theme.of(context).colorScheme.onSurface.withOpacity(0.45),
              ),
              child: Text(item.label),
            ),
          ],
        ),
      ),
    );
  }
}
