import 'dart:convert';

List<String> jsonToStringList(String? json) {
  if (json == null || json.isEmpty) return [];
  try {
    return (jsonDecode(json) as List<dynamic>).cast<String>();
  } catch (_) {
    return [];
  }
}

String stringListToJson(List<String> list) {
  return jsonEncode(list);
}

Map<String, dynamic> jsonToMap(String? json) {
  if (json == null || json.isEmpty) return {};
  try {
    return Map<String, dynamic>.from(jsonDecode(json) as Map);
  } catch (_) {
    return {};
  }
}

String mapToJson(Map<String, dynamic> map) {
  return jsonEncode(map);
}


