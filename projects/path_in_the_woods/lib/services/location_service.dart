import 'package:geolocator/geolocator.dart';

class LocationService {
  final int radius;
  final Duration? interval;
  final String notificationTitle;
  final String notificationText;

  LocationPermission permission = LocationPermission.unableToDetermine;

  LocationService({
    this.radius = 50,
    this.interval = const Duration(seconds: 30),
    this.notificationText = 'Click to see the details',
    this.notificationTitle = 'Running in the Background'
  });

  initialize() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (serviceEnabled) {
      permission = await Geolocator.checkPermission();

      if (!allowed()) {
        permission = await Geolocator.requestPermission();
      }
    }

    return permission;
  }

  allowed() {
    switch(permission) {
      case LocationPermission.always:
      case LocationPermission.whileInUse:
        return true;
      default:
        return false;
    }
  }

  listen(callback) {
    return Geolocator.getPositionStream(locationSettings: androidSettings)
    .listen(callback);
  }

  get androidSettings => AndroidSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: radius,
    forceLocationManager: false,
    intervalDuration: interval,
    foregroundNotificationConfig: ForegroundNotificationConfig(
        notificationText: notificationText,
        notificationTitle: notificationTitle,
        enableWakeLock: true,
    )
  );
}