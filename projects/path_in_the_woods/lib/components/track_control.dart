import 'package:flutter/material.dart';

enum TrackControlIcon {
  play,
  stop
}

class TrackControl extends StatefulWidget {
  final TrackControlIcon Function() initialState;
  final bool Function() onPlay;
  final bool Function() onStop;

  const TrackControl({
    super.key,
    required this.initialState,
    required this.onPlay,
    required this.onStop,
  });

  @override
  State<TrackControl> createState() => _TrackControlState();
}

class _TrackControlState extends State<TrackControl> {
  late TrackControlIcon controlIcon;

  playControl() => FloatingActionButton.large(
    child: Icon(
      Icons.play_arrow,
      color: Theme.of(context).colorScheme.onSecondary
    ),
    onPressed: () {
      if (widget.onPlay()) setState(() => controlIcon = TrackControlIcon.stop);
    }
  );

  stopControl() => FloatingActionButton.large(
    child: Icon(
      Icons.stop,
      color: Theme.of(context).colorScheme.onSecondary
    ),
    onPressed: () {
      if (widget.onStop()) setState(() => controlIcon = TrackControlIcon.play);
    }
  );

  chooseControl() {
    switch(controlIcon) {
      case TrackControlIcon.play:
        return playControl();
      case TrackControlIcon.stop:
        return stopControl();
    }
  }

  @override
  void initState() {
    super.initState();
    controlIcon = widget.initialState();
  }

  @override
  Widget build(BuildContext context) {
    switch(controlIcon) {
      case TrackControlIcon.play:
        return playControl();
      case TrackControlIcon.stop:
        return stopControl();
    }

    // return Column(
    //   mainAxisAlignment: MainAxisAlignment.end,
    //   children: [
    //     Row(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: [
    //         Padding(
    //           padding: const EdgeInsets.all(8.0),
    //           child: chooseControl(context)
    //         ),
    //       ],
    //     )
    //   ]
    // );
  }
}