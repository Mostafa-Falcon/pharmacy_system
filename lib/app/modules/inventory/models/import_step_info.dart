class ImportStepInfo {
  final String step;
  final int itemsFound;
  final int itemsParsed;
  final int itemsSaved;
  final int itemsUpdated;
  final int itemsSkipped;

  const ImportStepInfo({
    required this.step,
    this.itemsFound = 0,
    this.itemsParsed = 0,
    this.itemsSaved = 0,
    this.itemsUpdated = 0,
    this.itemsSkipped = 0,
  });

  ImportStepInfo copyWith({
    String? step,
    int? itemsFound,
    int? itemsParsed,
    int? itemsSaved,
    int? itemsUpdated,
    int? itemsSkipped,
  }) {
    return ImportStepInfo(
      step: step ?? this.step,
      itemsFound: itemsFound ?? this.itemsFound,
      itemsParsed: itemsParsed ?? this.itemsParsed,
      itemsSaved: itemsSaved ?? this.itemsSaved,
      itemsUpdated: itemsUpdated ?? this.itemsUpdated,
      itemsSkipped: itemsSkipped ?? this.itemsSkipped,
    );
  }
}
