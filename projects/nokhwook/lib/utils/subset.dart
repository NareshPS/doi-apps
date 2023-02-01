
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:nokhwook/utils/word.dart';

class WordSubset {
  static const randomWordCount = 20;
  final List<Word<WordItem>> words;
  final Random generator = Random();

  WordSubset({required this.words});

  List<int> random() {
    return List.generate(randomWordCount, (i) => generator.nextInt(randomWordCount));
  }

  List<Word<WordItem>> resolve(List<int> indices) {
    return indices.map((e) => words[e]).toList();
  }
}