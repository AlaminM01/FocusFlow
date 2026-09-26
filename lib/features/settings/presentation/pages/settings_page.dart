import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:focusflow/core/theme/app_theme.dart';
import '../providers/settings_provider.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
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
                'Settings & Theme',
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
                // Branding Card
                _BrandingSection(),
                const SizedBox(height: 28),

                // Theme selection
                _SectionHeader(title: 'Aesthetics & Theme'),
                const SizedBox(height: 12),
                _ThemeSelector(
                  currentType: settings.themeType,
                  onChanged: (type) {
                    ref.read(settingsProvider.notifier).setTheme(type);
                  },
                ),
                const SizedBox(height: 28),

                // Sound & Haptics
                _SectionHeader(title: 'Haptics & Feedback'),
                const SizedBox(height: 12),
                _FeedbackSection(
                  settings: settings,
                  onToggleSound: () =>
                      ref.read(settingsProvider.notifier).toggleSound(),
                  onToggleHaptics: () =>
                      ref.read(settingsProvider.notifier).toggleHaptics(),
                ),
                const SizedBox(height: 28),

                // About
                _SectionHeader(title: 'About FocusFlow'),
                const SizedBox(height: 12),
                _AboutSection(),
                const SizedBox(height: 120),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _BrandingSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: AppTheme.primaryGradient,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withOpacity(0.35),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.auto_awesome_rounded,
              color: Colors.white,
              size: 30,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'FocusFlow',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                      ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Distraction-Free Productivity Workspace',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white.withOpacity(0.85),
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1);
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title.toUpperCase(),
      style: Theme.of(context).textTheme.labelSmall?.copyWith(
            letterSpacing: 1.5,
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.w700,
          ),
    );
  }
}

class _ThemeSelector extends StatelessWidget {
  final AppThemeType currentType;
  final ValueChanged<AppThemeType> onChanged;

  const _ThemeSelector({
    required this.currentType,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: colorScheme.outline.withOpacity(0.08),
        ),
      ),
      child: Column(
        children: [
          _ThemeOption(
            icon: Icons.wb_sunny_rounded,
            label: 'Light Theme',
            subtitle: 'Clean, radiant and crisp daylight look',
            isSelected: currentType == AppThemeType.light,
            onTap: () => onChanged(AppThemeType.light),
          ),
          Divider(
            height: 1,
            color: colorScheme.outline.withOpacity(0.08),
            indent: 56,
          ),
          _ThemeOption(
            icon: Icons.dark_mode_rounded,
            label: 'Dark Theme',
            subtitle: 'Deep obsidian for relaxed focus',
            isSelected: currentType == AppThemeType.dark,
            onTap: () => onChanged(AppThemeType.dark),
          ),
          Divider(
            height: 1,
            color: colorScheme.outline.withOpacity(0.08),
            indent: 56,
          ),
          _ThemeOption(
            icon: Icons.brightness_1_rounded,
            label: 'AMOLED Black',
            subtitle: 'Pure pitch black #000000 for OLED efficiency',
            isSelected: currentType == AppThemeType.amoled,
            onTap: () => onChanged(AppThemeType.amoled),
            isLast: true,
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms, delay: 100.ms).slideY(begin: 0.1);
  }
}

class _ThemeOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isLast;

  const _ThemeOption({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: isSelected
              ? colorScheme.primary.withOpacity(0.15)
              : colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          color: isSelected
              ? colorScheme.primary
              : colorScheme.onSurface.withOpacity(0.5),
          size: 20,
        ),
      ),
      title: Text(
        label,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isSelected ? colorScheme.primary : null,
            ),
      ),
      subtitle: Text(
        subtitle,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurface.withOpacity(0.55),
            ),
      ),
      trailing: isSelected
          ? Icon(Icons.check_circle_rounded,
              color: colorScheme.primary, size: 22)
          : Icon(Icons.radio_button_unchecked,
              color: colorScheme.outline.withOpacity(0.3), size: 22),
    );
  }
}

class _FeedbackSection extends StatelessWidget {
  final SettingsState settings;
  final VoidCallback onToggleSound;
  final VoidCallback onToggleHaptics;

  const _FeedbackSection({
    required this.settings,
    required this.onToggleSound,
    required this.onToggleHaptics,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: colorScheme.outline.withOpacity(0.08),
        ),
      ),
      child: Column(
        children: [
          SwitchListTile(
            value: settings.soundEnabled,
            onChanged: (_) => onToggleSound(),
            title: Text(
              'Session Bell Audio',
              style: Theme.of(context)
                  .textTheme
                  .titleSmall
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              'Gentle chime when focus timers conclude',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurface.withOpacity(0.55),
                  ),
            ),
            secondary: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.volume_up_rounded,
                  color: colorScheme.primary, size: 20),
            ),
          ),
          Divider(
            height: 1,
            color: colorScheme.outline.withOpacity(0.08),
            indent: 56,
          ),
          SwitchListTile(
            value: settings.hapticsEnabled,
            onChanged: (_) => onToggleHaptics(),
            title: Text(
              'Haptic Sensations',
              style: Theme.of(context)
                  .textTheme
                  .titleSmall
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              'Subtle tactile feedback on completions',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurface.withOpacity(0.55),
                  ),
            ),
            secondary: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppTheme.secondaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.vibration_rounded,
                  color: AppTheme.secondaryColor, size: 20),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms, delay: 150.ms).slideY(begin: 0.1);
  }
}

class _AboutSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: colorScheme.outline.withOpacity(0.08),
        ),
      ),
      child: Column(
        children: [
          ListTile(
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.verified_rounded,
                  color: colorScheme.primary, size: 20),
            ),
            title: Text('Version',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    )),
            trailing: Text(
              '1.0.0 (Production Build)',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
          Divider(
              height: 1,
              color: colorScheme.outline.withOpacity(0.08),
              indent: 56),
          ListTile(
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppTheme.successColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.cloud_off_rounded,
                  color: AppTheme.successColor, size: 20),
            ),
            title: Text('Offline-First Architecture',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    )),
            subtitle: Text(
              '100% private, zero telemetry, local Hive database',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurface.withOpacity(0.55),
                  ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms, delay: 200.ms).slideY(begin: 0.1);
  }
}
