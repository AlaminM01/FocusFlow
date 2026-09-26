<div align="center">

# ⚡ FocusFlow
### *Distraction-Free Productivity Workspace*

[![Flutter](https://img.shields.io/badge/Flutter-3.47+-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.13+-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
[![Riverpod](https://img.shields.io/badge/State-Riverpod_2.6-blueviolet?style=for-the-badge)](https://riverpod.dev)
[![Hive](https://img.shields.io/badge/Database-Hive_Offline_First-orange?style=for-the-badge)](https://docs.hivedb.dev)
[![License](https://img.shields.io/badge/License-MIT-emerald?style=for-the-badge)](LICENSE)

*FocusFlow unites notes, tasks, deep work sessions, and stoic motivation into one fluid, glassmorphic mobile workspace.*

---

</div>

## 🌌 App Philosophy

Most productivity apps fall into two traps: cluttered admin dashboards or rigid task trackers with hidden subscriptions.

**FocusFlow** is designed with a different ethos:
- **Calm by Default**: Floating layouts, soft frosted glassmorphism, and minimal cognitive load inspired by Japanese aesthetic minimalism and Apple Human Interface Design.
- **100% Offline-First**: Zero cloud dependencies, no tracking, zero subscriptions, and instant millisecond local storage via Hive.
- **Holistic Flow**: Your thoughts (Notes), actions (Tasks), energy (Focus Timer), and mindset (Stoic Motivation) coexist in one harmonious interface.

---

## ✨ Features Showcase

### 1. 📝 Thought Sanctuary (Notes)
- **Fluid Organization**: Instant capture with custom canvas tints (Indigo, Emerald, Warm Amber, Violet, Cyan).
- **Categorization**: Pinned notes, favorite bookmarks, and real-time search across titles, contents, and `#tags`.
- **Auto-Save Engine**: Intelligent debounced synchronization ensures you never lose a thought.

### 2. 🎯 Daily Velocity (Tasks)
- **Distraction-Free Execution**: Daily task view with animated checkoffs and priority color bars (*Urgent*, *High*, *Medium*, *Low*).
- **Progress Tracking**: Real-time circular velocity indicator showing percentage of today's conquered goals.
- **Interactive Gestures**: Swipe to delete, quick completion toggle, and deadline management.

### 3. ⏱️ Deep Work & Focus Timer
- **Three Flow Modes**:
  - 🍅 **Pomodoro**: 25-minute concentrated work sprints
  - 🧠 **Deep Work**: 90-minute immersion sessions for complex problem solving
  - ☕ **Break / Recharge**: 5-minute restorative downtime
- **Custom Circular Ring Painter**: Multi-stop gradient sweep with real-time glow and time countdown.
- **Automatic Logging**: Records completed sessions to local history.

### 4. 💡 Daily Inspiration & Quotes
- **Curated Database**: 50+ hand-picked stoic and productivity reflections from *Marcus Aurelius, Seneca, Epictetus, James Clear, Cal Newport, Naval Ravikant, and Steve Jobs*.
- **Daily Reflection**: Deterministic daily quote generation with instant refresh capabilities.

### 5. 📊 Habit & Momentum Analytics
- **Streak Flame**: Consecutive active day tracking with longest personal streak records.
- **Weekly Trend**: Dynamic 7-day focus chart powered by FL Chart.
- **Productivity Index**: Composite daily score evaluating focus time and task completion velocity.

---

## 🎨 Design System & Theming

FocusFlow comes out-of-the-box with 3 hand-crafted themes:

| ☀️ Light Theme | 🌙 Dark Theme | 🖤 AMOLED Black |
| :--- | :--- | :--- |
| Clean, radiant slate daylight look with indigo accents | Deep obsidian glass with violet neon glow | Pitch black `#000000` for OLED battery efficiency |

### Visual Highlights:
- **Soft Glassmorphism**: Custom `BackdropFilter` sigma blur with frosted borders.
- **Dynamic Linear Gradients**: Fluid transitions across iris, cyan, and warm amber.
- **Micro-Interactions**: Smooth scale feedback, hero transitions, and slide animations via `flutter_animate`.

---

## 🏗️ Architecture Overview

FocusFlow strictly follows **Clean Architecture** with a **Feature-First** structure:

```
lib/
├── core/
│   ├── constants/       # Hive box keys, storage constants
│   ├── extensions/      # BuildContext & DateTime extensions
│   ├── theme/           # AppTheme, Material 3 palettes, AppColors
│   ├── utils/           # Debouncer, formatting utilities
│   └── widgets/         # GlassCard, GradientButton, EmptyStateWidget, FFAppBar
│
├── features/
│   ├── home/            # Header greeting, daily quote, quick stats, overview
│   ├── notes/           # NoteEntity, Hive models, repository, NoteEditorPage
│   ├── tasks/           # TaskEntity, priority tags, TaskTile, TaskEditorPage
│   ├── focus/           # Custom CircularTimer painter, FocusTimerNotifier
│   ├── motivation/      # Curated quotes database, daily quote generator
│   ├── tracking/        # Streak calculation, weekly FL Chart, productivity index
│   └── settings/        # Theme switcher (Light/Dark/AMOLED), haptics, about
│
└── main.dart            # Hive initialization, Riverpod root, Material 3 app
```

---

## 🚀 Getting Started

### Prerequisites
- [Flutter SDK](https://flutter.dev/docs/get-started/install) (`>= 3.24.0`)
- [Dart SDK](https://dart.dev/get-dart) (`>= 3.5.0`)
- Android Studio / VS Code with Flutter Extension

### Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/AlaminM01/FocusFlow.git
   cd FocusFlow
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Run the application:**
   ```bash
   flutter run
   ```

4. **Run tests:**
   ```bash
   flutter test
   ```

---

## 📦 APK & App Bundle Build Instructions

### Generate Android Release APK:
```bash
flutter build apk --release
```
*Output path:* `build/app/outputs/flutter-apk/app-release.apk`

### Generate Split Per-ABI APKs (Smaller download size):
```bash
flutter build apk --split-per-abi --release
```

### Generate Android App Bundle (.aab) for Google Play:
```bash
flutter build appbundle --release
```
*Output path:* `build/app/outputs/bundle/release/app-release.aab`

---

## 📱 App Store & Play Store Readiness

- [x] **Material 3 Design Guidelines**: Fully compliant with fluid typography and dynamic surfaces.
- [x] **Zero Paid Dependencies**: Built 100% with open-source, permissive MIT/BSD packages.
- [x] **Privacy First**: No internet permissions required, zero analytics tracking.
- [x] **Adaptive Edge-to-Edge Navigation**: Supports gesture navigation on Android 14+ and iOS.
- [x] **AMOLED Dark Mode**: True pitch black for maximum power efficiency.
- [x] **Proactive Error Boundaries**: Resilient empty states and fallbacks.

---

## 🗺️ Future Roadmap

- [ ] Interactive Home Screen Widgets (iOS WidgetKit & Android AppWidgets)
- [ ] Export notes to Markdown (`.md`) and PDF
- [ ] Custom ambient soundscapes (rain, white noise, cafe) during focus sessions
- [ ] Encrypted local backup and restore (JSON/ZIP export)
- [ ] Wear OS / Apple Watch companion timer

---

## 🤝 Contributing

Contributions make the open-source community an inspiring place to learn, create, and build. Any contributions you make are **greatly appreciated**.

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'feat: add some amazing feature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

<div align="center">

Crafted with ❤️ for distraction-free minds.

</div>
