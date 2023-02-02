
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:isar/isar.dart';
import 'package:location/location.dart';
import 'package:path_in_the_woods/models/track.dart';
import 'package:path_in_the_woods/pages/active_track.dart';

class ActiveTrackLoading extends StatefulWidget {
  final Isar db;
  const ActiveTrackLoading({super.key, required this.db});

  @override
  State<ActiveTrackLoading> createState() => _ActiveTrackLoadingState();
}

class _ActiveTrackLoadingState extends State<ActiveTrackLoading> {
  Location location = Location();
  String loadingMessage = 'Checking location service...';
  late LocationData current;

  void updateMessage(message) {
    setState(() {
      loadingMessage = message;
    });
  }

  void checkPermissions() async {
    bool serviceEnabled = await location.serviceEnabled();
    PermissionStatus permissionStatus = PermissionStatus.denied;
    bool locationAllowed(p) => p == PermissionStatus.granted;
    
    if (serviceEnabled) {
      serviceEnabled = await location.requestService();
    }

    if (serviceEnabled) {
      serviceEnabled = await location.changeSettings(
        accuracy: LocationAccuracy.high,
        // interval: 30000,
        distanceFilter: 10.0,
      );
    }

    if (serviceEnabled) {
      updateMessage('Location service is available. Checking for permissions...');
      permissionStatus = await location.hasPermission();

      if (!locationAllowed(permissionStatus)) {
        updateMessage('Location permissions are unavailable. Requesting...');
        permissionStatus = await location.requestPermission();
      }
    }

    if (!locationAllowed(permissionStatus)) {
      updateMessage('LocationServiceStatus: $serviceEnabled PermissionStatus: $permissionStatus');

      if (mounted){
        Navigator.pop(context, {
          'ServiceStatus': serviceEnabled,
          'PermissionStatus': permissionStatus
        });
      } else {
        print('active_trail_loading not mounted');
      }
    } else {
      updateMessage('Loading tracks...');

      if (mounted){
        Navigator.pushReplacementNamed(context, '/active_track');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    checkPermissions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[700],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SpinKitCubeGrid(
              color: Colors.white,
              size: 80.0
            ),
            const SizedBox(height: 10.0),
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 8.0),
              child: Text(
                loadingMessage,
                style: TextStyle(
                  color: Colors.green[700],
                  fontStyle: FontStyle.italic,
                  fontSize: 16.0
                ),
              ),
            )
          ]
        )
      ),
    );
  }
}