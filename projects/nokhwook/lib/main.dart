import 'package:flutter/material.dart';
import 'package:nokhwook/pages/home.dart';
import 'package:nokhwook/pages/loading.dart';
import 'package:nokhwook/services/navigation_service.dart';

Future<void> main () async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MaterialApp(
      navigatorKey: NavigationService.navigatorKey,
      // home: Stage(),
      routes: {
        '/': (context) => Loading(notificationService: notificationService),
        '/home': ((context) => Home(notificationService: notificationService)),
      },
    )
  );
}