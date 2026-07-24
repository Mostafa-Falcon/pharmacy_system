import 'package:equatable/equatable.dart';

enum ImportMedicinesStatus { initial, importing, success, error }

class ImportMedicinesState extends Equatable {
  final ImportMedicinesStatus status;
  final double progress;
  final String? fileName;
  final String? resultMessage;
  final bool hasError;
  final String? currentStep;
  final int itemsFound;
  final int itemsParsed;
  final int itemsSaved;
  final int itemsUpdated;
  final int itemsSkipped;

  const ImportMedicinesState({
    this.status = ImportMedicinesStatus.initial,
    this.progress = 0.0,
    this.fileName,
    this.resultMessage,
    this.hasError = false,
    this.currentStep,
    this.itemsFound = 0,
    this.itemsParsed = 0,
    this.itemsSaved = 0,
    this.itemsUpdated = 0,
    this.itemsSkipped = 0,
  });

  int get totalProcessed => itemsSaved + itemsUpdated + itemsSkipped;
  bool get hasItems => itemsFound > 0;

  ImportMedicinesState copyWith({
    ImportMedicinesStatus? status,
    double? progress,
    String? fileName,
    bool clearFileName = false,
    String? resultMessage,
    bool clearResult = false,
    bool? hasError,
    String? currentStep,
    bool clearStep = false,
    int? itemsFound,
    int? itemsParsed,
    int? itemsSaved,
    int? itemsUpdated,
    int? itemsSkipped,
  }) {
    return ImportMedicinesState(
      status: status ?? this.status,
      progress: progress ?? this.progress,
      fileName: clearFileName ? null : (fileName ?? this.fileName),
      resultMessage: clearResult ? null : (resultMessage ?? this.resultMessage),
      hasError: hasError ?? this.hasError,
      currentStep: clearStep ? null : (currentStep ?? this.currentStep),
      itemsFound: itemsFound ?? this.itemsFound,
      itemsParsed: itemsParsed ?? this.itemsParsed,
      itemsSaved: itemsSaved ?? this.itemsSaved,
      itemsUpdated: itemsUpdated ?? this.itemsUpdated,
      itemsSkipped: itemsSkipped ?? this.itemsSkipped,
    );
  }

  @override
  List<Object?> get props => [
    status, progress, fileName, resultMessage, hasError,
    currentStep, itemsFound, itemsParsed, itemsSaved, itemsUpdated, itemsSkipped,
  ];
}


