# 🏛️ FocusFlow — System Architecture & Technical Diagrams

This document provides a comprehensive visual and architectural breakdown of **FocusFlow**, using **Mermaid.js** diagrams to illustrate system hierarchy, data lifecycles, state flows, and user journeys.

---

## 1. High-Level System Architecture

```mermaid
graph TB
    subgraph ClientDevice["📱 Mobile Client (Flutter Engine)"]
        subgraph UI["🎨 Presentation Layer (Material 3 + Glassmorphism)"]
            HomeView["🏠 Home Dashboard"]
            NotesView["📝 Notes Sanctuary"]
            TasksView["🎯 Daily Tasks"]
            FocusView["⏱️ Focus Timer"]
            InsightsView["📊 Habit Insights"]
            SettingsView["⚙️ Settings & Themes"]
        end

        subgraph StateLayer["⚡ State Layer (Riverpod 2.6)"]
            NotesNotifier["NotesNotifier\n(AsyncValue<List<NoteEntity>>)"]
            TasksNotifier["TasksNotifier\n(AsyncValue<List<TaskEntity>>)"]
            FocusTimerNotifier["FocusTimerNotifier\n(FocusTimerState)"]
            StreakNotifier["StreakNotifier\n(StreakEntity)"]
            SettingsNotifier["SettingsNotifier\n(SettingsState)"]
        end

        subgraph DomainLayer["🏛️ Domain Layer (Pure Dart)"]
            NoteEntity["NoteEntity"]
            TaskEntity["TaskEntity"]
            FocusEntity["FocusSessionEntity"]
            StreakEntity["StreakEntity"]
            QuoteEntity["QuoteEntity"]
            RepoInterfaces["Abstract Repositories"]
        end

        subgraph DataLayer["💾 Data Layer (Local Hive DB)"]
            NoteAdapters["TypeAdapter<NoteModel> (0)"]
            TaskAdapters["TypeAdapter<TaskModel> (1)\nTypeAdapter<TaskPriority> (4)"]
            FocusAdapters["TypeAdapter<FocusSessionModel> (2)"]
            StreakAdapters["TypeAdapter<StreakModel> (3)"]
            RepoImpls["Repository Implementations"]
        end

        subgraph LocalStorage["📦 Physical Binary Storage (*.hive)"]
            NotesBox[("notes_box.hive")]
            TasksBox[("tasks_box.hive")]
            FocusBox[("focus_sessions_box.hive")]
            StreaksBox[("streaks_box.hive")]
            SettingsBox[("settings_box.hive")]
        end
    end

    UI --> StateLayer
    StateLayer --> DomainLayer
    StateLayer --> RepoInterfaces
    RepoImpls --> RepoInterfaces
    RepoImpls --> DataLayer
    DataLayer --> LocalStorage
```

---

## 2. Clean Architecture Layer Hierarchy (Feature-First)

```mermaid
flowchart LR
    subgraph Presentation["1. Presentation Layer"]
        Widgets["Custom Widgets\n(GlassCard, TaskTile, NoteCard)"]
        Pages["Pages / Screens\n(HomePage, FocusPage, etc.)"]
        Notifiers["Riverpod Notifiers\n(StateNotifier)"]
    end

    subgraph Domain["2. Domain Layer (Pure Core)"]
        Entities["Domain Entities\n(NoteEntity, TaskEntity, etc.)"]
        Contracts["Repository Interfaces\n(NotesRepository, etc.)"]
    end

    subgraph Data["3. Data Layer"]
        Models["Hive Models & Adapters\n(NoteModel, TaskModel)"]
        Repositories["Repository Impls\n(NotesRepositoryImpl, etc.)"]
    end

    subgraph Storage["4. Hive Local Engine"]
        BinaryBoxes["Binary Boxes\n(Sub-millisecond disk access)"]
    end

    Presentation -->|Dispatches Actions| Domain
    Presentation -->|Observes State| Notifiers
    Repositories -->|Implements| Contracts
    Repositories -->|Maps to Entities| Entities
    Repositories -->|Serializes/Deserializes| Models
    Models -->|Reads/Writes Binary| Storage
```

---

## 3. Reactive State Flow (Riverpod & Hive)

```mermaid
sequenceDiagram
    autonumber
    actor User as User
    participant UI as Flutter Widget (TasksPage)
    participant Notifier as TasksNotifier (Riverpod)
    participant Repo as TasksRepositoryImpl
    participant Hive as Hive Box (tasks_box)
    participant Derived as taskProgressProvider

    User->>UI: Taps Checkbox on TaskTile
    UI->>Notifier: ref.read(tasksProvider.notifier).toggleTask(id)
    Notifier->>Repo: completeTask(id)
    Repo->>Hive: box.put(id, updatedTaskModel)
    Hive-->>Repo: Write Success
    Repo-->>Notifier: Returns updated TaskEntity list
    Notifier->>Notifier: state = AsyncValue.data(newTasks)
    Notifier-->>UI: Rebuilds TaskTile with checkmark animation
    Notifier-->>Derived: Triggers reactive re-evaluation
    Derived-->>UI: Updates CircularPercentIndicator (e.g. 75% -> 100%)
```

---

## 4. Focus Timer State Machine Lifecycle

```mermaid
stateDiagram-v2
    [*] --> Idle: App Startup / Reset
    
    Idle --> Running: start() [Launches Timer.periodic]
    
    Running --> Paused: pause() [Cancels Timer.periodic]
    Paused --> Running: resume() [Restarts Timer.periodic]
    
    Running --> Idle: stop() [Elapsed < 1m: Discard session]
    Paused --> Idle: stop() [Elapsed < 1m: Discard session]
    
    Running --> Completed: stop() [Elapsed >= 1m: Record session]
    Paused --> Completed: stop() [Elapsed >= 1m: Record session]
    
    Running --> Completed: remainingSeconds == 0 [_onComplete()]
    
    Completed --> Logging: Trigger automated logging
    Logging --> Idle: Logs session to Hive & Increments Streak
```

---

## 5. Daily Habit Streak State Machine

```mermaid
flowchart TD
    Start([User Completes Task or Focus Session]) --> QueryLastActive[Query lastActiveDate from streaks_box]
    
    QueryLastActive --> CheckNull{Is lastActiveDate null?}
    CheckNull -- Yes --> SetOne[Set currentStreak = 1]
    CheckNull -- No --> CalcDiff[Calculate difference in calendar days]
    
    CalcDiff --> DiffCases{Day Difference}
    DiffCases -- 0 Days (Same Day) --> MaintainStreak[Keep currentStreak unchanged]
    DiffCases -- 1 Day (Consecutive) --> IncStreak[Increment currentStreak += 1]
    DiffCases -- > 1 Day (Gap) --> ResetStreak[Reset currentStreak = 1]
    
    SetOne --> CheckRecord{currentStreak > longestStreak?}
    MaintainStreak --> CheckRecord
    IncStreak --> CheckRecord
    ResetStreak --> CheckRecord
    
    CheckRecord -- Yes --> UpdateRecord[longestStreak = currentStreak]
    CheckRecord -- No --> SaveDB[Update lastActiveDate = DateTime.now()]
    UpdateRecord --> SaveDB
    SaveDB --> Persist[Write StreakModel to streaks_box]
    Persist --> End([Reactive UI Update on Home & Insights])
```

---

## 6. End-to-End User Journey Map

```mermaid
journey
    title A Day in FocusFlow
    section Morning (Planning)
      Open FocusFlow: 5: User reads deterministic Stoic Quote on Home
      Review Daily Goals: 5: Checks priority tasks due today
      Add Focus Tasks: 4: Creates 3 High-priority tasks in TasksPage
    section Midday (Deep Work)
      Select Focus Mode: 5: Switches to 90m Deep Work mode in FocusPage
      Start Immersion: 5: Circular gradient ring counts down with ambient glow
      Session Complete: 5: Timer completes, session auto-saved, streak increments
    section Afternoon (Notes & Capture)
      Capture Ideas: 5: Opens NoteEditorPage, types project architecture
      Auto-Save: 5: Debouncer silently auto-saves note to Hive
      Add Custom Tint: 4: Selects Emerald canvas tint and #architecture tag
    section Evening (Reflection)
      Review Insights: 5: Opens InsightsPage to view 7-day focus chart
      Productivity Score: 5: Celebrates 95% Productivity Index score
```
