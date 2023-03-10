import 'package:flutter/widgets.dart';
import 'package:isar/isar.dart';

part 'track.g.dart';

class TrackPoint {
  final double latitude;
  final double longitude;
  final double timestamp;

  TrackPoint(this.latitude, this.longitude, this.timestamp);
}

enum TrackStatus { ready, inProgress, paused, concluded }

@Collection(inheritance: false)
class Track extends Iterable<TrackPoint> with ChangeNotifier {
  Id id = Isar.autoIncrement; // you can also use id = null to auto increment

  String? name;
  List<double> latitudes = [];
  List<double> longitudes = [];
  List<double> timestamps = [];

  @enumerated
  TrackStatus status;

  Track({this.name, this.status = TrackStatus.ready});

  @override
  @ignore
  int get length => latitudes.length;

  @override
  @ignore
  bool get isNotEmpty => longitudes.isNotEmpty;

  @override
  @ignore
  TrackPoint get last => this[latitudes.length - 1];

  void addTrackPoint(TrackPoint trackPoint) {
    latitudes.add(trackPoint.latitude);
    longitudes.add(trackPoint.longitude);
    timestamps.add(trackPoint.timestamp);

    notifyListeners();
  }

  void add(latitude, longitude, timestamp) {
    latitudes.add(latitude);
    longitudes.add(longitude);
    timestamps.add(timestamp);

    notifyListeners();
  }

  TrackPoint operator [](index) =>
      TrackPoint(latitudes[index], longitudes[index], timestamps[index]);

  @override
  @ignore
  Iterator<TrackPoint> get iterator => TrackIterator(this);
}

class TrackIterator implements Iterator<TrackPoint> {
  final Track track;
  int _current = 0;

  TrackIterator(this.track);

  @override
  TrackPoint get current => track[_current];

  @override
  bool moveNext() {
    _current += 1;
    return _current < track.length;
  }
}

extension TrackExtensions on Track {
  ///
  Track growable() {
    latitudes = latitudes.toList();
    longitudes = longitudes.toList();
    timestamps = timestamps.toList();

    return this;
  }
}
