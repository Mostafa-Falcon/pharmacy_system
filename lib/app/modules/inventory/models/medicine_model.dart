import 'medicine_unit_model.dart';

class MedicineModel {
  String id;
  String name;
  String? nameEn;
  String? category;
  List<String> barcodes;
  double buyPrice;
  double sellPrice;
  int quantity;
  int minStock;
  DateTime? expiryDate;
  String? manufacturer;
  String branchId;
  int syncVersion;
  DateTime lastModified;
  bool isDeleted;
  String? dosageForm;
  String? strength;
  String? packageSize;
  bool expiryTrackingEnabled;
  String? supplierName;
  String? description;
  double? oldSellPrice;
  String? itemTypeId;
  String? groupId;
  List<MedicineUnitModel> units;
  bool alertEnabled;
  bool dosageFormEnabled;
  String? imageUrl;
  String? containerShape;
  bool allowNegativeStock;
  bool isTaxable;
  String? taxType;
  double? taxValue;
  bool pricesIncludeTax;
  String? location;
  bool isActive;
  DateTime? createdAt;

  MedicineModel({
    required this.id,
    required this.name,
    this.nameEn,
    this.category,
    List<String>? barcodes,
    required this.buyPrice,
    required this.sellPrice,
    required this.quantity,
    this.minStock = 10,
    this.expiryDate,
    this.manufacturer,
    required this.branchId,
    this.syncVersion = 1,
    DateTime? lastModified,
    this.isDeleted = false,
    this.dosageForm,
    this.strength,
    this.packageSize,
    this.expiryTrackingEnabled = false,
    this.supplierName,
    this.description,
    this.oldSellPrice,
    this.itemTypeId,
    this.groupId,
    List<MedicineUnitModel>? units,
    this.alertEnabled = false,
    this.dosageFormEnabled = false,
    this.imageUrl,
    this.containerShape,
    this.allowNegativeStock = false,
    this.isTaxable = false,
    this.taxType,
    this.taxValue,
    this.pricesIncludeTax = false,
    this.location,
    this.isActive = true,
    DateTime? createdAt,
  })  : lastModified = lastModified ?? DateTime.now(),
        createdAt = createdAt ?? lastModified ?? DateTime.now(),
        barcodes = barcodes ?? [],
        units = units ?? [];

  MedicineModel copyWith({
    String? id,
    String? name,
    String? nameEn,
    String? category,
    List<String>? barcodes,
    double? buyPrice,
    double? sellPrice,
    int? quantity,
    int? minStock,
    DateTime? expiryDate,
    String? manufacturer,
    String? branchId,
    int? syncVersion,
    DateTime? lastModified,
    bool? isDeleted,
    String? dosageForm,
    String? strength,
    String? packageSize,
    bool? expiryTrackingEnabled,
    String? supplierName,
    String? description,
    double? oldSellPrice,
    String? itemTypeId,
    String? groupId,
    List<MedicineUnitModel>? units,
    bool? alertEnabled,
    bool? dosageFormEnabled,
    String? imageUrl,
    String? containerShape,
    bool? allowNegativeStock,
    bool? isTaxable,
    String? taxType,
    double? taxValue,
    bool? pricesIncludeTax,
    String? location,
    bool? isActive,
    DateTime? createdAt,
  }) {
    return MedicineModel(
      id: id ?? this.id,
      name: name ?? this.name,
      nameEn: nameEn ?? this.nameEn,
      category: category ?? this.category,
      barcodes: barcodes ?? List<String>.from(this.barcodes),
      buyPrice: buyPrice ?? this.buyPrice,
      sellPrice: sellPrice ?? this.sellPrice,
      quantity: quantity ?? this.quantity,
      minStock: minStock ?? this.minStock,
      expiryDate: expiryDate ?? this.expiryDate,
      manufacturer: manufacturer ?? this.manufacturer,
      branchId: branchId ?? this.branchId,
      syncVersion: syncVersion ?? this.syncVersion + 1,
      lastModified: lastModified ?? DateTime.now(),
      isDeleted: isDeleted ?? this.isDeleted,
      dosageForm: dosageForm ?? this.dosageForm,
      strength: strength ?? this.strength,
      packageSize: packageSize ?? this.packageSize,
      expiryTrackingEnabled: expiryTrackingEnabled ?? this.expiryTrackingEnabled,
      supplierName: supplierName ?? this.supplierName,
      description: description ?? this.description,
      oldSellPrice: oldSellPrice ?? this.oldSellPrice,
      itemTypeId: itemTypeId ?? this.itemTypeId,
      groupId: groupId ?? this.groupId,
      units: units ?? List<MedicineUnitModel>.from(this.units),
      alertEnabled: alertEnabled ?? this.alertEnabled,
      dosageFormEnabled: dosageFormEnabled ?? this.dosageFormEnabled,
      imageUrl: imageUrl ?? this.imageUrl,
      containerShape: containerShape ?? this.containerShape,
      allowNegativeStock: allowNegativeStock ?? this.allowNegativeStock,
      isTaxable: isTaxable ?? this.isTaxable,
      taxType: taxType ?? this.taxType,
      taxValue: taxValue ?? this.taxValue,
      pricesIncludeTax: pricesIncludeTax ?? this.pricesIncludeTax,
      location: location ?? this.location,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'name_en': nameEn,
    'category': category,
    'barcodes': barcodes,
    'buy_price': buyPrice,
    'sell_price': sellPrice,
    'quantity': quantity,
    'min_stock': minStock,
    'expiry_date': expiryDate?.toIso8601String(),
    'manufacturer': manufacturer,
    'branch_id': branchId,
    'sync_version': syncVersion,
    'last_modified': lastModified.toIso8601String(),
    'is_deleted': isDeleted,
    'dosage_form': dosageForm,
    'strength': strength,
    'package_size': packageSize,
    'expiry_tracking_enabled': expiryTrackingEnabled,
    'supplier_name': supplierName,
    'description': description,
    'old_sell_price': oldSellPrice,
    'item_type_id': itemTypeId,
    'group_id': groupId,
    'units': units.map((u) => u.toJson()).toList(),
    'alert_enabled': alertEnabled,
    'dosage_form_enabled': dosageFormEnabled,
    'image_url': imageUrl,
    'container_shape': containerShape,
    'allow_negative_stock': allowNegativeStock,
    'is_taxable': isTaxable,
    'tax_type': taxType,
    'tax_value': taxValue,
    'prices_include_tax': pricesIncludeTax,
    'location': location,
    'is_active': isActive,
    'created_at': createdAt?.toIso8601String(),
  };

  factory MedicineModel.fromJson(Map<String, dynamic> json) => MedicineModel(
    id: json['id'] as String,
    name: json['name'] as String,
    nameEn: json['name_en'] as String?,
    category: json['category'] as String?,
    barcodes: (json['barcodes'] as List<dynamic>?)?.map((e) => e as String).toList(),
    buyPrice: (json['buy_price'] as num).toDouble(),
    sellPrice: (json['sell_price'] as num).toDouble(),
    quantity: json['quantity'] as int? ?? 0,
    minStock: json['min_stock'] as int? ?? 10,
    expiryDate: json['expiry_date'] != null ? DateTime.tryParse(json['expiry_date'] as String) : null,
    manufacturer: json['manufacturer'] as String?,
    branchId: json['branch_id'] as String,
    syncVersion: json['sync_version'] as int? ?? 1,
    lastModified: json['last_modified'] != null
        ? DateTime.tryParse(json['last_modified'] as String) ?? DateTime.now()
        : DateTime.now(),
    isDeleted: json['is_deleted'] as bool? ?? false,
    dosageForm: json['dosage_form'] as String?,
    strength: json['strength'] as String?,
    packageSize: json['package_size'] as String?,
    expiryTrackingEnabled: json['expiry_tracking_enabled'] as bool? ?? false,
    supplierName: json['supplier_name'] as String?,
    description: json['description'] as String?,
    oldSellPrice: (json['old_sell_price'] as num?)?.toDouble(),
    itemTypeId: json['item_type_id'] as String?,
    groupId: json['group_id'] as String?,
    units: (json['units'] as List<dynamic>?)
        ?.map((e) => MedicineUnitModel.fromJson(e as Map<String, dynamic>))
        .toList(),
    alertEnabled: json['alert_enabled'] as bool? ?? false,
    dosageFormEnabled: json['dosage_form_enabled'] as bool? ?? false,
    imageUrl: json['image_url'] as String?,
    containerShape: json['container_shape'] as String?,
    allowNegativeStock: json['allow_negative_stock'] as bool? ?? false,
    isTaxable: json['is_taxable'] as bool? ?? false,
    taxType: json['tax_type'] as String?,
    taxValue: (json['tax_value'] as num?)?.toDouble(),
    pricesIncludeTax: json['prices_include_tax'] as bool? ?? false,
    location: json['location'] as String?,
    isActive: json['is_active'] as bool? ?? true,
    createdAt: json['created_at'] != null
        ? DateTime.tryParse(json['created_at'] as String)
        : null,
  );
}
