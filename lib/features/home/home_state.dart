import '../../domain/models/focus_analytics.dart';
import '../../domain/models/material.dart';

class HomeState {
  const HomeState({
    required this.firstName,
    required this.greeting,
    required this.currentStreak,
    required this.recommendedMaterials,
    required this.weeklyStats,
    required this.todayFocusSeconds,
  });

  final String firstName;
  final String greeting;
  final int currentStreak;
  final List<StudyMaterial> recommendedMaterials;
  final List<DailyFocusStat> weeklyStats;
  final int todayFocusSeconds;
}
