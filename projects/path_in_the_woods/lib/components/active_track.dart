import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:isar/isar.dart';
import 'package:latlong2/latlong.dart';
import 'package:path_in_the_woods/components/new_track_form.dart';
import 'package:path_in_the_woods/components/track_control.dart';
import 'package:path_in_the_woods/components/track_details.dart';
import 'package:path_in_the_woods/models/track.dart';
import 'package:path_in_the_woods/services/location_service.dart';
import 'package:path_in_the_woods/services/track_service.dart';

class ActiveTrack extends StatefulWidget {
  final Isar db;
  final LocationService location;
  final TrackService trackService;
  final Function onStart, onStop;

  const ActiveTrack(
      {super.key,
      required this.db,
      required this.location,
      required this.trackService,
      required this.onStart,
      required this.onStop});

  @override
  State<ActiveTrack> createState() => _ActiveTrackState();
}

class _ActiveTrackState extends State<ActiveTrack> {
  void start(trackName) async {
    widget.trackService.create(trackName);
    await widget.onStart();
    widget.trackService.writeOff();
  }

  void conclude() async {
    await widget.onStop();
    widget.trackService.conclude();
    widget.trackService.writeOff();
  }

  void center(trackDetails) async {
    widget.location.get().then((position) {
      trackDetails.controller.add(TrackActionMessage(
          action: TrackAction.moveTo,
          data: LatLng(position.latitude, position.longitude)));
    });
  }

  @override
  Widget build(BuildContext context) {
    final trackDetails = TrackDetails(track: widget.trackService.track);
    center(trackDetails);

    return Stack(
      children: [
        trackDetails,
        Column(mainAxisAlignment: MainAxisAlignment.end, children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Spacer(),
                Expanded(
                  child: TrackControl(
                    initialState: () {
                      switch (widget.trackService.track.status) {
                        case (TrackStatus.inProgress):
                          return TrackControlIcon.stop;
                        default:
                          return TrackControlIcon.play;
                      }
                    },
                    onPlay: () {
                      showDialog(
                          context: context,
                          builder: (context) => NewTrackForm(
                                onAccept: (name) {
                                  start(name);
                                },
                              ));
                      return true;
                    },
                    onStop: () {
                      conclude();
                      return true;
                    },
                  ),
                ),
                Expanded(
                    child: Container(
                  alignment: Alignment.bottomRight,
                  child: IconButton(
                      onPressed: () => center(trackDetails),
                      icon: SizedBox.expand(
                        child: FittedBox(
                          child: Icon(
                            Icons.my_location,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      )),
                )),
              ],
            ),
          )
        ]),
      ],
    );
  }
}
