import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:latlong2/latlong.dart';
import 'package:path_in_the_woods/models/track.dart';
import 'package:tuple/tuple.dart';

enum TrackAction { center, moveTo }

class TrackActionMessage {
  final TrackAction action;
  final dynamic data;

  TrackActionMessage({required this.action, this.data});
}

class TrackDetails extends StatefulWidget {
  static const double zoom = 15.0;

  final Track track;
  final controller = StreamController<TrackActionMessage>();

  TrackDetails({super.key, required this.track});

  @override
  State<TrackDetails> createState() => _TrackDetailsState();
}

class _TrackDetailsState extends State<TrackDetails> {
  final minMarkerSeparationInMeters = 200;
  final Distance distance = const Distance();
  final MapController mapController = MapController();
  dynamic actionSubscription;

  void centerMap() {
    if (widget.track.isNotEmpty) {
      TrackPoint trackPoint = widget.track.last;
      mapController.move(
          LatLng(trackPoint.latitude, trackPoint.longitude), TrackDetails.zoom);
    }
  }

  void moveTo(LatLng position) {
    mapController.move(position, TrackDetails.zoom);
  }

  @override
  void initState() {
    super.initState();
    widget.track.addListener(() => mounted ? setState(() {}) : null);

    actionSubscription = widget.controller.stream.listen((event) {
      if (mounted) {
        switch (event.action) {
          case TrackAction.center:
            centerMap();
            break;
          case TrackAction.moveTo:
            moveTo(event.data as LatLng);
            break;
        }
      }
    });
    widget.controller.add(TrackActionMessage(action: TrackAction.center));
  }

  @override
  void dispose() {
    widget.track.removeListener((() => {}));
    if (actionSubscription != null) actionSubscription.cancel();

    super.dispose();
  }

  toLatLng(TrackPoint p) => LatLng(p.latitude, p.longitude);

  Marker toMarker(TrackPoint p) => Marker(
      point: toLatLng(p),
      builder: (context) => Icon(Icons.square,
          size: 12.0, color: Theme.of(context).colorScheme.secondary));

  Marker startMarker(TrackPoint start) => Marker(
      point: toLatLng(start),
      builder: (context) =>
          Icon(Icons.radio_button_on, color: Theme.of(context).colorScheme.secondary));

  Marker endMarker(TrackPoint end) => Marker(
      point: toLatLng(end),
      builder: (context) => Icon(Icons.flag,
          color: Theme.of(context).colorScheme.secondary));

  Iterable<TrackPoint> interestingTrackpoints() {
    final distances = <Tuple3>[const Tuple3(0, 0, 0.0)];

    for (var idx = 1; idx < widget.track.length; idx++) {
      distances.add(Tuple3(
          idx - 1,
          idx,
          distance.as(LengthUnit.Meter, toLatLng(widget.track[idx - 1]),
              toLatLng(widget.track[idx]))));
    }

    final points = distances
        .where((e) => e.item3 > minMarkerSeparationInMeters)
        .fold(<int>{}, (value, element) {
          value
            ..add(element.item1)
            ..add(element.item2);
          return value;
        })
        .map((index) => widget.track[index])
        .toList();

    print('Track: ${widget.track.name} Points: ${points}');
    return points;
  }

  @override
  Widget build(BuildContext context) {
    final totalPoints = widget.track.length;
    final markers = <Marker>[];

    if (totalPoints >= 2) {
      markers.add(startMarker(widget.track.first));
      markers.add(endMarker(widget.track.last));
    }

    markers.addAll(interestingTrackpoints().map(toMarker));

    return Stack(children: [
      FlutterMap(
        mapController: mapController,
        options: MapOptions(zoom: TrackDetails.zoom, onMapReady: centerMap),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.doiapps.path_in_the_woods',
          ),
          PolylineLayer(
            polylines: [
              Polyline(
                  points: widget.track
                      .map((e) => LatLng(e.latitude, e.longitude))
                      .toList(),
                  strokeWidth: 5.0,
                  color: Theme.of(context).colorScheme.tertiary,
                  isDotted: true),
            ],
          ),
          MarkerLayer(markers: markers),
          CurrentLocationLayer(
            style: LocationMarkerStyle(
              headingSectorColor: Theme.of(context).colorScheme.secondary,
              marker: DefaultLocationMarker(
                  color: Theme.of(context).colorScheme.secondary),
            ),
          )
        ],
      ),
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Spacer(),
              Container(
                margin: const EdgeInsets.all(8.0),
                padding: const EdgeInsets.all(4.0),
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onSecondary,
                    borderRadius: BorderRadius.circular(8.0)),
                child: Column(
                  children: [
                    Text(
                      'Track '.toUpperCase(),
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                    Text(
                      widget.track.name ?? '(no name)',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ],
                ),
              ),
              const Spacer()
            ],
          ),
        ],
      ),
    ]);
  }
}
