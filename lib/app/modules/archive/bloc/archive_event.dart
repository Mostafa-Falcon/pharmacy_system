import 'package:equatable/equatable.dart';
import 'package:pharmacy_system/app/modules/archive/models/archive_record_model.dart';

abstract class ArchiveEvent extends Equatable {
  const ArchiveEvent();

  @override
  List<Object?> get props => [];
}

class LoadArchive extends ArchiveEvent {
  const LoadArchive();
}

class ChangeArchiveEntityType extends ArchiveEvent {
  final ArchiveEntityType? entityType;
  const ChangeArchiveEntityType(this.entityType);

  @override
  List<Object?> get props => [entityType];
}

class SearchArchive extends ArchiveEvent {
  final String query;
  const SearchArchive(this.query);

  @override
  List<Object?> get props => [query];
}

class NextArchivePage extends ArchiveEvent {
  const NextArchivePage();
}

class PreviousArchivePage extends ArchiveEvent {
  const PreviousArchivePage();
}

class RestoreArchiveItem extends ArchiveEvent {
  final String recordId;
  final Map<String, dynamic>? modifiedData;
  const RestoreArchiveItem(this.recordId, {this.modifiedData});

  @override
  List<Object?> get props => [recordId, modifiedData];
}

class PermanentDeleteArchiveItem extends ArchiveEvent {
  final String recordId;
  const PermanentDeleteArchiveItem(this.recordId);

  @override
  List<Object?> get props => [recordId];
}



