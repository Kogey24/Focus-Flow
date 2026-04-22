import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_dimensions.dart';
import '../../core/utils/chapter_tree.dart';
import '../../core/widgets/empty_state_widget.dart';
import '../../core/widgets/filter_chip_row.dart';
import '../../domain/enums/material_type.dart' as study;
import '../home/home_notifier.dart';
import '../library/library_notifier.dart';
import 'add_material_notifier.dart';

class AddMaterialScreen extends ConsumerWidget {
  const AddMaterialScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(addMaterialNotifierProvider);

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
                  onSelected: (type) => ref.read(addMaterialNotifierProvider.notifier).setType(type),
                ),
                const SizedBox(height: 20),
                if (addState.type != study.MaterialType.course) ...[
                  Row(
                    children: [
                      Expanded(
                        child: FilledButton.tonalIcon(
                          onPressed: () => ref.read(addMaterialNotifierProvider.notifier).pickFiles(),
                          icon: const Icon(Icons.upload_file_rounded),
                          label: Text(addState.type == study.MaterialType.book ? 'Upload file' : 'Pick files'),
                        ),
                      ),
                      if (addState.type == study.MaterialType.video || addState.type == study.MaterialType.audio) ...[
                        const SizedBox(width: 12),
                        Expanded(
                          child: FilledButton.tonalIcon(
                            onPressed: () => ref.read(addMaterialNotifierProvider.notifier).pickFolder(),
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
                  onChanged: (value) => ref.read(addMaterialNotifierProvider.notifier).setTitle(value),
                ),
                const SizedBox(height: 12),
                TextField(
                  decoration: InputDecoration(
                    labelText: addState.type == study.MaterialType.course ? 'Source / URL / description' : 'Author / source',
                  ),
                  onChanged: (value) {
                    ref.read(addMaterialNotifierProvider.notifier).setAuthor(value);
                    if (addState.type == study.MaterialType.course) {
                      ref.read(addMaterialNotifierProvider.notifier).setSource(value);
                    }
                  },
                ),
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
                        onPressed: () => ref.read(addMaterialNotifierProvider.notifier).addManualChapter(),
                        icon: const Icon(Icons.add_rounded),
                        label: const Text('Add manual'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (addState.chapters.isEmpty)
                    const EmptyStateWidget(
                      title: 'No structure yet',
                      message: 'Upload a file or add manual chapters to shape the material.',
                      icon: Icons.list_alt_rounded,
                    )
                  else
                    ...addState.chapters.asMap().entries.map(
                      (entry) => Padding(
                        padding: EdgeInsets.only(left: chapterTree.depthOf(entry.value.id) * 16.0),
                        child: Card(
                          child: ListTile(
                            leading: CircleAvatar(child: Text('${entry.key + 1}')),
                            title: TextFormField(
                              initialValue: entry.value.title,
                              decoration: const InputDecoration(border: InputBorder.none),
                              onChanged: (value) {
                                ref.read(addMaterialNotifierProvider.notifier).updateChapterTitle(entry.key, value);
                              },
                            ),
                            subtitle: entry.value.duration == null
                                ? (entry.value.pageStart == null
                                    ? null
                                    : Text('Pages ${entry.value.pageStart}-${entry.value.pageEnd ?? entry.value.pageStart}'))
                                : Text('${entry.value.duration} seconds'),
                            trailing: IconButton(
                              onPressed: () => ref.read(addMaterialNotifierProvider.notifier).removeChapter(entry.key),
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
}
