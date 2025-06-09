import 'package:equatable/equatable.dart';

class StatusReportItem extends Equatable {
  final String title;
  final DateTime timestamp;

  const StatusReportItem({
    required this.title,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [title, timestamp];

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory StatusReportItem.fromJson(Map<String, dynamic> json) {
    return StatusReportItem(
      title: json['title'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }
}

class DeviceStatusReport extends Equatable {
  final int deviceId;
  final List<StatusReportItem> reports;

  const DeviceStatusReport({
    required this.deviceId,
    required this.reports,
  });

  @override
  List<Object?> get props => [deviceId, reports];

  Map<String, dynamic> toJson() {
    return {
      'deviceId': deviceId,
      'reports': reports.map((report) => report.toJson()).toList(),
    };
  }

  factory DeviceStatusReport.fromJson(Map<String, dynamic> json) {
    return DeviceStatusReport(
      deviceId: json['deviceId'] as int,
      reports: (json['reports'] as List)
          .map((reportJson) => StatusReportItem.fromJson(reportJson))
          .toList(),
    );
  }
} 