class ImportStepInfo {
  final String step;
  final int itemsFound;
  final int itemsSaved;
  final int itemsUpdated;
  final int itemsSkipped;

  const ImportStepInfo({
    required this.step,
    this.itemsFound = 0,
    this.itemsSaved = 0,
    this.itemsUpdated = 0,
    this.itemsSkipped = 0,
  });

  ImportStepInfo copyWith({
    String? step,
    int? itemsFound,
    int? itemsSaved,
    int? itemsUpdated,
    int? itemsSkipped,
  }) =>
      ImportStepInfo(
        step: step ?? this.step,
        itemsFound: itemsFound ?? this.itemsFound,
        itemsSaved: itemsSaved ?? this.itemsSaved,
        itemsUpdated: itemsUpdated ?? this.itemsUpdated,
        itemsSkipped: itemsSkipped ?? this.itemsSkipped,
      );

  Map<String, dynamic> toMap() => {
        'step': step,
        'itemsFound': itemsFound,
        'itemsSaved': itemsSaved,
        'itemsUpdated': itemsUpdated,
        'itemsSkipped': itemsSkipped,
      };

  factory ImportStepInfo.fromMap(Map<String, dynamic> map) => ImportStepInfo(
        step: map['step'] as String? ?? 'done',
        itemsFound: map['itemsFound'] as int? ?? 0,
        itemsSaved: map['itemsSaved'] as int? ?? 0,
        itemsUpdated: map['itemsUpdated'] as int? ?? 0,
        itemsSkipped: map['itemsSkipped'] as int? ?? 0,
      );
}
