part of 'settings_bloc.dart';

enum SettingsStatus { initial, loading, loaded, saving, error }

class SettingsState extends Equatable {
  final SettingsStatus status;
  final PharmacySettings settings;
  final String activeTab;
  final String searchQuery;
  final String? lastUpdated;
  final String? error;

  SettingsState({
    this.status = SettingsStatus.initial,
    PharmacySettings? settings,
    this.activeTab = 'project',
    this.searchQuery = '',
    this.lastUpdated,
    this.error,
  }) : settings = settings ?? PharmacySettings();

  SettingsState copyWith({
    SettingsStatus? status,
    PharmacySettings? settings,
    String? activeTab,
    String? searchQuery,
    String? lastUpdated,
    bool clearLastUpdated = false,
    String? error,
    bool clearError = false,
  }) {
    return SettingsState(
      status: status ?? this.status,
      settings: settings ?? this.settings,
      activeTab: activeTab ?? this.activeTab,
      searchQuery: searchQuery ?? this.searchQuery,
      lastUpdated: clearLastUpdated ? null : (lastUpdated ?? this.lastUpdated),
      error: clearError ? null : (error ?? this.error),
    );
  }

  @override
  List<Object?> get props => [status, settings, activeTab, searchQuery, lastUpdated, error];
}


