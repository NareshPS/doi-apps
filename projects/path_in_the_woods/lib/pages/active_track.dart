
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:location/location.dart';
import 'package:path_in_the_woods/components/track_details.dart';
import 'package:path_in_the_woods/models/track.dart';
import 'package:provider/provider.dart';

class ActiveTrack extends StatefulWidget {
  final Isar db;
  const ActiveTrack({super.key, required this.db});

  @override
  State<ActiveTrack> createState() => _ActiveTrackState();
}

class _ActiveTrackState extends State<ActiveTrack> {
  final Location location = Location();
  late dynamic locationSubscription;
  late Track track;

  @override
  void initState() {
    super.initState();

    // widget.db.tracks.get(widget.db.tracks.countSync()).then((value) {
    //   track = value!.growable();

    //   locationSubscription = location.onLocationChanged.listen(
    //     (LocationData data) {
    //       if (mounted) {
    //         setState(() {
    //           track.add(data.latitude, data.longitude, data.time);
    //           widget.db.writeTxn(() => widget.db.tracks.put(track));
    //         });
    //       }
    //     }
    //   );
    // });
  }

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
        locationSubscription = location.onLocationChanged.listen(
          (LocationData data) {
            if (mounted) {
              setState(() {
                track!.add(data.latitude, data.longitude, data.time);
                widget.db.writeTxn(() => widget.db.tracks.put(track));
              });
            }
          }
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