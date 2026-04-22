import '../../domain/models/focus_analytics.dart';

enum StatsRange {
  week(7, 'Week'),
  month(30, 'Month'),
  allTime(null, 'All time');

  const StatsRange(this.days, this.label);

  final int? days;
  final String label;
}

class StatsState {
  const StatsState({
    required this.range,
    required this.summary,
  });

  final StatsRange range;
  final StatsSummary summary;
}
