import 'package:equatable/equatable.dart';
import 'package:pharmacy_system/app/modules/archive/models/archive_record_model.dart';

enum ArchiveStatus { initial, loading, loaded, error, working }

class ArchiveState extends Equatable {
  final ArchiveStatus status;
  final List<ArchiveRecordModel> records;
  final ArchiveEntityType? selectedType;
  final String query;
  final int currentPage;
  final int pageSize;
  final int totalRecords;
  final String? error;
  final bool isWorking;

  const ArchiveState({
    this.status = ArchiveStatus.initial,
    this.records = const [],
    this.selectedType,
    this.query = '',
    this.currentPage = 1,
    this.pageSize = 50,
    this.totalRecords = 0,
    this.error,
    this.isWorking = false,
  });

  int get totalPages => pageSize > 0 ? (totalRecords / pageSize).ceil() : 1;
  bool get hasNextPage => currentPage < totalPages;
  bool get hasPreviousPage => currentPage > 1;

  ArchiveState copyWith({
    ArchiveStatus? status,
    List<ArchiveRecordModel>? records,
    ArchiveEntityType? selectedType,
    String? query,
    int? currentPage,
    int? pageSize,
    int? totalRecords,
    String? error,
    bool? isWorking,
    bool clearError = false,
  }) {
    return ArchiveState(
      status: status ?? this.status,
      records: records ?? this.records,
      selectedType: selectedType ?? this.selectedType,
      query: query ?? this.query,
      currentPage: currentPage ?? this.currentPage,
      pageSize: pageSize ?? this.pageSize,
      totalRecords: totalRecords ?? this.totalRecords,
      error: clearError ? null : (error ?? this.error),
      isWorking: isWorking ?? this.isWorking,
    );
  }

  @override
  List<Object?> get props => [
    status,
    records,
    selectedType,
    query,
    currentPage,
    pageSize,
    totalRecords,
    error,
    isWorking,
  ];
}

