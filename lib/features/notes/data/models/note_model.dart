import 'package:hive/hive.dart';
import '../../domain/entities/note_entity.dart';

part 'note_model.g.dart';

@HiveType(typeId: 0)
class NoteModel extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String title;

  @HiveField(2)
  late String content;

  @HiveField(3)
  late DateTime createdAt;

  @HiveField(4)
  late DateTime updatedAt;

  @HiveField(5)
  late bool isPinned;

  @HiveField(6)
  late bool isFavorite;

  @HiveField(7)
  late int colorIndex;

  @HiveField(8)
  late List<String> tags;

  NoteModel({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    this.isPinned = false,
    this.isFavorite = false,
    this.colorIndex = 0,
    List<String>? tags,
  }) : tags = tags ?? [];

  /// Convert this model to a domain [NoteEntity].
  NoteEntity toEntity() {
    return NoteEntity(
      id: id,
      title: title,
      content: content,
      createdAt: createdAt,
      updatedAt: updatedAt,
      isPinned: isPinned,
      isFavorite: isFavorite,
      colorIndex: colorIndex,
      tags: List<String>.from(tags),
    );
  }

  /// Build a [NoteModel] from a domain [NoteEntity].
  factory NoteModel.fromEntity(NoteEntity entity) {
    return NoteModel(
      id: entity.id,
      title: entity.title,
      content: entity.content,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      isPinned: entity.isPinned,
      isFavorite: entity.isFavorite,
      colorIndex: entity.colorIndex,
      tags: List<String>.from(entity.tags),
    );
  }
}
