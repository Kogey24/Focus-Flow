import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/utils/chapter_tree.dart';
import '../../core/widgets/chapter_tile.dart';
import '../../core/widgets/progress_bar.dart';
import '../../domain/models/chapter.dart';
import '../../domain/models/material.dart';

class BookDetailScreen extends StatelessWidget {
  const BookDetailScreen({
    super.key,
    required this.material,
    required this.chapters,
    required this.activeChapterId,
    required this.onToggleChapter,
    required this.onAddNote,
  });

  final StudyMaterial material;
  final List<Chapter> chapters;
  final String? activeChapterId;
  final Future<void> Function(String chapterId) onToggleChapter;
  final Future<void> Function(String chapterId, String note) onAddNote;

  @override
  Widget build(BuildContext context) {
    final chapterTree = ChapterTree.fromChapters(chapters);
    final activeLeafId = chapterTree.normalizeToLeafId(activeChapterId);
    final expandedIds = chapterTree.ancestorIdsOf(activeLeafId).toSet();

    return _MaterialDetailShell(
      material: material,
      buttonLabel: 'Build focus queue',
      buttonAction: activeLeafId == null
          ? null
          : () => context.push(
              Uri(
                path: '/session',
                queryParameters: {
                  'materialId': material.id,
                  'chapterId': activeLeafId,
                },
              ).toString(),
            ),
      child: chapterTree.roots.isEmpty
          ? const SizedBox.shrink()
          : Column(
              children: chapterTree.roots
                  .map(
                    (node) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _BookChapterNodeTile(
                        node: node,
                        tree: chapterTree,
                        activeLeafId: activeLeafId,
                        expandedIds: expandedIds,
                        onToggleChapter: onToggleChapter,
                        onAddNote: (chapter) =>
                            _showNoteDialog(context, chapter),
                        onOpenSession: (chapterId) {
                          context.push(
                            Uri(
                              path: '/session',
                              queryParameters: {
                                'materialId': material.id,
                                'chapterId': chapterId,
                              },
                            ).toString(),
                          );
                        },
                      ),
                    ),
                  )
                  .toList(growable: false),
            ),
    );
  }

  Future<void> _showNoteDialog(BuildContext context, Chapter chapter) async {
    final controller = TextEditingController(text: chapter.note ?? '');
    final note = await showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Note for ${chapter.title}'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Add chapter note'),
          maxLines: 4,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(controller.text),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    if (note == null || note.trim().isEmpty) return;
    await onAddNote(chapter.id, note);
  }
}

class _BookChapterNodeTile extends StatelessWidget {
  const _BookChapterNodeTile({
    required this.node,
    required this.tree,
    required this.activeLeafId,
    required this.expandedIds,
    required this.onToggleChapter,
    required this.onAddNote,
    required this.onOpenSession,
  });

  final ChapterTreeNode node;
  final ChapterTree tree;
  final String? activeLeafId;
  final Set<String> expandedIds;
  final Future<void> Function(String chapterId) onToggleChapter;
  final Future<void> Function(Chapter chapter) onAddNote;
  final void Function(String chapterId) onOpenSession;

  @override
  Widget build(BuildContext context) {
    if (node.isLeaf) {
      return ChapterTile(
        title: node.chapter.title,
        subtitle: _leafSubtitle(node.chapter),
        isCompleted: node.chapter.isCompleted,
        isActive: node.chapter.id == activeLeafId,
        indentLevel: tree.depthOf(node.chapter.id),
        onTap: () => onOpenSession(node.chapter.id),
        onToggle: () => onToggleChapter(node.chapter.id),
        onLongPress: () => onAddNote(node.chapter),
      );
    }

    final completedLeaves = tree.completedLeafCount(node.chapter.id);
    final totalLeaves = tree.leafCount(node.chapter.id);
    final subtitleParts = <String>[
      if (totalLeaves > 0) '$completedLeaves / $totalLeaves complete',
      if (_totalDurationLabel(node.chapter.id) != null)
        _totalDurationLabel(node.chapter.id)!,
      if (_pageRange(node.chapter) != null) _pageRange(node.chapter)!,
    ];

    return Card(
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          key: PageStorageKey(node.chapter.id),
          initiallyExpanded: expandedIds.contains(node.chapter.id),
          tilePadding: const EdgeInsets.symmetric(horizontal: 8),
          childrenPadding: const EdgeInsets.only(bottom: 4),
          leading: Checkbox(
            value: tree.isEffectivelyCompleted(node.chapter.id),
            onChanged: (_) => onToggleChapter(node.chapter.id),
          ),
          title: Text(
            node.chapter.title,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: expandedIds.contains(node.chapter.id)
                  ? FontWeight.w700
                  : FontWeight.w600,
            ),
          ),
          subtitle: subtitleParts.isEmpty
              ? null
              : Text(
                  subtitleParts.join('  -  '),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
          children: node.children
              .map(
                (child) => Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
                  child: _BookChapterNodeTile(
                    node: child,
                    tree: tree,
                    activeLeafId: activeLeafId,
                    expandedIds: expandedIds,
                    onToggleChapter: onToggleChapter,
                    onAddNote: onAddNote,
                    onOpenSession: onOpenSession,
                  ),
                ),
              )
              .toList(growable: false),
        ),
      ),
    );
  }

  String? _leafSubtitle(Chapter chapter) {
    final pageRange = _pageRange(chapter);
    final durationLabel = _durationLabel(chapter.duration);
    final detail = durationLabel ?? pageRange;

    if (detail != null && (chapter.note ?? '').trim().isNotEmpty) {
      return '$detail - ${chapter.note}';
    }
    return detail ?? chapter.note;
  }

  String? _pageRange(Chapter chapter) {
    if (chapter.pageStart == null) return null;
    return 'Pages ${chapter.pageStart}-${chapter.pageEnd ?? chapter.pageStart}';
  }

  String? _totalDurationLabel(String chapterId) {
    final leaves = tree.leafDescendantsOf(chapterId);
    var total = 0;
    var hasAnyDuration = false;
    for (final leaf in leaves) {
      if (leaf.duration == null) continue;
      total += leaf.duration!;
      hasAnyDuration = true;
    }
    if (!hasAnyDuration) return null;
    return _durationLabel(total);
  }

  String? _durationLabel(int? seconds) {
    if (seconds == null || seconds <= 0) return null;
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final remainingSeconds = seconds % 60;

    if (hours > 0) {
      return remainingSeconds == 0
          ? '${hours}h ${minutes}m'
          : '${hours}h ${minutes}m ${remainingSeconds}s';
    }
    if (minutes > 0) {
      return remainingSeconds == 0
          ? '${minutes}m'
          : '${minutes}m ${remainingSeconds}s';
    }
    return '${remainingSeconds}s';
  }
}

class _MaterialDetailShell extends StatelessWidget {
  const _MaterialDetailShell({
    required this.material,
    required this.buttonLabel,
    required this.buttonAction,
    required this.child,
  });

  final StudyMaterial material;
  final String buttonLabel;
  final VoidCallback? buttonAction;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(material.type.icon, size: 42),
                const SizedBox(height: 12),
                Text(
                  material.title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                if ((material.author ?? '').isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(material.author!),
                ],
                if ((material.filePath ?? '').startsWith('http')) ...[
                  const SizedBox(height: 4),
                  Text(
                    material.filePath!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
                const SizedBox(height: 12),
                ProgressBar(value: material.progress, type: material.type),
                const SizedBox(height: 8),
                Text('${(material.progress * 100).round()}% complete'),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        child,
        const SizedBox(height: 20),
        FilledButton(onPressed: buttonAction, child: Text(buttonLabel)),
      ],
    );
  }
}
