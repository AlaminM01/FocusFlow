import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:focusflow/core/extensions/date_extensions.dart';
import 'package:focusflow/core/theme/app_theme.dart';
import 'package:focusflow/features/notes/domain/entities/note_entity.dart';
import 'package:focusflow/features/notes/presentation/pages/note_editor_page.dart';
import 'package:focusflow/features/notes/presentation/providers/notes_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Beautiful note card with glassmorphism touches and tag support.
class NoteCard extends ConsumerWidget {
  const NoteCard({
    super.key,
    required this.note,
    this.color,
    this.index = 0,
    this.onTap,
    this.onLongPress,
  });

  final NoteEntity note;
  final Color? color;
  final int index;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tt = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;
    final appColors =
        Theme.of(context).extension<AppColors>() ?? AppColors.dark;

    final noteColors = [
      appColors.noteCard1,
      appColors.noteCard2,
      appColors.noteCard3,
      appColors.noteCard4,
      appColors.noteCard5,
    ];
    final cardBg = color ?? noteColors[note.colorIndex % noteColors.length];

    return GestureDetector(
      onTap: onTap ??
          () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => NoteEditorPage(existingNote: note),
                ),
              ),
      onLongPress: onLongPress ?? () => _showOptions(context, ref),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: cs.outline.withOpacity(0.08),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tags row
            if (note.tags.isNotEmpty) ...[
              Wrap(
                spacing: 6,
                runSpacing: 4,
                children: note.tags
                    .take(3)
                    .map((tag) => Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: cs.onSurface.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '#$tag',
                            style: tt.labelSmall?.copyWith(
                              color: cs.onSurface.withOpacity(0.7),
                              fontSize: 10,
                            ),
                          ),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 8),
            ],

            // Title
            if (note.title.isNotEmpty) ...[
              Text(
                note.title,
                style: tt.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),
            ],

            // Content preview
            if (note.content.isNotEmpty)
              Text(
                note.content,
                style: tt.bodySmall?.copyWith(
                  color: cs.onSurface.withOpacity(0.65),
                  height: 1.45,
                ),
                maxLines: note.title.isEmpty ? 5 : 3,
                overflow: TextOverflow.ellipsis,
              ),

            const SizedBox(height: 12),

            // Bottom row
            Row(
              children: [
                Text(
                  note.updatedAt.friendlyDate,
                  style: tt.labelSmall?.copyWith(
                    color: cs.onSurface.withOpacity(0.4),
                  ),
                ),
                const Spacer(),
                if (note.isPinned)
                  Icon(
                    Icons.push_pin_rounded,
                    size: 15,
                    color: cs.primary,
                  ),
                if (note.isPinned) const SizedBox(width: 6),
                GestureDetector(
                  onTap: () =>
                      ref.read(notesProvider.notifier).toggleFavorite(note.id),
                  child: Icon(
                    note.isFavorite
                        ? Icons.favorite_rounded
                        : Icons.favorite_outline_rounded,
                    size: 16,
                    color: note.isFavorite
                        ? Colors.redAccent
                        : cs.onSurface.withOpacity(0.35),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 400.ms, delay: Duration(milliseconds: index * 50))
        .slideY(begin: 0.08, end: 0, curve: Curves.easeOut);
  }

  void _showOptions(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _NoteOptionsSheet(note: note, ref: ref),
    );
  }
}

class _NoteOptionsSheet extends StatelessWidget {
  const _NoteOptionsSheet({required this.note, required this.ref});
  final NoteEntity note;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: cs.onSurface.withOpacity(0.15),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          _OptionTile(
            icon: note.isPinned
                ? Icons.push_pin_outlined
                : Icons.push_pin_rounded,
            label: note.isPinned ? 'Unpin' : 'Pin',
            onTap: () {
              Navigator.pop(context);
              ref.read(notesProvider.notifier).togglePin(note.id);
            },
          ),
          _OptionTile(
            icon: note.isFavorite
                ? Icons.favorite_outline_rounded
                : Icons.favorite_rounded,
            label: note.isFavorite ? 'Unfavorite' : 'Favorite',
            onTap: () {
              Navigator.pop(context);
              ref.read(notesProvider.notifier).toggleFavorite(note.id);
            },
          ),
          _OptionTile(
            icon: Icons.delete_outline_rounded,
            label: 'Delete',
            color: AppTheme.errorColor,
            onTap: () {
              Navigator.pop(context);
              ref.read(notesProvider.notifier).deleteNote(note.id);
            },
          ),
        ],
      ),
    );
  }
}

class _OptionTile extends StatelessWidget {
  const _OptionTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
  });
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return ListTile(
      leading: Icon(icon, color: color ?? cs.onSurface),
      title: Text(
        label,
        style: TextStyle(
          color: color ?? cs.onSurface,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }
}
