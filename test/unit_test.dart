import 'package:flutter_test/flutter_test.dart';
import 'package:focusflow/features/notes/domain/entities/note_entity.dart';
import 'package:focusflow/features/tasks/domain/entities/task_entity.dart';
import 'package:focusflow/features/focus/domain/entities/focus_session_entity.dart';
import 'package:focusflow/features/tracking/domain/entities/streak_entity.dart';
import 'package:focusflow/features/motivation/data/repositories/quotes_repository.dart';

void main() {
  group('Notes Entity Tests', () {
    test('NoteEntity creation and copyWith', () {
      final now = DateTime.now();
      final note = NoteEntity(
        id: '1',
        title: 'Deep Focus Habits',
        content: 'Distraction-free environment leads to flow state.',
        createdAt: now,
        updatedAt: now,
        isPinned: false,
        isFavorite: true,
        colorIndex: 2,
        tags: ['productivity', 'habits'],
      );

      expect(note.id, '1');
      expect(note.title, 'Deep Focus Habits');
      expect(note.isFavorite, true);
      expect(note.tags.length, 2);

      final updated = note.copyWith(title: 'Mastering Flow');
      expect(updated.title, 'Mastering Flow');
      expect(updated.isFavorite, true);
    });
  });

  group('Tasks Entity Tests', () {
    test('TaskEntity priority and completion toggling', () {
      final task = TaskEntity(
        id: 't-101',
        title: 'Complete architecture review',
        description: 'Verify Clean Architecture boundaries',
        createdAt: DateTime.now(),
        priority: TaskPriority.urgent,
        isCompleted: false,
      );

      expect(task.priority, TaskPriority.urgent);
      expect(task.isCompleted, false);

      final completed = task.copyWith(
        isCompleted: true,
        completedAt: DateTime.now(),
      );
      expect(completed.isCompleted, true);
      expect(completed.completedAt, isNotNull);
    });
  });

  group('Focus Session Entity Tests', () {
    test('FocusSession duration calculation', () {
      final start = DateTime.now().subtract(const Duration(minutes: 25));
      final end = DateTime.now();
      final session = FocusSessionEntity(
        id: 'f-1',
        startTime: start,
        endTime: end,
        durationMinutes: 25,
        sessionType: 'pomodoro',
        isCompleted: true,
      );

      expect(session.durationMinutes, 25);
      expect(session.sessionType, 'pomodoro');
      expect(session.isCompleted, true);
    });
  });

  group('Streak Entity Tests', () {
    test('StreakEntity active calculation', () {
      const streak = StreakEntity(
        currentStreak: 5,
        longestStreak: 12,
        totalFocusMinutes: 250,
        totalTasksCompleted: 18,
      );

      expect(streak.currentStreak, 5);
      expect(streak.longestStreak, 12);
      expect(streak.totalFocusHours, 250 / 60.0);
    });
  });

  group('Motivational Quotes Tests', () {
    test('QuotesRepository contains over 50 curated quotes', () {
      final quotes = QuotesRepository.getAllQuotes();
      expect(quotes.length, greaterThanOrEqualTo(50));
      expect(quotes.any((q) => q.author == 'Marcus Aurelius'), isTrue);
      expect(quotes.any((q) => q.author == 'James Clear'), isTrue);
      expect(quotes.any((q) => q.author == 'Naval Ravikant'), isTrue);
    });

    test('Daily quote returns valid deterministic quote', () {
      final daily = QuotesRepository.getDailyQuote();
      expect(daily.quote.isNotEmpty, isTrue);
      expect(daily.author.isNotEmpty, isTrue);
    });
  });
}
