import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:nokhwook/pages/home.dart';
import 'package:nokhwook/services/notification_service.dart';

final logger = Logger(printer: PrettyPrinter(methodCount: 5));

Future<void> main() async {
  final notificationService = NotificationService();

  WidgetsFlutterBinding.ensureInitialized();

  runApp(MaterialApp(
    routes: {
      '/': (context) => Home(notificationService: notificationService),
    },
  ));
}
