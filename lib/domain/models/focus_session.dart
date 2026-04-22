import '../enums/session_status.dart';

class FocusSession {
  const FocusSession({
    required this.id,
    required this.materialId,
    required this.startedAt,
    required this.durationSeconds,
    required this.status,
    this.chapterId,
    this.endedAt,
    this.notes,
  });

  final String id;
  final String materialId;
  final String? chapterId;
  final DateTime startedAt;
  final DateTime? endedAt;
  final int durationSeconds;
  final SessionStatus status;
  final String? notes;
}
