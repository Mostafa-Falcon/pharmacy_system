mixin SortableListMixin {
  String sortColumnId = '';
  bool isSortAscending = true;
  int currentPage = 0;
  int pageSize = 25;

  void onSort(String columnId, bool ascending) {
    if (sortColumnId == columnId) {
      isSortAscending = !isSortAscending;
    } else {
      sortColumnId = columnId;
      isSortAscending = ascending;
    }
  }

  void nextPage() {
    if (currentPage < _totalPages - 1) {
      currentPage++;
    }
  }

  void previousPage() {
    if (currentPage > 0) {
      currentPage--;
    }
  }

  void onPageSizeChanged(int size) {
    pageSize = size;
    currentPage = 0;
  }

  int get totalItemsForPagination => 0;

  int get _totalPages => totalPagesFor(totalItemsForPagination);

  List<T> paginatedList<T>(List<T> items) {
    final start = currentPage * pageSize;
    final end = (start + pageSize).clamp(0, items.length);
    if (start >= items.length) return [];
    return items.sublist(start, end);
  }

  int totalPagesFor(int totalItems) {
    final size = pageSize;
    if (totalItems == 0) return 1;
    return (totalItems / size).ceil();
  }
}
