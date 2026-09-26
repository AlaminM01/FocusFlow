import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:focusflow/core/theme/app_theme.dart';
import 'package:focusflow/core/widgets/empty_state_widget.dart';
import '../providers/notes_provider.dart';
import '../widgets/note_card.dart';
import 'note_editor_page.dart';
import '../../domain/entities/note_entity.dart';

class NotesPage extends ConsumerStatefulWidget {
  const NotesPage({super.key});

  @override
  ConsumerState<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends ConsumerState<NotesPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final notesAsync = ref.watch(notesProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openEditor(context, null),
        backgroundColor: colorScheme.primary,
        foregroundColor: Colors.white,
        child: const Icon(Icons.edit_note_rounded, size: 28),
      )
          .animate()
          .fadeIn(delay: 300.ms)
          .scale(begin: const Offset(0.8, 0.8), curve: Curves.easeOutBack),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // App bar
          SliverAppBar(
            expandedHeight: 120,
            pinned: true,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 24, bottom: 16),
              title: Text(
                'Notes & Ideas',
                style: textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),

          // Search bar
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
              child: TextField(
                controller: _searchController,
                onChanged: (v) =>
                    setState(() => _searchQuery = v.toLowerCase()),
                decoration: InputDecoration(
                  hintText: 'Search notes by title, content or tags...',
                  prefixIcon: Icon(Icons.search_rounded,
                      color: colorScheme.onSurface.withOpacity(0.4)),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: Icon(Icons.clear_rounded,
                              color: colorScheme.onSurface.withOpacity(0.4)),
                          onPressed: () {
                            _searchController.clear();
                            setState(() => _searchQuery = '');
                          },
                        )
                      : null,
                ),
              ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1),
            ),
          ),

          // Filter tabs
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: _FilterTabs(
                controller: _tabController,
                onChanged: () => setState(() {}),
              ),
            ),
          ),

          // Notes grid
          notesAsync.when(
            loading: () => const SliverToBoxAdapter(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(60),
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
            error: (e, _) => SliverToBoxAdapter(
              child: Center(child: Text('Error loading notes: $e')),
            ),
            data: (notes) {
              final filtered = _filterNotes(notes);
              if (filtered.isEmpty) {
                return SliverToBoxAdapter(
                  child: EmptyStateWidget(
                    icon: Icons.sticky_note_2_rounded,
                    title: _searchQuery.isNotEmpty
                        ? 'No matching notes found'
                        : 'Your canvas is clear',
                    subtitle: _searchQuery.isNotEmpty
                        ? 'Try modifying your search criteria'
                        : 'Tap the button below to capture your thoughts & insights',
                    actionLabel: _searchQuery.isEmpty ? 'Write Note' : null,
                    onAction: _searchQuery.isEmpty
                        ? () => _openEditor(context, null)
                        : null,
                  ),
                );
              }
              return SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 120),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => NoteCard(
                      note: filtered[index],
                      index: index,
                      onTap: () => _openEditor(context, filtered[index]),
                    ),
                    childCount: filtered.length,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  List<NoteEntity> _filterNotes(List<NoteEntity> notes) {
    List<NoteEntity> result = notes;

    // Tab filter
    switch (_tabController.index) {
      case 1:
        result = result.where((n) => n.isPinned).toList();
        break;
      case 2:
        result = result.where((n) => n.isFavorite).toList();
        break;
    }

    // Search filter
    if (_searchQuery.isNotEmpty) {
      result = result.where((n) {
        final titleMatch = n.title.toLowerCase().contains(_searchQuery);
        final contentMatch = n.content.toLowerCase().contains(_searchQuery);
        final tagMatch =
            n.tags.any((t) => t.toLowerCase().contains(_searchQuery));
        return titleMatch || contentMatch || tagMatch;
      }).toList();
    }

    // Sort: pinned first, then by date updated
    result.sort((a, b) {
      if (a.isPinned && !b.isPinned) return -1;
      if (!a.isPinned && b.isPinned) return 1;
      return b.updatedAt.compareTo(a.updatedAt);
    });

    return result;
  }

  void _openEditor(BuildContext context, NoteEntity? note) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => NoteEditorPage(existingNote: note),
      ),
    );
  }
}

class _FilterTabs extends StatelessWidget {
  final TabController controller;
  final VoidCallback onChanged;

  const _FilterTabs({required this.controller, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final labels = ['All Notes', 'Pinned', 'Favorites'];

    return Row(
      children: List.generate(labels.length, (i) {
        final isSelected = controller.index == i;
        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: GestureDetector(
            onTap: () {
              controller.animateTo(i);
              onChanged();
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? colorScheme.primary
                    : colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected
                      ? Colors.transparent
                      : colorScheme.outline.withOpacity(0.08),
                ),
              ),
              child: Text(
                labels[i],
                style: TextStyle(
                  color: isSelected
                      ? Colors.white
                      : colorScheme.onSurface.withOpacity(0.7),
                  fontWeight:
                      isSelected ? FontWeight.w600 : FontWeight.w500,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
