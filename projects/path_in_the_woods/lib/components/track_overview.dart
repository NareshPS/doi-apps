import 'package:flutter/material.dart';
import 'package:path_in_the_woods/components/info_card.dart';
import 'package:path_in_the_woods/models/track.dart';
import 'package:tuple/tuple.dart';

class TrackOverview extends StatelessWidget {
  final Track track;
  const TrackOverview(this.track, {super.key});

  @override
  Widget build(BuildContext context) {
    return InfoCard(
      infoItems: [
        Tuple2('id', '${track.id}'),
        Tuple2('name', '${track.name}'),
        Tuple2('length', '${track.latitudes.length}'),
        Tuple2('status', track.status.name.toUpperCase()),
      ]
    );
  }
}