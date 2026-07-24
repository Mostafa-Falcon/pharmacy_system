import 'package:equatable/equatable.dart';
import 'package:pharmacy_system/app/core/models/inventory/stock_transfer_model.dart';

abstract class StockTransferEvent extends Equatable {
  const StockTransferEvent();

  @override
  List<Object?> get props => [];
}

class LoadStockTransfers extends StockTransferEvent {
  const LoadStockTransfers();
}

class SelectTransferTab extends StockTransferEvent {
  final int index;
  const SelectTransferTab(this.index);

  @override
  List<Object?> get props => [index];
}

class SendTransfer extends StockTransferEvent {
  final StockTransferModel transfer;
  const SendTransfer(this.transfer);

  @override
  List<Object?> get props => [transfer];
}

class ReceiveTransfer extends StockTransferEvent {
  final String id;
  const ReceiveTransfer(this.id);

  @override
  List<Object?> get props => [id];
}

class CancelTransfer extends StockTransferEvent {
  final String id;
  const CancelTransfer(this.id);

  @override
  List<Object?> get props => [id];
}




