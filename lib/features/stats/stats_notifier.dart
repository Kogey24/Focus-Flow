import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/repositories/progress_repository.dart';
import 'stats_state.dart';

part 'stats_notifier.g.dart';

@riverpod
class StatsNotifier extends _$StatsNotifier {
  StatsRange _range = StatsRange.week;

  @override
  Future<StatsState> build() async {
    final repo = ref.watch(progressRepositoryProvider);
    final from = switch (_range) {
      StatsRange.week => DateTime.now().subtract(const Duration(days: 6)),
      StatsRange.month => DateTime.now().subtract(const Duration(days: 29)),
      StatsRange.allTime => null,
    };

    return StatsState(
      range: _range,
      summary: await repo.getSummary(from: from),
    );
  }

  Future<void> setRange(StatsRange range) async {
    _range = range;
    ref.invalidateSelf();
    state = await AsyncValue.guard(build);
  }
}
