import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmacy_system/app/core/models/base/correction_model.dart';
import 'package:pharmacy_system/app/core/data/services/system/correction_service.dart';
import 'package:pharmacy_system/app/core/data/services/system/system_health_service.dart';

// States
abstract class CorrectionChainState extends Equatable {
  const CorrectionChainState();

  @override
  List<Object?> get props => [];
}

class CorrectionChainInitial extends CorrectionChainState {}

class CorrectionChainLoading extends CorrectionChainState {}

class CorrectionChainLoaded extends CorrectionChainState {
  final List<CorrectionEntry> entries;
  final bool isOnline;

  const CorrectionChainLoaded(this.entries, {this.isOnline = true});

  @override
  List<Object?> get props => [entries, isOnline];
}

class CorrectionChainError extends CorrectionChainState {
  final String message;

  const CorrectionChainError(this.message);

  @override
  List<Object?> get props => [message];
}

// Cubit (Bloc 9.0)
class CorrectionChainCubit extends Cubit<CorrectionChainState> {
  CorrectionChainCubit() : super(CorrectionChainInitial());

  Future<void> loadChain({
    required CorrectionReferenceType referenceType,
    required String referenceId,
  }) async {
    emit(CorrectionChainLoading());
    try {
      // 🌐 التحقق من حالة النظام قبل التحميل
      final health = await SystemHealthService.instance.checkHealth();
      
      final entries = await CorrectionService.getChain(
        referenceType: referenceType,
        referenceId: referenceId,
      );
      
      emit(CorrectionChainLoaded(entries, isOnline: health.supabaseReachable));
    } catch (e) {
      emit(CorrectionChainError(e.toString()));
    }
  }
}
