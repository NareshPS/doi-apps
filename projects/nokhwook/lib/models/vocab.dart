import 'package:nokhwook/models/word.dart';

class Vocab extends Iterable<Word> {
  final List<String> header;
  final List<Word>? words;

  Vocab({required this.header, words}) : words = words ?? [];

  add(Word w) => words!.add(w);

  @override
  Iterator<Word> get iterator => words!.iterator;

  @override
  int get length => words!.length;

  Iterator<Word> get randomIterator => RandomIterator(this);

  static Vocab parse(List<List> entries) => Vocab(
      header: entries[0].map((e) => e as String).toList(),
      words: entries
          .getRange(1, entries.length)
          .map((e) => Word.parse(e))
          .toList());

  operator [](index) => words![index];
  operator []=(int index, Word w) => words![index] = w;

  Vocab subset(List<int> indices) => Vocab(
      header: header, words: indices.map((index) => words![index]).toList());
}

class RandomIterator implements Iterator<Word> {
  final Vocab words;
  final List<int> indices;
  int index = 0;

  RandomIterator(this.words)
      : indices = Iterable<int>.generate(words.length).toList() {
    indices.shuffle();
  }

  @override
  Word get current => words[indices[index]];

  @override
  bool moveNext() {
    index += 1;
    return index < words.length;
  }
}
