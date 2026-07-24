import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import 'package:pharmacy_system/app/core/models/inventory/promotion_model.dart';
import 'package:pharmacy_system/app/core/data/services/auth/auth_service.dart';
import 'package:pharmacy_system/app/core/data/services/inventory/promotion_service.dart';
enum PromotionsStatus { initial, loading, loaded, error }

class PromotionsState {
  final PromotionsStatus status;
  final List<PromotionModel> promotions;
  final String? error;

  const PromotionsState({
    this.status = PromotionsStatus.initial,
    this.promotions = const [],
    this.error,
  });

  PromotionsState copyWith({
    PromotionsStatus? status,
    List<PromotionModel>? promotions,
    String? error,
  }) {
    return PromotionsState(
      status: status ?? this.status,
      promotions: promotions ?? this.promotions,
      error: error ?? this.error,
    );
  }
}

class LoadPromotions {
  const LoadPromotions();
}

class CreatePromotion {
  final PromotionModel promotion;
  const CreatePromotion(this.promotion);
}

class UpdatePromotion {
  final PromotionModel promotion;
  const UpdatePromotion(this.promotion);
}

class DeletePromotion {
  final String id;
  const DeletePromotion(this.id);
}

class TogglePromotionStatus {
  final String id;
  final bool isActive;
  const TogglePromotionStatus(this.id, this.isActive);
}

class PromotionsBloc extends Bloc<Object, PromotionsState> {
  final _uuid = const Uuid();

  PromotionsBloc() : super(const PromotionsState()) {
    on<LoadPromotions>((event, emit) async {
      emit(state.copyWith(status: PromotionsStatus.loading));
      try {
        final branchId = AuthService.currentBranchId ?? '';
        final items = await PromotionService.getAll(branchId: branchId);
        emit(state.copyWith(status: PromotionsStatus.loaded, promotions: items));
      } catch (e) {
        emit(state.copyWith(status: PromotionsStatus.error, error: e.toString()));
      }
    });

    on<CreatePromotion>((event, emit) async {
      final created = await PromotionService.create(event.promotion.copyWith(
        id: _uuid.v4(),
        branchId: AuthService.currentBranchId ?? '',
      ));
      final updated = [...state.promotions, created];
      emit(state.copyWith(promotions: updated));
    });

    on<UpdatePromotion>((event, emit) async {
      await PromotionService.update(event.promotion);
      final updated = state.promotions.map((p) => p.id == event.promotion.id ? event.promotion : p).toList();
      emit(state.copyWith(promotions: updated));
    });

    on<DeletePromotion>((event, emit) async {
      await PromotionService.delete(event.id);
      final updated = state.promotions.where((p) => p.id != event.id).toList();
      emit(state.copyWith(promotions: updated));
    });

    on<TogglePromotionStatus>((event, emit) async {
      await PromotionService.toggleActive(event.id, event.isActive);
      final updated = state.promotions.map((p) {
        if (p.id == event.id) return p.copyWith(isActive: event.isActive);
        return p;
      }).toList();
      emit(state.copyWith(promotions: updated));
    });
  }
}




