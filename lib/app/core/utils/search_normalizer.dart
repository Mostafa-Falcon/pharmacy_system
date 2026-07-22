/// Normalizes user-entered Arabic/English search text once before it reaches
/// the in-memory catalogue index or local database query.
///
/// The normalization intentionally stays conservative: it removes Arabic
/// diacritics/tatweel, unifies common alef/yaa forms, lower-cases Latin text
/// and collapses whitespace. The original value is never changed in storage.
abstract final class SearchNormalizer {
  static final RegExp _arabicDiacritics = RegExp(
    r'[\u0610-\u061A\u064B-\u065F\u0670\u06D6-\u06ED]',
  );
  static final RegExp _whitespace = RegExp(r'\s+');

  static String normalize(String? value) {
    if (value == null || value.isEmpty) return '';
    return value
        .replaceAll('\u0640', '') // Tatweel.
        .replaceAll(_arabicDiacritics, '')
        .replaceAll(RegExp(r'[أإآٱ]'), 'ا')
        .replaceAll('ى', 'ي')
        .replaceAll('ؤ', 'و')
        .replaceAll('ئ', 'ي')
        .replaceAll('ة', 'ه')
        .toLowerCase()
        .trim()
        .replaceAll(_whitespace, ' ');
  }

  static String normalizeBarcode(String? value) {
    if (value == null || value.isEmpty) return '';
    return value.trim().toLowerCase().replaceAll(_whitespace, '');
  }

  static String combine(Iterable<String?> values) {
    return values
        .map(normalize)
        .where((value) => value.isNotEmpty)
        .toSet()
        .join(' ');
  }
}
