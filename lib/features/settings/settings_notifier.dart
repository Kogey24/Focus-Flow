import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/providers/shared_preferences_provider.dart';
import '../../data/repositories/material_repository.dart';
import '../home/home_notifier.dart';
import 'settings_state.dart';

part 'settings_notifier.g.dart';

@riverpod
class SettingsNotifier extends _$SettingsNotifier {
  @override
  Future<SettingsState> build() async {
    final prefs = ref.watch(sharedPreferencesProvider);
    return SettingsState(
      firstName: prefs.getString('first_name') ?? 'Alex',
      defaultSessionMinutes: prefs.getInt('default_session_minutes') ?? 25,
      breakMinutes: prefs.getInt('break_minutes') ?? 5,
      dailyGoalMinutes: prefs.getInt('daily_goal_minutes') ?? 120,
      dailyReminderEnabled: prefs.getBool('daily_reminder_enabled') ?? true,
      dailyReminderTime: _timeFromString(prefs.getString('daily_reminder_time') ?? '19:00'),
      streakAlertEnabled: prefs.getBool('streak_alert_enabled') ?? true,
      onboardingComplete: prefs.getBool('onboarding_complete') ?? false,
    );
  }

  Future<void> saveSettings(SettingsState next) async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setString('first_name', next.firstName);
    await prefs.setInt('default_session_minutes', next.defaultSessionMinutes);
    await prefs.setInt('break_minutes', next.breakMinutes);
    await prefs.setInt('daily_goal_minutes', next.dailyGoalMinutes);
    await prefs.setBool('daily_reminder_enabled', next.dailyReminderEnabled);
    await prefs.setString('daily_reminder_time', _timeToString(next.dailyReminderTime));
    await prefs.setBool('streak_alert_enabled', next.streakAlertEnabled);
    await prefs.setBool('onboarding_complete', next.onboardingComplete);
    state = AsyncData(next);
    ref.invalidate(homeNotifierProvider);
  }

  Future<void> clearAllData() async {
    await ref.read(appDatabaseProvider).clearAllData();
  }

  TimeOfDay _timeFromString(String value) {
    final split = value.split(':');
    return TimeOfDay(
      hour: int.tryParse(split.firstOrNull ?? '') ?? 19,
      minute: int.tryParse(split.length > 1 ? split[1] : '') ?? 0,
    );
  }

  String _timeToString(TimeOfDay value) {
    return '${value.hour.toString().padLeft(2, '0')}:${value.minute.toString().padLeft(2, '0')}';
  }
}
