import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:floor/floor.dart';

import '../core/constants/constants.dart';
import '../core/constants/database_constants.dart';

@Entity(tableName: kAppSettingsTable)
class AppSettings extends Equatable {
  @primaryKey
  final int id;
  final String appPassword;
  final String appVersion;
  final bool showPassPage;
  final int selectedDeviceIndex;
  final int selectedThemePalette;

  const AppSettings({
    this.id = 1,
    this.appPassword = kDefaultDevicePassword,
    this.appVersion = kAppVersion,
    this.showPassPage = false,
    this.selectedDeviceIndex = 0,
    this.selectedThemePalette = 0,
  });

  @override
  List<Object> get props {
    return [
      id,
      appPassword,
      appVersion,
      showPassPage,
      selectedDeviceIndex,
      selectedThemePalette,
    ];
  }

  factory AppSettings.fromMap(Map<String, dynamic> map) {
    return AppSettings(
      appPassword: map['appPassword'] as String? ?? kDefaultDevicePassword,
      appVersion: map['appVersion'] as String? ?? kAppVersion,
      showPassPage: map['showPassPage'] as bool? ?? false,
      selectedDeviceIndex: map['selectedDeviceIndex'] as int? ?? 0,
      selectedThemePalette: map['selectedThemePalette'] as int? ?? 0,
    );
  }

  factory AppSettings.fromJson(String source) => AppSettings.fromMap(
        json.decode(source) as Map<String, dynamic>,
      );

  @override
  bool? get stringify => true;

  AppSettings copyWith({
    int? id,
    String? appPassword,
    String? appVersion,
    bool? showPassPage,
    int? selectedDeviceIndex,
    int? selectedThemePalette,
  }) {
    return AppSettings(
      id: id ?? this.id,
      appPassword: appPassword ?? this.appPassword,
      appVersion: appVersion ?? this.appVersion,
      showPassPage: showPassPage ?? this.showPassPage,
      selectedDeviceIndex: selectedDeviceIndex ?? this.selectedDeviceIndex,
      selectedThemePalette: selectedThemePalette ?? this.selectedThemePalette,
    );
  }
}
