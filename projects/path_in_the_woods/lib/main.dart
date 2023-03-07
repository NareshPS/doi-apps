import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:isar/isar.dart';
import 'package:logger/logger.dart';
import 'package:path_in_the_woods/models/track.dart';
import 'package:path_in_the_woods/pages/home.dart';
import 'package:path_in_the_woods/services/location_service.dart';
import 'package:path_in_the_woods/services/track_service.dart';
import 'package:path_in_the_woods/themes.dart';

LocationService locationService = LocationService(
  // interval: const Duration(seconds: 30),
  notificationText: "Click to see the details.",
  notificationTitle: "Recording Track",
);

final logger = Logger(
  printer: PrettyPrinter(),
);

void main() async {
  final Isar isar = await Isar.open([TrackSchema]);
  TrackService trackService = TrackService(db: isar);
  await trackService.initialize();

  runApp(
    AdaptiveTheme(
      light: Themes.lightTheme,
      dark: Themes.darkTheme,
      initial: AdaptiveThemeMode.light,
      builder: (light, dark) => MaterialApp(
        theme: light,
        darkTheme: dark,
        builder: EasyLoading.init(),
        initialRoute: '/home',
        routes: {
          '/home': (context) => Home(
            db: isar,
            location: locationService,
            trackService: trackService,
            logger: logger
          ),
        },
      ),
    )
  );
}