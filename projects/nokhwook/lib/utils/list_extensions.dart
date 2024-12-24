extension ListExtensions<T> on List<T> {
  List<T> takeLast(int n) {
    return length > n ? skip(length - n).toList() : this;
  }
}
