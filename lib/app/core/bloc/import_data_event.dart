import 'package:equatable/equatable.dart';

enum ImportEntityType { medicines, customers, suppliers, expenses, sales, products }

abstract class ImportDataEvent extends Equatable {
  const ImportDataEvent();

  @override
  List<Object?> get props => [];
}

class PickAndImportData extends ImportDataEvent {
  final ImportEntityType entityType;
  const PickAndImportData(this.entityType);
}

class ResetImportData extends ImportDataEvent {
  const ResetImportData();
}
