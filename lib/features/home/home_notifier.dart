import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/providers/shared_preferences_provider.dart';
import '../../data/repositories/material_repository.dart';
import '../../data/repositories/progress_repository.dart';
import '../../data/repositories/session_repository.dart';
import 'home_state.dart';

part 'home_notifier.g.dart';

@riverpod
class HomeNotifier extends _$HomeNotifier {
  @override
  Future<HomeState> build() async {
    final materialRepository = ref.watch(materialRepositoryProvider);
    final progressRepository = ref.watch(progressRepositoryProvider);
    final sessionRepository = ref.watch(sessionRepositoryProvider);
    final prefs = ref.watch(sharedPreferencesProvider);
    final firstName = prefs.getString('first_name') ?? 'Learner';
    final hour = DateTime.now().hour;
    final greeting = switch (hour) {
      < 12 => 'Good morning',
      < 17 => 'Good afternoon',
      _ => 'Good evening',
    };

    return HomeState(
      firstName: firstName,
      greeting: greeting,
      currentStreak: await sessionRepository.getCurrentStreak(),
      recommendedMaterials: await materialRepository.getInProgress(limit: 3),
      weeklyStats: await progressRepository.getFocusStats(days: 7),
      todayFocusSeconds: await sessionRepository.getTodayFocusSeconds(),
    );
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(build);
  }
}
