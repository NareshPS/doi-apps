import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path_in_the_woods/components/track_overview.dart';
import 'package:path_in_the_woods/models/track.dart';
import 'package:path_in_the_woods/pages/view_track.dart';
import 'package:provider/provider.dart';

class TrackList extends StatelessWidget {
  final Isar db;
  const TrackList({super.key, required this.db});

  Future<List<Track>> trackPod() async {
    final tracks = db.tracks;
    // TODO: Get DB changes.
    return tracks.filter().not().statusEqualTo(TrackStatus.ready).findAll();
  }

  @override
  Widget build(BuildContext context) {
    return FutureProvider<List<Track>>(
      initialData: const [],
      create: (context) => trackPod(),
      catchError: (context, error) => throw Exception(Text(error.toString())),
      child: Consumer<List<Track>>(
          builder: (context, tracks, child) {
            return ListView.builder(
              itemCount: tracks.length,
              itemBuilder: (context, index) => GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ViewTrack(track: tracks[index])
                    ),
                  );
                },
                child: TrackOverview(tracks[index])
              ),
            );
          },
        )
      );
  }
}