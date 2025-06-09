import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import '../models/scheduling.dart';
import '../services/local/app_database.dart';

class SchedulingRepository {
  final AppDatabase _db;

  SchedulingRepository(this._db);

  Future<List<ScheduleItem>> getSchedulesForDevice(String deviceId) async {
    return await _db.scheduleDao.getSchedulesForDevice(deviceId);
  }

  Future<void> saveSchedule(String deviceId, String relayName, bool isActivating, 
      ScheduleMode mode, ScheduleType type, TimeOfDay time, 
      {DateTime? date, int? weekday}) async {
    
    final schedule = ScheduleItem.create(
      id: const Uuid().v4(),
      deviceId: deviceId,
      relayName: relayName,
      isActivating: isActivating,
      scheduleMode: mode,
      scheduleType: type,
      time: time,
      dateTime: date,
      weekdayNumber: weekday,
    );
    
    await _db.scheduleDao.insertSchedule(schedule);
  }

  Future<void> deleteSchedule(String deviceId, String scheduleId) async {
    await _db.scheduleDao.deleteScheduleById(scheduleId, deviceId);
  }

  Future<void> deleteAllSchedulesForDevice(String deviceId) async {
    await _db.scheduleDao.deleteAllSchedulesForDevice(deviceId);
  }

  Future<void> createScheduleTable(sqflite.Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS schedules(
        id TEXT PRIMARY KEY,
        deviceId TEXT NOT NULL,
        relayName TEXT NOT NULL,
        isActivating INTEGER NOT NULL,
        mode INTEGER NOT NULL,
        type INTEGER NOT NULL,
        timeHour INTEGER NOT NULL,
        timeMinute INTEGER NOT NULL,
        date INTEGER,
        weekday INTEGER
      )
    ''');
  }
} 