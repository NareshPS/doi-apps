import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:path_in_the_woods/components/track_point_overview.dart';
import 'package:path_in_the_woods/models/track.dart';

class TrackDetails extends StatelessWidget {
  final Track track;
  final MapController mapController = MapController();
  static const double zoom = 15.0;

  TrackDetails({super.key, required this.track}) {
    // centerMap();
  }

  void centerMap() {
    if (track.isNotEmpty) {
      TrackPoint trackPoint = track.last;
      mapController.move(LatLng(trackPoint.latitude, trackPoint.longitude), zoom);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.green[700],
        padding: const EdgeInsets.all(2.0),
        child: Column(
          children: [
            Expanded(
              child: FlutterMap(
                mapController: mapController,
                
                options: MapOptions(
                  center: LatLng(18.7883433, 98.9853),
                  zoom: zoom
                ),
                children: [
                    TileLayer(
                        urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.doiapps.path_in_the_woods',
                    ),
                    PolylineLayer(
                      polylineCulling: false,
                      polylines: [
                        Polyline(
                          points: track.map((e) => LatLng(e.latitude, e.longitude)).toList(),
                          strokeWidth: 5.0,
                          color: Colors.brown,
                          isDotted: true
                        ),
                      ],
                    ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.green[700],
              ),
              margin: const EdgeInsets.only(bottom: 2.0),
              child: Flex(
                direction: Axis.horizontal,
                children: [
                  Flexible(
                    fit: FlexFit.tight,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Text(
                            'Trackpoints'.toUpperCase(),
                            style: TextStyle(
                              color: Colors.grey[100],
                              fontWeight: FontWeight.bold
                            ),
                          ),
                          const SizedBox(width: 5,),
                          Text(
                            '${track.length}',
                            style: TextStyle(
                              color: Colors.grey[100],
                              fontWeight: FontWeight.bold
                            ),
                          )
                        ]
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 8.0),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.grey[300]),
                        foregroundColor: MaterialStateProperty.all(Colors.green[700])
                      ),
                      onPressed: centerMap,
                      child: const Text('Center'),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: ListView(
                children: List.generate(
                  track.length,
                  (index) => TrackPointOverview(
                    trackPoint: track[index],
                    prior: track[max(0, index-1)],
                  ),
                )
              ),
            ),
          ],
        ),
      );
  }
}