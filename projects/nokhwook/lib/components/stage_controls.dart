import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class StageControls extends StatefulWidget {
  final Map<String, Function> actions;

  const StageControls({super.key, required this.actions});

  @override
  State<StageControls> createState() => _StageControlsState();
}

class _StageControlsState extends State<StageControls> with WidgetsBindingObserver{
  int maxFrameRateMS = 15000;
  int minFrameRateMS = 500;
  int frameRateMS = 1000;

  String playerState = 'paused';
  Timer? playTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (playerState == 'playing') {
      setState(() => playerState = 'paused');
      stop();
    }
  }

  @override
  void dispose() {
    playTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void start() {
    playTimer = Timer.periodic(
      Duration(milliseconds: frameRateMS),
      (timer) {
        widget.actions['next']!();
      }
    );
  }

  void stop() {
    if(playTimer != null) playTimer!.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        FloatingActionButton.large(
          backgroundColor: Colors.red[400],
          onPressed: () {  },
          child: SleekCircularSlider(
            initialValue: frameRateMS.toDouble(),
            min: minFrameRateMS.toDouble(),
            max: maxFrameRateMS.toDouble(),
            onChange: (value) {
              setState(() {
                frameRateMS = value.toInt();
                playerState = 'playing';
              });
              stop();
              start();
            },
            appearance: CircularSliderAppearance(
              customColors: CustomSliderColors(
                trackColor: Colors.grey[300],
                progressBarColor: Colors.red[400],
                shadowColor: Colors.red[100],
                dotColor: Colors.grey[300],
              ),
              customWidths: CustomSliderWidths(
                trackWidth: 1.0
              ),
              infoProperties: InfoProperties(
                bottomLabelText: 'ms',
                modifier: (value) => '${value.toInt()}',
                bottomLabelStyle: TextStyle(
                  fontSize: 12.0,
                  color: Colors.grey[300],
                  letterSpacing: 1.5,
                  fontStyle: FontStyle.italic
                ),
                mainLabelStyle: const TextStyle(
                  fontSize: 16.0,
                  color: Colors.white,
                  letterSpacing: 2.0,
                  fontWeight: FontWeight.bold,
                )
              )
            ),
          ),
        ),
        playerState == 'playing'
        ? FloatingActionButton.large(
          heroTag: 'playing',
          backgroundColor: Colors.red[400],
          onPressed: () {
            setState(() => playerState = 'paused');
            stop();
          },
          child: const Icon(Icons.pause_circle),
        )
        : FloatingActionButton.large(
            heroTag: 'paused',
            backgroundColor: Colors.red[400],
            onPressed: () {
              setState(() => playerState = 'playing');
              start();
            },
            child: const Icon(Icons.play_circle),
          )
      ]
    );
  }
}