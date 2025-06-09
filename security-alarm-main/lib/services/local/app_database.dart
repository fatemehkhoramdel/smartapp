// ignore_for_file: depend_on_referenced_packages

import 'dart:async';

import 'package:floor/floor.dart';
import 'package:security_alarm/core/constants/database_constants.dart';
import 'package:security_alarm/models/audio_notification.dart';
import 'package:security_alarm/models/relay.dart';
import 'package:security_alarm/models/scheduling.dart';
import 'package:security_alarm/models/smart_control.dart';
import 'package:security_alarm/models/scenario.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import '../../models/app_settings.dart';
import '../../models/device.dart';
import 'DAOs/app_settings_dao.dart';
import 'DAOs/audio_notification_dao.dart';
import 'DAOs/device_dao.dart';
import 'DAOs/relay_dao.dart';
import 'DAOs/schedule_dao.dart';
import 'DAOs/smart_control_dao.dart';
import 'DAOs/zones_dao.dart';
import 'DAOs/scenario_dao.dart';

part 'app_database.g.dart';

/// Floor database class
@Database(version: kDatabaseVersion, entities: [AppSettings, Device, Relay, AudioNotification, ScheduleItem, SmartControl, ZonesTable, Scenario])
abstract class AppDatabase extends FloorDatabase {
  AppSettingsDAO get appSettingsDao;
  DeviceDAO get deviceDao;
  RelayDAO get relayDao;
  AudioNotificationDAO get audioNotificationDao;
  ScheduleDAO get scheduleDao;
  SmartControlDAO get smartControlDao;
  ZonesDao get zonesDao;
  ScenarioDAO get scenarioDao;
}
