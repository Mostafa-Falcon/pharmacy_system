import 'package:equatable/equatable.dart';
import 'package:pharmacy_system/app/modules/sales/models/return_model.dart';

abstract class FreeReturnEvent extends Equatable {
  const FreeReturnEvent();

  @override
  List<Object?> get props => [];
}

class SetReturnType extends FreeReturnEvent {
  final String returnType;
  const SetReturnType(this.returnType);
  @override
  List<Object?> get props => [returnType];
}

class SetPartyType extends FreeReturnEvent {
  final String partyType;
  const SetPartyType(this.partyType);
  @override
  List<Object?> get props => [partyType];
}

class SetSelectedParty extends FreeReturnEvent {
  final String? id;
  final String? name;
  const SetSelectedParty(this.id, this.name);
  @override
  List<Object?> get props => [id, name];
}

class AddReturnItem extends FreeReturnEvent {
  final ReturnItemModel item;
  const AddReturnItem(this.item);
  @override
  List<Object?> get props => [item];
}

class RemoveReturnItem extends FreeReturnEvent {
  final int index;
  const RemoveReturnItem(this.index);
  @override
  List<Object?> get props => [index];
}

class UpdateReturnItem extends FreeReturnEvent {
  final int index;
  final ReturnItemModel item;
  const UpdateReturnItem(this.index, this.item);
  @override
  List<Object?> get props => [index, item];
}

class SetDiscountPercent extends FreeReturnEvent {
  final double percent;
  const SetDiscountPercent(this.percent);
  @override
  List<Object?> get props => [percent];
}

class SetReturnNotes extends FreeReturnEvent {
  final String notes;
  const SetReturnNotes(this.notes);
  @override
  List<Object?> get props => [notes];
}

class SetReturnReason extends FreeReturnEvent {
  final ReturnReason reason;
  const SetReturnReason(this.reason);
  @override
  List<Object?> get props => [reason];
}

class SubmitFreeReturn extends FreeReturnEvent {
  const SubmitFreeReturn();
}
