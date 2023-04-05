import 'dart:convert';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

enum NotificationCategory { dailyWord, weeklyWord, everyMinuteWord }

class NotificationService {
  final plugin = FlutterLocalNotificationsPlugin();

  Future<NotificationAppLaunchDetails?> get details async =>
      plugin.getNotificationAppLaunchDetails();

  Future<bool?> initialize(onReceive) async {
    const notificationInitializationSettings = InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher_round'));

    return plugin.initialize(
      notificationInitializationSettings,
      onDidReceiveNotificationResponse: onReceive,
    );
  }

  androidNotificationDetails(NotificationCategory category) {
    switch (category) {
      case NotificationCategory.dailyWord:
        return const AndroidNotificationDetails(
          'daily_word',
          'Daily Word',
          channelDescription: 'Daily word reminder',
          category: AndroidNotificationCategory.reminder,
        );
      case NotificationCategory.weeklyWord:
        return const AndroidNotificationDetails(
          'weekly_word',
          'Weekly Word',
          channelDescription: 'Weekly word reminder',
          category: AndroidNotificationCategory.reminder,
        );
      case NotificationCategory.everyMinuteWord:
        return const AndroidNotificationDetails(
          'minute_word',
          'Minute Word',
          channelDescription: 'Minute word reminder for testing purposes',
          category: AndroidNotificationCategory.reminder,
        );
    }
  }

  scheduleWordReminder(NotificationCategory category, int wordId, String title,
      String desc, RepeatInterval freq) async {
    final details =
        NotificationDetails(android: androidNotificationDetails(category));

    // Cancel existing reminder and schedule a new one.
    plugin.cancel(category.index).then((value) => plugin.periodicallyShow(
        category.index, title, desc, freq, details,
        androidAllowWhileIdle: true, payload: jsonEncode({'wordId': wordId})));
  }

  Future scheduleDailyWord(int wordId, String title, String desc) async {
    scheduleWordReminder(NotificationCategory.dailyWord, wordId, title, desc,
        RepeatInterval.daily);
  }

  Future scheduleWeeklyWord(int wordId, String title, String desc) async {
    scheduleWordReminder(NotificationCategory.weeklyWord, wordId, title, desc,
        RepeatInterval.weekly);
  }

  Future scheduleEveryMinuteWord(int wordId, String title, String desc) async {
    scheduleWordReminder(NotificationCategory.everyMinuteWord, wordId, title,
        desc, RepeatInterval.everyMinute);
  }
}
