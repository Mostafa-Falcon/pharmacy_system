enum AccountType {
  asset,
  liability,
  equity,
  income,
  expense;

  static AccountType fromJson(String json) =>
      AccountType.values.firstWhere((e) => e.name == json, orElse: () => AccountType.asset);

  String toJson() => name;
}

enum JournalEntryType {
  sales,
  salesReturn,
  purchase,
  purchaseReturn,
  expense,
  payment,
  receipt,
  adjustment,
  transfer,
  other;

  static JournalEntryType fromJson(String json) =>
      JournalEntryType.values.firstWhere((e) => e.name == json, orElse: () => JournalEntryType.other);

  String toJson() => name;
}
