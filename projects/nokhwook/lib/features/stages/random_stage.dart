import 'dart:math';

import 'package:flutter/material.dart';
import 'package:nokhwook/features/stages/stage.dart';
import 'package:nokhwook/models/vocab.dart';

class RandomStage extends StatefulWidget {
  final Vocab vocab;

  const RandomStage({super.key, required this.vocab});

  @override
  State<RandomStage> createState() => _RandomStageState();
}

class _RandomStageState extends State<RandomStage> {
  final int numItems = 20;
  late List<int> subset;

  @override
  void initState() {
    final random = Random();
    subset = Iterable<int>.generate(
        numItems, (x) => random.nextInt(widget.vocab.length)).toList();
    subset.shuffle(random);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stage(vocab: widget.vocab, title: 'Random Words', subset: subset);
  }
}
