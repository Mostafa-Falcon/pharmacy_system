import 'medicine_model.dart';

/// 🔍 امتداد البحث الذكي والسريع في قائمة الأدوية المطابق للفكرة المعمارية
extension MedicineSearchExtension on List<MedicineModel> {
  /// 🎯 فلترة القائمة بالبحث في الاسم العربي، الإنجليزي، أو أي باركود ممسوح للصنف
  List<MedicineModel> filterByNameOrBarcode(String query) {
    // 1️⃣ إذا كان نص البحث فارغاً، يتم إرجاع القائمة كاملة كما هي
    if (query.trim().isEmpty) return this;

    // 2️⃣ تحويل كلمة البحث لحروف صغيرة وتنظيف الفراغات
    final q = query.toLowerCase().trim();

    // 3️⃣ الفلترة في الاسم العربي والإنجليزي وقائمة الباركودات للصنف ككل
    return where((item) {
      final matchesName = item.name.toLowerCase().contains(q);
      final matchesNameEn = item.nameEn?.toLowerCase().contains(q) ?? false;
      final matchesBarcode = item.barcodes.any((b) => b.code.toLowerCase().contains(q));

      return matchesName || matchesNameEn || matchesBarcode;
    }).toList();
  }
}


