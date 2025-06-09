import 'package:equatable/equatable.dart';
import 'package:floor/floor.dart';

import '../core/constants/constants.dart';
import '../core/constants/database_constants.dart';
import 'device.dart';

@Entity(
  tableName: kRelayTable,
  foreignKeys: [
    ForeignKey(
      childColumns: ['device_id'],
      parentColumns: ['id'],
      entity: Device,
    )
  ],
)
class Relay extends Equatable {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  @ColumnInfo(name: 'device_id')
  final int deviceId;
  final String relayName;
  final String relayTriggerTime;
  final bool relayState;

  const Relay({
    this.id,
    required this.deviceId,
    required this.relayName,
    this.relayTriggerTime = kDefaultRelayTrigger,
    this.relayState = false,
  });

  @override
  List<Object?> get props => throw UnimplementedError();

  @override
  bool? get stringify => true;

  Relay copyWith({
    int? id,
    int? deviceId,
    String? relayName,
    String? relayTriggerTime,
    bool? relayState,
  }) {
    return Relay(
      id: id ?? this.id,
      deviceId: deviceId ?? this.deviceId,
      relayName: relayName ?? this.relayName,
      relayTriggerTime: relayTriggerTime ?? this.relayTriggerTime,
      relayState: relayState ?? this.relayState,
    );
  }
}
