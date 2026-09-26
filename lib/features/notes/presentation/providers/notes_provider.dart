import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import '../../data/models/note_model.dart';
import '../../data/repositories/notes_repository_impl.dart';
import '../../domain/entities/note_entity.dart';
import '../../domain/repositories/notes_repository.dart';

// ──────────────────────────────────────────────
// Repository provider
// ──────────────────────────────────────────────

/// Provides the Hive-backed [NotesRepository].
final notesRepositoryProvider = Provider<NotesRepository>((ref) {
  final box = Hive.box<NoteModel>('notes');
  return NotesRepositoryImpl(box);
});

// ──────────────────────────────────────────────
// State notifier
// ──────────────────────────────────────────────

class NotesNotifier extends StateNotifier<AsyncValue<List<NoteEntity>>> {
  final NotesRepository _repository;
  final _uuid = const Uuid();

  NotesNotifier(this._repository) : super(const AsyncValue.loading()) {
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    try {
      state = const AsyncValue.loading();
      final notes = await _repository.getAllNotes();
      state = AsyncValue.data(notes);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Refresh the list from the local store.
  Future<void> refresh() => _loadNotes();

  /// Creates and saves a new note, then refreshes the list.
  Future<void> addNote({
    required String title,
    required String content,
    int colorIndex = 0,
    List<String> tags = const [],
  }) async {
    final now = DateTime.now();
    final note = NoteEntity(
      id: _uuid.v4(),
      title: title,
      content: content,
      createdAt: now,
      updatedAt: now,
      colorIndex: colorIndex,
      tags: tags,
    );
    await _repository.saveNote(note);
    await _loadNotes();
  }

  /// Updates an existing note and refreshes the list.
  Future<void> updateNote(NoteEntity note) async {
    final updated = note.copyWith(updatedAt: DateTime.now());
    await _repository.updateNote(updated);
    await _loadNotes();
  }

  /// Toggles [NoteEntity.isPinned] for the note with [id].
  Future<void> togglePin(String id) async {
    final notes = state.valueOrNull ?? [];
    final note = notes.firstWhere((n) => n.id == id);
    await updateNote(note.copyWith(isPinned: !note.isPinned));
  }

  /// Toggles [NoteEntity.isFavorite] for the note with [id].
  Future<void> toggleFavorite(String id) async {
    final notes = state.valueOrNull ?? [];
    final note = notes.firstWhere((n) => n.id == id);
    await updateNote(note.copyWith(isFavorite: !note.isFavorite));
  }

  /// Permanently deletes the note with [id].
  Future<void> deleteNote(String id) async {
    await _repository.deleteNote(id);
    await _loadNotes();
  }
}

// ──────────────────────────────────────────────
// Public providers
// ──────────────────────────────────────────────

/// Provides the full notes list as [AsyncValue<List<NoteEntity>>].
final notesProvider =
    StateNotifierProvider<NotesNotifier, AsyncValue<List<NoteEntity>>>((ref) {
  final repository = ref.read(notesRepositoryProvider);
  return NotesNotifier(repository);
});

/// Derived provider: only favourite notes.
final favouriteNotesProvider = Provider<List<NoteEntity>>((ref) {
  return ref.watch(notesProvider).valueOrNull?.where((n) => n.isFavorite).toList() ?? [];
});

/// Derived provider: notes whose title or content matches a search query.
final noteSearchProvider = Provider.family<List<NoteEntity>, String>((ref, query) {
  final all = ref.watch(notesProvider).valueOrNull ?? [];
  if (query.isEmpty) return all;
  final lower = query.toLowerCase();
  return all
      .where((n) =>
          n.title.toLowerCase().contains(lower) ||
          n.content.toLowerCase().contains(lower))
      .toList();
});
