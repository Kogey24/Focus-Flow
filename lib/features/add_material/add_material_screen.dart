import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:path/path.dart' as path;

import '../../core/constants/app_dimensions.dart';
import '../../core/utils/chapter_tree.dart';
import '../../core/widgets/empty_state_widget.dart';
import '../../core/widgets/filter_chip_row.dart';
import '../../domain/enums/material_type.dart' as study;
import '../../domain/models/chapter.dart';
import '../home/home_notifier.dart';
import '../library/library_notifier.dart';
import 'add_material_notifier.dart';
import 'add_material_state.dart';

class AddMaterialScreen extends ConsumerWidget {
  const AddMaterialScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(addMaterialNotifierProvider);
    final notifier = ref.read(addMaterialNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            if (context.canPop()) {
              context.pop();
              return;
            }
            context.go('/library');
          },
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        title: const Text('Add material'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppDimensions.spacing16),
        child: state.when(
          data: (addState) {
            final chapterTree = ChapterTree.fromChapters(addState.chapters);
            final chapterIndexById = <String, int>{
              for (final entry in addState.chapters.asMap().entries) entry.value.id: entry.key,
            };
            return ListView(
              children: [
                Text(
                  'Type',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 12),
                FilterChipRow<study.MaterialType>(
                  values: study.MaterialType.values,
                  selected: addState.type,
                  labelBuilder: (type) => type.label,
                  onSelected: notifier.setType,
                ),
                const SizedBox(height: 20),
                if (addState.type != study.MaterialType.course) ...[
                  Row(
                    children: [
                      Expanded(
                        child: FilledButton.tonalIcon(
                          onPressed: notifier.pickFiles,
                          icon: const Icon(Icons.upload_file_rounded),
                          label: Text(addState.type == study.MaterialType.book ? 'Upload file' : 'Pick files'),
                        ),
                      ),
                      if (addState.type == study.MaterialType.video || addState.type == study.MaterialType.audio) ...[
                        const SizedBox(width: 12),
                        Expanded(
                          child: FilledButton.tonalIcon(
                            onPressed: notifier.pickFolder,
                            icon: const Icon(Icons.folder_open_rounded),
                            label: const Text('Pick folder'),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 12),
                ],
                TextField(
                  decoration: const InputDecoration(labelText: 'Title'),
                  onChanged: notifier.setTitle,
                ),
                const SizedBox(height: 12),
                TextField(
                  decoration: InputDecoration(
                    labelText: addState.type == study.MaterialType.course ? 'Source / URL / description' : 'Author / source',
                  ),
                  onChanged: (value) {
                    notifier.setAuthor(value);
                    if (addState.type == study.MaterialType.course) {
                      notifier.setSource(value);
                    }
                  },
                ),
                if (addState.selectedFolderPath != null &&
                    (addState.type == study.MaterialType.video || addState.type == study.MaterialType.audio)) ...[
                  const SizedBox(height: 16),
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.folder_open_rounded),
                      title: Text(path.basename(addState.selectedFolderPath!)),
                      subtitle: Text(_folderSummaryMessage(addState)),
                    ),
                  ),
                ],
                if (addState.type != study.MaterialType.course) ...[
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        addState.type == study.MaterialType.book ? 'Chapters' : 'Episodes / tracks',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      TextButton.icon(
                        onPressed: notifier.addManualChapter,
                        icon: const Icon(Icons.add_rounded),
                        label: const Text('Add manual'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (addState.chapters.isEmpty)
                    EmptyStateWidget(
                      title: addState.selectedFolderPath != null &&
                              (addState.type == study.MaterialType.video || addState.type == study.MaterialType.audio)
                          ? 'No supported files found'
                          : 'No structure yet',
                      message: addState.selectedFolderPath != null &&
                              (addState.type == study.MaterialType.video || addState.type == study.MaterialType.audio)
                          ? _emptyFolderMessage(addState)
                          : 'Upload a file or add manual chapters to shape the material.',
                      icon: addState.selectedFolderPath != null
                          ? Icons.folder_off_rounded
                          : Icons.list_alt_rounded,
                    )
                  else if (addState.type == study.MaterialType.book)
                    Theme(
                      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                      child: Column(
                        children: chapterTree.roots
                            .map(
                              (node) => Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: _BookStructureNodeEditor(
                                  node: node,
                                  chapterTree: chapterTree,
                                  chapterIndexById: chapterIndexById,
                                  onTitleChanged: (chapterId, title) {
                                    final index = chapterIndexById[chapterId];
                                    if (index == null) return;
                                    notifier.updateChapterTitle(index, title);
                                  },
                                  onRemove: (chapterId) {
                                    final index = chapterIndexById[chapterId];
                                    if (index == null) return;
                                    notifier.removeChapter(index);
                                  },
                                ),
                              ),
                            )
                            .toList(growable: false),
                      ),
                    )
                  else
                    ...addState.chapters.asMap().entries.map(
                      (entry) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Card(
                          child: ListTile(
                            leading: CircleAvatar(child: Text('${entry.key + 1}')),
                            title: TextFormField(
                              initialValue: entry.value.title,
                              decoration: const InputDecoration(border: InputBorder.none),
                              onChanged: (value) => notifier.updateChapterTitle(entry.key, value),
                            ),
                            subtitle: entry.value.duration == null
                                ? (entry.value.pageStart == null
                                    ? null
                                    : Text('Pages ${entry.value.pageStart}-${entry.value.pageEnd ?? entry.value.pageStart}'))
                                : Text('${entry.value.duration} seconds'),
                            trailing: IconButton(
                              onPressed: () => notifier.removeChapter(entry.key),
                              icon: const Icon(Icons.close_rounded),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: addState.isSaving
                      ? null
                      : () async {
                          final materialId = await ref.read(addMaterialNotifierProvider.notifier).save();
                          if (materialId == null || !context.mounted) return;
                          ref.invalidate(libraryNotifierProvider);
                          ref.invalidate(homeNotifierProvider);
                          context.go('/library/$materialId');
                        },
                  child: Text(addState.isSaving ? 'Saving...' : 'Add to library'),
                ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => EmptyStateWidget(
            title: 'Add material failed',
            message: '$error',
            ctaLabel: 'Retry',
            onPressed: () => ref.invalidate(addMaterialNotifierProvider),
          ),
        ),
      ),
    );
  }

  String _folderSummaryMessage(AddMaterialState addState) {
    final materialLabel = addState.type.label.toLowerCase();
    final supportedCount = addState.selectedPaths.length;
    final ignoredCount = addState.folderIgnoredFilesCount ?? 0;
    final supportedLabel = supportedCount == 1 ? '$materialLabel file' : '$materialLabel files';
    final ignoredLabel = ignoredCount == 1 ? '1 unsupported file' : '$ignoredCount unsupported files';

    if (supportedCount == 0 && ignoredCount == 0) {
      return 'No files were found in the selected folder.';
    }
    if (supportedCount == 0) {
      return 'Found no supported $materialLabel files and ignored $ignoredLabel.';
    }
    if (ignoredCount == 0) {
      return 'Found $supportedCount supported $supportedLabel ready to import.';
    }
    return 'Found $supportedCount supported $supportedLabel ready to import and ignored $ignoredLabel.';
  }

  String _emptyFolderMessage(AddMaterialState addState) {
    final materialLabel = addState.type.label.toLowerCase();
    final ignoredCount = addState.folderIgnoredFilesCount ?? 0;
    if (ignoredCount == 0) {
      return 'The selected folder does not contain any files.';
    }
    final ignoredLabel = ignoredCount == 1 ? '1 unsupported file' : '$ignoredCount unsupported files';
    return 'The selected folder does not contain supported $materialLabel files. It ignored $ignoredLabel.';
  }
}

class _BookStructureNodeEditor extends StatelessWidget {
  const _BookStructureNodeEditor({
    required this.node,
    required this.chapterTree,
    required this.chapterIndexById,
    required this.onTitleChanged,
    required this.onRemove,
  });

  final ChapterTreeNode node;
  final ChapterTree chapterTree;
  final Map<String, int> chapterIndexById;
  final void Function(String chapterId, String title) onTitleChanged;
  final void Function(String chapterId) onRemove;

  @override
  Widget build(BuildContext context) {
    if (node.isLeaf) {
      final index = chapterIndexById[node.chapter.id];
      final subtitle = _chapterSubtitle(node.chapter);
      return Card(
        child: ListTile(
          leading: CircleAvatar(
            child: Text(index == null ? '-' : '${index + 1}'),
          ),
          title: TextFormField(
            initialValue: node.chapter.title,
            decoration: const InputDecoration(border: InputBorder.none),
            onChanged: (value) => onTitleChanged(node.chapter.id, value),
          ),
          subtitle: subtitle == null ? null : Text(subtitle),
          trailing: IconButton(
            onPressed: () => onRemove(node.chapter.id),
            icon: const Icon(Icons.close_rounded),
          ),
        ),
      );
    }

    final index = chapterIndexById[node.chapter.id];
    final descendantCount = chapterTree.leafCount(node.chapter.id);

    return Card(
      child: ExpansionTile(
        key: PageStorageKey('add-material-${node.chapter.id}'),
        tilePadding: const EdgeInsets.symmetric(horizontal: 8),
        childrenPadding: const EdgeInsets.only(left: 12, right: 12, bottom: 8),
        controlAffinity: ListTileControlAffinity.leading,
        title: TextFormField(
          initialValue: node.chapter.title,
          decoration: const InputDecoration(
            border: InputBorder.none,
            isDense: true,
          ),
          onChanged: (value) => onTitleChanged(node.chapter.id, value),
        ),
        subtitle: Text(
          _branchSubtitle(
            chapter: node.chapter,
            descendantCount: descendantCount,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (index != null)
              Padding(
                padding: const EdgeInsets.only(right: 4),
                child: CircleAvatar(
                  radius: 14,
                  child: Text(
                    '${index + 1}',
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ),
              ),
            IconButton(
              onPressed: () => onRemove(node.chapter.id),
              icon: const Icon(Icons.close_rounded),
            ),
          ],
        ),
        children: node.children
            .map(
              (child) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _BookStructureNodeEditor(
                  node: child,
                  chapterTree: chapterTree,
                  chapterIndexById: chapterIndexById,
                  onTitleChanged: onTitleChanged,
                  onRemove: onRemove,
                ),
              ),
            )
            .toList(growable: false),
      ),
    );
  }

  String _branchSubtitle({
    required Chapter chapter,
    required int descendantCount,
  }) {
    final pageLabel = _pageLabel(chapter.pageStart, chapter.pageEnd);
    final countLabel = descendantCount == 1 ? '1 nested item' : '$descendantCount nested items';
    return pageLabel == null ? countLabel : '$countLabel  -  $pageLabel';
  }

  String? _chapterSubtitle(Chapter chapter) {
    if (chapter.duration != null) {
      return '${chapter.duration} seconds';
    }
    return _pageLabel(chapter.pageStart, chapter.pageEnd);
  }

  String? _pageLabel(int? pageStart, int? pageEnd) {
    if (pageStart == null) return null;
    return 'Pages $pageStart-${pageEnd ?? pageStart}';
  }
}
