import 'package:hive/hive.dart';
import '../../domain/entities/note_entity.dart';
import '../../domain/repositories/notes_repository.dart';
import '../models/note_model.dart';

/// Hive-backed implementation of [NotesRepository].
class NotesRepositoryImpl implements NotesRepository {
  final Box<NoteModel> _box;

  const NotesRepositoryImpl(this._box);

  @override
  Future<List<NoteEntity>> getAllNotes() async {
    final models = _box.values.toList();
    // Pinned notes first, then sort by updatedAt descending.
    models.sort((a, b) {
      if (a.isPinned && !b.isPinned) return -1;
      if (!a.isPinned && b.isPinned) return 1;
      return b.updatedAt.compareTo(a.updatedAt);
    });
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<void> saveNote(NoteEntity note) async {
    final model = NoteModel.fromEntity(note);
    await _box.put(note.id, model);
  }

  @override
  Future<void> deleteNote(String id) async {
    await _box.delete(id);
  }

  @override
  Future<void> updateNote(NoteEntity note) async {
    final model = NoteModel.fromEntity(note);
    await _box.put(note.id, model);
  }
}
