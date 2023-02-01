class WordItem {
  String lang;
  String phrase;

  WordItem({required this.lang, this.phrase=''});
  @override
  String toString() {
    return '($lang, $phrase)';
  }
}

class Word<WordItem> {
  WordItem header;
  List<WordItem> items;

  Word({required this.header, required this.items});
  WordItem operator [](int i) => items[i];
  add(WordItem item) => items.add(item);

  @override
  String toString() {
    return '{header: $header, items:$items}';
  }
}