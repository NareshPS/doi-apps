import 'dart:math';

import 'package:nokhwook/utils/word.dart';

abstract class NextWord {
  int _index;

  NextWord({start = -1}): _index = start;

  int get(List<Word<WordItem>> words);
  get index => _index;
}

class OrderedNext extends NextWord {
  OrderedNext({start = -1}):super(start: start);

  @override
  int get(words) {
    _index = (_index + 1)%words.length;
    return _index;
  }
}

class RandomNext extends NextWord {
  Random selector = Random();

  @override
  int get(List<Word<WordItem>> words) {
    _index = selector.nextInt(words.length);
    return _index;
  }

}