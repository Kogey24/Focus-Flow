import '../../domain/enums/material_type.dart';
import '../../domain/models/chapter.dart';

class AddMaterialState {
  static const _unset = Object();

  const AddMaterialState({
    required this.type,
    required this.title,
    required this.author,
    required this.source,
    required this.selectedPaths,
    required this.chapters,
    required this.isSaving,
    this.totalPages,
    this.totalDuration,
  });

  final MaterialType type;
  final String title;
  final String author;
  final String source;
  final List<String> selectedPaths;
  final List<Chapter> chapters;
  final bool isSaving;
  final int? totalPages;
  final int? totalDuration;

  AddMaterialState copyWith({
    MaterialType? type,
    String? title,
    String? author,
    String? source,
    List<String>? selectedPaths,
    List<Chapter>? chapters,
    bool? isSaving,
    Object? totalPages = _unset,
    Object? totalDuration = _unset,
  }) {
    return AddMaterialState(
      type: type ?? this.type,
      title: title ?? this.title,
      author: author ?? this.author,
      source: source ?? this.source,
      selectedPaths: selectedPaths ?? this.selectedPaths,
      chapters: chapters ?? this.chapters,
      isSaving: isSaving ?? this.isSaving,
      totalPages: totalPages == _unset ? this.totalPages : totalPages as int?,
      totalDuration: totalDuration == _unset ? this.totalDuration : totalDuration as int?,
    );
  }
}
