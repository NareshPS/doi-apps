import 'package:geolocator/geolocator.dart';
import 'package:isar/isar.dart';
import 'package:path_in_the_woods/models/track.dart';

class TrackService {
  final Isar db;
  Track? _track;

  TrackService({required this.db});

  initialize() async {
    final tracks = db.tracks;
    final allTracks = await tracks.where().findAll();
    
    if (allTracks.isNotEmpty) {
      final lastTrack = allTracks.last;

      if (lastTrack.status != TrackStatus.concluded) {
        _track = lastTrack.growable();
      }

    }

    _track ??= Track();
  }

  create(name) {
    _track = Track(name: name, status: TrackStatus.inProgress);
  }

  addPoint(Position? point) {
    track.add(
      point?.latitude,
      point?.longitude,
      point?.timestamp?.millisecondsSinceEpoch.toDouble()
    );
  }

  pause() {
    track.status = TrackStatus.paused;
  }

  conclude() {
    track.status = TrackStatus.concluded;
  }

  writeOff() {
    db.writeTxnSync(() => db.tracks.putSync(track));
  }

  Track get track => _track!;
}