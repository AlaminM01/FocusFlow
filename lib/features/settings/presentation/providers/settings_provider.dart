import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:focusflow/core/constants/hive_constants.dart';

enum AppThemeType {
  light,
  dark,
  amoled,
}

class SettingsState {
  final AppThemeType themeType;
  final bool soundEnabled;
  final bool hapticsEnabled;
  final int defaultPomodoroMinutes;
  final int defaultDeepWorkMinutes;
  final int defaultBreakMinutes;

  const SettingsState({
    this.themeType = AppThemeType.dark,
    this.soundEnabled = true,
    this.hapticsEnabled = true,
    this.defaultPomodoroMinutes = 25,
    this.defaultDeepWorkMinutes = 90,
    this.defaultBreakMinutes = 5,
  });

  SettingsState copyWith({
    AppThemeType? themeType,
    bool? soundEnabled,
    bool? hapticsEnabled,
    int? defaultPomodoroMinutes,
    int? defaultDeepWorkMinutes,
    int? defaultBreakMinutes,
  }) {
    return SettingsState(
      themeType: themeType ?? this.themeType,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      hapticsEnabled: hapticsEnabled ?? this.hapticsEnabled,
      defaultPomodoroMinutes:
          defaultPomodoroMinutes ?? this.defaultPomodoroMinutes,
      defaultDeepWorkMinutes:
          defaultDeepWorkMinutes ?? this.defaultDeepWorkMinutes,
      defaultBreakMinutes: defaultBreakMinutes ?? this.defaultBreakMinutes,
    );
  }
}

class SettingsNotifier extends StateNotifier<SettingsState> {
  SettingsNotifier() : super(const SettingsState()) {
    _load();
  }

  void _load() {
    try {
      final box = Hive.box(HiveConstants.settingsBox);
      final themeIndex = box.get('theme_type', defaultValue: 1) as int;
      final sound = box.get('sound_enabled', defaultValue: true) as bool;
      final haptics = box.get('haptics_enabled', defaultValue: true) as bool;
      final pomodoro = box.get('pomodoro_mins', defaultValue: 25) as int;
      final deepWork = box.get('deepwork_mins', defaultValue: 90) as int;
      final breakMins = box.get('break_mins', defaultValue: 5) as int;

      state = SettingsState(
        themeType: AppThemeType.values[themeIndex.clamp(0, 2)],
        soundEnabled: sound,
        hapticsEnabled: haptics,
        defaultPomodoroMinutes: pomodoro,
        defaultDeepWorkMinutes: deepWork,
        defaultBreakMinutes: breakMins,
      );
    } catch (_) {}
  }

  Future<void> setTheme(AppThemeType type) async {
    state = state.copyWith(themeType: type);
    try {
      final box = Hive.box(HiveConstants.settingsBox);
      await box.put('theme_type', type.index);
    } catch (_) {}
  }

  Future<void> toggleSound() async {
    final next = !state.soundEnabled;
    state = state.copyWith(soundEnabled: next);
    try {
      final box = Hive.box(HiveConstants.settingsBox);
      await box.put('sound_enabled', next);
    } catch (_) {}
  }

  Future<void> toggleHaptics() async {
    final next = !state.hapticsEnabled;
    state = state.copyWith(hapticsEnabled: next);
    try {
      final box = Hive.box(HiveConstants.settingsBox);
      await box.put('haptics_enabled', next);
    } catch (_) {}
  }
}

final settingsProvider =
    StateNotifierProvider<SettingsNotifier, SettingsState>((ref) {
  return SettingsNotifier();
});

final themeTypeProvider = Provider<AppThemeType>((ref) {
  return ref.watch(settingsProvider).themeType;
});

final themeModeProvider = Provider<ThemeMode>((ref) {
  final type = ref.watch(themeTypeProvider);
  switch (type) {
    case AppThemeType.light:
      return ThemeMode.light;
    case AppThemeType.dark:
    case AppThemeType.amoled:
      return ThemeMode.dark;
  }
});
