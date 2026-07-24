import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/bloc/base_paginated_bloc.dart';
import 'package:pharmacy_system/app/core/models/contacts/customer_group_model.dart';
import 'package:pharmacy_system/app/core/data/services/customer/customer_group_service.dart';
import 'package:pharmacy_system/app/shared/presentation/widgets/components/feedback/app_snackbar.dart';

// --- Custom Events ---

class AddCustomerGroup extends PaginatedEvent {
  final String name;
  final double discountPercent;
  final String? priceGroupId;
  final String? description;
  const AddCustomerGroup({
    required this.name,
    this.discountPercent = 0,
    this.priceGroupId,
    this.description,
  });
}

class UpdateCustomerGroup extends PaginatedEvent {
  final CustomerGroupModel group;
  const UpdateCustomerGroup(this.group);
}

class DeleteCustomerGroup extends PaginatedEvent {
  final String id;
  const DeleteCustomerGroup(this.id);
}

class ToggleActiveCustomerGroup extends PaginatedEvent {
  final String id;
  const ToggleActiveCustomerGroup(this.id);
}

// --- Bloc ---

class CustomerGroupsBloc extends BasePaginatedBloc<CustomerGroupModel> {
  CustomerGroupsBloc() {
    on<AddCustomerGroup>(_onAdd);
    on<UpdateCustomerGroup>(_onUpdate);
    on<DeleteCustomerGroup>(_onDelete);
    on<ToggleActiveCustomerGroup>(_onToggleActive);
    add(const LoadItems());
  }

  @override
  Future<List<CustomerGroupModel>> fetchAllItems() async {
    return CustomerGroupService.getAll(activeOnly: false);
  }

  @override
  bool filterCondition(CustomerGroupModel item, String query) {
    if (query.isEmpty) return true;
    final q = query.toLowerCase();
    return item.name.toLowerCase().contains(q) ||
        (item.description?.toLowerCase().contains(q) ?? false);
  }

  @override
  int compareItems(CustomerGroupModel a, CustomerGroupModel b, String column) {
    switch (column) {
      case 'name':
        return a.name.toLowerCase().compareTo(b.name.toLowerCase());
      case 'discount':
        return a.discountPercent.compareTo(b.discountPercent);
      default:
        return a.name.toLowerCase().compareTo(b.name.toLowerCase());
    }
  }

  Future<void> _onAdd(AddCustomerGroup event, Emitter<PaginatedState<CustomerGroupModel>> emit) async {
    try {
      await CustomerGroupService.add(
        name: event.name,
        discountPercent: event.discountPercent,
        priceGroupId: event.priceGroupId,
        description: event.description,
      );
      add(const LoadItems(refresh: true));
      AppSnackbar.success('?? ????? ???????? ?????');
    } catch (e) {
      AppSnackbar.error('??? ?? ????? ????????: $e');
    }
  }

  Future<void> _onUpdate(UpdateCustomerGroup event, Emitter<PaginatedState<CustomerGroupModel>> emit) async {
    try {
      await CustomerGroupService.update(event.group);
      add(const LoadItems(refresh: true));
      AppSnackbar.success('?? ????? ????????');
    } catch (e) {
      AppSnackbar.error('??? ?? ????? ????????: $e');
    }
  }

  Future<void> _onDelete(DeleteCustomerGroup event, Emitter<PaginatedState<CustomerGroupModel>> emit) async {
    try {
      await CustomerGroupService.delete(event.id);
      add(const LoadItems(refresh: true));
      AppSnackbar.success('?? ??? ????????');
    } catch (e) {
      AppSnackbar.error('??? ?? ??? ????????: $e');
    }
  }

  Future<void> _onToggleActive(ToggleActiveCustomerGroup event, Emitter<PaginatedState<CustomerGroupModel>> emit) async {
    final group = CustomerGroupService.getById(event.id);
    if (group != null) {
      if (group.isActive) {
        await CustomerGroupService.deactivate(event.id);
      } else {
        await CustomerGroupService.update(group.copyWith(isActive: true));
      }
      add(const LoadItems(refresh: true));
    }
  }
}





