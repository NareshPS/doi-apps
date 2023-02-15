
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:isar/isar.dart';
import 'package:path_in_the_woods/services/location_service.dart';

class ActiveTrackLoading extends StatefulWidget {
  final LocationService location;
  final Isar db;

  const ActiveTrackLoading({
    super.key,
    required this.db,
    required this.location,
  });

  @override
  State<ActiveTrackLoading> createState() => _ActiveTrackLoadingState();
}

class _ActiveTrackLoadingState extends State<ActiveTrackLoading> {
  String loadingMessage = 'Checking location services...';

  void updateMessage(message) {
    setState(() {
      loadingMessage = '$message' ' Status: ${widget.location.permission.name}';
    });
  }

  void checkPermissionsAndRedirect() async {
    updateMessage(loadingMessage);
    await widget.location.initialize();

    if (widget.location.allowed()) {
      updateMessage('Location services available');

      if (mounted) {
        Navigator.pushReplacementNamed(context, '/active_track');
      }
    } else {
      updateMessage('Location services unavailable');

      if (mounted) {
        Navigator.pop(context, {
          'PermissionStatus': widget.location.permission.name
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    checkPermissionsAndRedirect();
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