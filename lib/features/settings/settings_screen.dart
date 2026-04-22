import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/widgets/confirmation_dialog.dart';
import '../../core/widgets/empty_state_widget.dart';
import '../home/home_notifier.dart';
import '../library/library_notifier.dart';
import '../stats/stats_notifier.dart';
import 'settings_notifier.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(settingsNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: state.when(
        data: (settings) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              TextField(
                controller: TextEditingController(text: settings.firstName),
                decoration: const InputDecoration(labelText: 'First name'),
                onSubmitted: (value) {
                  ref.read(settingsNotifierProvider.notifier).saveSettings(
                        settings.copyWith(firstName: value.trim().isEmpty ? settings.firstName : value.trim()),
                      );
                },
              ),
              const SizedBox(height: 20),
              _SliderTile(
                label: 'Default session length',
                value: settings.defaultSessionMinutes.toDouble(),
                min: 5,
                max: 90,
                suffix: 'min',
                onChanged: (value) {
                  ref.read(settingsNotifierProvider.notifier).saveSettings(
                        settings.copyWith(defaultSessionMinutes: value.round()),
                      );
                },
              ),
              _SliderTile(
                label: 'Break length',
                value: settings.breakMinutes.toDouble(),
                min: 5,
                max: 30,
                suffix: 'min',
                onChanged: (value) {
                  ref.read(settingsNotifierProvider.notifier).saveSettings(
                        settings.copyWith(breakMinutes: value.round()),
                      );
                },
              ),
              _SliderTile(
                label: 'Daily goal',
                value: settings.dailyGoalMinutes.toDouble(),
                min: 30,
                max: 240,
                suffix: 'min',
                onChanged: (value) {
                  ref.read(settingsNotifierProvider.notifier).saveSettings(
                        settings.copyWith(dailyGoalMinutes: value.round()),
                      );
                },
              ),
              SwitchListTile(
                title: const Text('Daily reminder'),
                value: settings.dailyReminderEnabled,
                onChanged: (value) {
                  ref.read(settingsNotifierProvider.notifier).saveSettings(
                        settings.copyWith(dailyReminderEnabled: value),
                      );
                },
              ),
              SwitchListTile(
                title: const Text('Streak alerts'),
                value: settings.streakAlertEnabled,
                onChanged: (value) {
                  ref.read(settingsNotifierProvider.notifier).saveSettings(
                        settings.copyWith(streakAlertEnabled: value),
                      );
                },
              ),
              ListTile(
                title: const Text('Reminder time'),
                subtitle: Text(settings.dailyReminderTime.format(context)),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () async {
                  final picked = await showTimePicker(
                    context: context,
                    initialTime: settings.dailyReminderTime,
                  );
                  if (picked == null) return;
                  ref.read(settingsNotifierProvider.notifier).saveSettings(
                        settings.copyWith(dailyReminderTime: picked),
                      );
                },
              ),
              const SizedBox(height: 20),
              FilledButton.tonal(
                onPressed: () async {
                  final confirmed = await ConfirmationDialog.show(
                    context,
                    title: 'Clear all local data?',
                    message: 'This removes your materials, sessions, notes, and stats from this device.',
                    confirmLabel: 'Clear data',
                  );
                  if (!confirmed || !context.mounted) return;
                  await ref.read(settingsNotifierProvider.notifier).clearAllData();
                  ref.invalidate(homeNotifierProvider);
                  ref.invalidate(libraryNotifierProvider);
                  ref.invalidate(statsNotifierProvider);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('All local data cleared.')),
                  );
                },
                child: const Text('Clear data'),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => EmptyStateWidget(
          title: 'Settings could not load',
          message: '$error',
          ctaLabel: 'Retry',
          onPressed: () => ref.invalidate(settingsNotifierProvider),
        ),
      ),
    );
  }
}

class _SliderTile extends StatelessWidget {
  const _SliderTile({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.suffix,
    required this.onChanged,
  });

  final String label;
  final double value;
  final double min;
  final double max;
  final String suffix;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$label: ${value.round()} $suffix'),
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: (max - min).round(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
