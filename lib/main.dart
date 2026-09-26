import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/theme/app_theme.dart';
import 'core/constants/hive_constants.dart';
import 'features/notes/data/models/note_model.dart';
import 'features/tasks/data/models/task_model.dart';
import 'features/focus/data/models/focus_session_model.dart';
import 'features/tracking/data/models/streak_model.dart';
import 'features/settings/presentation/providers/settings_provider.dart';
import 'features/home/presentation/pages/main_shell.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();

  // Register Hive Adapters
  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(NoteModelAdapter());
  }
  if (!Hive.isAdapterRegistered(1)) {
    Hive.registerAdapter(TaskModelAdapter());
  }
  if (!Hive.isAdapterRegistered(4)) {
    Hive.registerAdapter(TaskPriorityAdapter());
  }
  if (!Hive.isAdapterRegistered(2)) {
    Hive.registerAdapter(FocusSessionModelAdapter());
  }
  if (!Hive.isAdapterRegistered(3)) {
    Hive.registerAdapter(StreakModelAdapter());
  }

  // Open Hive Boxes
  await Hive.openBox<NoteModel>(HiveConstants.notesBox);
  await Hive.openBox<TaskModel>(HiveConstants.tasksBox);
  await Hive.openBox<FocusSessionModel>(HiveConstants.focusSessionsBox);
  await Hive.openBox<StreakModel>(HiveConstants.streaksBox);
  await Hive.openBox(HiveConstants.settingsBox);

  // System UI Overlay
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
    ),
  );

  runApp(
    const ProviderScope(
      child: FocusFlowApp(),
    ),
  );
}

class FocusFlowApp extends ConsumerWidget {
  const FocusFlowApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeType = ref.watch(themeTypeProvider);

    ThemeData activeTheme;
    switch (themeType) {
      case AppThemeType.light:
        activeTheme = AppTheme.lightTheme;
        break;
      case AppThemeType.dark:
        activeTheme = AppTheme.darkTheme;
        break;
      case AppThemeType.amoled:
        activeTheme = AppTheme.amoledTheme;
        break;
    }

    return MaterialApp(
      title: 'FocusFlow',
      debugShowCheckedModeBanner: false,
      theme: activeTheme,
      home: const MainShell(),
    );
  }
}
