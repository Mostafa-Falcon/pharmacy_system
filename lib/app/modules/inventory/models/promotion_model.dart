import 'package:collection/collection.dart';

enum PromotionType { discount, buyXGetY, bundle, seasonal }

class PromotionModel {
  String id;
  String name;
  String? description;
  PromotionType type;
  double value;
  bool isPercentage;
  DateTime startDate;
  DateTime endDate;
  List<String> medicineIds;
  List<String> categoryFilters;
  String? customerGroupId;
  String branchId;
  bool isActive;
  DateTime lastModified;

  PromotionModel({
    required this.id,
    required this.name,
    this.description,
    required this.type,
    required this.value,
    required this.isPercentage,
    required this.startDate,
    required this.endDate,
    List<String>? medicineIds,
    List<String>? categoryFilters,
    this.customerGroupId,
    required this.branchId,
    this.isActive = true,
    DateTime? lastModified,
  })  : medicineIds = medicineIds ?? [],
        categoryFilters = categoryFilters ?? [],
        lastModified = lastModified ?? DateTime.now();

  bool get isCurrentlyActive {
    final now = DateTime.now();
    return isActive && now.isAfter(startDate) && now.isBefore(endDate);
  }

  bool appliesToMedicine(String medicineId, String? category, String? customerGroupId) {
    if (!isCurrentlyActive) return false;
    if (medicineIds.isNotEmpty && !medicineIds.contains(medicineId)) return false;
    if (categoryFilters.isNotEmpty && category != null && !categoryFilters.contains(category)) return false;
    if (this.customerGroupId != null && this.customerGroupId != customerGroupId) return false;
    return true;
  }

  double calculateDiscount(double originalPrice) {
    if (!isPercentage) return value.clamp(0, originalPrice);
    return (originalPrice * (value / 100)).clamp(0, originalPrice);
  }

  PromotionModel copyWith({
    String? id,
    String? name,
    String? description,
    PromotionType? type,
    double? value,
    bool? isPercentage,
    DateTime? startDate,
    DateTime? endDate,
    List<String>? medicineIds,
    List<String>? categoryFilters,
    String? customerGroupId,
    String? branchId,
    bool? isActive,
    DateTime? lastModified,
  }) {
    return PromotionModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      type: type ?? this.type,
      value: value ?? this.value,
      isPercentage: isPercentage ?? this.isPercentage,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      medicineIds: medicineIds ?? this.medicineIds,
      categoryFilters: categoryFilters ?? this.categoryFilters,
      customerGroupId: customerGroupId ?? this.customerGroupId,
      branchId: branchId ?? this.branchId,
      isActive: isActive ?? this.isActive,
      lastModified: lastModified ?? this.lastModified,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'type': type.name,
    'value': value,
    'is_percentage': isPercentage,
    'start_date': startDate.toIso8601String(),
    'end_date': endDate.toIso8601String(),
    'medicine_ids': medicineIds,
    'category_filters': categoryFilters,
    'customer_group_id': customerGroupId,
    'branch_id': branchId,
    'is_active': isActive,
    'last_modified': lastModified.toIso8601String(),
  };

  factory PromotionModel.fromJson(Map<String, dynamic> json) => PromotionModel(
    id: json['id'] as String,
    name: json['name'] as String,
    description: json['description'] as String?,
    type: PromotionType.values.firstWhereOrNull((e) => e.name == json['type']) ?? PromotionType.discount,
    value: (json['value'] as num).toDouble(),
    isPercentage: json['is_percentage'] as bool? ?? true,
    startDate: json['start_date'] != null ? DateTime.tryParse(json['start_date'] as String) ?? DateTime.now() : DateTime.now(),
    endDate: json['end_date'] != null ? DateTime.tryParse(json['end_date'] as String) ?? DateTime.now().add(const Duration(days: 30)) : DateTime.now().add(const Duration(days: 30)),
    medicineIds: (json['medicine_ids'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
    categoryFilters: (json['category_filters'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
    customerGroupId: json['customer_group_id'] as String?,
    branchId: json['branch_id'] as String? ?? '',
    isActive: json['is_active'] as bool? ?? true,
    lastModified: json['last_modified'] != null ? DateTime.tryParse(json['last_modified'] as String) ?? DateTime.now() : DateTime.now(),
  );
}
