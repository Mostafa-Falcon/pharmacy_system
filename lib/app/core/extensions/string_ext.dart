extension NullIfEmptyExt on String {
  String? get nullIfEmpty => isEmpty ? null : this;
}


