class ProgressSnapshot {
  const ProgressSnapshot({
    required this.id,
    required this.materialId,
    required this.snapshotAt,
    required this.percentComplete,
    this.chapterId,
    this.lastPositionSeconds,
  });

  final String id;
  final String materialId;
  final String? chapterId;
  final DateTime snapshotAt;
  final double percentComplete;
  final int? lastPositionSeconds;
}
