import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import '../../data/models/focus_session_model.dart';
import '../../data/repositories/focus_repository_impl.dart';
import '../../domain/entities/focus_session_entity.dart';
import '../../domain/repositories/focus_repository.dart';

// ──────────────────────────────────────────────
// Repository provider
// ──────────────────────────────────────────────

/// Provides the Hive-backed [FocusRepository].
final focusRepositoryProvider = Provider<FocusRepository>((ref) {
  final box = Hive.box<FocusSessionModel>('focus_sessions');
  return FocusRepositoryImpl(box);
});

// ──────────────────────────────────────────────
// Sessions list provider
// ──────────────────────────────────────────────

class FocusNotifier
    extends StateNotifier<AsyncValue<List<FocusSessionEntity>>> {
  final FocusRepository _repository;
  final _uuid = const Uuid();

  FocusNotifier(this._repository) : super(const AsyncValue.loading()) {
    _load();
  }

  Future<void> _load() async {
    try {
      state = const AsyncValue.loading();
      final sessions = await _repository.getAllSessions();
      state = AsyncValue.data(sessions);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> refresh() => _load();

  Future<void> saveSession(FocusSessionEntity session) async {
    await _repository.saveSession(session);
    await _load();
  }

  Future<void> deleteSession(String id) async {
    await _repository.deleteSession(id);
    await _load();
  }

  /// Convenience: record a completed session directly from the timer state.
  Future<void> recordCompletedSession({
    required String sessionType,
    required int durationMinutes,
    required DateTime startTime,
  }) async {
    final now = DateTime.now();
    final session = FocusSessionEntity(
      id: _uuid.v4(),
      startTime: startTime,
      endTime: now,
      durationMinutes: durationMinutes,
      sessionType: sessionType,
      isCompleted: true,
    );
    await saveSession(session);
  }
}

final focusSessionsProvider = StateNotifierProvider<FocusNotifier,
    AsyncValue<List<FocusSessionEntity>>>((ref) {
  final repository = ref.read(focusRepositoryProvider);
  return FocusNotifier(repository);
});

// ──────────────────────────────────────────────
// Timer state + notifier
// ──────────────────────────────────────────────

/// Immutable state for the active focus timer.
class FocusTimerState {
  final int remainingSeconds;
  final bool isRunning;
  final bool isPaused;
  final String sessionType; // 'pomodoro' | 'deepwork' | 'break'
  final int totalSeconds;
  final DateTime? sessionStartTime;

  const FocusTimerState({
    required this.remainingSeconds,
    required this.isRunning,
    required this.isPaused,
    required this.sessionType,
    required this.totalSeconds,
    this.sessionStartTime,
  });

  FocusTimerState copyWith({
    int? remainingSeconds,
    bool? isRunning,
    bool? isPaused,
    String? sessionType,
    int? totalSeconds,
    DateTime? sessionStartTime,
  }) {
    return FocusTimerState(
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      isRunning: isRunning ?? this.isRunning,
      isPaused: isPaused ?? this.isPaused,
      sessionType: sessionType ?? this.sessionType,
      totalSeconds: totalSeconds ?? this.totalSeconds,
      sessionStartTime: sessionStartTime ?? this.sessionStartTime,
    );
  }

  /// Progress from 1.0 → 0.0 as the timer counts down.
  double get progress =>
      totalSeconds == 0 ? 0.0 : remainingSeconds / totalSeconds;

  int get elapsedSeconds => totalSeconds - remainingSeconds;

  int get elapsedMinutes => elapsedSeconds ~/ 60;

  static FocusTimerState initial({
    String sessionType = 'pomodoro',
    int totalSeconds = 25 * 60,
  }) {
    return FocusTimerState(
      remainingSeconds: totalSeconds,
      isRunning: false,
      isPaused: false,
      sessionType: sessionType,
      totalSeconds: totalSeconds,
    );
  }
}

class FocusTimerNotifier extends StateNotifier<FocusTimerState> {
  Timer? _timer;
  final Ref _ref;

  FocusTimerNotifier(this._ref)
      : super(FocusTimerState.initial());

  // ── Public controls ──────────────────────────

  /// Start (or restart) a new session.
  void start({required String sessionType, required int durationMinutes}) {
    _cancelTimer();
    final totalSeconds = durationMinutes * 60;
    state = FocusTimerState(
      remainingSeconds: totalSeconds,
      isRunning: true,
      isPaused: false,
      sessionType: sessionType,
      totalSeconds: totalSeconds,
      sessionStartTime: DateTime.now(),
    );
    _startTicking();
  }

  void pause() {
    if (!state.isRunning || state.isPaused) return;
    _cancelTimer();
    state = state.copyWith(isRunning: false, isPaused: true);
  }

  void resume() {
    if (!state.isPaused) return;
    state = state.copyWith(isRunning: true, isPaused: false);
    _startTicking();
  }

  /// Stop and optionally save the session if enough time elapsed.
  Future<void> stop({bool save = true}) async {
    final elapsed = state.elapsedMinutes;
    final sessionType = state.sessionType;
    final startTime = state.sessionStartTime;
    _cancelTimer();
    state = FocusTimerState.initial();

    if (save && elapsed >= 1 && startTime != null) {
      await _ref.read(focusSessionsProvider.notifier).recordCompletedSession(
            sessionType: sessionType,
            durationMinutes: elapsed,
            startTime: startTime,
          );
    }
  }

  /// Called by the internal timer every second.
  Future<void> tick() async {
    if (state.remainingSeconds <= 1) {
      // Session complete.
      await _onComplete();
    } else {
      state = state.copyWith(remainingSeconds: state.remainingSeconds - 1);
    }
  }

  // ── Private ──────────────────────────────────

  void _startTicking() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => tick());
  }

  void _cancelTimer() {
    _timer?.cancel();
    _timer = null;
  }

  Future<void> _onComplete() async {
    _cancelTimer();
    final sessionType = state.sessionType;
    final totalMinutes = state.totalSeconds ~/ 60;
    final startTime = state.sessionStartTime;

    state = state.copyWith(remainingSeconds: 0, isRunning: false);

    if (startTime != null) {
      await _ref.read(focusSessionsProvider.notifier).recordCompletedSession(
            sessionType: sessionType,
            durationMinutes: totalMinutes,
            startTime: startTime,
          );
    }

    // Reset to idle.
    state = FocusTimerState.initial(
        sessionType: sessionType, totalSeconds: state.totalSeconds);
  }

  @override
  void dispose() {
    _cancelTimer();
    super.dispose();
  }
}

/// Provides the live focus timer state.
final activeFocusTimerProvider =
    StateNotifierProvider<FocusTimerNotifier, FocusTimerState>((ref) {
  return FocusTimerNotifier(ref);
});

// ──────────────────────────────────────────────
// Derived providers
// ──────────────────────────────────────────────

/// Total focus minutes recorded today.
final todayFocusMinutesProvider = Provider<int>((ref) {
  final sessions = ref.watch(focusSessionsProvider).valueOrNull ?? [];
  final now = DateTime.now();
  return sessions
      .where((s) =>
          s.isCompleted &&
          s.startTime.year == now.year &&
          s.startTime.month == now.month &&
          s.startTime.day == now.day)
      .fold<int>(0, (sum, s) => sum + s.durationMinutes);
});

/// Number of Pomodoro sessions completed today.
final todayPomodoroCountProvider = Provider<int>((ref) {
  final sessions = ref.watch(focusSessionsProvider).valueOrNull ?? [];
  final now = DateTime.now();
  return sessions
      .where((s) =>
          s.isCompleted &&
          s.sessionType == 'pomodoro' &&
          s.startTime.year == now.year &&
          s.startTime.month == now.month &&
          s.startTime.day == now.day)
      .length;
});
