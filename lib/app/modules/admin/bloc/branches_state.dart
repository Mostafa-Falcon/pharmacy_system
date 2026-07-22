import 'package:pharmacy_system/app/modules/auth/models/branch_model.dart';
import '../../../core/bloc/base_state.dart';

class BranchesState extends BaseState<List<BranchModel>> {
  const BranchesState({
    super.data,
    super.isLoading = false,
    super.errorMessage,
    super.fromDate,
    super.toDate,
  });

  List<BranchModel> get branches => data ?? [];
  String? get error => errorMessage;
  BaseState<List<BranchModel>> get branchesState => this;

  @override
  BranchesState copyWith({
    List<BranchModel>? data,
    bool? isLoading,
    String? errorMessage,
    bool? isInitial,
    bool? isEmpty,
    DateTime? fromDate,
    DateTime? toDate,
  }) {
    return BranchesState(
      data: data ?? this.data,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      fromDate: fromDate ?? this.fromDate,
      toDate: toDate ?? this.toDate,
    );
  }

  @override
  List<Object?> get props => [
        data,
        isLoading,
        errorMessage,
        fromDate,
        toDate,
      ];
}

