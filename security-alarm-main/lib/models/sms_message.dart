import 'package:equatable/equatable.dart';
import 'package:floor/floor.dart';

@Entity(tableName: 'sms_messages')
class SmsMessage extends Equatable {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  
  final int deviceId;
  final String message;
  final DateTime timestamp;
  final bool isIncoming;

  const SmsMessage({
    this.id,
    required this.deviceId,
    required this.message,
    required this.timestamp,
    required this.isIncoming,
  });

  @override
  List<Object?> get props => [id, deviceId, message, timestamp, isIncoming];

  SmsMessage copyWith({
    int? id,
    int? deviceId,
    String? message,
    DateTime? timestamp,
    bool? isIncoming,
  }) {
    return SmsMessage(
      id: id ?? this.id,
      deviceId: deviceId ?? this.deviceId,
      message: message ?? this.message,
      timestamp: timestamp ?? this.timestamp,
      isIncoming: isIncoming ?? this.isIncoming,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'deviceId': deviceId,
      'message': message,
      'timestamp': timestamp.toIso8601String(),
      'isIncoming': isIncoming,
    };
  }

  factory SmsMessage.fromJson(Map<String, dynamic> json) {
    return SmsMessage(
      id: json['id'] as int?,
      deviceId: json['deviceId'] as int,
      message: json['message'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      isIncoming: json['isIncoming'] as bool,
    );
  }
} 