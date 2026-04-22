import '../enums/material_type.dart';

class StudyMaterial {
  const StudyMaterial({
    required this.id,
    required this.title,
    required this.type,
    required this.createdAt,
    this.author,
    this.filePath,
    this.thumbnailPath,
    this.totalDuration,
    this.totalPages,
    this.status = 'not_started',
    this.tags = const [],
    this.progress = 0,
  });

  final String id;
  final String title;
  final String? author;
  final MaterialType type;
  final String? filePath;
  final String? thumbnailPath;
  final int? totalDuration;
  final int? totalPages;
  final DateTime createdAt;
  final String status;
  final List<String> tags;
  final double progress;

  bool get isCompleted => status == 'completed';
  bool get isInProgress => status == 'in_progress';
  bool get isNotStarted => status == 'not_started';

  StudyMaterial copyWith({
    String? id,
    String? title,
    String? author,
    MaterialType? type,
    String? filePath,
    String? thumbnailPath,
    int? totalDuration,
    int? totalPages,
    DateTime? createdAt,
    String? status,
    List<String>? tags,
    double? progress,
  }) {
    return StudyMaterial(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      type: type ?? this.type,
      filePath: filePath ?? this.filePath,
      thumbnailPath: thumbnailPath ?? this.thumbnailPath,
      totalDuration: totalDuration ?? this.totalDuration,
      totalPages: totalPages ?? this.totalPages,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
      tags: tags ?? this.tags,
      progress: progress ?? this.progress,
    );
  }
}
