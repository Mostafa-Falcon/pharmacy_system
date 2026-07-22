part of 'settings_bloc.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();
  @override
  List<Object?> get props => [];
}

class LoadSettings extends SettingsEvent {
  const LoadSettings();
}

class SetActiveTab extends SettingsEvent {
  final String tab;
  const SetActiveTab(this.tab);
  @override
  List<Object?> get props => [tab];
}

class SetSearchQuery extends SettingsEvent {
  final String query;
  const SetSearchQuery(this.query);
  @override
  List<Object?> get props => [query];
}

class UpdateProjectSettings extends SettingsEvent {
  final ProjectSettings Function(ProjectSettings) updater;
  const UpdateProjectSettings(this.updater);
  @override
  List<Object?> get props => [updater];
}

class UpdateTaxSettings extends SettingsEvent {
  final TaxSettings Function(TaxSettings) updater;
  const UpdateTaxSettings(this.updater);
  @override
  List<Object?> get props => [updater];
}

class UpdateItemsSettings extends SettingsEvent {
  final ItemsSettings Function(ItemsSettings) updater;
  const UpdateItemsSettings(this.updater);
  @override
  List<Object?> get props => [updater];
}

class UpdateSalesSettings extends SettingsEvent {
  final SalesSettings Function(SalesSettings) updater;
  const UpdateSalesSettings(this.updater);
  @override
  List<Object?> get props => [updater];
}

class UpdateSystemSettings extends SettingsEvent {
  final SystemSettings Function(SystemSettings) updater;
  const UpdateSystemSettings(this.updater);
  @override
  List<Object?> get props => [updater];
}

class UpdateEmailSettings extends SettingsEvent {
  final EmailSettings Function(EmailSettings) updater;
  const UpdateEmailSettings(this.updater);
  @override
  List<Object?> get props => [updater];
}

class UpdateSmsSettings extends SettingsEvent {
  final SmsSettings Function(SmsSettings) updater;
  const UpdateSmsSettings(this.updater);
  @override
  List<Object?> get props => [updater];
}

class UpdateRewardsSettings extends SettingsEvent {
  final RewardsSettings Function(RewardsSettings) updater;
  const UpdateRewardsSettings(this.updater);
  @override
  List<Object?> get props => [updater];
}

class UpdateShortcutsSettings extends SettingsEvent {
  final ShortcutsSettings Function(ShortcutsSettings) updater;
  const UpdateShortcutsSettings(this.updater);
  @override
  List<Object?> get props => [updater];
}

class UpdateExtraUnitsSettings extends SettingsEvent {
  final ExtraUnitsSettings Function(ExtraUnitsSettings) updater;
  const UpdateExtraUnitsSettings(this.updater);
  @override
  List<Object?> get props => [updater];
}

class UpdateInvoiceLayoutSettings extends SettingsEvent {
  final InvoiceLayoutSettings Function(InvoiceLayoutSettings) updater;
  const UpdateInvoiceLayoutSettings(this.updater);
  @override
  List<Object?> get props => [updater];
}
