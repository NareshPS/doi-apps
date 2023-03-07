class StageIterator implements Iterator<int> {
  final List<int> indices;

  int index = 0;

  StageIterator(length, {indices})
      : indices = indices ?? Iterable<int>.generate(length).toList();

  @override
  bool moveNext() {
    index = (index + 1) % indices.length;
    return true;
  }

  reset(overrideIndex) => index = overrideIndex % indices.length;

  @override
  int get current => indices[index];
}
