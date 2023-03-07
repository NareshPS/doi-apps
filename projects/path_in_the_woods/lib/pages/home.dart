import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geolocator/geolocator.dart';
import 'package:isar/isar.dart';
import 'package:logger/logger.dart';
import 'package:path_in_the_woods/components/active_track.dart';
import 'package:path_in_the_woods/components/app_preferences.dart';
import 'package:path_in_the_woods/components/track_list.dart';
import 'package:path_in_the_woods/models/track.dart';
import 'package:path_in_the_woods/services/location_service.dart';
import 'package:path_in_the_woods/services/track_service.dart';

class Home extends StatefulWidget {
  final Isar db;
  final LocationService location;
  final TrackService trackService;
  final Logger logger;

  const Home(
      {super.key,
      required this.db,
      required this.location,
      required this.trackService,
      required this.logger});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final defaultContent = const Center(child: Text('Welcome'));
  String title = 'Home';

  late Widget content;
  dynamic locationSubscription;

  listenMovements() async {
    await widget.location.initialize();

    if (widget.location.allowed()) {
      widget.location.reset();
      locationSubscription = widget.location.listen((Position? trackPoint) {
        // print('track point: ${widget.trackService.track.length}');
        widget.trackService.addPoint(trackPoint);
        widget.trackService.writeOff();
      });
    } else {
      EasyLoading.showError(
          'Location Unavailable. ${widget.location.permission.name}');
    }
  }

  @override
  void initState() {
    super.initState();
    content = defaultContent;

    if (widget.trackService.track.status == TrackStatus.inProgress) {
      listenMovements();
    }
  }

  @override
  void dispose() {
    if (locationSubscription != null) locationSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final activeTrack = ActiveTrack(
        db: widget.db,
        location: widget.location,
        trackService: widget.trackService,
        onStart: listenMovements,
        onStop: () async => {
              if (locationSubscription != null)
                await locationSubscription.cancel()
            });
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: Text(title),
            centerTitle: true,
            actions: [
              IconButton(
                  onPressed: AdaptiveTheme.of(context).toggleThemeMode,
                  icon: const Icon(Icons.brightness_auto_rounded))
            ],
          ),
          bottomNavigationBar: BottomAppBar(
              color: Theme.of(context).colorScheme.background,
              shape: const CircularNotchedRectangle(),
              child: IconTheme(
                data:
                    IconThemeData(color: Theme.of(context).colorScheme.primary),
                child: Flex(
                    direction: Axis.horizontal,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                          onPressed: () => setState(() {
                                title = 'Home';
                                content = defaultContent;
                              }),
                          icon: const Icon(Icons.home)),
                      IconButton(
                        icon: const Icon(Icons.radar),
                        tooltip: 'Record',
                        onPressed: () => setState(() {
                          title = 'Current Track';
                          content = activeTrack;
                        }),
                      ),
                      IconButton(
                        icon: const Icon(Icons.route),
                        tooltip: 'All Tracks',
                        onPressed: () {
                          setState(() {
                            title = 'All Tracks';
                            content = TrackList(db: widget.db);
                          });
                        },
                      ),
                      IconButton(
                          onPressed: () => setState(() {
                                title = 'Settings';
                                content = const AppPreferences();
                              }),
                          icon: const Icon(Icons.settings))
                    ]),
              )),
          body: content),
    );
  }
}
