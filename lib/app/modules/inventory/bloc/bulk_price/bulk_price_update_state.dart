import 'package:equatable/equatable.dart';

class BulkPriceUpdateState extends Equatable {
  final List<String> categories;
  final String? selectedCategory;
  final String selectedField;
  final String selectedOperation;
  final double value;
  final int affectedCount;
  final bool isLoading;
  final bool isSuccess;
  final String? message;

  const BulkPriceUpdateState({
    this.categories = const [],
    this.selectedCategory,
    this.selectedField = 'sellPrice',
    this.selectedOperation = 'set',
    this.value = 0,
    this.affectedCount = 0,
    this.isLoading = false,
    this.isSuccess = false,
    this.message,
  });

  BulkPriceUpdateState copyWith({
    List<String>? categories,
    String? selectedCategory,
    String? selectedField,
    String? selectedOperation,
    double? value,
    int? affectedCount,
    bool? isLoading,
    bool? isSuccess,
    String? message,
  }) {
    return BulkPriceUpdateState(
      categories: categories ?? this.categories,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      selectedField: selectedField ?? this.selectedField,
      selectedOperation: selectedOperation ?? this.selectedOperation,
      value: value ?? this.value,
      affectedCount: affectedCount ?? this.affectedCount,
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [
    categories,
    selectedCategory,
    selectedField,
    selectedOperation,
    value,
    affectedCount,
    isLoading,
    isSuccess,
    message,
  ];
}
