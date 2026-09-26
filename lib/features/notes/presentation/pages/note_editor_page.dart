import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focusflow/core/theme/app_theme.dart';
import 'package:focusflow/core/utils/debouncer.dart';
import 'package:focusflow/core/extensions/date_extensions.dart';
import 'package:uuid/uuid.dart';
import '../providers/notes_provider.dart';
import '../../domain/entities/note_entity.dart';

class NoteEditorPage extends ConsumerStatefulWidget {
  final NoteEntity? existingNote;

  const NoteEditorPage({super.key, this.existingNote});

  @override
  ConsumerState<NoteEditorPage> createState() => _NoteEditorPageState();
}

class _NoteEditorPageState extends ConsumerState<NoteEditorPage> {
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;
  late final Debouncer _debouncer;
  late bool _isPinned;
  late bool _isFavorite;
  late int _colorIndex;
  late List<String> _tags;
  bool _hasChanges = false;
  bool _isSaving = false;

  final List<Color> _lightColors = const [
    Color(0xFFEEF2FF),
    Color(0xFFF0FDF4),
    Color(0xFFFFF7ED),
    Color(0xFFFDF4FF),
    Color(0xFFEFF6FF),
  ];

  @override
  void initState() {
    super.initState();
    final note = widget.existingNote;
    _titleController = TextEditingController(text: note?.title ?? '');
    _contentController = TextEditingController(text: note?.content ?? '');
    _isPinned = note?.isPinned ?? false;
    _isFavorite = note?.isFavorite ?? false;
    _colorIndex = note?.colorIndex ?? 0;
    _tags = List<String>.from(note?.tags ?? []);
    _debouncer = Debouncer(delay: const Duration(seconds: 1));

    _titleController.addListener(_onChanged);
    _contentController.addListener(_onChanged);
  }

  void _onChanged() {
    if (!_hasChanges) setState(() => _hasChanges = true);
    _debouncer(() => _save());
  }

  @override
  void dispose() {
    _debouncer.dispose();
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();
    if (title.isEmpty && content.isEmpty) return;

    setState(() => _isSaving = true);

    final notifier = ref.read(notesProvider.notifier);
    final now = DateTime.now();

    if (widget.existingNote != null) {
      await notifier.updateNote(widget.existingNote!.copyWith(
        title: title.isEmpty ? 'Untitled' : title,
        content: content,
        updatedAt: now,
        isPinned: _isPinned,
        isFavorite: _isFavorite,
        colorIndex: _colorIndex,
        tags: _tags,
      ));
    } else {
      await notifier.addNote(NoteEntity(
        id: const Uuid().v4(),
        title: title.isEmpty ? 'Untitled' : title,
        content: content,
        createdAt: now,
        updatedAt: now,
        isPinned: _isPinned,
        isFavorite: _isFavorite,
        colorIndex: _colorIndex,
        tags: _tags,
      ));
    }

    if (mounted) {
      setState(() {
        _isSaving = false;
        _hasChanges = false;
      });
    }
  }

  void _showAddTagDialog() {
    final tagCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Tag'),
        content: TextField(
          controller: tagCtrl,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'e.g. Ideas, Project, Personal'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final text = tagCtrl.text.trim().replaceAll('#', '');
              if (text.isNotEmpty && !_tags.contains(text)) {
                setState(() {
                  _tags.add(text);
                  _hasChanges = true;
                });
                _save();
              }
              Navigator.pop(ctx);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final noteColor = isDark
        ? Theme.of(context).scaffoldBackgroundColor
        : _lightColors[_colorIndex % _lightColors.length];

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) await _save();
      },
      child: Scaffold(
        backgroundColor: noteColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            onPressed: () async {
              await _save();
              if (context.mounted) Navigator.pop(context);
            },
          ),
          actions: [
            // Pin toggle
            IconButton(
              icon: Icon(
                _isPinned ? Icons.push_pin_rounded : Icons.push_pin_outlined,
                color: _isPinned ? colorScheme.primary : null,
              ),
              onPressed: () {
                setState(() {
                  _isPinned = !_isPinned;
                  _hasChanges = true;
                });
                _save();
              },
            ),
            // Favorite toggle
            IconButton(
              icon: Icon(
                _isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                color: _isFavorite ? Colors.redAccent : null,
              ),
              onPressed: () {
                setState(() {
                  _isFavorite = !_isFavorite;
                  _hasChanges = true;
                });
                _save();
              },
            ),
            // Delete
            if (widget.existingNote != null)
              IconButton(
                icon: const Icon(Icons.delete_outline_rounded, color: Colors.red),
                onPressed: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Delete Note?'),
                      content: const Text('This action cannot be undone.'),
                      actions: [
                        TextButton(
                            onPressed: () => Navigator.pop(ctx, false),
                            child: const Text('Cancel')),
                        TextButton(
                          onPressed: () => Navigator.pop(ctx, true),
                          child: const Text('Delete',
                              style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    ),
                  );
                  if (confirm == true && context.mounted) {
                    ref
                        .read(notesProvider.notifier)
                        .deleteNote(widget.existingNote!.id);
                    Navigator.pop(context);
                  }
                },
              ),
            // Save status indicator
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Center(
                child: _isSaving
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : _hasChanges
                        ? Icon(Icons.circle, size: 8, color: colorScheme.primary)
                        : Icon(Icons.check_rounded,
                            size: 18,
                            color: colorScheme.primary.withOpacity(0.6)),
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title input
                    TextField(
                      controller: _titleController,
                      style: textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        height: 1.2,
                      ),
                      maxLines: null,
                      decoration: InputDecoration(
                        hintText: 'Note Title',
                        hintStyle: textTheme.headlineSmall?.copyWith(
                          color: colorScheme.onSurface.withOpacity(0.3),
                          fontWeight: FontWeight.w700,
                        ),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        filled: false,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Timestamp
                    Text(
                      widget.existingNote?.updatedAt.friendlyDateTime ??
                          DateTime.now().friendlyDateTime,
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface.withOpacity(0.4),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Tag chips
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        ..._tags.map((tag) => Chip(
                              label: Text('#$tag'),
                              deleteIcon: const Icon(Icons.close, size: 14),
                              onDeleted: () {
                                setState(() {
                                  _tags.remove(tag);
                                  _hasChanges = true;
                                });
                                _save();
                              },
                              labelStyle: const TextStyle(fontSize: 12),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 4, vertical: 0),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            )),
                        ActionChip(
                          avatar: const Icon(Icons.add, size: 14),
                          label: const Text('Add Tag'),
                          onPressed: _showAddTagDialog,
                          labelStyle: const TextStyle(fontSize: 12),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Content input
                    TextField(
                      controller: _contentController,
                      style: textTheme.bodyLarge?.copyWith(height: 1.6),
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                        hintText: 'Write your thoughts without distractions...',
                        hintStyle: textTheme.bodyLarge?.copyWith(
                          color: colorScheme.onSurface.withOpacity(0.3),
                          height: 1.6,
                        ),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        filled: false,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),

            // Color picker bar
            _ColorPickerBar(
              selectedIndex: _colorIndex,
              colors: _lightColors,
              onSelected: (i) {
                setState(() {
                  _colorIndex = i;
                  _hasChanges = true;
                });
                _save();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ColorPickerBar extends StatelessWidget {
  final int selectedIndex;
  final List<Color> colors;
  final ValueChanged<int> onSelected;

  const _ColorPickerBar({
    required this.selectedIndex,
    required this.colors,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.paddingOf(context).bottom;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      height: 60 + bottomPad,
      padding:
          EdgeInsets.only(left: 20, right: 20, bottom: bottomPad + 6, top: 6),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          top: BorderSide(color: colorScheme.outline.withOpacity(0.08)),
        ),
      ),
      child: Row(
        children: [
          Text(
            'CANVAS TINT',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: colorScheme.onSurface.withOpacity(0.4),
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1,
                  fontSize: 10,
                ),
          ),
          const SizedBox(width: 16),
          ...List.generate(colors.length, (i) {
            final isSelected = i == selectedIndex;
            return GestureDetector(
              onTap: () => onSelected(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(right: 10),
                width: isSelected ? 34 : 26,
                height: isSelected ? 34 : 26,
                decoration: BoxDecoration(
                  color: colors[i],
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected
                        ? AppTheme.primaryColor
                        : Colors.black12,
                    width: isSelected ? 2.5 : 1,
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
