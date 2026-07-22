import 'medicine_model.dart';

extension MedicineSearchExtension on List<MedicineModel> {
  List<MedicineModel> filterByNameOrBarcode(String query) {
    if (query.isEmpty) return this;
    final q = query.toLowerCase().trim();
    return where((m) =>
      m.name.toLowerCase().contains(q) ||
      m.barcodes.any((b) => b.toLowerCase().contains(q))
    ).toList();
  }
}
