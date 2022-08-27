Iterable<E> mapIndexed<E, T>(
  Iterable<T> items,
  E Function(int index, T item) f,
) sync* {
  int index = 0;
  for (final item in items) {
    yield f(index, item);
    index++;
  }
}

extension CustomIterable<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;

  T? firstWhereOrNull(bool Function(T element) test) {
    final list = where(test);
    return list.isEmpty ? null : list.first;
  }

  Iterable<T> superJoin(T separator) {
    final iterator = this.iterator;
    if (!iterator.moveNext()) return [];
    final list = [iterator.current];
    while (iterator.moveNext()) {
      list
        ..add(separator)
        ..add(iterator.current);
    }
    return list;
  }
}
