import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final storageAlertServiceProvider = Provider<StorageAlertService>(
  (ref) => StorageAlertService(),
);

class StorageAlertService {
  static const _channelId = 'focus_flow_storage_alerts';
  static const _channelName = 'Storage alerts';
  static const _channelDescription =
      'Alerts when Focus Flow cannot save more local material.';
  static const _notificationId = 9001;

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  bool _isInitialized = false;

  Future<void> notifyDatabaseFull({
    String title = 'Focus Flow storage is full',
    String? body,
  }) async {
    try {
      await _ensureInitialized();

      if (Platform.isAndroid) {
        await _plugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >()
            ?.requestNotificationsPermission();
      }

      const androidDetails = AndroidNotificationDetails(
        _channelId,
        _channelName,
        channelDescription: _channelDescription,
        importance: Importance.high,
        priority: Priority.high,
      );

      await _plugin.show(
        id: _notificationId,
        title: title,
        body:
            body ??
            'Clear some saved materials or app data, then try the upload again.',
        notificationDetails: const NotificationDetails(
          android: androidDetails,
          iOS: DarwinNotificationDetails(),
        ),
      );
    } catch (_) {
      // Notifications are best effort. A failed alert should not break saving.
    }
  }

  Future<void> _ensureInitialized() async {
    if (_isInitialized) return;

    const settings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    );
    await _plugin.initialize(settings: settings);

    if (Platform.isAndroid) {
      const channel = AndroidNotificationChannel(
        _channelId,
        _channelName,
        description: _channelDescription,
        importance: Importance.high,
      );
      await _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.createNotificationChannel(channel);
    }

    _isInitialized = true;
  }
}
