enum PartyBalanceEffect {
  increase,
  decrease;

  static PartyBalanceEffect? fromJson(String? json) =>
      json == null ? null : PartyBalanceEffect.values.firstWhere((e) => e.name == json);
}

enum PartyPaymentKind {
  customerReceipt,
  supplierPayment,
  supplierReceipt,
  supplierOpeningBalance,
  supplierAdditionNote,
  supplierDiscountNote;

  bool get isSupplier => switch (this) {
    customerReceipt => false,
    _ => true,
  };

  bool get affectsCash => switch (this) {
    customerReceipt => true,
    supplierPayment => true,
    supplierReceipt => true,
    _ => false,
  };

  String get label => switch (this) {
    customerReceipt => 'مقبوضات عميل',
    supplierPayment => 'مدفوعات مورد',
    supplierReceipt => 'مقبوضات مورد',
    supplierOpeningBalance => 'رصيد افتتاحي مورد',
    supplierAdditionNote => 'إشعار إضافة مورد',
    supplierDiscountNote => 'إشعار خصم مورد',
  };

  static PartyPaymentKind fromJson(String json) =>
      PartyPaymentKind.values.firstWhere((e) => e.name == json,
          orElse: () => PartyPaymentKind.supplierPayment);

  String toJson() => name;
}
