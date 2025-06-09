import 'package:equatable/equatable.dart';
import 'package:floor/floor.dart';
import '../core/constants/database_constants.dart';

@Entity(tableName: 'smart_control')
class SmartControl extends Equatable {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final int deviceId;
  final String controlType; // ورود امن، خروج امن، مسافرت امن، خواب امن
  final bool speakerEnabled;
  final bool remoteCodeEnabled;
  final bool remoteEnabled;
  final bool relay1Enabled;
  final bool relay2Enabled;
  final bool relay3Enabled;
  final bool scenarioEnabled;
  final String activeMode; // فعال، غیر فعال، نیمه فعال، بی‌صدا فعال، بی‌صدا نیمه فعال

  const SmartControl({
    this.id,
    required this.deviceId,
    required this.controlType,
    this.speakerEnabled = false,
    this.remoteCodeEnabled = false,
    this.remoteEnabled = false,
    this.relay1Enabled = false,
    this.relay2Enabled = false,
    this.relay3Enabled = false,
    this.scenarioEnabled = false,
    this.activeMode = 'فعال',
  });

  @override
  List<Object?> get props => [
        id,
        deviceId,
        controlType,
        speakerEnabled,
        remoteCodeEnabled,
        remoteEnabled,
        relay1Enabled,
        relay2Enabled,
        relay3Enabled,
        scenarioEnabled,
        activeMode,
      ];

  SmartControl copyWith({
    int? id,
    int? deviceId,
    String? controlType,
    bool? speakerEnabled,
    bool? remoteCodeEnabled,
    bool? remoteEnabled,
    bool? relay1Enabled,
    bool? relay2Enabled,
    bool? relay3Enabled,
    bool? scenarioEnabled,
    String? activeMode,
  }) {
    return SmartControl(
      id: id ?? this.id,
      deviceId: deviceId ?? this.deviceId,
      controlType: controlType ?? this.controlType,
      speakerEnabled: speakerEnabled ?? this.speakerEnabled,
      remoteCodeEnabled: remoteCodeEnabled ?? this.remoteCodeEnabled,
      remoteEnabled: remoteEnabled ?? this.remoteEnabled,
      relay1Enabled: relay1Enabled ?? this.relay1Enabled,
      relay2Enabled: relay2Enabled ?? this.relay2Enabled,
      relay3Enabled: relay3Enabled ?? this.relay3Enabled,
      scenarioEnabled: scenarioEnabled ?? this.scenarioEnabled,
      activeMode: activeMode ?? this.activeMode,
    );
  }
} 