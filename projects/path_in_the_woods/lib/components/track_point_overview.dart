import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:path_in_the_woods/components/info_card.dart';
import 'package:path_in_the_woods/models/track.dart';
import 'package:tuple/tuple.dart';

class TrackPointOverview extends StatelessWidget {
  final TrackPoint trackPoint;
  final TrackPoint? prior;
  final dateFormat = DateFormat("HH:mm:ss");

  TrackPointOverview({super.key, required this.trackPoint, this.prior});

  String getTimeOfDayFromTS(double milliseconds) {
    return dateFormat.format(
      DateTime.fromMillisecondsSinceEpoch(milliseconds.toInt())
    );
  }

  @override
  Widget build(BuildContext context) {
    double distanceInMetres = 0.0;

    if (prior != null) {
      distanceInMetres = const Distance()(
        LatLng((prior?.latitude)!, (prior?.longitude)!),
        LatLng(trackPoint.latitude, trackPoint.longitude),
      );
    }

    return InfoCard(
      infoItems: [
        Tuple2('Coordinates', '(${trackPoint.latitude}, ${trackPoint.longitude})'),
        Tuple2('Movement (M)', '$distanceInMetres'),
        Tuple2('Timestamp', getTimeOfDayFromTS(trackPoint.timestamp))
      ]
    );
  }
}