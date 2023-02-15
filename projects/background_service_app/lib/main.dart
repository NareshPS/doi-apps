import 'dart:async';

import 'package:background_service_app/services/location_service.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

void main() {
  // LocationTask.initialize();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
    // return WithForegroundTask(
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: ListView.builder(
          itemCount: trackPoints.length,
          itemBuilder: (context, index) => Text(
            '${trackPoints[index].latitude}, '
            '${trackPoints[index].longitude}, '
            '${dateFormat.format(
              DateTime.fromMillisecondsSinceEpoch(
                trackPoints[index].timestamp!.millisecondsSinceEpoch
              )
            )}'
          )
        )
      ),
    );
    // );
  }

  @override
  void dispose() {
    locationSubscription.cancel();
    super.dispose();
  }
}

// void startTracking(callback) async {
//   bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

//   print('Enabled: $serviceEnabled');

//   if (serviceEnabled) {
//     LocationPermission p = await Geolocator.checkPermission();

//     print('Permissions: ${p.name}');

//     if (isPermissionDenied(p)) {
//       p = await Geolocator.requestPermission();
//       if (isPermissionDenied(p)) {
//         print('Location tracking permission denied');
//       } else {
//         startListening(callback);
//       }
//     } else {
//       print('Start listening...');
//         startListening(callback);
//     }
//   }
// }

// startListening(recorder) async {
//   final settings = AndroidSettings(
//     accuracy: LocationAccuracy.high,
//     distanceFilter: 20,
//     forceLocationManager: false,
//     intervalDuration: const Duration(seconds: 30),
//     // (Optional) Set foreground notification config to keep the app alive 
//     // when going to the background
//     foregroundNotificationConfig: const ForegroundNotificationConfig(
//         notificationText:
//         "Click to see track details.",
//         notificationTitle: "Recording the current track",
//         enableWakeLock: true,
//     )
//   );

//   return Geolocator.getPositionStream(locationSettings: settings).listen(recorder);
// }

// bool isPermissionDenied(p) {
//   if ((p == LocationPermission.denied)|| (p == LocationPermission.deniedForever)) {
//     return true;
//   }
//   else {
//     return false;
//   }
// }