import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/utils/duration_formatter.dart';
import '../../core/widgets/progress_bar.dart';
import '../../domain/models/chapter.dart';
import '../../domain/models/material.dart';

class VideoDetailScreen extends StatelessWidget {
  const VideoDetailScreen({
    super.key,
    required this.material,
    required this.chapters,
    required this.activeChapterId,
    required this.onToggleChapter,
  });

  final StudyMaterial material;
  final List<Chapter> chapters;
  final String? activeChapterId;
  final Future<void> Function(String chapterId) onToggleChapter;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: ListTile(
            leading: Icon(material.type.icon, size: 32),
            title: Text(material.title),
            subtitle: Text(material.author ?? '${chapters.length} episodes'),
            trailing: FilledButton(
              onPressed: () => context.push('/session?materialId=${material.id}&chapterId=$activeChapterId'),
              child: const Text('Resume'),
            ),
          ),
        ),
        const SizedBox(height: 16),
        ...chapters.map(
          (chapter) => Card(
            child: ListTile(
              leading: CircleAvatar(child: Text('${chapter.orderIndex + 1}')),
              title: Text(chapter.title),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (chapter.duration != null)
                    Text(DurationFormatter.asCompact(Duration(seconds: chapter.duration!))),
                  const SizedBox(height: 8),
                  ProgressBar(
                    value: chapter.isCompleted ? 1 : (chapter.id == activeChapterId ? 0.55 : 0),
                    type: material.type,
                  ),
                ],
              ),
              trailing: IconButton(
                onPressed: () => onToggleChapter(chapter.id),
                icon: Icon(
                  chapter.isCompleted ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                ),
              ),
              onTap: () => context.push('/session?materialId=${material.id}&chapterId=${chapter.id}'),
            ),
          ),
        ),
      ],
    );
  }
}
