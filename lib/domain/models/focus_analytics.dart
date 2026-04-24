import '../enums/material_type.dart';

class DailyFocusStat {
  const DailyFocusStat({
    required this.date,
    required this.minutes,
    this.sessionCount = 0,
  });

  final DateTime date;
  final double minutes;
  final int sessionCount;
}

class MaterialTypeBreakdown {
  const MaterialTypeBreakdown({required this.type, required this.minutes});

  final MaterialType type;
  final double minutes;
}

class RecentCompletion {
  const RecentCompletion({
    required this.chapterTitle,
    required this.materialTitle,
    required this.completedAt,
    required this.materialId,
  });

  final String chapterTitle;
  final String materialTitle;
  final DateTime completedAt;
  final String materialId;
}

class StatsSummary {
  const StatsSummary({
    required this.totalFocusSeconds,
    required this.currentStreak,
    required this.completedSessions,
    required this.completedMaterials,
    required this.dailyStats,
    required this.typeBreakdown,
    required this.recentCompletions,
  });

  final int totalFocusSeconds;
  final int currentStreak;
  final int completedSessions;
  final int completedMaterials;
  final List<DailyFocusStat> dailyStats;
  final List<MaterialTypeBreakdown> typeBreakdown;
  final List<RecentCompletion> recentCompletions;
}
