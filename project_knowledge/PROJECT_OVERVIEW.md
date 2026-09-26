# ⚡ FocusFlow — Project Overview
### *Distraction-Free Productivity Sanctuary*

---

## 1. Executive Summary & Purpose
**FocusFlow** is an offline-first, distraction-free productivity mobile workspace designed to eliminate cognitive fatigue and contextual fragmentation. Built natively with **Flutter (Material 3)**, **Riverpod 2.6**, and **Hive local storage**, it harmoniously unifies five essential productivity pillars into a single fluid interface:
1. **Thought Sanctuary (Notes)**: Markdown-ready capture with custom color canvas tints, `#tags`, and debounced auto-save.
2. **Daily Velocity (Tasks)**: Priority-tagged checklist with real-time completion progress tracking.
3. **Immersive Focus Engine (Timer)**: Custom circular sweep progress timer with *Pomodoro (25m)*, *Deep Work (90m)*, and *Recharge (5m)* modes.
4. **Mindset & Inspiration (Stoic Wisdom)**: Curated local database of 50+ timeless stoic and productivity reflections.
5. **Momentum & Habit Analytics (Insights)**: Continuous active streak engine, weekly FL Chart analytics, and composite Productivity Index scoring.

---

## 2. Problem Statement
Modern productivity applications suffer from three critical flaws:
1. **Admin Dashboard Overload**: Cluttered interfaces with steep learning curves create cognitive friction instead of focus.
2. **Fragmented Workspaces**: Users switch between 3–5 different apps for notes, todo lists, pomodoro timers, and habits.
3. **Cloud & Subscription Dependency**: Mandatory logins, telemetry tracking, network latency, and paywalls compromise privacy and focus.

---

## 3. The FocusFlow Solution
FocusFlow provides a **Zen-inspired, zero-distraction workspace**:
- **Calm by Design**: Soft glassmorphism (`BackdropFilter` sigma blur), floating bottom navigation, and subtle organic gradients inspired by Apple HIG, Linear, and Arc Browser.
- **100% Offline-First Architecture**: Zero backend servers, zero API tokens, zero telemetry. All data is persisted locally in sub-millisecond binary Hive boxes.
- **Unified Flow State**: Transitions between capturing ideas, checking off goals, timing deep work sessions, and reviewing habit momentum occur within one single, cohesive app shell.

---

## 4. Target Users
- **Software Engineers & Technical Creators**: Developers requiring deep work sprints and technical snippet capture.
- **Students & Researchers**: Learners balancing daily lecture tasks, study timers, and lecture notes.
- **Writers & Designers**: Minimalists seeking a clean canvas without distracting notifications or cloud popups.
- **Productivity Enthusiasts**: Practitioners of *Getting Things Done (GTD)*, *Deep Work (Cal Newport)*, and *Atomic Habits (James Clear)*.

---

## 5. Core Feature Matrix

| Feature | Description | Key Tech / Highlights |
| :--- | :--- | :--- |
| **Notes Sanctuary** | Create, edit, delete, pin, favorite, and tag notes | Debounced auto-save, 5 canvas color tints, real-time search |
| **Daily Tasks** | Priority-graded task tracker with completion toggles | Swipe-to-delete, 4 priority levels (*Urgent/High/Medium/Low*), circular velocity indicator |
| **Focus Timer** | Pomodoro & Deep Work timer with visual sweep indicator | `CustomPainter` gradient arc, pulsing glow, auto-session logging |
| **Stoic Motivation** | 50+ curated philosophical & productivity quotes | Deterministic daily quote generation, category tagging, instant shuffle |
| **Productivity Tracking** | Streaks, focus hours, completion rates, 7-day trend | FL Chart bar visualizations, composite Productivity Score |
| **Triple-Theme Engine** | Light Slate, Obsidian Dark, and AMOLED Pitch Black | True `#000000` AMOLED support for OLED battery saving |

---

## 6. Architecture & Tech Stack

```
lib/
├── core/                # Constants, Theme Engine, Extensions, Utilities, Global Widgets
│   ├── constants/       # Hive box names & keys
│   ├── extensions/      # BuildContext & DateTime extensions
│   ├── theme/           # AppTheme, Material 3 palettes, AppColors ThemeExtension
│   ├── utils/           # Auto-save Debouncer
│   └── widgets/         # GlassCard, GradientButton, EmptyStateWidget, FFAppBar
│
├── features/            # Feature-First Clean Architecture Modules
│   ├── home/            # Home dashboard, greeting, quick stats row, quote card
│   ├── notes/           # NoteEntity, NoteModel (Hive TypeId 0), NoteEditorPage, NotesNotifier
│   ├── tasks/           # TaskEntity, TaskModel (Hive TypeId 1), TaskPriority (TypeId 4), TaskTile
│   ├── focus/           # FocusSessionEntity, FocusSessionModel (TypeId 2), CircularTimer, FocusNotifier
│   ├── motivation/      # QuoteEntity, QuotesRepository (50+ quotes), MotivationNotifier
│   ├── tracking/        # StreakEntity, StreakModel (TypeId 3), FL Chart Analytics, Productivity Score
│   └── settings/        # Theme switcher (Light/Dark/AMOLED), sound & haptic toggles
│
└── main.dart            # Hive adapter registrations, ProviderScope, MaterialApp root
```

- **Framework**: Flutter 3.24+ (Dart 3.5+) with Material 3 Design
- **State Management**: `flutter_riverpod: ^2.6.1` (StateNotifierProvider & Provider pattern)
- **Local Persistence**: `hive_flutter: ^1.1.0` (Handwritten binary `TypeAdapter`s, zero code-generation conflicts)
- **Charts & Graphs**: `fl_chart: ^1.1.1` & `percent_indicator: ^4.2.5`
- **Typography & Animations**: `google_fonts: ^6.2.1` (Inter typeface) & `flutter_animate: ^4.5.2`

---

## 7. Data Flow & State Lifecycle

```
[ User Interaction ] ──▶ [ Presentation (Widgets & Pages) ]
                                   │
                                   ▼ (reads & dispatches)
                        [ Riverpod StateNotifiers ]
                                   │
                                   ▼ (domain operations)
                        [ Repository Implementations ]
                                   │
                                   ▼ (binary read/write)
                        [ Hive Local Boxes (*.hive) ]
```

1. **User Action**: User toggles a task or starts a 25-minute Pomodoro timer.
2. **State Dispatch**: `ref.read(tasksProvider.notifier).toggleTask(id)` or `ref.read(activeFocusTimerProvider.notifier).start()`.
3. **Data Mutation**: Repository updates the corresponding in-memory list and writes to the respective binary Hive Box (`notes_box`, `tasks_box`, `focus_sessions_box`, `streaks_box`).
4. **Reactive UI Update**: Riverpod automatically invalidates dependent providers (`taskProgressProvider`, `todayFocusMinutesProvider`, `streakProvider`), updating all UI components instantaneously with zero frame drops.

---

## 8. Focus & Streak Algorithms

- **Active Streak Calculation**: Inspects `lastActiveDate`. If activity occurs today, streak is preserved. If activity occurred yesterday (`difference.inDays == 1`), streak increments by +1. If gap exceeds 1 day, streak safely resets to 1, updating `longestStreak` if surpassed.
- **Productivity Index Formula**:
  $$\text{Productivity Index} = \min\left(100, \, \left(\frac{\text{Task Completion Rate} + \min(1.0, \frac{\text{Focus Minutes}}{60})}{2}\right) \times 100\right)$$
- **Deterministic Daily Quote**:
  $$\text{Index} = (\text{Day of Year}) \pmod{\text{Total Quotes}}$$

---

## 9. Future Roadmap
1. **Interactive Home Screen Widgets**: iOS WidgetKit and Android AppWidgets for quick timers and task checkoffs.
2. **Ambient Sound Generator**: Built-in offline audio synthesizer (Rain, White Noise, Cafe ambiance).
3. **Encrypted JSON/ZIP Backup**: Export and restore private notes and session history with AES encryption.
4. **Wear OS / Apple Watch Sync**: Companion timer app for smartwatch wrist tracking.
