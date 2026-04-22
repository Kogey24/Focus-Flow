import '../../domain/models/chapter.dart';
import '../../domain/models/material.dart';

class MaterialDetailState {
  const MaterialDetailState({
    required this.material,
    required this.chapters,
    this.activeChapterId,
  });

  final StudyMaterial material;
  final List<Chapter> chapters;
  final String? activeChapterId;
}
