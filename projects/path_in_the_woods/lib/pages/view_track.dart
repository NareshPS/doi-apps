import 'package:flutter/material.dart';
import 'package:path_in_the_woods/components/track_details.dart';
import 'package:path_in_the_woods/models/track.dart';

class ViewTrack extends StatelessWidget {
  final Track track;

  const ViewTrack({super.key, required this.track});

  String get trackName => track.name ?? track.id.toString();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Track: ${trackName.isNotEmpty? trackName: track.id}'),
        centerTitle: true,
      ),
      body: TrackDetails(track: track),
    );
  }
}