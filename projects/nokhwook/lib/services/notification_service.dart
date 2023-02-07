import 'dart:convert';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:nokhwook/utils/word.dart';

enum EngagementType {
  dailyWord,
  weeklyWord
}

class NotificationService {
  final plugin = FlutterLocalNotificationsPlugin();

  Future<bool?> initialize(onReceive) async {
    const notificationInitializationSettings = InitializationSettings(
      android: AndroidInitializationSettings(
        '@mipmap/ic_launcher_round'
      )
    );

    return plugin.initialize(
      notificationInitializationSettings, 
      onDidReceiveNotificationResponse: onReceive,
    );
  }

  scheduleWordReminder(EngagementType type, int wordId, Word<WordItem> w, RepeatInterval freq) {
    final title = 'Today\'s ${w.header.lang} Word: ${w.header.phrase}';
    final body = '${w.header.phrase} in ${w.items[0].lang} means ${w.items[0].phrase}';

    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'daily_word', 'Daily Word',
        channelDescription: 'Daily word notifications',
        category: AndroidNotificationCategory.reminder,
      )
    );

    plugin.periodicallyShow(
      type.index, title, body, freq,
      details, androidAllowWhileIdle: true,
      payload: jsonEncode({
        'wordId': wordId
      })
    );
  }

  cancelSchedule(EngagementType type) {
    plugin.cancel(type.index);
  }

  scheduleWordReminders(int wordId, Word<WordItem> w) async {
    // scheduleWordReminder(EngagementType.dailyWord, wordId, w, RepeatInterval.everyMinute);
    scheduleWordReminder(EngagementType.dailyWord, wordId, w, RepeatInterval.daily);
    scheduleWordReminder(EngagementType.weeklyWord, wordId, w, RepeatInterval.weekly);
  }

  cancelWordReminders() {
    cancelSchedule(EngagementType.dailyWord);
    cancelSchedule(EngagementType.weeklyWord);
  }

  rescheduleWordReminders(int wordId, Word<WordItem> w) async {
    await cancelWordReminders();
    await scheduleWordReminders(wordId, w);
  }
}