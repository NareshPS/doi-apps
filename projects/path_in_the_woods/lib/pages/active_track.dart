
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:isar/isar.dart';
import 'package:path_in_the_woods/components/track_details.dart';
import 'package:path_in_the_woods/models/track.dart';
import 'package:path_in_the_woods/services/location_service.dart';
import 'package:provider/provider.dart';

class ActiveTrack extends StatefulWidget {
  final Isar db;
  final LocationService location;

  const ActiveTrack({
    super.key,
    required this.db,
    required this.location
  });

  @override
  State<ActiveTrack> createState() => _ActiveTrackState();
}

class _ActiveTrackState extends State<ActiveTrack> {
  late dynamic locationSubscription;
  late Track track;

  @override
  void dispose() {
    locationSubscription.cancel();

    super.dispose();
  }

  Future<Track?> activeTrackPod() async {
    final tracks = widget.db.tracks;
    final lastTrackId = tracks.countSync();

    return tracks.get(lastTrackId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureProvider<Track?>(
      initialData: Track(),
      create: (context) => activeTrackPod(),
      updateShouldNotify: (previous, track) {
        locationSubscription = widget.location.listen(
          (Position? trackPoint) => setState(() {
            track!.add(
              trackPoint?.latitude,
              trackPoint?.longitude,
              trackPoint?.timestamp?.millisecondsSinceEpoch.toDouble()
            );
            widget.db.writeTxn(() => widget.db.tracks.put(track));
          })
        );

        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Active Track'),
          centerTitle: true,
          backgroundColor: Colors.green[700],
        ),
        body: Consumer<Track>(
          builder: (context, track, child) => TrackDetails(track: track.growable())
        )
      ),
    );
  }
}