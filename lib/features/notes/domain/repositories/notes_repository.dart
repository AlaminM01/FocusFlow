import '../entities/note_entity.dart';

/// Abstract contract for note persistence operations.
abstract class NotesRepository {
  /// Returns all notes sorted by pinned-first, then by updatedAt descending.
  Future<List<NoteEntity>> getAllNotes();

  /// Persists a new note.
  Future<void> saveNote(NoteEntity note);

  /// Permanently removes the note with [id].
  Future<void> deleteNote(String id);

  /// Overwrites an existing note with [note.id].
  Future<void> updateNote(NoteEntity note);
}
