import 'package:floor/floor.dart';

import '../../../models/scheduling.dart';

@dao
abstract class ScheduleDAO {
  @Query('SELECT * FROM ScheduleItem WHERE deviceId = :deviceId')
  Future<List<ScheduleItem>> getSchedulesForDevice(String deviceId);

  @insert
  Future<void> insertSchedule(ScheduleItem schedule);

  @delete
  Future<void> deleteSchedule(ScheduleItem schedule);

  @Query('DELETE FROM ScheduleItem WHERE id = :id AND deviceId = :deviceId')
  Future<void> deleteScheduleById(String id, String deviceId);

  @Query('DELETE FROM ScheduleItem WHERE deviceId = :deviceId')
  Future<void> deleteAllSchedulesForDevice(String deviceId);
} 