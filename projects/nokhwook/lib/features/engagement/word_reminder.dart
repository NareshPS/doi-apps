import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:nokhwook/main.dart';
import 'package:nokhwook/models/vocab.dart';
import 'package:nokhwook/services/notification_service.dart';
import 'package:nokhwook/models/word.dart';

class WordReminder {
  // static bool firstLaunch = true;

  final NotificationService notificationService;
  final reminders = StreamController<int>();

  WordReminder({required this.notificationService});

  Future<void> initialize(words) async {
    await notificationService.initialize(onNotificationReceive);
    schedule(words);

    logger.i('WordReminder: initialize');
    await notificationService.details.then((details) {
      if (details != null &&
          details.didNotificationLaunchApp &&
          details.notificationResponse!.payload != null) {
        logger.i('launched from notification');
        final payload =
            jsonDecode(details.notificationResponse!.payload ?? '{}');

        reminders.add(payload['wordId']);
      }
    });
  }

  void schedule(Vocab words) {
    // Random words to show in the daily and the weekly reminders.
    final random = Random();
    final dailyWordId = random.nextInt(words.length);
    final weeklyWordId = random.nextInt(words.length);

    // notificationService
    //     .scheduleDailyWord(
    //         dailyWordId,
    //         wordReminderTitle('Daily', words[dailyWordId]),
    //         wordReminderDesc(words[dailyWordId]))
    //     .then((_) => notificationService.scheduleWeeklyWord(
    //         weeklyWordId,
    //         wordReminderTitle('Weekly', words[weeklyWordId]),
    //         wordReminderDesc(words[weeklyWordId])));

    notificationService.scheduleEveryMinuteWord(
        dailyWordId,
        wordReminderTitle('Daily', words.header, words[dailyWordId]),
        wordReminderDesc(words.header, words[dailyWordId]));
  }

  wordReminderTitle(String prefix, List<String> header, Word w) =>
      '$prefix ${header[0]} Word: ${w[0].phrase}';
  wordReminderDesc(List<String> header, Word w) =>
      'In ${header[1]} language, it means ${w[1].phrase}';

  onNotificationReceive(NotificationResponse details) {
    final payload = jsonDecode(details.payload ?? '{}');
    logger.i('Received notification: ${details.payload}');

    reminders.add(payload['wordId']);
    // reminders.stream

    // Navigator.of(NavigationService.navigatorKey.currentContext!)
    //     .pushNamed('/home', arguments: {
    //   'start': payload['wordId'],
    // });
  }

  // Future<int?> wordId() {
  //   // If this is the first time we arrived at this page,
  //   // check if the arrival is caused by a click on a notification.
  //   // Unfortunately, the notification launch state persists throughout
  //   // the app session. The firstLaunch variable ensures that
  //   // we handle the notification payload only as a response
  //   // to notification click.
  //   if (firstLaunch) {
  //     firstLaunch = false;
  //     return notificationService.details.then((details) {
  //       if (details != null &&
  //           details.didNotificationLaunchApp &&
  //           details.notificationResponse!.payload != null) {
  //         final payload =
  //             jsonDecode(details.notificationResponse!.payload ?? '{}');

  //         return payload['wordId'];
  //       }
  //       return null;
  //     });
  //   }
  //   return Future.value(null);
  // }
}
