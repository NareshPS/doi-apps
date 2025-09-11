import 'dart:async';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:logger/logger.dart';
import 'package:nokhwook/features/engagement/word_reminder.dart';
import 'package:nokhwook/features/preferences/global_preferences.dart';
import 'package:nokhwook/features/stages/random_stage_preferences.dart';
import 'package:nokhwook/features/welcome/memorized_subset.dart';
import 'package:nokhwook/models/vocab.dart';
import 'package:nokhwook/pages/home.dart';
import 'package:nokhwook/services/constants_service.dart';
import 'package:nokhwook/services/notification_service.dart';
import 'package:nokhwook/services/subtitles_service.dart';
import 'package:nokhwook/themes.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

final logger = Logger(printer: PrettyPrinter(methodCount: 5));
final errorController = StreamController<String>();

Future<Vocab> loadVocabulary(String language) async {
  String vocab =
      await rootBundle.loadString('assets/vocab_${language.toLowerCase()}.csv');
  List<List<dynamic>> items = const CsvToListConverter().convert(vocab);

  return Vocab.parse(items);
}

Future<WordReminder> initializeNotifications(Vocab vocab) async {
  final notificationService = NotificationService();
  final reminder = WordReminder(notificationService: notificationService);

  reminder.initialize(vocab);
  return reminder;
}

Future<SubtitlesService> loadSubtitles(String targetLanguage) async {
  final sources = ConstantsService.subtitleSources[targetLanguage] ?? {};
  final service = SubtitlesService(sources: sources);
  await service.load();
  return service;
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MultiProvider(
    providers: [
      FutureProvider(
          create: (context) => SharedPreferences.getInstance(),
          initialData: null),
      ChangeNotifierProvider(create: (context) {
        final prefs = context.read<SharedPreferences?>();
        return prefs != null ? GlobalPreferences(prefs) : null;
      }),
      FutureProvider(
          create: (context) {
            final prefs = context.read<GlobalPreferences?>();

            return prefs != null ? loadSubtitles(prefs.targetLanguage) : null;
          },
          initialData: null),
      FutureProvider(
        create: (context) {
          final prefs = context.read<GlobalPreferences?>();
          if (prefs != null) {
            var vocab = loadVocabulary(prefs.targetLanguage);
            logger.i('Loading vocab for language: ${prefs.targetLanguage}');

            // Initialize notifications after vocab is loaded
            vocab.then((vocab) => initializeNotifications(vocab));

            return vocab;
          } else {
            return null;
          }
        },
        initialData: null,
      ),
      ChangeNotifierProvider(create: (context) {
        final prefs = context.read<SharedPreferences?>();
        return prefs != null ? RandomStagePreferences(prefs) : null;
      }),
      ChangeNotifierProvider(create: (context) {
        final prefs = context.read<SharedPreferences?>();
        final globalPreferences = context.read<GlobalPreferences?>();

        return prefs != null && globalPreferences != null
            ? MemorizedSubset(prefs, globalPreferences)
            : null;
      }),
      StreamProvider<WordReminderMessage?>(
          create: (context) => WordReminder.messageController.stream,
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
                    Provider.of<GlobalPreferences?>(context) != null &&
                    Provider.of<Vocab?>(context) != null &&
                    Provider.of<SubtitlesService?>(context) != null)
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
