class Streak {
  const Streak({
    required this.id,
    required this.date,
    required this.totalFocusSeconds,
    required this.sessionCount,
  });

  final String id;
  final DateTime date;
  final int totalFocusSeconds;
  final int sessionCount;
}
