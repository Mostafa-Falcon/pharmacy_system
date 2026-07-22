mixin SortableListMixin<T> {
  String sortColumn = 'id';
  bool isAscending = true;

  void updateSort(String column, bool ascending) {
    sortColumn = column;
    isAscending = ascending;
  }

  List<T> sortList(List<T> list, int Function(T a, T b, String column) comparer) {
    final sorted = List<T>.from(list);
    sorted.sort((a, b) {
      final cmp = comparer(a, b, sortColumn);
      return isAscending ? cmp : -cmp;
    });
    return sorted;
  }
}
