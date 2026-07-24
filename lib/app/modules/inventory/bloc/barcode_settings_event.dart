import 'package:equatable/equatable.dart';

abstract class BarcodeSettingsEvent extends Equatable {
  const BarcodeSettingsEvent();

  @override
  List<Object?> get props => [];
}

class LoadBarcodeSettings extends BarcodeSettingsEvent {
  const LoadBarcodeSettings();
}

class UpdatePrefix extends BarcodeSettingsEvent {
  final String value;
  const UpdatePrefix(this.value);

  @override
  List<Object?> get props => [value];
}

class UpdateSerialLength extends BarcodeSettingsEvent {
  final int value;
  const UpdateSerialLength(this.value);

  @override
  List<Object?> get props => [value];
}

class UpdateFormatIndex extends BarcodeSettingsEvent {
  final int value;
  const UpdateFormatIndex(this.value);

  @override
  List<Object?> get props => [value];
}

class UpdateLabelWidth extends BarcodeSettingsEvent {
  final double value;
  const UpdateLabelWidth(this.value);

  @override
  List<Object?> get props => [value];
}

class UpdateLabelHeight extends BarcodeSettingsEvent {
  final double value;
  const UpdateLabelHeight(this.value);

  @override
  List<Object?> get props => [value];
}

class ToggleShowPrice extends BarcodeSettingsEvent {
  const ToggleShowPrice();
}

class ToggleShowName extends BarcodeSettingsEvent {
  const ToggleShowName();
}

class ToggleShowBarcode extends BarcodeSettingsEvent {
  const ToggleShowBarcode();
}

class UpdatePrintLayoutIndex extends BarcodeSettingsEvent {
  final int value;
  const UpdatePrintLayoutIndex(this.value);

  @override
  List<Object?> get props => [value];
}

class UpdateCopiesPerItem extends BarcodeSettingsEvent {
  final int value;
  const UpdateCopiesPerItem(this.value);

  @override
  List<Object?> get props => [value];
}

class UpdatePharmacyName extends BarcodeSettingsEvent {
  final String value;
  const UpdatePharmacyName(this.value);

  @override
  List<Object?> get props => [value];
}

class ToggleUsePharmacySignature extends BarcodeSettingsEvent {
  const ToggleUsePharmacySignature();
}

class SaveBarcodeSettings extends BarcodeSettingsEvent {
  const SaveBarcodeSettings();
}


