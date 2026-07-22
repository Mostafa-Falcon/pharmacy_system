import 'dart:convert';

abstract final class CanonicalJson {
  static String encode(dynamic value) {
    if (value is Map) {
      final normalized = <String, dynamic>{
        for (final entry in value.entries) entry.key.toString(): entry.value,
      };
      final keys = normalized.keys.toList()..sort();
      return '{${keys.map((key) => '${jsonEncode(key)}:${encode(normalized[key])}').join(',')}}';
    }
    if (value is List) {
      return '[${value.map(encode).join(',')}]';
    }
    return jsonEncode(value);
  }

  static bool equals(dynamic left, dynamic right) =>
      encode(left) == encode(right);
}
