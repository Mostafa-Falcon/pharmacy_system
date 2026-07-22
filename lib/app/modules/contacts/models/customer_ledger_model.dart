enum CustomerLedgerEntryType {
  openingBalance,
  saleInvoice,
  saleReturn,
  customerPayment,
  saleVoid,
  manualAdjustment,
  additionNotice,
  discountNotice,
  checkReceipt,
  checkPayment,
}

class CustomerLedgerModel {
  String id;
  String customerId;
  String branchId;
  CustomerLedgerEntryType type;
  double debit;
  double credit;
  double balanceAfter;
  String? referenceId;
  String? referenceNumber;
  String? notes;
  String? createdBy;
  DateTime entryDate;
  int syncVersion;
  DateTime lastModified;
  bool isDeleted;

  CustomerLedgerModel({
    required this.id,
    required this.customerId,
    required this.branchId,
    required this.type,
    required this.debit,
    required this.credit,
    required this.balanceAfter,
    this.referenceId,
    this.referenceNumber,
    this.notes,
    this.createdBy,
    required this.entryDate,
    this.syncVersion = 1,
    DateTime? lastModified,
    this.isDeleted = false,
  }) : lastModified = lastModified ?? DateTime.now();

  CustomerLedgerModel copyWith({
    String? id,
    String? customerId,
    String? branchId,
    CustomerLedgerEntryType? type,
    double? debit,
    double? credit,
    double? balanceAfter,
    String? referenceId,
    String? referenceNumber,
    String? notes,
    String? createdBy,
    DateTime? entryDate,
    int? syncVersion,
    DateTime? lastModified,
    bool? isDeleted,
  }) {
    return CustomerLedgerModel(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      branchId: branchId ?? this.branchId,
      type: type ?? this.type,
      debit: debit ?? this.debit,
      credit: credit ?? this.credit,
      balanceAfter: balanceAfter ?? this.balanceAfter,
      referenceId: referenceId ?? this.referenceId,
      referenceNumber: referenceNumber ?? this.referenceNumber,
      notes: notes ?? this.notes,
      createdBy: createdBy ?? this.createdBy,
      entryDate: entryDate ?? this.entryDate,
      syncVersion: syncVersion ?? this.syncVersion + 1,
      lastModified: lastModified ?? DateTime.now(),
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'customer_id': customerId,
    'branch_id': branchId,
    'type': type.name,
    'debit': debit,
    'credit': credit,
    'balance_after': balanceAfter,
    'reference_id': referenceId,
    'reference_number': referenceNumber,
    'notes': notes,
    'created_by': createdBy,
    'entry_date': entryDate.toIso8601String(),
    'sync_version': syncVersion,
    'last_modified': lastModified.toIso8601String(),
    'is_deleted': isDeleted,
  };

  factory CustomerLedgerModel.fromJson(Map<String, dynamic> json) =>
      CustomerLedgerModel(
        id: json['id'] as String,
        customerId: json['customer_id'] as String,
        branchId: json['branch_id'] as String,
        type: CustomerLedgerEntryType.values.firstWhere(
          (e) => e.name == json['type'],
          orElse: () => CustomerLedgerEntryType.saleInvoice,
        ),
        debit: (json['debit'] as num?)?.toDouble() ?? 0.0,
        credit: (json['credit'] as num?)?.toDouble() ?? 0.0,
        balanceAfter: (json['balance_after'] as num?)?.toDouble() ?? 0.0,
        referenceId: json['reference_id'] as String?,
        referenceNumber: json['reference_number'] as String?,
        notes: json['notes'] as String?,
        createdBy: json['created_by'] as String?,
        entryDate:
            DateTime.tryParse(json['entry_date'] as String) ?? DateTime.now(),
        syncVersion: json['sync_version'] as int? ?? 1,
        lastModified: json['last_modified'] != null
            ? DateTime.tryParse(json['last_modified'] as String) ??
                  DateTime.now()
            : DateTime.now(),
        isDeleted: json['is_deleted'] as bool? ?? false,
      );
}
