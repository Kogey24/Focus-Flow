import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/utils/duration_formatter.dart';
import '../../core/widgets/empty_state_widget.dart';
import '../../core/widgets/filter_chip_row.dart';
import '../../core/widgets/stat_card.dart';
import 'stats_notifier.dart';
import 'stats_state.dart';

class StatsScreen extends ConsumerWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(statsNotifierProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Stats')),
      body: Padding(
        padding: const EdgeInsets.all(AppDimensions.spacing16),
        child: state.when(
          data: (stats) {
            final summary = stats.summary;
            return ListView(
              children: [
                FilterChipRow<StatsRange>(
                  values: StatsRange.values,
                  selected: stats.range,
                  labelBuilder: (range) => range.label,
                  onSelected: (range) {
                    ref.read(statsNotifierProvider.notifier).setRange(range);
                  },
                ),
                const SizedBox(height: 16),
                GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  physics: const NeverScrollableScrollPhysics(),
                  childAspectRatio: 1.45,
                  children: [
                    StatCard(
                      label: 'Total focus',
                      value: DurationFormatter.asCompact(
                        Duration(seconds: summary.totalFocusSeconds),
                      ),
                      icon: Icons.timer_outlined,
                    ),
                    StatCard(
                      label: 'Current streak',
                      value: '${summary.currentStreak} days',
                      icon: Icons.local_fire_department_rounded,
                    ),
                    StatCard(
                      label: 'Sessions completed',
                      value: '${summary.completedSessions}',
                      icon: Icons.check_circle_outline_rounded,
                    ),
                    StatCard(
                      label: 'Materials finished',
                      value: '${summary.completedMaterials}',
                      icon: Icons.flag_circle_rounded,
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _StatsBarChart(stats: summary.dailyStats),
                const SizedBox(height: 24),
                if (summary.typeBreakdown.isNotEmpty) _BreakdownChart(summary: summary),
                const SizedBox(height: 24),
                Text(
                  'Recently completed',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 12),
                if (summary.recentCompletions.isEmpty)
                  const EmptyStateWidget(
                    title: 'No completions yet',
                    message: 'Finished chapters and episodes will show up here.',
                  )
                else
                  ...summary.recentCompletions.map(
                    (completion) => Card(
                      child: ListTile(
                        leading: const Icon(Icons.task_alt_rounded),
                        title: Text(completion.chapterTitle),
                        subtitle: Text(completion.materialTitle),
                        trailing: Text(DurationFormatter.formatDate(completion.completedAt)),
                      ),
                    ),
                  ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => EmptyStateWidget(
            title: 'Stats could not load',
            message: '$error',
            ctaLabel: 'Retry',
            onPressed: () => ref.invalidate(statsNotifierProvider),
          ),
        ),
      ),
    );
  }
}

class _StatsBarChart extends StatelessWidget {
  const _StatsBarChart({required this.stats});

  final List stats;

  @override
  Widget build(BuildContext context) {
    final typedStats = stats.cast<dynamic>();
    final maxY = typedStats.isEmpty
        ? 30.0
        : typedStats.map((entry) => entry.minutes as double).reduce((a, b) => a > b ? a : b) + 10;

    return Container(
      height: 250,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Theme.of(context).colorScheme.surface,
      ),
      child: BarChart(
        BarChartData(
          maxY: maxY,
          alignment: BarChartAlignment.spaceBetween,
          borderData: FlBorderData(show: false),
          gridData: const FlGridData(show: false),
          titlesData: FlTitlesData(
            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index < 0 || index >= typedStats.length) {
                    return const SizedBox.shrink();
                  }
                  return Text(
                    DurationFormatter.formatDate(typedStats[index].date).substring(0, 1),
                  );
                },
              ),
            ),
          ),
          barGroups: [
            for (var i = 0; i < typedStats.length; i++)
              BarChartGroupData(
                x: i,
                barRods: [
                  BarChartRodData(
                    toY: typedStats[i].minutes as double,
                    width: 16,
                    borderRadius: BorderRadius.circular(8),
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class _BreakdownChart extends StatelessWidget {
  const _BreakdownChart({required this.summary});

  final dynamic summary;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Theme.of(context).colorScheme.surface,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Time by material type',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 220,
            child: PieChart(
              PieChartData(
                centerSpaceRadius: 46,
                sectionsSpace: 4,
                sections: [
                  for (final item in summary.typeBreakdown)
                    PieChartSectionData(
                      value: item.minutes as double,
                      color: AppColors.accentForType(item.type),
                      title: '${item.type.label}\n${item.minutes.round()}m',
                      radius: 54,
                      titleStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
