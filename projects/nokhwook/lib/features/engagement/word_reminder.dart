import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:nokhwook/main.dart';
import 'package:nokhwook/models/vocab.dart';
import 'package:nokhwook/services/notification_service.dart';
import 'package:nokhwook/models/word.dart';

class WordReminderMessage {
  final int? wordId;

  WordReminderMessage({required this.wordId});
}

class WordReminder {
  final NotificationService notificationService;
  static final messageController = StreamController<WordReminderMessage>();

  WordReminder({required this.notificationService});

  Future<void> initialize(words) async {
    await notificationService.initialize(onNotificationReceive);

    schedule(words);

    logger.i('WordReminder: initialize');
    notificationService.details.then((details) {
      WordReminderMessage message;
      if (details != null &&
          details.didNotificationLaunchApp &&
          details.notificationResponse!.payload != null) {
        final payload =
            jsonDecode(details.notificationResponse!.payload ?? '{}');

        errorController.add('WordReminder: Initialization through reminder');
        message = WordReminderMessage(wordId: payload['wordId']);
      } else {
        message = WordReminderMessage(wordId: null);
      }
      messageController.add(message);

      logger.i(details?.didNotificationLaunchApp);
    });
  }

  void schedule(Vocab words) {
    // Random words to show in the daily and the weekly reminders.
    final random = Random();
    final dailyWordId = random.nextInt(words.length);
    final weeklyWordId = random.nextInt(words.length);

    notificationService
        .scheduleDailyWord(
            dailyWordId,
            wordReminderTitle('Daily', words.header, words[dailyWordId]),
            wordReminderDesc(words.header, words[dailyWordId]))
        .then((_) => notificationService.scheduleWeeklyWord(
            weeklyWordId,
            wordReminderTitle('Weekly', words.header, words[weeklyWordId]),
            wordReminderDesc(words.header, words[weeklyWordId])));

    // notificationService.scheduleEveryMinuteWord(
    //     dailyWordId,
    //     wordReminderTitle('Daily', words.header, words[dailyWordId]),
    //     wordReminderDesc(words.header, words[dailyWordId]));

    errorController.add('WordReminder: Scheduling reminder');
  }

  wordReminderTitle(String prefix, List<String> header, Word w) =>
      '$prefix ${header[0]} Word: ${w[0].phrase}';
  wordReminderDesc(List<String> header, Word w) =>
      'In ${header[1]} language, it means ${w[1].phrase}';

  @pragma('vm:entry-point')
  static onNotificationReceive(NotificationResponse details) {
    final payload = jsonDecode(details.payload ?? '{}');
    logger.i('Received notification: ${details.payload}');

    errorController.add('WordReminder: Notification received');

    messageController.add(WordReminderMessage(wordId: payload['wordId']));
  }
}
