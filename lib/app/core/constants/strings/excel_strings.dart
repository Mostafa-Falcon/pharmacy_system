// excel_strings.dart — نصوص استيراد ملفات الإكسيل والمواد الخام للـ Mapping.


class ExcelStrings {
  ExcelStrings._();

  // أعمدة العملاء والموردين
  static const List<String> colName = ['الاسم', 'اسم العميل', 'name', 'الإسم', 'اسم', 'المورد', 'اسم المورد'];
  static const List<String> colContactId = ['معرف الاتصال', 'معرف', 'contact id', 'customer id', 'id', 'رقم'];
  static const List<String> colPhone = ['موبايل', 'هاتف', 'phone', 'تليفون', 'جوال', 'الموبايل', 'رقم الموبايل'];
  static const List<String> colEmail = ['بريد', 'email', 'إيميل'];
  static const List<String> colAddress = ['عنوان', 'address', 'العنوان'];
  static const List<String> colCompany = ['شركة', 'company', 'اسم المشروع', 'مشروع'];
  static const List<String> colTaxId = ['ضريبي', 'tax', 'tax_id', 'الرقم الضريبي'];
  static const List<String> colCreditLimit = ['ائتمان', 'credit limit', 'limit'];
  static const List<String> colDiscount = ['خصم', 'discount'];
  static const List<String> colType = ['نوع', 'kind', 'type', 'النوع'];
  static const List<String> colTotalDue = ['اجمالي المستحق', 'إجمالي المستحق', 'total due', 'مجموع المبيعات غير المدفوعة', 'المستحق'];
  static const List<String> colOpeningBalance = ['الرصيد الافتتاحي', 'افتتاحي', 'opening', 'رصيد', 'رصيد أول المدة', 'رصيد اول المدة'];

  // أعمدة الأصناف (Medicines)
  static const List<String> colMedicineBarcode = ['sku', 'barcode', 'باركود', 'كود', 'ean'];
  static const List<String> colMedicineUnit = ['unit', 'الوحدة', 'وحدة'];
  static const List<String> colMedicineCategory = ['category', 'التصنيف', 'فئة', 'قسم', 'تصنيف العرض', 'sub-cato'];
  static const List<String> colMedicineBuyPrice = ['purchase price', 'سعر الشراء', 'سعر شراء', 'purchase'];
  static const List<String> colMedicineSellPrice = ['selling price', 'سعر البيع', 'سعر بيع', 'سعر', 'selling'];
  static const List<String> colMedicineStock = ['opening stock', 'المخزون', 'الكمية', 'quantity', 'stock', 'qty', 'الرصيد', 'رصيد', 'المخزن'];
  static const List<String> colMedicineBrand = ['brand', 'ماركة', 'الشركة المصنعة', 'البراند'];
  static const List<String> colMedicineLocation = ['موقع التخزين', 'المكان', 'الرف', 'مكان', 'location'];
  static const List<String> colMedicineRack = ['rack', 'رف'];
  static const List<String> colMedicineRow = ['row', 'صف'];
  static const List<String> colMedicinePosition = ['position', 'خانة', 'موقع'];
  static const List<String> colMedicineExpiry = ['expiry', 'تاريخ الصلاحية', 'انتهاء', 'اكسباير'];
  static const List<String> colMedicineVat = ['vat', 'ضريبة', 'tax'];

  // نصوص عامة للبحث والتصفية
  static const String currencyEgp = 'ج.م';
  static const String totalRowKey = 'المجموع';
  static const String expenseKey = 'مصروف';
  static const String amountKey = 'المبلغ';
  static const String dateKey = 'تاريخ';
}


