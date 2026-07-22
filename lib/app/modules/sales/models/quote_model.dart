enum QuoteStatus { draft, sent, accepted, rejected }

class QuoteModel {
  String id;
  String branchId;
  int number;
  String customerName;
  String? notes;
  List<Map<String, dynamic>> items;
  double subtotal;
  double discount;
  double total;
  QuoteStatus status;
  DateTime createdAt;
  int syncVersion;
  DateTime lastModified;
  bool isDeleted;

  QuoteModel({
    required this.id,
    required this.branchId,
    required this.number,
    required this.customerName,
    this.notes,
    this.items = const [],
    this.subtotal = 0,
    this.discount = 0,
    this.total = 0,
    this.status = QuoteStatus.draft,
    required this.createdAt,
    this.syncVersion = 1,
    DateTime? lastModified,
    this.isDeleted = false,
  }) : lastModified = lastModified ?? DateTime.now();

  QuoteModel copyWith({
    String? id,
    String? branchId,
    int? number,
    String? customerName,
    String? notes,
    List<Map<String, dynamic>>? items,
    double? subtotal,
    double? discount,
    double? total,
    QuoteStatus? status,
    DateTime? createdAt,
    int? syncVersion,
    DateTime? lastModified,
    bool? isDeleted,
  }) {
    return QuoteModel(
      id: id ?? this.id,
      branchId: branchId ?? this.branchId,
      number: number ?? this.number,
      customerName: customerName ?? this.customerName,
      notes: notes ?? this.notes,
      items: items ?? this.items,
      subtotal: subtotal ?? this.subtotal,
      discount: discount ?? this.discount,
      total: total ?? this.total,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      syncVersion: syncVersion ?? this.syncVersion + 1,
      lastModified: lastModified ?? DateTime.now(),
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'branch_id': branchId,
    'number': number,
    'customer_name': customerName,
    'notes': notes,
    'items': items
        .map((e) => {
              'name': e['name'],
              'qty': e['qty'],
              'unit_price': e['unit_price'],
              'total': e['total'],
            })
        .toList(),
    'subtotal': subtotal,
    'discount': discount,
    'total': total,
    'status': status.name,
    'created_at': createdAt.toIso8601String(),
    'sync_version': syncVersion,
    'last_modified': lastModified.toIso8601String(),
    'is_deleted': isDeleted,
  };

  factory QuoteModel.fromJson(Map<String, dynamic> json) => QuoteModel(
    id: json['id'] as String,
    branchId: json['branch_id'] as String,
    number: json['number'] as int? ?? 1,
    customerName: json['customer_name'] as String? ?? '',
    notes: json['notes'] as String?,
    items: (json['items'] as List?)
            ?.cast<Map<String, dynamic>>()
            .map((e) => {
                  'name': e['name'],
                  'qty': e['qty'],
                  'unit_price': e['unit_price'],
                  'total': e['total'],
                })
            .toList() ??
        [],
    subtotal: (json['subtotal'] as num?)?.toDouble() ?? 0,
    discount: (json['discount'] as num?)?.toDouble() ?? 0,
    total: (json['total'] as num?)?.toDouble() ?? 0,
    status: QuoteStatus.values.firstWhere(
      (e) => e.name == json['status'],
      orElse: () => QuoteStatus.draft,
    ),
    createdAt: json['created_at'] != null
        ? DateTime.tryParse(json['created_at'] as String) ?? DateTime.now()
        : DateTime.now(),
    syncVersion: json['sync_version'] as int? ?? 1,
    lastModified: json['last_modified'] != null
        ? DateTime.tryParse(json['last_modified'] as String) ?? DateTime.now()
        : DateTime.now(),
    isDeleted: json['is_deleted'] as bool? ?? false,
  );
}
