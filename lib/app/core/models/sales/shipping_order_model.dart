/// 🚚 حالة عملية الشحن والتوصيل
enum ShippingStatus {
  pending,   // في الانتظار
  shipped,   // تم الشحن / جاري التوصيل
  delivered, // تم التوصيل بنجاح
  cancelled, // ملغاة
}

/// 🚚 موديل طلبات وإذونات الشحن والتوصيل (Shipping Order Model)
class ShippingOrderModel {
  // 🆔 المعرف الفريد لإذن الشحن (Primary Key)
  final String id;

  // 🔢 رقم الفاتورة/الطلب المرجعي المباشر (مثل: 0076)
  final String invoiceNumber;

  // 🆔 معرف الفاتورة المرتبطة
  final String invoiceId;

  // 📅 تاريخ ووقت عملية الشحن
  final DateTime shippingDate;

  // 👤 اسم العميل (مثل: أحمد محمود / زبون نقدي)
  final String customerName;

  // 📞 رقم هاتف/اتصال العميل لتوصيل الطلب
  final String? customerPhone;

  // 📍 عنوان الشحن والتوصيل التفصيلي
  final String shippingAddress;

  // 📝 تفاصيل الشحن والأصناف الموصلة (مثل: 2 زجاجة بروفين)
  final String? shippingDetails;

  // 👤 اسم الشخص المستلم فعلياً (مثل: سلمت لـ)
  final String? deliveredTo;

  // 🚚 معرف مندوب/طيار التوصيل المسئول (مثل: السيد مندوب 1)
  final String? deliveryAgentId;

  // 🚚 اسم مندوب/طيار التوصيل
  final String? deliveryAgentName;

  // 🚚 حالة الشحن والتوصيل (في الانتظار pending / تم الشحن shipped / تم التوصيل delivered)
  final ShippingStatus shippingStatus;

  // 💳 حالة السداد والدفع (مدفوع / غير مدفوع)
  final bool isPaid;

  // 📝 ملاحظات الشحن والتوصيل
  final String? notes;

  // 📎 مسارات المرفقات والمستندات المرفوعة
  final List<String>? documentUrls;

  // 👤 اسم/معرف الصيدلي المنشئ لإذن الشحن
  final String createdBy;

  // 🏬 معرف الفرع
  final String branchId;

  // 🏢 معرف الحساب الرئيسي / المؤسسة
  final String accountId;

  // 🕒 تاريخ ووقت آخر تعديل
  final DateTime lastModified;

  // 🗑️ حالة الحذف المنطقي
  final bool isDeleted;

  ShippingOrderModel({
    required this.id,
    required this.invoiceNumber,
    required this.invoiceId,
    DateTime? shippingDate,
    required this.customerName,
    this.customerPhone,
    required this.shippingAddress,
    this.shippingDetails,
    this.deliveredTo,
    this.deliveryAgentId,
    this.deliveryAgentName,
    this.shippingStatus = ShippingStatus.pending,
    this.isPaid = false,
    this.notes,
    this.documentUrls,
    required this.createdBy,
    required this.branchId,
    required this.accountId,
    DateTime? lastModified,
    this.isDeleted = false,
  })  : shippingDate = shippingDate ?? DateTime.now(),
        lastModified = lastModified ?? DateTime.now();

  Map<String, dynamic> toJson() => {
    'id': id,
    'invoice_number': invoiceNumber,
    'invoice_id': invoiceId,
    'shipping_date': shippingDate.toIso8601String(),
    'customer_name': customerName,
    'customer_phone': customerPhone,
    'shipping_address': shippingAddress,
    'shipping_details': shippingDetails,
    'delivered_to': deliveredTo,
    'delivery_agent_id': deliveryAgentId,
    'delivery_agent_name': deliveryAgentName,
    'shipping_status': shippingStatus.name,
    'is_paid': isPaid,
    'notes': notes,
    'document_urls': documentUrls,
    'created_by': createdBy,
    'branch_id': branchId,
    'account_id': accountId,
    'last_modified': lastModified.toIso8601String(),
    'is_deleted': isDeleted,
  };

  factory ShippingOrderModel.fromJson(Map<String, dynamic> json) => ShippingOrderModel(
    id: json['id'] as String,
    invoiceNumber: json['invoice_number'] as String,
    invoiceId: json['invoice_id'] as String? ?? '',
    shippingDate: DateTime.tryParse(json['shipping_date'] as String? ?? '') ?? DateTime.now(),
    customerName: json['customer_name'] as String? ?? 'زبون نقدي',
    customerPhone: json['customer_phone'] as String?,
    shippingAddress: json['shipping_address'] as String? ?? '',
    shippingDetails: json['shipping_details'] as String?,
    deliveredTo: json['delivered_to'] as String?,
    deliveryAgentId: json['delivery_agent_id'] as String?,
    deliveryAgentName: json['delivery_agent_name'] as String?,
    shippingStatus: json['shipping_status'] == 'delivered'
        ? ShippingStatus.delivered
        : json['shipping_status'] == 'shipped'
            ? ShippingStatus.shipped
            : json['shipping_status'] == 'cancelled'
                ? ShippingStatus.cancelled
                : ShippingStatus.pending,
    isPaid: json['is_paid'] as bool? ?? false,
    notes: json['notes'] as String?,
    documentUrls: (json['document_urls'] as List<dynamic>?)?.map((e) => e.toString()).toList(),
    createdBy: json['created_by'] as String? ?? '',
    branchId: json['branch_id'] as String? ?? '',
    accountId: json['account_id'] as String? ?? '',
    lastModified: DateTime.tryParse(json['last_modified'] as String? ?? '') ?? DateTime.now(),
    isDeleted: json['is_deleted'] as bool? ?? false,
  );
}


