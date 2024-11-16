import 'dart:async';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:background_service_app/features/subtitles/subtitle_widget.dart';
import 'package:background_service_app/features/swiper/local_swiper.dart';
import 'package:background_service_app/services/location_service.dart';
import 'package:background_service_app/themes.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

// import 'features/swiper/swiper.dart';

void main() {
  // LocationTask.initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      light: CustomTheme.lightTheme,
      dark: CustomTheme.darkTheme,
      initial: AdaptiveThemeMode.light,
      builder: (theme, darkTheme) => MaterialApp(
        title: 'Flutter Demo',
        theme: theme,
        darkTheme: darkTheme,
        home: const MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  LocationService locationService = LocationService(
    radius: 20,
    interval: const Duration(seconds: 30),
    notificationText: "Click to see the details.",
    notificationTitle: "Recording Track",
  );

  late StreamSubscription<Position> locationSubscription;

  final dateFormat = DateFormat("HH:mm:ss");
  List<Position> trackPoints = [];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await locationService.initialize();
      locationSubscription = locationService.listen(addTrackPoint);
    });
  }

  addTrackPoint(Position? trackPoint) {
    setState(() => trackPoints.add(trackPoint!));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(children: [
        Text('Hello'),
        Expanded(
          child: const SubtitleWidget(),
        ),
        // Expanded(child: Text(''))
      ]),
      //   body: const SubtitleWidget(
      //       path:
      //           'assets/subtitles/captain.america.the.first.avenger.2011.en.srt'),
    );
  }

  @override
  void dispose() {
    locationSubscription.cancel();
    super.dispose();
  }
}
