import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/bloc/base_paginated_bloc.dart';
import 'package:pharmacy_system/app/shared/presentation/widgets/components/feedback/app_snackbar.dart';
import 'package:pharmacy_system/app/core/models/inventory/medicine_brand_model.dart';
import '../services/brand_service.dart';

// --- Custom Events ---

class AddBrand extends PaginatedEvent {
  final String name;
  final String? description;
  final String? logo;
  const AddBrand({required this.name, this.description, this.logo});
}

class UpdateBrand extends PaginatedEvent {
  final MedicineBrandModel brand;
  const UpdateBrand(this.brand);
}

class DeleteBrand extends PaginatedEvent {
  final String id;
  const DeleteBrand(this.id);
}

// --- Bloc ---

class BrandsBloc extends BasePaginatedBloc<MedicineBrandModel> {
  BrandsBloc() {
    on<AddBrand>(_onAdd);
    on<UpdateBrand>(_onUpdate);
    on<DeleteBrand>(_onDelete);
    add(const LoadItems());
  }

  @override
  Future<List<MedicineBrandModel>> fetchAllItems() async {
    return BrandService.getAll();
  }

  @override
  bool filterCondition(MedicineBrandModel item, String query) {
    if (query.isEmpty) return true;
    final q = query.toLowerCase();
    return item.name.toLowerCase().contains(q) ||
        (item.description?.toLowerCase().contains(q) ?? false);
  }

  @override
  int compareItems(MedicineBrandModel a, MedicineBrandModel b, String column) {
    switch (column) {
      case 'name':
        return a.name.toLowerCase().compareTo(b.name.toLowerCase());
      case 'description':
        return (a.description ?? '').toLowerCase().compareTo((b.description ?? '').toLowerCase());
      default:
        return a.name.toLowerCase().compareTo(b.name.toLowerCase());
    }
  }

  Future<void> _onAdd(AddBrand event, Emitter<PaginatedState<MedicineBrandModel>> emit) async {
    if (BrandService.nameExists(event.name)) {
      AppSnackbar.error('??? ??????? ???????? ????? ??????');
      return;
    }
    await BrandService.add(
      name: event.name,
      description: event.description,
      logo: event.logo,
    );
    add(const LoadItems(refresh: true));
  }

  Future<void> _onUpdate(UpdateBrand event, Emitter<PaginatedState<MedicineBrandModel>> emit) async {
    if (BrandService.nameExists(event.brand.name, excludeId: event.brand.id)) {
      AppSnackbar.error('??? ??????? ???????? ????? ??????');
      return;
    }
    await BrandService.update(event.brand);
    add(const LoadItems(refresh: true));
  }

  Future<void> _onDelete(DeleteBrand event, Emitter<PaginatedState<MedicineBrandModel>> emit) async {
    await BrandService.delete(event.id);
    add(const LoadItems(refresh: true));
  }
}





