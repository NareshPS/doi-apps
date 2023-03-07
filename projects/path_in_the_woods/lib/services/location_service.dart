import 'dart:math';

import 'package:geolocator/geolocator.dart';
import 'package:path_in_the_woods/utils/resolve_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tuple/tuple.dart';

class KalmanData {
  final double latitude;
  final double longitude;
  final int timestamp;
  final double variance;

  KalmanData({
    required this.latitude,
    required this.longitude,
    required this.timestamp,
    required this.variance,
  });
}

class KalmanFilter {
  final double q;
  KalmanData? current;

  KalmanFilter(this.q);

  get data => current;

  double uncertainityDelta(timeDelta) =>
      (timeDelta > 0) ? timeDelta * q * q / 1000 : 0;

  reset() => current = null;

  Position process(Position p) {
    final accuracy = max(1.0, p.accuracy);

    if (current == null) {
      current = KalmanData(
          latitude: p.latitude,
          longitude: p.longitude,
          timestamp: p.timestamp!.millisecondsSinceEpoch,
          variance: accuracy * accuracy);
    } else {
      final timeDelta =
          p.timestamp!.millisecondsSinceEpoch - current!.timestamp;
      var uncertainity = current!.variance + uncertainityDelta(timeDelta);
      var kalmanFactor = uncertainity / (uncertainity + accuracy * accuracy);

      current = KalmanData(
        latitude:
            current!.latitude + kalmanFactor * (p.latitude - current!.latitude),
        longitude: current!.longitude +
            kalmanFactor * (p.longitude - current!.longitude),
        timestamp: p.timestamp!.millisecondsSinceEpoch,
        variance: (1 - kalmanFactor) * uncertainity,
      );
    }

    return Position(
      latitude: current!.latitude,
      longitude: current!.longitude,
      timestamp: DateTime.fromMillisecondsSinceEpoch(current!.timestamp),
      accuracy: sqrt(current!.variance),
      altitude: p.altitude,
      heading: p.heading,
      speed: p.speed,
      speedAccuracy: p.speedAccuracy,
      floor: p.floor,
    );
  }
}

//   const KalmanFilter(this.q);

//     private final float MinAccuracy = 1;

//     private float Q_metres_per_second;
//     private long TimeStamp_milliseconds;
//     private double lat;
//     private double lng;
//     private float variance; // P matrix.  Negative means object uninitialised.  NB: units irrelevant, as long as same units used throughout

//     public KalmanLatLong(float Q_metres_per_second) { this.Q_metres_per_second = Q_metres_per_second; variance = -1; }

//     public long get_TimeStamp() { return TimeStamp_milliseconds; }
//     public double get_lat() { return lat; }
//     public double get_lng() { return lng; }
//     public float get_accuracy() { return (float)Math.sqrt(variance); }

//     public void SetState(double lat, double lng, float accuracy, long TimeStamp_milliseconds) {
//         this.lat=lat; this.lng=lng; variance = accuracy * accuracy; this.TimeStamp_milliseconds=TimeStamp_milliseconds;
//     }

//     /// <summary>
//     /// Kalman filter processing for lattitude and longitude
//     /// </summary>
//     /// <param name="lat_measurement_degrees">new measurement of lattidude</param>
//     /// <param name="lng_measurement">new measurement of longitude</param>
//     /// <param name="accuracy">measurement of 1 standard deviation error in metres</param>
//     /// <param name="TimeStamp_milliseconds">time of measurement</param>
//     /// <returns>new state</returns>
//     public void Process(double lat_measurement, double lng_measurement, float accuracy, long TimeStamp_milliseconds) {
//         if (accuracy < MinAccuracy) accuracy = MinAccuracy;
//         if (variance < 0) {
//             // if variance < 0, object is unitialised, so initialise with current values
//             this.TimeStamp_milliseconds = TimeStamp_milliseconds;
//             lat=lat_measurement; lng = lng_measurement; variance = accuracy*accuracy;
//         } else {
//             // else apply Kalman filter methodology

//             long TimeInc_milliseconds = TimeStamp_milliseconds - this.TimeStamp_milliseconds;
//             if (TimeInc_milliseconds > 0) {
//                 // time has moved on, so the uncertainty in the current position increases
//                 variance += TimeInc_milliseconds * Q_metres_per_second * Q_metres_per_second / 1000;
//                 this.TimeStamp_milliseconds = TimeStamp_milliseconds;
//                 // TO DO: USE VELOCITY INFORMATION HERE TO GET A BETTER ESTIMATE OF CURRENT POSITION
//             }

//             // Kalman gain matrix K = Covarariance * Inverse(Covariance + MeasurementVariance)
//             // NB: because K is dimensionless, it doesn't matter that variance has different units to lat and lng
//             float K = variance / (variance + accuracy * accuracy);
//             // apply K
//             lat += K * (lat_measurement - lat);
//             lng += K * (lng_measurement - lng);
//             // new Covarariance  matrix is (IdentityMatrix - K) * Covarariance
//             variance = (1 - K) * variance;
//         }
//     }
// }

class LocationService {
  static const serviceRadius = Tuple2('location_service.radius', 20);
  static const serviceInterval = Tuple2('location_service.interval', 20);

  final String notificationTitle;
  final String notificationText;
  Duration? interval;
  int? radius;

  LocationPermission permission = LocationPermission.unableToDetermine;
  KalmanFilter filter = KalmanFilter(3.0);
  late SharedPreferences prefs;

  LocationService(
      {this.notificationText = 'Click to see the details',
      this.notificationTitle = 'Running in the Background',
      this.interval,
      this.radius});

  initialize() async {
    prefs = await SharedPreferences.getInstance();

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
    switch (permission) {
      case LocationPermission.always:
      case LocationPermission.whileInUse:
        return true;
      default:
        return false;
    }
  }

  reset() => filter.reset;
  Future<Position> get() => Geolocator.getCurrentPosition();

  listen(callback) {
    return Geolocator.getPositionStream(locationSettings: androidSettings)
        .listen((p) => callback(filter.process(p)));
  }

  get androidSettings => AndroidSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter:
          ResolveSettings.resolve(prefs, serviceRadius, override: radius),
      forceLocationManager: false,
      intervalDuration: Duration(
          seconds: ResolveSettings.resolve(prefs, serviceInterval,
              override: interval)),
      foregroundNotificationConfig: ForegroundNotificationConfig(
        notificationText: notificationText,
        notificationTitle: notificationTitle,
        enableWakeLock: true,
      ));
}
