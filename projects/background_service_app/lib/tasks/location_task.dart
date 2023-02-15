import 'dart:async';
import 'dart:isolate';

import 'package:flutter_foreground_task/flutter_foreground_task.dart';
// import 'package:location/location.dart';

class LocationTaskHandler extends TaskHandler {
  // final location = Location();
  // late StreamSubscription<LocationData> locationStream;

  @override
  Future<void> onStart(DateTime timestamp, SendPort? sendPort) async {
    // Location().onLocationChanged.listen((data) {
    //   print('Task Latitude: ${data.latitude} Longitude: ${data.longitude}');
    //   // sendPort?.send(data);
    // });
  }

  @override
  Future<void> onEvent(DateTime timestamp, SendPort? sendPort) async {
    // LocationData locationData = await location.getLocation();
    // print('received event. ${locationData}');
  }

  @override
  Future<void> onDestroy(DateTime timestamp, SendPort? sendPort) async {
    // locationStream.cancel();
  }
}

class LocationTask {
  static initialize() {
    FlutterForegroundTask.init(
      foregroundTaskOptions: const ForegroundTaskOptions(
        interval: 30000,
        allowWakeLock: true,
      ),
      iosNotificationOptions: const IOSNotificationOptions(),
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: 'track_recorder_channel_id',
        channelName: 'Track Recorder',
        iconData: const NotificationIconData(
          name: 'launcher',
          resType: ResourceType.mipmap,
          resPrefix: ResourcePrefix.ic
        )
      ),
    );
  }

  static startService() async {
    if (await FlutterForegroundTask.isRunningService) {
      await FlutterForegroundTask.restartService();
    } else {
      await FlutterForegroundTask.startService(
        notificationTitle: 'Foreground Service is running',
        notificationText: 'Tap to return to the app',
        callback: setupHandler,
      );
    }
  }

  static stopService() {
    return FlutterForegroundTask.stopService();
  }
}

// The callback function should always be a top-level function.
@pragma('vm:entry-point')
void setupHandler() {
  // The setTaskHandler function must be called to handle the task in the background.
  FlutterForegroundTask.setTaskHandler(LocationTaskHandler());
}

