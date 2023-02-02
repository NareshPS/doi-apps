import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path_in_the_woods/models/track.dart';
import 'package:path_in_the_woods/pages/active_track.dart';
import 'package:path_in_the_woods/pages/active_track_loading.dart';
import 'package:path_in_the_woods/pages/track_list.dart';
import 'package:path_in_the_woods/pages/side_bar.dart';

void main() async {
  final Isar isar = await Isar.open([TrackSchema]);

  // Ensure that there is at least one track in the database.
  if (isar.tracks.countSync() == 0) {
    isar.writeTxnSync(() => isar.tracks.putSync(Track(name: '(current)')));
  }

  runApp(MaterialApp(
    routes: {
      '/': (context) => const Home(),
      '/active_track_loading': (context) => ActiveTrackLoading(db: isar),
      '/active_track': (context) => ActiveTrack(db: isar),
      '/track_list': ((context) => TrackList(db: isar)),
    },
  ));
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[400],
      appBar: AppBar(
        title: const Text('Home'),
        centerTitle: true,
        backgroundColor: Colors.green[700],
      ),
      drawer: const SideBar(),
      body: Container(
        color: Colors.white,
        child: Center(
          child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.green[700])
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/active_track_loading');
            },
            child: const Text('Active Track')
          ),
        ),
      ),
    );
  }
}
