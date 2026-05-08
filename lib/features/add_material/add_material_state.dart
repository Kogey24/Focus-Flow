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
    this.selectedFolderPath,
    this.folderIgnoredFilesCount,
    required this.chapters,
    required this.isSaving,
    this.totalPages,
    this.totalDuration,
    required this.isImporting,
    this.importError,
    this.importWarnings = const [],
    this.thumbnailPath,
    this.importerLabel,
    this.isPreparingSelection = false,
    this.selectionStatus,
    this.uploadProgress = 0,
    this.uploadStatus,
    this.saveError,
    this.isStorageFull = false,
  });

  final MaterialType type;
  final String title;
  final String author;
  final String source;
  final List<String> selectedPaths;
  final String? selectedFolderPath;
  final int? folderIgnoredFilesCount;
  final List<Chapter> chapters;
  final bool isSaving;
  final int? totalPages;
  final int? totalDuration;
  final bool isImporting;
  final String? importError;
  final List<String> importWarnings;
  final String? thumbnailPath;
  final String? importerLabel;
  final bool isPreparingSelection;
  final String? selectionStatus;
  final double uploadProgress;
  final String? uploadStatus;
  final String? saveError;
  final bool isStorageFull;

  AddMaterialState copyWith({
    MaterialType? type,
    String? title,
    String? author,
    String? source,
    List<String>? selectedPaths,
    Object? selectedFolderPath = _unset,
    Object? folderIgnoredFilesCount = _unset,
    List<Chapter>? chapters,
    bool? isSaving,
    Object? totalPages = _unset,
    Object? totalDuration = _unset,
    bool? isImporting,
    Object? importError = _unset,
    List<String>? importWarnings,
    Object? thumbnailPath = _unset,
    Object? importerLabel = _unset,
    bool? isPreparingSelection,
    Object? selectionStatus = _unset,
    double? uploadProgress,
    Object? uploadStatus = _unset,
    Object? saveError = _unset,
    bool? isStorageFull,
  }) {
    return AddMaterialState(
      type: type ?? this.type,
      title: title ?? this.title,
      author: author ?? this.author,
      source: source ?? this.source,
      selectedPaths: selectedPaths ?? this.selectedPaths,
      selectedFolderPath: selectedFolderPath == _unset
          ? this.selectedFolderPath
          : selectedFolderPath as String?,
      folderIgnoredFilesCount: folderIgnoredFilesCount == _unset
          ? this.folderIgnoredFilesCount
          : folderIgnoredFilesCount as int?,
      chapters: chapters ?? this.chapters,
      isSaving: isSaving ?? this.isSaving,
      totalPages: totalPages == _unset ? this.totalPages : totalPages as int?,
      totalDuration: totalDuration == _unset
          ? this.totalDuration
          : totalDuration as int?,
      isImporting: isImporting ?? this.isImporting,
      importError: importError == _unset
          ? this.importError
          : importError as String?,
      importWarnings: importWarnings ?? this.importWarnings,
      thumbnailPath: thumbnailPath == _unset
          ? this.thumbnailPath
          : thumbnailPath as String?,
      importerLabel: importerLabel == _unset
          ? this.importerLabel
          : importerLabel as String?,
      isPreparingSelection: isPreparingSelection ?? this.isPreparingSelection,
      selectionStatus: selectionStatus == _unset
          ? this.selectionStatus
          : selectionStatus as String?,
      uploadProgress: uploadProgress ?? this.uploadProgress,
      uploadStatus: uploadStatus == _unset
          ? this.uploadStatus
          : uploadStatus as String?,
      saveError: saveError == _unset ? this.saveError : saveError as String?,
      isStorageFull: isStorageFull ?? this.isStorageFull,
    );
  }
}
