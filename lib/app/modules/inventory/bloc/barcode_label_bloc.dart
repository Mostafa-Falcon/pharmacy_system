import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pharmacy_system/app/core/constants/app_strings.dart';
import 'package:printing/printing.dart';

import 'package:pharmacy_system/app/modules/inventory/models/medicine_model.dart';
import 'package:pharmacy_system/app/core/data/services/auth/auth_service.dart';
import 'package:pharmacy_system/app/core/data/services/admin/branch_data_service.dart';
import 'package:pharmacy_system/app/core/presentation/widgets/reusables/feedback/app_snackbar.dart';

// --- Models ---
class SelectedLabelItem extends Equatable {
  final MedicineModel medicine;
  final int copies;

  const SelectedLabelItem({required this.medicine, required this.copies});

  SelectedLabelItem copyWith({MedicineModel? medicine, int? copies}) {
    return SelectedLabelItem(
      medicine: medicine ?? this.medicine,
      copies: copies ?? this.copies,
    );
  }

  @override
  List<Object?> get props => [medicine, copies];
}

// --- Events ---
abstract class BarcodeLabelEvent extends Equatable {
  const BarcodeLabelEvent();
  @override
  List<Object?> get props => [];
}

class SearchLabelMedicines extends BarcodeLabelEvent {
  final String query;
  const SearchLabelMedicines(this.query);
  @override
  List<Object?> get props => [query];
}

class AddLabelMedicine extends BarcodeLabelEvent {
  final MedicineModel medicine;
  const AddLabelMedicine(this.medicine);
  @override
  List<Object?> get props => [medicine];
}

class RemoveLabelMedicine extends BarcodeLabelEvent {
  final int index;
  const RemoveLabelMedicine(this.index);
  @override
  List<Object?> get props => [index];
}

class UpdateLabelCopies extends BarcodeLabelEvent {
  final int index;
  final int copies;
  const UpdateLabelCopies(this.index, this.copies);
  @override
  List<Object?> get props => [index, copies];
}

class SetDefaultCopies extends BarcodeLabelEvent {
  final int copies;
  const SetDefaultCopies(this.copies);
  @override
  List<Object?> get props => [copies];
}

class PrintLabels extends BarcodeLabelEvent {
  const PrintLabels();
}

// --- State ---
class BarcodeLabelState extends Equatable {
  final List<MedicineModel> searchResults;
  final String searchQuery;
  final List<SelectedLabelItem> selectedMedicines;
  final int defaultCopies;

  const BarcodeLabelState({
    this.searchResults = const [],
    this.searchQuery = '',
    this.selectedMedicines = const [],
    this.defaultCopies = 1,
  });

  BarcodeLabelState copyWith({
    List<MedicineModel>? searchResults,
    String? searchQuery,
    List<SelectedLabelItem>? selectedMedicines,
    int? defaultCopies,
  }) {
    return BarcodeLabelState(
      searchResults: searchResults ?? this.searchResults,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedMedicines: selectedMedicines ?? this.selectedMedicines,
      defaultCopies: defaultCopies ?? this.defaultCopies,
    );
  }

  @override
  List<Object?> get props => [searchResults, searchQuery, selectedMedicines, defaultCopies];
}

// --- Bloc ---
class BarcodeLabelBloc extends Bloc<BarcodeLabelEvent, BarcodeLabelState> {
  BarcodeLabelBloc() : super(const BarcodeLabelState()) {
    on<SearchLabelMedicines>(_onSearch);
    on<AddLabelMedicine>(_onAdd);
    on<RemoveLabelMedicine>(_onRemove);
    on<UpdateLabelCopies>(_onUpdateCopies);
    on<SetDefaultCopies>(_onSetDefault);
    on<PrintLabels>(_onPrint);
  }

  String get _branchId => AuthService.currentBranchId ?? '';

  void _onSearch(SearchLabelMedicines event, Emitter<BarcodeLabelState> emit) {
    final q = event.query.trim().toLowerCase();
    if (q.isEmpty) {
      emit(state.copyWith(searchResults: const [], searchQuery: event.query));
      return;
    }
    final all = BranchDataService.getMedicines(branchId: _branchId);
    final results = all.where((m) {
      final nameMatch = m.name.toLowerCase().contains(q);
      final nameEnMatch = m.nameEn?.toLowerCase().contains(q) ?? false;
      final barcodeMatch = m.barcodes.any((b) => b.toLowerCase().contains(q));
      return nameMatch || nameEnMatch || barcodeMatch;
    }).take(15).toList();
    emit(state.copyWith(searchResults: results, searchQuery: event.query));
  }

  void _onAdd(AddLabelMedicine event, Emitter<BarcodeLabelState> emit) {
    if (state.selectedMedicines.any((s) => s.medicine.id == event.medicine.id)) return;
    final updated = [
      ...state.selectedMedicines,
      SelectedLabelItem(medicine: event.medicine, copies: state.defaultCopies),
    ];
    emit(state.copyWith(selectedMedicines: updated, searchResults: const [], searchQuery: ''));
  }

  void _onRemove(RemoveLabelMedicine event, Emitter<BarcodeLabelState> emit) {
    final updated = [...state.selectedMedicines]..removeAt(event.index);
    emit(state.copyWith(selectedMedicines: updated));
  }

  void _onUpdateCopies(UpdateLabelCopies event, Emitter<BarcodeLabelState> emit) {
    final copies = event.copies < 1 ? 1 : event.copies;
    final updated = [...state.selectedMedicines];
    updated[event.index] = updated[event.index].copyWith(copies: copies);
    emit(state.copyWith(selectedMedicines: updated));
  }

  void _onSetDefault(SetDefaultCopies event, Emitter<BarcodeLabelState> emit) {
    emit(state.copyWith(defaultCopies: event.copies < 1 ? 1 : event.copies));
  }

  Future<void> _onPrint(PrintLabels event, Emitter<BarcodeLabelState> emit) async {
    if (state.selectedMedicines.isEmpty) {
      AppSnackbar.warning(AppStrings.selectAtLeastOneMedicine, title: AppStrings.warning);
      return;
    }

    final doc = pw.Document();
    final items = <pw.Widget>[];

    for (final selected in state.selectedMedicines) {
      for (int i = 0; i < selected.copies; i++) {
        items.add(_buildLabel(selected.medicine));
        // items.add(pw.SizedBox(height: 4)); // Optional spacing
      }
    }

    doc.addPage(pw.MultiPage(
      pageFormat: const PdfPageFormat(100 * PdfPageFormat.mm, 50 * PdfPageFormat.mm),
      margin: const pw.EdgeInsets.all(4),
      build: (ctx) => items,
    ));

    await Printing.sharePdf(
      bytes: await doc.save(),
      filename: 'barcode_labels.pdf',
    );
  }

  pw.Widget _buildLabel(MedicineModel medicine) {
    final barcode = medicine.barcodes.isNotEmpty ? medicine.barcodes.first : '';
    return pw.Container(
      padding: const pw.EdgeInsets.all(2),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(2)),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        children: [
          pw.Text(medicine.name, style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold)),
          if (medicine.strength != null && medicine.strength!.isNotEmpty)
            pw.Text(medicine.strength!, style: pw.TextStyle(fontSize: 6, color: PdfColors.grey)),
          pw.SizedBox(height: 2),
          pw.BarcodeWidget(
            barcode: pw.Barcode.code128(),
            data: barcode,
            width: 80,
            height: 16,
          ),
          pw.Text(barcode, style: pw.TextStyle(fontSize: 5, color: PdfColors.grey)),
          pw.Text('${medicine.sellPrice.toStringAsFixed(2)} ${AppStrings.currency}', style: pw.TextStyle(fontSize: 7, fontWeight: pw.FontWeight.bold)),
        ],
      ),
    );
  }
}

