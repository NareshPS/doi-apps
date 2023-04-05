import 'dart:async';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:csv/csv.dart';
import 'package:csv/csv_settings_autodetection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:logger/logger.dart';
import 'package:nokhwook/features/engagement/word_reminder.dart';
import 'package:nokhwook/features/stages/random_stage_preferences.dart';
import 'package:nokhwook/features/welcome/memorized_subset.dart';
import 'package:nokhwook/models/vocab.dart';
import 'package:nokhwook/pages/home.dart';
import 'package:nokhwook/services/notification_service.dart';
import 'package:nokhwook/services/subtitles_service.dart';
import 'package:nokhwook/themes.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

final logger = Logger(printer: PrettyPrinter(methodCount: 5));
final errorController = StreamController<String>();

Future<Vocab> loadVocabulary() async {
  String vocab = await rootBundle.loadString('assets/vocab.csv');
  List<List<dynamic>> items = const CsvToListConverter().convert(vocab);

  return Vocab.parse(items);
}

initializeNotifications(vocab) async {
  final notificationService = NotificationService();
  final reminder = WordReminder(notificationService: notificationService);

  reminder.initialize(vocab);
  errorController.add('Main: Initializing WordReminder');
  return reminder;
}

Future<SubtitlesService> loadSubtitles() async {
  final sources = {
    'Thai': 'assets/subtitles/captain.america.the.first.avenger.2011.th.srt',
    'English': 'assets/subtitles/captain.america.the.first.avenger.2011.en.srt',
  };
  final service = SubtitlesService(sources: sources);
  await service.load();
  return service;
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final vocab = await loadVocabulary();
  initializeNotifications(vocab);

  runApp(MultiProvider(
    providers: [
      FutureProvider(create: (context) => loadVocabulary(), initialData: null),
      FutureProvider(create: (context) => loadSubtitles(), initialData: null),
      // Provider(create: (context) => NotificationService()),
      FutureProvider(
          create: (context) => SharedPreferences.getInstance(),
          initialData: null),
      ChangeNotifierProvider(create: (context) {
        final prefs = context.read<SharedPreferences?>();
        return prefs != null ? RandomStagePreferences(prefs) : null;
      }),
      ChangeNotifierProvider(create: (context) {
        final prefs = context.read<SharedPreferences?>();
        return prefs != null ? MemorizedSubset(prefs) : null;
      }),
      StreamProvider<WordReminderMessage?>(
          create: (context) => WordReminder.messageController.stream,
          // context.read<WordReminder>().messageController.stream,
          initialData: null),
      StreamProvider<String?>(
          create: (context) => errorController.stream, initialData: null)
    ],
    child: AdaptiveTheme(
      light: Themes.lightTheme,
      dark: Themes.darkTheme,
      initial: AdaptiveThemeMode.light,
      builder: (light, dark) => MaterialApp(
        theme: light,
        darkTheme: dark,
        routes: {
          '/': (context) {
            return (Provider.of<SharedPreferences?>(context) != null &&
                    Provider.of<Vocab?>(context) != null &&
                    Provider.of<SubtitlesService?>(context) != null)
                // Provider.of<Vocab?>(context) != null)
                ? const Home()
                : Container(
                    color: Colors.red[400],
                    child: const Center(
                      child: SpinKitCubeGrid(
                        color: Colors.white,
                        size: 80.0,
                        duration: Duration(seconds: 2),
                      ),
                    ),
                  );
          },
        },
      ),
    ),
  ));
}
