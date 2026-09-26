# 📜 FocusFlow — Changelog

All notable changes, architectural milestones, UI redesigns, and bug fixes for **FocusFlow** are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [1.0.0] - 2026-09-26 — Initial Production Release

### 🚀 Added Features
- **Clean Architecture Infrastructure**: Feature-first module layout dividing domain entities, repository contracts, Hive data models, and presentation controllers.
- **Thought Sanctuary (Notes Module)**:
  - Full CRUD operations with instant search by title, content, and `#tags`.
  - Pinning and favoriting capabilities with pinned-first sorting.
  - 5 custom canvas tint colors (*Indigo, Emerald, Warm Amber, Purple, Sky Blue*).
  - 1000ms debounced auto-save engine in `NoteEditorPage`.
  - Android & iOS predictive back navigation auto-save hook via `PopScope`.
- **Daily Velocity (Tasks Module)**:
  - 4 priority classifications: *Urgent*, *High*, *Medium*, *Low* with custom left-border visual indicators.
  - Interactive animated checkbox with scale micro-interaction on completion.
  - `Dismissible` swipe-to-delete gesture interaction.
  - Real-time `taskProgressProvider` powering the Circular Percent velocity card.
  - Target due date scheduling and overdue date calculations.
- **Immersive Focus Engine (Timer Module)**:
  - 3 preset flow modalities: *Pomodoro (25m)*, *Deep Work (90m)*, and *Short Break (5m)*.
  - `CustomPainter` (`_TimerRingPainter`) rendering a multi-stop sweep gradient arc with glowing lead point.
  - Ambient glow shadow pulsating when timer is running.
  - Automated session persistence to Hive when countdown reaches zero or user stops after $\ge 1\text{ min}$.
- **Curated Stoic Wisdom (Motivation Module)**:
  - In-memory curated catalog of 50+ philosophical reflections (*Marcus Aurelius, Seneca, Epictetus, James Clear, Cal Newport, Naval Ravikant*).
  - Deterministic daily quote formula using calendar day-of-year index.
  - Instant quote shuffle action with cross-fade animation.
- **Momentum & Analytics (Tracking Module)**:
  - Consecutive active streak calculation with record streak preservation.
  - 7-day focus trend visualization using FL Chart with custom bar rod gradients.
  - Composite daily Productivity Index evaluation score.
- **Triple-Theme Aesthetics Engine**:
  - ☀️ **Light Slate**: Clean daylight surface (`#FFFFFF`) on `#F8FAFC`.
  - 🌙 **Obsidian Dark**: Frosted glass surfaces (`#131A29`) on `#090D16`.
  - 🖤 **AMOLED Pitch Black**: Pure `#000000` surface optimization for OLED battery efficiency.
  - `AppColors` `ThemeExtension` providing typed custom tokens across all themes.

### 🎨 UI/UX Enhancements
- Built floating pill bottom navigation in `MainShell` with `BackdropFilter` sigma blur.
- Implemented `GradientButton` with press down scale compression (`0.96`).
- Added `GlassCard` reusable glassmorphic container with translucent borders.
- Replaced standard Material app bar with gradient-masked `FFAppBar`.
- Configured edge-to-edge transparent system navigation bars in `main.dart`.

### ⚡ Performance & Quality Engineering
- Hand-authored all five Hive `TypeAdapter`s (`NoteModelAdapter`, `TaskModelAdapter`, `FocusSessionModelAdapter`, `StreakModelAdapter`, `TaskPriorityAdapter`), eliminating `build_runner` conflicts.
- Verified 100% static analysis pass with `flutter analyze` (0 errors, 0 warnings).
- Added unit test suite in `test/unit_test.dart` and widget tests in `test/widget_test.dart`.
- Added high-resolution marketing hero banner and 4 UI mockup screenshots in `assets/screenshots/`.

---

## [0.2.0] - 2026-09-26 — Data Layer & State Integration
- Added Hive Box constants: `notes_box`, `tasks_box`, `focus_sessions_box`, `streaks_box`, `settings_box`.
- Implemented Riverpod notifiers (`NotesNotifier`, `TasksNotifier`, `FocusTimerNotifier`, `StreakNotifier`).
- Added `DateTime` and `BuildContext` utility extensions.

---

## [0.1.0] - 2026-09-26 — Project Inception
- Created Flutter base project with Material 3.
- Configured `pubspec.yaml` with Riverpod, Hive, Google Fonts, Flutter Animate, and FL Chart.
- Structured Clean Architecture folder tree.
