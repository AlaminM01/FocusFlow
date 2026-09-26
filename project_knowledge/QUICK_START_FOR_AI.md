# ⚡ FocusFlow — AI Quick Start Guide (Compact Summary)

> **FOR AI MODELS**: Read this 1-page summary to answer 95% of questions regarding FocusFlow's architecture, state flow, database, and features.

---

## 1. What is FocusFlow?
**FocusFlow** is an offline-first, distraction-free productivity mobile workspace built with **Flutter (Material 3)**, **Riverpod 2.6**, and **Hive 2.2**. It unites:
1. **Notes**: Color-tinted cards, tags, pinned/favorites, 1s debounced auto-save.
2. **Tasks**: Priorities (*Urgent/High/Medium/Low*), swipe-to-delete, daily completion velocity.
3. **Focus Timer**: *Pomodoro (25m)*, *Deep Work (90m)*, *Break (5m)* with a `CustomPainter` glowing sweep ring.
4. **Stoic Motivation**: 50+ curated quotes, deterministic daily quote (`dayOfYear % length`).
5. **Analytics**: Active habit streaks, 7-day FL Chart bar graph, composite Productivity Index.
6. **Triple Theme**: Light, Dark, and AMOLED Pitch Black (`#000000`).

---

## 2. Tech Stack & State Management
- **Framework**: Flutter 3.24+ / Dart 3.5+ (Material 3)
- **State**: `flutter_riverpod: ^2.6.1`
  - `notesProvider`: `StateNotifierProvider<NotesNotifier, AsyncValue<List<NoteEntity>>>`
  - `tasksProvider`: `StateNotifierProvider<TasksNotifier, AsyncValue<List<TaskEntity>>>`
  - `activeFocusTimerProvider`: `StateNotifierProvider<FocusTimerNotifier, FocusTimerState>`
  - `streakProvider`: `StateNotifierProvider<StreakNotifier, StreakEntity>`
  - `taskProgressProvider`: Derived completion percentage (`0.0 - 1.0`)
  - `themeTypeProvider`: `Provider<AppThemeType>` (Light, Dark, AMOLED)
- **Database**: `hive_flutter: ^1.1.0` (Handwritten `TypeAdapter`s, zero code-gen conflicts)
  - `notes_box` (TypeId 0: `NoteModel`)
  - `tasks_box` (TypeId 1: `TaskModel`, TypeId 4: `TaskPriority`)
  - `focus_sessions_box` (TypeId 2: `FocusSessionModel`)
  - `streaks_box` (TypeId 3: `StreakModel`)
  - `settings_box` (Plain Map for preferences)

---

## 3. Architecture & Code Layout
```
lib/
├── core/       # Constants (HiveConstants), Extensions, AppTheme, Debouncer, GlassCard
├── features/
│   ├── home/       # HomePage, MainShell (floating glass navbar), QuickStatsRow
│   ├── notes/      # NoteEntity, NoteModel, NotesNotifier, NoteEditorPage (auto-save)
│   ├── tasks/      # TaskEntity, TaskModel, TasksNotifier, TasksPage, TaskTile
│   ├── focus/      # FocusSessionEntity, FocusSessionModel, FocusPage, CircularTimer
│   ├── motivation/ # QuoteEntity, QuotesRepository (50+), MotivationPage
│   ├── tracking/   # StreakEntity, StreakModel, InsightsPage (FL Chart)
│   └── settings/   # SettingsState, SettingsNotifier, SettingsPage (Theme switcher)
└── main.dart   # Hive adapter registration, ProviderScope, dynamic theme routing
```

---

## 4. Key Formulas & Rules
- **Streak Calculation**: Difference between `DateTime.now()` and `lastActiveDate`. $1\text{ day} \to \text{streak} + 1$; $>1\text{ day} \to \text{streak} = 1$; same day $\to$ maintain.
- **Productivity Index**:
  $$\text{Score} = \min\left(100, \, \left(\frac{\text{Task Completion Rate} + \min(1.0, \frac{\text{Focus Minutes}}{60})}{2}\right) \times 100\right)$$
- **Auto-Save**: `Debouncer(delay: Duration(seconds: 1))` + `PopScope(onPopInvokedWithResult: ...)` guarantees 100% data safety.
- **Zero Cloud**: No Firebase, no Supabase, no REST API, no telemetry. 100% offline-first.

---

## 5. Build Commands
```bash
flutter pub get                 # Install dependencies
flutter analyze                 # Static analysis (0 errors, 0 warnings)
flutter test                    # Run test suite
flutter build apk --release     # Build release APK
flutter build appbundle --release # Build Google Play Bundle
```
