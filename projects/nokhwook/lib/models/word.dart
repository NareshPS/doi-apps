class WordItem {
  String phrase;

  WordItem({required this.phrase});
  @override
  String toString() {
    return '($phrase)';
  }
}

class Word {
  // WordItem header;
  List<WordItem> items;

  Word({required this.items});
  WordItem operator [](int i) => items[i];

  static Word parse(List values) {
    return Word(items: values.map((v) => WordItem(phrase: v)).toList());
  }

  @override
  String toString() => 'items:$items}';
}
