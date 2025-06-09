import 'package:flutter/material.dart';
import 'package:floor/floor.dart';

enum ScheduleType {
  daily,
  once,
  weekly
}

enum ScheduleMode {
  allTimes,
  whenActive,
  whenDeactive,
  statusQuery
}

@entity
class ScheduleItem {
  @primaryKey
  final String id;
  
  final String deviceId;
  final String relayName;
  final int isActivating; // 1 = activation, 0 = deactivation
  final int mode; // ScheduleMode index
  final int type; // ScheduleType index
  final int timeHour;
  final int timeMinute;
  final int? date; // for once type (milliseconds since epoch)
  final int? weekday; // 1-7 for weekly type (1 = Monday)

  ScheduleItem({
    required this.id,
    required this.deviceId,
    required this.relayName,
    required this.isActivating,
    required this.mode,
    required this.type,
    required this.timeHour,
    required this.timeMinute,
    this.date,
    this.weekday,
  });

  factory ScheduleItem.create({
    required String id,
    required String deviceId,
    required String relayName,
    required bool isActivating,
    required ScheduleMode scheduleMode,
    required ScheduleType scheduleType,
    required TimeOfDay time,
    DateTime? dateTime,
    int? weekdayNumber,
  }) {
    return ScheduleItem(
      id: id,
      deviceId: deviceId,
      relayName: relayName,
      isActivating: isActivating ? 1 : 0,
      mode: scheduleMode.index,
      type: scheduleType.index,
      timeHour: time.hour,
      timeMinute: time.minute,
      date: dateTime?.millisecondsSinceEpoch,
      weekday: weekdayNumber,
    );
  }

  bool get isActivatingBool => isActivating == 1;
  ScheduleMode get scheduleMode => ScheduleMode.values[mode];
  ScheduleType get scheduleType => ScheduleType.values[type];
  TimeOfDay get time => TimeOfDay(hour: timeHour, minute: timeMinute);
  DateTime? get dateTime => date != null ? DateTime.fromMillisecondsSinceEpoch(date!) : null;

  String getDisplayText() {
    String relayAction = isActivatingBool ? 'فعال' : 'غیر فعال';
    String timeText = '${timeHour.toString().padLeft(2, '0')}:${timeMinute.toString().padLeft(2, '0')}';
    String dateText = '';

    if (scheduleType == ScheduleType.once && dateTime != null) {
      dateText = ' در تاریخ ${dateTime!.day}/${dateTime!.month}';
    } else if (scheduleType == ScheduleType.weekly && weekday != null) {
      List<String> weekdays = ['شنبه', 'یکشنبه', 'دوشنبه', 'سه شنبه', 'چهارشنبه', 'پنج شنبه', 'جمعه'];
      dateText = ' در روز ${weekdays[weekday! - 1]}';
    }

    return 'رله $relayName در ساعت $timeText$dateText $relayAction می شود.';
  }
} 