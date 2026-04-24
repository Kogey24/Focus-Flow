import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_dimensions.dart';
import '../../core/utils/duration_formatter.dart';
import '../../core/widgets/empty_state_widget.dart';
import '../../core/widgets/material_card.dart';
import '../../core/widgets/streak_badge.dart';
import '../../core/widgets/stat_card.dart';
import '../../domain/models/focus_analytics.dart';
import 'home_notifier.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeNotifierProvider);
    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.surfaceContainerHighest,
              Theme.of(context).scaffoldBackgroundColor,
            ],
          ),
        ),
        child: SafeArea(
          child: state.when(
            data: (home) {
              return RefreshIndicator(
                onRefresh: () =>
                    ref.read(homeNotifierProvider.notifier).refresh(),
                child: ListView(
                  padding: const EdgeInsets.all(AppDimensions.spacing16),
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${home.greeting}, ${home.firstName}',
                                style: Theme.of(context).textTheme.headlineSmall
                                    ?.copyWith(fontWeight: FontWeight.w800),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Build momentum with one focused session at a time.',
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurfaceVariant,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () => context.go('/settings'),
                          icon: const Icon(Icons.tune_rounded),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppDimensions.spacing16),
                    Row(
                      children: [
                        Expanded(child: StreakBadge(days: home.currentStreak)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: StatCard(
                            label: 'Today',
                            value: DurationFormatter.asCompact(
                              Duration(seconds: home.todayFocusSeconds),
                            ),
                            icon: Icons.schedule_rounded,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppDimensions.spacing16),
                    FilledButton(
                      onPressed: () => context.push('/session'),
                      onLongPress: () => context.push('/session'),
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 18),
                      ),
                      child: const Text('Start focus session'),
                    ),
                    const SizedBox(height: AppDimensions.spacing24),
                    _WeeklyChart(stats: home.weeklyStats),
                    const SizedBox(height: AppDimensions.spacing24),
                    Text(
                      "Today's focus",
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (home.recommendedMaterials.isEmpty)
                      const EmptyStateWidget(
                        title: 'Nothing queued yet',
                        message:
                            'Add your first study material to start building a focus flow.',
                        icon: Icons.auto_stories_rounded,
                      )
                    else
                      ...home.recommendedMaterials.map(
                        (material) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: MaterialCard(
                            material: material,
                            onTap: () =>
                                context.push('/library/${material.id}'),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => EmptyStateWidget(
              title: 'Home could not load',
              message: '$error',
              ctaLabel: 'Retry',
              onPressed: () => ref.invalidate(homeNotifierProvider),
            ),
          ),
        ),
      ),
    );
  }
}

class _WeeklyChart extends StatelessWidget {
  const _WeeklyChart({required this.stats});

  final List<DailyFocusStat> stats;

  @override
  Widget build(BuildContext context) {
    const maxY = 1.0;

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
            'Weekly focus',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Text(
            'Bars fill based on sessions completed: 1-3 = 25%, 4-6 = 75%, 7+ = 100%.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 190,
            child: BarChart(
              BarChartData(
                maxY: maxY,
                alignment: BarChartAlignment.spaceBetween,
                gridData: const FlGridData(show: false),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index < 0 || index >= stats.length) {
                          return const SizedBox.shrink();
                        }
                        final label = DurationFormatter.formatDate(
                          stats[index].date,
                        );
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(label.substring(0, 1)),
                        );
                      },
                    ),
                  ),
                ),
                barGroups: [
                  for (var i = 0; i < stats.length; i++)
                    BarChartGroupData(
                      x: i,
                      barRods: [
                        BarChartRodData(
                          toY: _sessionFillLevel(stats[i].sessionCount),
                          width: 18,
                          borderRadius: BorderRadius.circular(8),
                          color: Theme.of(context).colorScheme.primary,
                          backDrawRodData: BackgroundBarChartRodData(
                            show: true,
                            toY: maxY,
                            color: Theme.of(
                              context,
                            ).colorScheme.surfaceContainerHighest,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  double _sessionFillLevel(int sessionCount) {
    if (sessionCount >= 7) return 1;
    if (sessionCount >= 4) return 0.75;
    if (sessionCount >= 1) return 0.25;
    return 0;
  }
}
