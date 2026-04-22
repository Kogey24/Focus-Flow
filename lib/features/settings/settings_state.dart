import 'package:flutter/material.dart';

class SettingsState {
  const SettingsState({
    required this.firstName,
    required this.defaultSessionMinutes,
    required this.breakMinutes,
    required this.dailyGoalMinutes,
    required this.dailyReminderEnabled,
    required this.dailyReminderTime,
    required this.streakAlertEnabled,
    required this.onboardingComplete,
  });

  final String firstName;
  final int defaultSessionMinutes;
  final int breakMinutes;
  final int dailyGoalMinutes;
  final bool dailyReminderEnabled;
  final TimeOfDay dailyReminderTime;
  final bool streakAlertEnabled;
  final bool onboardingComplete;

  SettingsState copyWith({
    String? firstName,
    int? defaultSessionMinutes,
    int? breakMinutes,
    int? dailyGoalMinutes,
    bool? dailyReminderEnabled,
    TimeOfDay? dailyReminderTime,
    bool? streakAlertEnabled,
    bool? onboardingComplete,
  }) {
    return SettingsState(
      firstName: firstName ?? this.firstName,
      defaultSessionMinutes: defaultSessionMinutes ?? this.defaultSessionMinutes,
      breakMinutes: breakMinutes ?? this.breakMinutes,
      dailyGoalMinutes: dailyGoalMinutes ?? this.dailyGoalMinutes,
      dailyReminderEnabled: dailyReminderEnabled ?? this.dailyReminderEnabled,
      dailyReminderTime: dailyReminderTime ?? this.dailyReminderTime,
      streakAlertEnabled: streakAlertEnabled ?? this.streakAlertEnabled,
      onboardingComplete: onboardingComplete ?? this.onboardingComplete,
    );
  }
}
