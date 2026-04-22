import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/widgets/empty_state_widget.dart';
import '../../domain/enums/material_type.dart' as study;
import 'audio_detail_screen.dart';
import 'book_detail_screen.dart';
import 'material_detail_notifier.dart';
import 'video_detail_screen.dart';

class MaterialDetailScreen extends ConsumerWidget {
  const MaterialDetailScreen({
    super.key,
    required this.materialId,
  });

  final String materialId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(materialDetailNotifierProvider(materialId));

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
      ),
      body: state.when(
        data: (detail) {
          final notifier = ref.read(materialDetailNotifierProvider(materialId).notifier);
          return switch (detail.material.type) {
            study.MaterialType.book => BookDetailScreen(
                material: detail.material,
                chapters: detail.chapters,
                activeChapterId: detail.activeChapterId,
                onToggleChapter: notifier.toggleChapter,
                onAddNote: (chapterId, note) => notifier.addNote(
                  chapterId: chapterId,
                  note: note,
                ),
              ),
            study.MaterialType.video => VideoDetailScreen(
                material: detail.material,
                chapters: detail.chapters,
                activeChapterId: detail.activeChapterId,
                onToggleChapter: notifier.toggleChapter,
              ),
            study.MaterialType.audio => AudioDetailScreen(
                material: detail.material,
                chapters: detail.chapters,
                activeChapterId: detail.activeChapterId,
                onToggleChapter: notifier.toggleChapter,
              ),
            study.MaterialType.course => BookDetailScreen(
                material: detail.material,
                chapters: detail.chapters,
                activeChapterId: detail.activeChapterId,
                onToggleChapter: notifier.toggleChapter,
                onAddNote: (chapterId, note) => notifier.addNote(
                  chapterId: chapterId,
                  note: note,
                ),
              ),
          };
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => EmptyStateWidget(
          title: 'Material could not load',
          message: '$error',
          ctaLabel: 'Retry',
          onPressed: () => ref.invalidate(materialDetailNotifierProvider(materialId)),
        ),
      ),
    );
  }
}
