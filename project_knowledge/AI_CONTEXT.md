# 🤖 AI_CONTEXT.md — FocusFlow Knowledge Base

> **INSTRUCTION FOR AI AGENTS & LLMs**:
> This document is the **Single Source of Truth** for the **FocusFlow** codebase. Use this document to understand the full technical specifications, architecture, data structures, state providers, and business rules without requiring full codebase scans.

---

## 1. Project Metadata
- **Project Name**: FocusFlow
- **Type**: Native Cross-Platform Mobile Application (Android, iOS)
- **Framework**: Flutter 3.24+ / Dart 3.5+
- **Architecture**: Clean Architecture (Feature-First Pattern)
- **State Management**: Flutter Riverpod 2.6.1 (`StateNotifierProvider`, `Provider`)
- **Database**: Hive 2.2.3 + Hive Flutter 1.1.0 (Completely offline-first, zero cloud dependencies)
- **Theming**: Material 3 (Light, Dark, AMOLED `#000000`) with Custom `AppColors` `ThemeExtension`
- **Typography & Animations**: `google_fonts: ^6.2.1` (Inter), `flutter_animate: ^4.5.2`, `fl_chart: ^1.1.1`
- **GitHub Remote**: `https://github.com/AlaminM01/FocusFlow.git`

---

## 2. Directory Structure & File Map

```
lib/
├── main.dart                                                  # App entrypoint, Hive init, adapter registration, ProviderScope, dynamic theme routing
├── core/
│   ├── constants/
│   │   └── hive_constants.dart                               # Box keys: notes_box, tasks_box, focus_sessions_box, streaks_box, settings_box
│   ├── extensions/
│   │   ├── context_extensions.dart                           # BuildContext helpers: theme, colorScheme, textTheme, appColors, screen dims, showSnackBar
│   │   └── date_extensions.dart                              # DateTime helpers: isToday, friendlyDate, friendlyDateTime, isoDate, dayOfYear
│   ├── theme/
│   │   └── app_theme.dart                                    # AppTheme (lightTheme, darkTheme, amoledTheme), primary/focus/energy gradients, AppColors extension
│   ├── utils/
│   │   └── debouncer.dart                                    # Timer debouncer used for note editor auto-saving (1 sec delay)
│   └── widgets/
│       ├── empty_state_widget.dart                           # Generic empty state with icon, title, subtitle & action button
│       ├── ff_app_bar.dart                                   # Custom transparent app bar with gradient title mask
│       ├── glass_card.dart                                   # Glassmorphism container with BackdropFilter sigma blur and translucent borders
│       └── gradient_button.dart                              # Animated button with custom gradients and tap scale micro-interaction
└── features/
    ├── focus/
    │   ├── data/
    │   │   ├── models/focus_session_model.dart               # HiveObject (TypeId 2): id, startTime, endTime, durationMinutes, sessionType, isCompleted
    │   │   ├── models/focus_session_model.g.dart             # Handwritten TypeAdapter<FocusSessionModel> (BinaryReader/Writer)
    │   │   └── repositories/focus_repository_impl.dart       # CRUD operations against Box<FocusSessionModel>
    │   ├── domain/
    │   │   ├── entities/focus_session_entity.dart            # Pure domain entity with copyWith
    │   │   └── repositories/focus_repository.dart            # Abstract interface
    │   └── presentation/
    │       ├── pages/focus_page.dart                         # Timer UI with mode chips (Pomodoro 25m, Deep Work 90m, Break 5m), CustomPainter ring, controls & stats
    │       ├── providers/focus_provider.dart                 # focusSessionsProvider, activeFocusTimerProvider (Timer.periodic), todayFocusMinutesProvider
    │       └── widgets/
    │           ├── circular_timer.dart                       # CustomPainter circular gradient sweep arc with progress dot and center countdown
    │           └── focus_mode_chip.dart                      # Selector chip for timer modes
    ├── home/
    │   └── presentation/
    │       ├── pages/home_page.dart                          # Dashboard: greeting, date badge, quote card, 3-column stats row, top tasks, recent notes, focus CTA
    │       ├── pages/main_shell.dart                         # Floating glass bottom navigation bar with 5 tabs (Home, Notes, Tasks, Focus, Insights)
    │       └── widgets/
    │           ├── quick_stats_row.dart                      # 3-column row displaying streak days, completed tasks, and focus time
    │           ├── quote_card.dart                           # Glassmorphic daily quote card with next quote shuffle action
    │           └── streak_card.dart                          # Single metric card with emoji, title & gradient
    ├── motivation/
    │   ├── data/repositories/quotes_repository.dart          # 50+ curated stoic & productivity quotes (Marcus Aurelius, Seneca, James Clear, Naval Ravikant)
    │   ├── domain/entities/quote_entity.dart                 # QuoteEntity(quote, author)
    │   └── presentation/
    │       ├── pages/motivation_page.dart                    # Inspiration screen with daily quote hero banner and curated list
    │       └── providers/motivation_provider.dart            # quotesProvider, dailyQuoteProvider (dayOfYear % length), randomQuoteProvider
    ├── notes/
    │   ├── data/
    │   │   ├── models/note_model.dart                        # HiveObject (TypeId 0): id, title, content, createdAt, updatedAt, isPinned, isFavorite, colorIndex, tags
    │   │   ├── models/note_model.g.dart                      # Handwritten TypeAdapter<NoteModel>
    │   │   └── repositories/notes_repository_impl.dart       # CRUD operations against Box<NoteModel> with pinned-first sorting
    │   ├── domain/
    │   │   ├── entities/note_entity.dart                     # NoteEntity with copyWith
    │   │   └── repositories/notes_repository.dart            # Abstract interface
    │   └── presentation/
    │       ├── pages/note_editor_page.dart                   # Fullscreen note editor with auto-save debouncer, tag manager, canvas color palette
    │       ├── pages/notes_page.dart                         # Searchable notes list with tabs (All Notes, Pinned, Favorites)
    │       ├── providers/notes_provider.dart                 # notesProvider (NotesNotifier CRUD), favouriteNotesProvider, noteSearchProvider
    │       └── widgets/note_card.dart                        # Note card with color tints, tag chips, pin/favorite status, long-press options sheet
    ├── settings/
    │   └── presentation/
    │       ├── pages/settings_page.dart                      # Theme selector (Light, Dark, AMOLED), sound/haptic toggles, offline status, version
    │       └── providers/settings_provider.dart              # settingsProvider (SettingsNotifier persisted to settingsBox), themeTypeProvider, themeModeProvider
    ├── tasks/
    │   ├── data/
    │   │   ├── models/task_model.dart                        # HiveObject (TypeId 1): id, title, description, createdAt, dueDate, isCompleted, priority, completedAt
    │   │   ├── models/task_model.g.dart                      # Handwritten TypeAdapter<TaskModel> & TypeAdapter<TaskPriority> (TypeId 4)
    │   │   └── repositories/tasks_repository_impl.dart       # CRUD operations against Box<TaskModel> with incomplete-first sorting
    │   ├── domain/
    │   │   ├── entities/task_entity.dart                     # TaskEntity with TaskPriority enum (low, medium, high, urgent), isOverdue, isDueToday
    │   │   └── repositories/tasks_repository.dart            # Abstract interface
    │   └── presentation/
    │       ├── pages/task_editor_page.dart                   # Bottom sheet editor with title, description, priority chips, and date picker
    │       ├── pages/tasks_page.dart                         # Daily velocity tracker with CircularPercentIndicator, filters (All, Active, Completed), TaskTile list
    │       ├── providers/tasks_provider.dart                 # tasksProvider (TasksNotifier), taskProgressProvider (0.0 - 1.0), pendingTasksProvider
    │       └── widgets/task_tile.dart                        # Animated checkbox, priority color indicator bar, swipe-to-delete dismissible
    └── tracking/
        ├── data/
        │   ├── models/streak_model.dart                      # HiveObject (TypeId 3): currentStreak, longestStreak, lastActiveDate, totalFocusMinutes, totalTasksCompleted, totalNotesCreated, dailyFocusMinutes
        │   ├── models/streak_model.g.dart                    # Handwritten TypeAdapter<StreakModel>
        │   └── repositories/tracking_repository_impl.dart    # Consecutive-day calculation & activity increment logic
        ├── domain/
        │   ├── entities/streak_entity.dart                   # StreakEntity with totalFocusHours, focusMinutesForDate
        │   └── repositories/tracking_repository.dart         # Abstract interface
        └── presentation/
            ├── pages/insights_page.dart                      # Analytics dashboard: Streak hero card, velocity metrics, weekly FL Chart bar chart, Productivity Index
            └── providers/tracking_provider.dart              # trackingRepositoryProvider, streakProvider (StreakNotifier), productivityInsightsProvider
```

---

## 3. Database Schema & TypeIds

Hive boxes are opened at application startup in `main.dart`. All TypeAdapters are manually written to avoid generator version conflicts:

| Box Name | TypeId | Target Model | Fields |
| :--- | :---: | :--- | :--- |
| `notes_box` | `0` | `NoteModel` | `0: id (String)`, `1: title (String)`, `2: content (String)`, `3: createdAt (DateTime)`, `4: updatedAt (DateTime)`, `5: isPinned (bool)`, `6: isFavorite (bool)`, `7: colorIndex (int)`, `8: tags (List<String>)` |
| `tasks_box` | `1` | `TaskModel` | `0: id (String)`, `1: title (String)`, `2: description (String?)`, `3: createdAt (DateTime)`, `4: dueDate (DateTime?)`, `5: isCompleted (bool)`, `6: priority (TaskPriority)`, `7: completedAt (DateTime?)` |
| `tasks_box` | `4` | `TaskPriority` | `enum: low (0), medium (1), high (2), urgent (3)` |
| `focus_sessions_box` | `2` | `FocusSessionModel` | `0: id (String)`, `1: startTime (DateTime)`, `2: endTime (DateTime)`, `3: durationMinutes (int)`, `4: sessionType (String)`, `5: isCompleted (bool)` |
| `streaks_box` | `3` | `StreakModel` | `0: currentStreak (int)`, `1: longestStreak (int)`, `2: lastActiveDate (DateTime?)`, `3: totalFocusMinutes (int)`, `4: totalTasksCompleted (int)`, `5: totalNotesCreated (int)`, `6: dailyFocusMinutes (Map<String, int>)` |
| `settings_box` | `N/A` | Plain Map | `theme_type (int: 0=light, 1=dark, 2=amoled)`, `sound_enabled (bool)`, `haptics_enabled (bool)` |

---

## 4. Key Business Logic & Algorithms

### 4.1. Streak Calculation (`tracking_repository_impl.dart`)
```dart
DateTime today = DateTime.now();
DateTime? lastActive = streak.lastActiveDate;

if (lastActive == null) {
  streak.currentStreak = 1;
} else {
  int diffDays = DateTime(today.year, today.month, today.day)
      .difference(DateTime(lastActive.year, lastActive.month, lastActive.day))
      .inDays;

  if (diffDays == 1) {
    streak.currentStreak += 1;
  } else if (diffDays > 1) {
    streak.currentStreak = 1; // Gap reset
  }
  // diffDays == 0: already logged today, keep current streak
}
if (streak.currentStreak > streak.longestStreak) {
  streak.longestStreak = streak.currentStreak;
}
streak.lastActiveDate = today;
```

### 4.2. Timer Engine (`focus_provider.dart`)
- **Timer Frequency**: `Timer.periodic(const Duration(seconds: 1), ...)`
- **Auto-Completion**: When `remainingSeconds <= 1`, timer invokes `_onComplete()` which automatically creates a `FocusSessionEntity` and logs it to `focusSessionsProvider`.
- **Automatic Activity Hook**: Completing a focus session triggers `ref.read(streakProvider.notifier).incrementFocusTime(duration)`.

### 4.3. Note Auto-Save (`note_editor_page.dart`)
- Text fields listen to inputs and pass updates to `Debouncer(delay: Duration(seconds: 1))`.
- When typing stops for 1000ms, the note saves silently without locking the UI thread.
- `PopScope(onPopInvokedWithResult: ...)` guarantees auto-save on back navigation.

---

## 5. UI & Theming Architecture
- **Theme Selection**: Managed by `settingsProvider` and `themeTypeProvider`.
- **Light Theme**: Radiant background (`#F8FAFC`), Surface (`#FFFFFF`), Primary (`#6366F1`).
- **Dark Theme**: Deep Obsidian background (`#090D16`), Surface (`#131A29`), Primary (`#6366F1`).
- **AMOLED Theme**: Pitch Black background (`#000000`), Surface (`#0A0A0A`).
- **AppColors Extension**: Custom `ThemeExtension<AppColors>` provides note card tints (`noteCard1` to `noteCard5`), glass borders, and shimmer colors across all themes.

---

## 6. Testing Strategy
- `test/unit_test.dart`: Entity immutability, `copyWith`, streak gap handling, and quote collection verification.
- `test/widget_test.dart`: `GradientButton` tap callbacks, `GlassCard` blur rendering, and `AppTheme` palette checks.
