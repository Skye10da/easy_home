extension Filter<T> on Stream<List<T>> {
  Stream<List<T>> filer(bool Function(T) where) =>
      map((items) => items.where(where).toList());
}