import 'package:flutter/material.dart';
import 'package:path_in_the_woods/components/info_card.dart';
import 'package:path_in_the_woods/components/simple_info.dart';
import 'package:path_in_the_woods/models/track.dart';
import 'package:tuple/tuple.dart';

class TrackOverview extends StatelessWidget {
  final Track track;
  const TrackOverview(this.track, {super.key});

  Widget getHeading(value) {
    return Text(
      value.toUpperCase(),
      style: TextStyle(color: Colors.grey[600]),
    );
  }

  Widget getInfo(value) {
    return Text(
      '$value',
      style: TextStyle(
        color: Colors.green[600],
        letterSpacing: 1.15,
        fontWeight: FontWeight.w600
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InfoCard(
      infoItems: [
        Tuple2('id', '${track.id}'),
        Tuple2('name', '${track.name}')
      ]
    );
  }
}