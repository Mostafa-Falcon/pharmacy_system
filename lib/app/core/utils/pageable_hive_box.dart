/// @deprecated Replaced by Drift DAO queries.
/// Kept as a generic in-memory pagination utility.
class PageableHiveBox<T> {
  final Map<String, dynamic> _data;
  final T Function(Map<String, dynamic>) fromJson;

  PageableHiveBox(this._data, this.fromJson);

  int get totalCount => _data.length;

  List<T> getAll() {
    return _data.values
        .map((e) => fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  List<T> getPage(int page, int pageSize) {
    final start = page * pageSize;
    final values = _data.values
        .skip(start)
        .take(pageSize)
        .map((e) => fromJson(Map<String, dynamic>.from(e)))
        .toList();
    return values;
  }

  List<String> getAllKeys() {
    return _data.keys.toList();
  }

  List<String> getPageKeys(int page, int pageSize) {
    final start = page * pageSize;
    return _data.keys.toList().skip(start).take(pageSize).toList();
  }

  List<T> getByKeys(List<String> keys) {
    return keys
        .map((k) => _data[k])
        .where((e) => e != null)
        .map((e) => fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  T? getById(String id) {
    final data = _data[id];
    if (data == null) return null;
    return fromJson(Map<String, dynamic>.from(data));
  }
}
