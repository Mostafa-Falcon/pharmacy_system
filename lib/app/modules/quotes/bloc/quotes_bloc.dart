import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmacy_system/app/core/data/services/auth/auth_service.dart';
import 'package:pharmacy_system/app/core/data/services/sales/quote_service.dart';
import 'package:pharmacy_system/app/core/presentation/widgets/reusables/feedback/app_snackbar.dart';
import 'quotes_event.dart';
import 'quotes_state.dart';

class QuotesBloc extends Bloc<QuotesEvent, QuotesState> {
  QuotesBloc() : super(const QuotesState()) {
    on<LoadQuotes>(_onLoad);
    on<CreateQuote>(_onCreate);
    on<DeleteQuote>(_onDelete);
    add(const LoadQuotes());
  }

  Future<void> _onLoad(LoadQuotes event, Emitter<QuotesState> emit) async {
    emit(state.copyWith(status: QuotesStatus.loading));
    try {
      final quotes = QuoteService.getAll(branchId: AuthService.currentBranchId);
      emit(state.copyWith(status: QuotesStatus.loaded, quotes: quotes));
    } catch (e) {
      emit(state.copyWith(status: QuotesStatus.error, error: e.toString()));
    }
  }

  Future<void> _onCreate(CreateQuote event, Emitter<QuotesState> emit) async {
    try {
      await QuoteService.create(
        customerName: event.customerName,
        notes: event.notes,
        items: event.items,
        subtotal: event.subtotal,
        discount: event.discount,
        total: event.total,
      );
      add(const LoadQuotes());
      AppSnackbar.success('تم إنشاء عرض السعر بنجاح');
    } catch (e) {
      AppSnackbar.error('فشل في إنشاء عرض السعر: $e');
    }
  }

  Future<void> _onDelete(DeleteQuote event, Emitter<QuotesState> emit) async {
    try {
      await QuoteService.softDelete(event.id);
      add(const LoadQuotes());
      AppSnackbar.success('تم حذف عرض السعر');
    } catch (e) {
      AppSnackbar.error('فشل في حذف عرض السعر: $e');
    }
  }
}
