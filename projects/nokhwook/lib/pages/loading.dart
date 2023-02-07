import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:csv/csv.dart';
import 'package:nokhwook/services/navigation_service.dart';
import 'package:nokhwook/services/notification_service.dart';
import 'package:nokhwook/utils/next_word.dart';
import 'package:nokhwook/utils/word.dart';

final notificationService = NotificationService();

class Loading extends StatefulWidget {
  final NotificationService notificationService;

  const Loading({
    super.key,
    required this.notificationService
  });

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  late List<Word<WordItem>> words;

  Future<void> loadVocabulary() async {
    String vocab = await rootBundle.loadString('assets/vocab.csv');
    List<List<dynamic>> items = const CsvToListConverter().convert(vocab);
    List<dynamic> header = items.removeAt(0);

    // Data transformation functions.
    makeWordItem(index, v) => WordItem(lang: header[index], phrase: v);
    makeWordItems(entries) => entries.asMap().entries.map<WordItem>(
      (e) => makeWordItem(e.key, e.value)
    );

    words = items.map<Word<WordItem>>((item) {
      Iterable<WordItem> wordItems = makeWordItems(item);
      return Word(
        header: wordItems.first,
        items: wordItems.skip(1).toList()
      );
    }).toList();

    if (mounted) {
      Navigator.pushReplacementNamed(
        context,
        '/home',
        arguments: {
          'category': 'All Words',
          'words': words,
          'subset': List.generate(words.length, (i) => i)
        }
      );
    }
  }

  void initializeEngagement() async {
    await notificationService.initialize(onNotificationReceive);
    scheduleEngagement();
  }

  void scheduleEngagement() {
        // Reschedule random word notifications.
    final randomWordId = RandomNext().get(words);
    widget.notificationService.rescheduleWordReminders(randomWordId, words[randomWordId]);
  }

  onNotificationReceive(NotificationResponse details) {
    switch (details.id!) {
      case 0 /** EngagementType.dailyWord */:
      case 1 /** EngagementType.weeklyWord */:
        Map<String, dynamic> payload = jsonDecode(details.payload ?? '{}');

        Navigator.of(NavigationService.navigatorKey.currentContext!)
        .pushNamed(
          '/home',
          arguments: {
            'category': 'All Words',
            'words': words,
            'subset': List.generate(words.length, (i) => i),
            'start': payload['wordId']
          }
        );
    }

    scheduleEngagement();
  }

  void asyncInit() async {
    await loadVocabulary();
    initializeEngagement();
  }

  @override
  void initState() {
    super.initState();
    
    asyncInit();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red[400],
      child: const Center(
        child: SpinKitCubeGrid(
          color: Colors.white,
          size: 80.0,
        ),
      ),
    );
  }
}