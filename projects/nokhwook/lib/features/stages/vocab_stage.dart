import 'package:flutter/material.dart';
import 'package:nokhwook/features/stages/stage.dart';
import 'package:nokhwook/models/vocab.dart';

class VocabStage extends StatelessWidget {
  final Stream<int> currentWord;
  final Vocab vocab;

  const VocabStage({super.key, required this.vocab, required this.currentWord});

  @override
  Widget build(BuildContext context) {
    return Stage(vocab: vocab, title: 'All Words', currentWord: currentWord);
  }
}
