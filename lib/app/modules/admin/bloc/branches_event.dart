import 'package:equatable/equatable.dart';

abstract class BranchesEvent extends Equatable {
  const BranchesEvent();
  @override
  List<Object?> get props => [];
}

class LoadBranches extends BranchesEvent {
  const LoadBranches();
}

class AddBranch extends BranchesEvent {
  final String name;
  final String? address;
  final String? phone;
  const AddBranch({required this.name, this.address, this.phone});
  @override
  List<Object?> get props => [name, address, phone];
}

class UpdateBranch extends BranchesEvent {
  final String id;
  final String? name;
  final String? address;
  final String? phone;
  const UpdateBranch(this.id, {this.name, this.address, this.phone});
  @override
  List<Object?> get props => [id, name, address, phone];
}

class DeleteBranch extends BranchesEvent {
  final String id;
  const DeleteBranch(this.id);
  @override
  List<Object?> get props => [id];
}


