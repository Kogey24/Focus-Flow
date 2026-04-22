import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/utils/duration_formatter.dart';
import '../../domain/models/chapter.dart';
import '../../domain/models/material.dart';

class AudioDetailScreen extends StatelessWidget {
  const AudioDetailScreen({
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
            subtitle: Text('${chapters.length} tracks'),
            trailing: FilledButton(
              onPressed: () => context.push('/session?materialId=${material.id}&chapterId=$activeChapterId'),
              child: const Text('Play next'),
            ),
          ),
        ),
        const SizedBox(height: 16),
        ...chapters.map(
          (chapter) => Card(
            child: CheckboxListTile(
              value: chapter.isCompleted,
              onChanged: (_) => onToggleChapter(chapter.id),
              title: Text(chapter.title),
              subtitle: chapter.duration == null
                  ? null
                  : Text(DurationFormatter.asCompact(Duration(seconds: chapter.duration!))),
              secondary: const Icon(Icons.graphic_eq_rounded),
              controlAffinity: ListTileControlAffinity.trailing,
            ),
          ),
        ),
      ],
    );
  }
}
