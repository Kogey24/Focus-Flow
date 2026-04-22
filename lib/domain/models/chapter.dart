class Chapter {
  const Chapter({
    required this.id,
    required this.materialId,
    required this.title,
    required this.orderIndex,
    this.parentId,
    this.pageStart,
    this.pageEnd,
    this.duration,
    this.filePath,
    this.isCompleted = false,
    this.completedAt,
    this.note,
  });

  final String id;
  final String materialId;
  final String title;
  final String? parentId;
  final int orderIndex;
  final int? pageStart;
  final int? pageEnd;
  final int? duration;
  final String? filePath;
  final bool isCompleted;
  final DateTime? completedAt;
  final String? note;

  Chapter copyWith({
    String? id,
    String? materialId,
    String? title,
    String? parentId,
    int? orderIndex,
    int? pageStart,
    int? pageEnd,
    int? duration,
    String? filePath,
    bool? isCompleted,
    DateTime? completedAt,
    String? note,
  }) {
    return Chapter(
      id: id ?? this.id,
      materialId: materialId ?? this.materialId,
      title: title ?? this.title,
      parentId: parentId ?? this.parentId,
      orderIndex: orderIndex ?? this.orderIndex,
      pageStart: pageStart ?? this.pageStart,
      pageEnd: pageEnd ?? this.pageEnd,
      duration: duration ?? this.duration,
      filePath: filePath ?? this.filePath,
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: completedAt ?? this.completedAt,
      note: note ?? this.note,
    );
  }
}
