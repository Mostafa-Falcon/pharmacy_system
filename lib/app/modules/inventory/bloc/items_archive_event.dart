import 'package:equatable/equatable.dart';

abstract class ItemsArchiveEvent extends Equatable {
  const ItemsArchiveEvent();

  @override
  List<Object?> get props => [];
}

class LoadItemsArchive extends ItemsArchiveEvent {
  const LoadItemsArchive();
}

class SearchItemsArchive extends ItemsArchiveEvent {
  final String query;
  const SearchItemsArchive(this.query);

  @override
  List<Object?> get props => [query];
}

class ToggleItemSelection extends ItemsArchiveEvent {
  final String id;
  const ToggleItemSelection(this.id);

  @override
  List<Object?> get props => [id];
}

class ToggleAllSelection extends ItemsArchiveEvent {
  const ToggleAllSelection();
}

class RestoreItem extends ItemsArchiveEvent {
  final String id;
  const RestoreItem(this.id);

  @override
  List<Object?> get props => [id];
}

class RestoreSelected extends ItemsArchiveEvent {
  const RestoreSelected();
}

class DeleteItem extends ItemsArchiveEvent {
  final String id;
  const DeleteItem(this.id);

  @override
  List<Object?> get props => [id];
}

class DeleteSelected extends ItemsArchiveEvent {
  const DeleteSelected();
}
