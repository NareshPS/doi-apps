import 'dart:math';

import 'package:flutter/material.dart';
import 'package:nokhwook/features/stages/random_stage_preferences.dart';
import 'package:nokhwook/features/stages/stage.dart';
import 'package:nokhwook/main.dart';
import 'package:nokhwook/models/vocab.dart';
import 'package:provider/provider.dart';

class RandomStage extends StatefulWidget {
  const RandomStage({super.key});

  @override
  State<RandomStage> createState() => _RandomStageState();
}

class _RandomStageState extends State<RandomStage>
    with AutomaticKeepAliveClientMixin {
  final stageKey = const Key('randomStage');

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    Random random = Random();
    final vocab = context.watch<Vocab>();
    final prefs = context.watch<RandomStagePreferences>();
    final subset = Iterable.generate(prefs.sampleSize)
        .map((_) => random.nextInt(vocab.length))
        .toList();
    logger.i('Subset: $subset PlaySpeed: ${prefs.playSpeed}');
    return Stage(
        title: 'Random Cards', subset: subset, playSpeed: prefs.playSpeed);
  }
}
