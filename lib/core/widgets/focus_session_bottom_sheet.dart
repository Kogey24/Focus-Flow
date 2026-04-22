import 'package:flutter/material.dart';

import '../utils/chapter_tree.dart';
import '../../domain/models/chapter.dart';
import '../../domain/models/material.dart';

class FocusSessionBottomSheet extends StatefulWidget {
  const FocusSessionBottomSheet({
    super.key,
    required this.materials,
    required this.initialMaterialId,
    required this.chapters,
    required this.initialChapterId,
    required this.initialDurationMinutes,
  });

  final List<StudyMaterial> materials;
  final String? initialMaterialId;
  final List<Chapter> chapters;
  final String? initialChapterId;
  final int initialDurationMinutes;

  @override
  State<FocusSessionBottomSheet> createState() => _FocusSessionBottomSheetState();
}

class _FocusSessionBottomSheetState extends State<FocusSessionBottomSheet> {
  late String? _materialId = widget.initialMaterialId;
  late double _durationMinutes = widget.initialDurationMinutes.toDouble();
  late String? _chapterId;

  ChapterTree get _chapterTree => ChapterTree.fromChapters(widget.chapters);

  @override
  void initState() {
    super.initState();
    _chapterId = _chapterTree.normalizeToLeafId(widget.initialChapterId);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final leafChapters = _chapterTree.leafChapters();
    final selectedChapterId = _chapterTree.normalizeToLeafId(_chapterId);

    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Set up focus session',
            style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: _materialId,
            decoration: const InputDecoration(labelText: 'Material'),
            items: widget.materials
                .map(
                  (material) => DropdownMenuItem<String>(
                    value: material.id,
                    child: Text(material.title),
                  ),
                )
                .toList(),
            onChanged: (value) => setState(() {
              _materialId = value;
              _chapterId = null;
            }),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: selectedChapterId,
            decoration: const InputDecoration(labelText: 'Chapter / Topic'),
            items: leafChapters
                .map(
                  (chapter) => DropdownMenuItem<String>(
                    value: chapter.id,
                    child: Text(_chapterTree.pathLabel(chapter.id)),
                  ),
                )
                .toList(),
            onChanged: (value) => setState(() => _chapterId = value),
          ),
          const SizedBox(height: 12),
          Text(
            'Duration: ${_durationMinutes.round()} min',
            style: theme.textTheme.labelLarge,
          ),
          Slider(
            value: _durationMinutes,
            min: 5,
            max: 90,
            divisions: 17,
            label: '${_durationMinutes.round()} min',
            onChanged: (value) => setState(() => _durationMinutes = value),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _materialId == null
                  ? null
                  : () {
                      Navigator.of(context).pop((
                        materialId: _materialId,
                        chapterId: selectedChapterId,
                        durationMinutes: _durationMinutes.round(),
                      ));
                    },
              child: const Text('Start session'),
            ),
          ),
        ],
      ),
    );
  }
}
