import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:pharmacy_system/app/core/data/services/accounting/correction_service.dart';
import 'package:pharmacy_system/app/core/models/base/correction_model.dart';

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

  const CorrectionChainLoaded(this.entries);

  @override
  List<Object?> get props => [entries];
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
      final entries = await CorrectionService.getChain(
        referenceType: referenceType,
        referenceId: referenceId,
      );
      emit(CorrectionChainLoaded(entries));
    } catch (e) {
      emit(CorrectionChainError(e.toString()));
    }
  }
}


