// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

abstract class $AppDatabaseBuilderContract {
  /// Adds migrations to the builder.
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $AppDatabaseBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<AppDatabase> build();
}

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder implements $AppDatabaseBuilderContract {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $AppDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  AppSettingsDAO? _appSettingsDaoInstance;

  DeviceDAO? _deviceDaoInstance;

  RelayDAO? _relayDaoInstance;

  AudioNotificationDAO? _audioNotificationDaoInstance;

  ScheduleDAO? _scheduleDaoInstance;

  SmartControlDAO? _smartControlDaoInstance;

  ZonesDao? _zonesDaoInstance;

  ScenarioDAO? _scenarioDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `app_settings` (`id` INTEGER NOT NULL, `appPassword` TEXT NOT NULL, `appVersion` TEXT NOT NULL, `showPassPage` INTEGER NOT NULL, `selectedDeviceIndex` INTEGER NOT NULL, `selectedThemePalette` INTEGER NOT NULL, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `device` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `deviceName` TEXT NOT NULL, `devicePassword` TEXT NOT NULL, `devicePhone` TEXT NOT NULL, `deviceModel` TEXT NOT NULL, `deviceState` TEXT NOT NULL, `isManager` INTEGER NOT NULL, `alarmTime` TEXT NOT NULL, `remoteAmount` INTEGER NOT NULL, `simChargeAmount` INTEGER NOT NULL, `antennaAmount` INTEGER NOT NULL, `batteryAmount` INTEGER NOT NULL, `cityPowerState` INTEGER NOT NULL, `gsmState` INTEGER NOT NULL, `speakerState` INTEGER NOT NULL, `networkState` INTEGER NOT NULL, `capsulMax` INTEGER NOT NULL, `capsulMin` INTEGER NOT NULL, `totalContactsAmount` INTEGER NOT NULL, `spyAmount` INTEGER NOT NULL, `chargePeriodictReport` INTEGER NOT NULL, `batteryPeriodictReport` INTEGER NOT NULL, `callOrder` INTEGER NOT NULL, `alarmDuration` INTEGER NOT NULL, `callDuration` INTEGER NOT NULL, `controlRelaysWithRemote` INTEGER NOT NULL, `monitoring` INTEGER NOT NULL, `remoteReporting` INTEGER NOT NULL, `scenarioReporting` INTEGER NOT NULL, `callPriority` INTEGER NOT NULL, `smsPriority` INTEGER NOT NULL, `operator` TEXT NOT NULL, `deviceLang` TEXT NOT NULL, `deviceSimLang` TEXT NOT NULL, `silentOnSiren` INTEGER NOT NULL, `relayOnDingDong` INTEGER NOT NULL, `callOnPowerLoss` INTEGER NOT NULL, `manageWithContacts` INTEGER NOT NULL, `gsmStateVisibility` INTEGER NOT NULL, `remoteAmountVisibility` INTEGER NOT NULL, `antennaAmountVisibility` INTEGER NOT NULL, `contactsAmountVisibility` INTEGER NOT NULL, `networkStateVisibility` INTEGER NOT NULL, `batteryShapeVisibility` INTEGER NOT NULL, `zone1Visibility` INTEGER NOT NULL, `zone2Visibility` INTEGER NOT NULL, `zone3Visibility` INTEGER NOT NULL, `zone4Visibility` INTEGER NOT NULL, `zone5Visibility` INTEGER NOT NULL, `relay1Visibility` INTEGER NOT NULL, `relay2Visibility` INTEGER NOT NULL, `relay1SectionVisibility` INTEGER NOT NULL, `relay2SectionVisibility` INTEGER NOT NULL, `semiActiveVisibility` INTEGER NOT NULL, `silentVisibility` INTEGER NOT NULL, `spyVisibility` INTEGER NOT NULL, `relay1ActiveBtnVisibility` INTEGER NOT NULL, `relay2ActiveBtnVisibility` INTEGER NOT NULL, `relay1TriggerBtnVisibility` INTEGER NOT NULL, `relay2TriggerBtnVisibility` INTEGER NOT NULL, `zone1Name` TEXT NOT NULL, `zone1Condition` TEXT NOT NULL, `zone1State` INTEGER NOT NULL, `zone1SemiActive` INTEGER NOT NULL, `zone2Name` TEXT NOT NULL, `zone2Condition` TEXT NOT NULL, `zone2State` INTEGER NOT NULL, `zone2SemiActive` INTEGER NOT NULL, `zone3Name` TEXT NOT NULL, `zone3Condition` TEXT NOT NULL, `zone3State` INTEGER NOT NULL, `zone3SemiActive` INTEGER NOT NULL, `zone4Name` TEXT NOT NULL, `zone4Condition` TEXT NOT NULL, `zone4State` INTEGER NOT NULL, `zone4SemiActive` INTEGER NOT NULL, `zone5Name` TEXT NOT NULL, `zone5Condition` TEXT NOT NULL, `zone5State` INTEGER NOT NULL, `zone5SemiActive` INTEGER NOT NULL, `deviceStatus1` TEXT, `inputType1` TEXT, `inputSelect1` TEXT, `actionType1` TEXT, `actionSelect1` TEXT, `scenarioName1` TEXT, `deviceStatus2` TEXT, `inputType2` TEXT, `inputSelect2` TEXT, `actionType2` TEXT, `actionSelect2` TEXT, `scenarioName2` TEXT, `deviceStatus3` TEXT, `inputType3` TEXT, `inputSelect3` TEXT, `actionType3` TEXT, `actionSelect3` TEXT, `scenarioName3` TEXT, `deviceStatus4` TEXT, `inputType4` TEXT, `inputSelect4` TEXT, `actionType4` TEXT, `actionSelect4` TEXT, `scenarioName4` TEXT, `deviceStatus5` TEXT, `inputType5` TEXT, `inputSelect5` TEXT, `actionType5` TEXT, `actionSelect5` TEXT, `scenarioName5` TEXT, `deviceStatus6` TEXT, `inputType6` TEXT, `inputSelect6` TEXT, `actionType6` TEXT, `actionSelect6` TEXT, `scenarioName6` TEXT, `deviceStatus7` TEXT, `inputType7` TEXT, `inputSelect7` TEXT, `actionType7` TEXT, `actionSelect7` TEXT, `scenarioName7` TEXT, `deviceStatus8` TEXT, `inputType8` TEXT, `inputSelect8` TEXT, `actionType8` TEXT, `actionSelect8` TEXT, `scenarioName8` TEXT, `deviceStatus9` TEXT, `inputType9` TEXT, `inputSelect9` TEXT, `actionType9` TEXT, `actionSelect9` TEXT, `scenarioName9` TEXT, `deviceStatus10` TEXT, `inputType10` TEXT, `inputSelect10` TEXT, `actionType10` TEXT, `actionSelect10` TEXT, `scenarioName10` TEXT, `contact1Phone` TEXT NOT NULL, `contact1SMS` INTEGER NOT NULL, `contact1Call` INTEGER NOT NULL, `contact1Manager` INTEGER NOT NULL, `contact2Phone` TEXT NOT NULL, `contact2SMS` INTEGER NOT NULL, `contact2Call` INTEGER NOT NULL, `contact2Manager` INTEGER NOT NULL, `contact3Phone` TEXT NOT NULL, `contact3SMS` INTEGER NOT NULL, `contact3Call` INTEGER NOT NULL, `contact3Manager` INTEGER NOT NULL, `contact4Phone` TEXT NOT NULL, `contact4SMS` INTEGER NOT NULL, `contact4Call` INTEGER NOT NULL, `contact4Manager` INTEGER NOT NULL, `contact5Phone` TEXT NOT NULL, `contact5SMS` INTEGER NOT NULL, `contact5Call` INTEGER NOT NULL, `contact5Manager` INTEGER NOT NULL, `contact6Phone` TEXT NOT NULL, `contact6SMS` INTEGER NOT NULL, `contact6Call` INTEGER NOT NULL, `contact6Manager` INTEGER NOT NULL, `contact7Phone` TEXT NOT NULL, `contact7SMS` INTEGER NOT NULL, `contact7Call` INTEGER NOT NULL, `contact7Manager` INTEGER NOT NULL, `contact8Phone` TEXT NOT NULL, `contact8SMS` INTEGER NOT NULL, `contact8Call` INTEGER NOT NULL, `contact8Manager` INTEGER NOT NULL, `contact9Phone` TEXT NOT NULL, `contact9SMS` INTEGER NOT NULL, `contact9Call` INTEGER NOT NULL, `contact9Manager` INTEGER NOT NULL, `contact10Phone` TEXT NOT NULL, `contact10SMS` INTEGER NOT NULL, `contact10Call` INTEGER NOT NULL, `contact10Manager` INTEGER NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `relay` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `device_id` INTEGER NOT NULL, `relayName` TEXT NOT NULL, `relayTriggerTime` TEXT NOT NULL, `relayState` INTEGER NOT NULL, FOREIGN KEY (`device_id`) REFERENCES `device` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `audio_notification` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `deviceId` INTEGER NOT NULL, `volume` REAL NOT NULL, `generalArmed` INTEGER NOT NULL, `generalDisarmed` INTEGER NOT NULL, `generalReportByUser` INTEGER NOT NULL, `noAccess` INTEGER NOT NULL, `powerOn` INTEGER NOT NULL, `powerOff` INTEGER NOT NULL, `sirenTriggered` INTEGER NOT NULL, `sirenTimeExpired` INTEGER NOT NULL, `chargeLow` INTEGER NOT NULL, `batteryLow` INTEGER NOT NULL, `batteryDisconnected` INTEGER NOT NULL, `sirenOff` INTEGER NOT NULL, `reportByAdmin` INTEGER NOT NULL, `deviceBackupDeleted` INTEGER NOT NULL, `generalArmedVolume` REAL NOT NULL, `generalDisarmedVolume` REAL NOT NULL, `generalReportByUserVolume` REAL NOT NULL, `noAccessVolume` REAL NOT NULL, `powerOnVolume` REAL NOT NULL, `powerOffVolume` REAL NOT NULL, `sirenTriggeredVolume` REAL NOT NULL, `sirenTimeExpiredVolume` REAL NOT NULL, `chargeLowVolume` REAL NOT NULL, `batteryLowVolume` REAL NOT NULL, `batteryDisconnectedVolume` REAL NOT NULL, `sirenOffVolume` REAL NOT NULL, `reportByAdminVolume` REAL NOT NULL, `deviceBackupDeletedVolume` REAL NOT NULL, `zone1Alert` INTEGER NOT NULL, `zone2Alert` INTEGER NOT NULL, `zone3Alert` INTEGER NOT NULL, `zone4Alert` INTEGER NOT NULL, `zone5Alert` INTEGER NOT NULL, `zone1SemiAlert` INTEGER NOT NULL, `zone2SemiAlert` INTEGER NOT NULL, `zone3SemiAlert` INTEGER NOT NULL, `zone4SemiAlert` INTEGER NOT NULL, `zone5SemiAlert` INTEGER NOT NULL, `allZonesSemiAlert` INTEGER NOT NULL, `semiActiveZones` INTEGER NOT NULL, `zone1AlertVolume` REAL NOT NULL, `zone2AlertVolume` REAL NOT NULL, `zone3AlertVolume` REAL NOT NULL, `zone4AlertVolume` REAL NOT NULL, `zone5AlertVolume` REAL NOT NULL, `zone1SemiAlertVolume` REAL NOT NULL, `zone2SemiAlertVolume` REAL NOT NULL, `zone3SemiAlertVolume` REAL NOT NULL, `zone4SemiAlertVolume` REAL NOT NULL, `zone5SemiAlertVolume` REAL NOT NULL, `allZonesSemiAlertVolume` REAL NOT NULL, `semiActiveZonesVolume` REAL NOT NULL, `zonesStatus` INTEGER NOT NULL, `relaysStatus` INTEGER NOT NULL, `connectStatus` INTEGER NOT NULL, `batteryStatus` INTEGER NOT NULL, `simStatus` INTEGER NOT NULL, `powerStatus` INTEGER NOT NULL, `deviceLossPower` INTEGER NOT NULL, `simCredit` INTEGER NOT NULL, `deviceLostConnection` INTEGER NOT NULL, `zonesStatusVolume` REAL NOT NULL, `relaysStatusVolume` REAL NOT NULL, `connectStatusVolume` REAL NOT NULL, `batteryStatusVolume` REAL NOT NULL, `simStatusVolume` REAL NOT NULL, `powerStatusVolume` REAL NOT NULL, `deviceLossPowerVolume` REAL NOT NULL, `simCreditVolume` REAL NOT NULL, `deviceLostConnectionVolume` REAL NOT NULL, `sirenEnabled` INTEGER NOT NULL, `incorrectCode` INTEGER NOT NULL, `disconnectedSensor` INTEGER NOT NULL, `adminManager` INTEGER NOT NULL, `activateRelay` INTEGER NOT NULL, `deactivateRelay` INTEGER NOT NULL, `deleteBackup` INTEGER NOT NULL, `networkLost` INTEGER NOT NULL, `deactivatedByUser` INTEGER NOT NULL, `deactivatedByAdmin` INTEGER NOT NULL, `deactivatedByTimer` INTEGER NOT NULL, `deactivatedByBackup` INTEGER NOT NULL, `silenceMode` INTEGER NOT NULL, `sirenEnabledVolume` REAL NOT NULL, `incorrectCodeVolume` REAL NOT NULL, `disconnectedSensorVolume` REAL NOT NULL, `adminManagerVolume` REAL NOT NULL, `activateRelayVolume` REAL NOT NULL, `deactivateRelayVolume` REAL NOT NULL, `deleteBackupVolume` REAL NOT NULL, `networkLostVolume` REAL NOT NULL, `deactivatedByUserVolume` REAL NOT NULL, `deactivatedByAdminVolume` REAL NOT NULL, `deactivatedByTimerVolume` REAL NOT NULL, `deactivatedByBackupVolume` REAL NOT NULL, `silenceModeVolume` REAL NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `ScheduleItem` (`id` TEXT NOT NULL, `deviceId` TEXT NOT NULL, `relayName` TEXT NOT NULL, `isActivating` INTEGER NOT NULL, `mode` INTEGER NOT NULL, `type` INTEGER NOT NULL, `timeHour` INTEGER NOT NULL, `timeMinute` INTEGER NOT NULL, `date` INTEGER, `weekday` INTEGER, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `smart_control` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `deviceId` INTEGER NOT NULL, `controlType` TEXT NOT NULL, `speakerEnabled` INTEGER NOT NULL, `remoteCodeEnabled` INTEGER NOT NULL, `remoteEnabled` INTEGER NOT NULL, `relay1Enabled` INTEGER NOT NULL, `relay2Enabled` INTEGER NOT NULL, `relay3Enabled` INTEGER NOT NULL, `scenarioEnabled` INTEGER NOT NULL, `activeMode` TEXT NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `ZonesTable` (`id` INTEGER NOT NULL, `deviceId` INTEGER NOT NULL, `zonesJson` TEXT NOT NULL, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Scenario` (`id` INTEGER NOT NULL, `deviceId` INTEGER NOT NULL, `scenarioText1` TEXT NOT NULL, `scenarioText2` TEXT NOT NULL, `scenarioText3` TEXT NOT NULL, `scenarioText4` TEXT NOT NULL, `scenarioText5` TEXT NOT NULL, `scenarioText6` TEXT NOT NULL, `scenarioText7` TEXT NOT NULL, `scenarioText8` TEXT NOT NULL, `scenarioText9` TEXT NOT NULL, `scenarioText10` TEXT NOT NULL, `smsFormat` TEXT NOT NULL, `modeFormat` TEXT NOT NULL, PRIMARY KEY (`id`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  AppSettingsDAO get appSettingsDao {
    return _appSettingsDaoInstance ??=
        _$AppSettingsDAO(database, changeListener);
  }

  @override
  DeviceDAO get deviceDao {
    return _deviceDaoInstance ??= _$DeviceDAO(database, changeListener);
  }

  @override
  RelayDAO get relayDao {
    return _relayDaoInstance ??= _$RelayDAO(database, changeListener);
  }

  @override
  AudioNotificationDAO get audioNotificationDao {
    return _audioNotificationDaoInstance ??=
        _$AudioNotificationDAO(database, changeListener);
  }

  @override
  ScheduleDAO get scheduleDao {
    return _scheduleDaoInstance ??= _$ScheduleDAO(database, changeListener);
  }

  @override
  SmartControlDAO get smartControlDao {
    return _smartControlDaoInstance ??=
        _$SmartControlDAO(database, changeListener);
  }

  @override
  ZonesDao get zonesDao {
    return _zonesDaoInstance ??= _$ZonesDao(database, changeListener);
  }

  @override
  ScenarioDAO get scenarioDao {
    return _scenarioDaoInstance ??= _$ScenarioDAO(database, changeListener);
  }
}

class _$AppSettingsDAO extends AppSettingsDAO {
  _$AppSettingsDAO(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _appSettingsInsertionAdapter = InsertionAdapter(
            database,
            'app_settings',
            (AppSettings item) => <String, Object?>{
                  'id': item.id,
                  'appPassword': item.appPassword,
                  'appVersion': item.appVersion,
                  'showPassPage': item.showPassPage ? 1 : 0,
                  'selectedDeviceIndex': item.selectedDeviceIndex,
                  'selectedThemePalette': item.selectedThemePalette
                }),
        _appSettingsUpdateAdapter = UpdateAdapter(
            database,
            'app_settings',
            ['id'],
            (AppSettings item) => <String, Object?>{
                  'id': item.id,
                  'appPassword': item.appPassword,
                  'appVersion': item.appVersion,
                  'showPassPage': item.showPassPage ? 1 : 0,
                  'selectedDeviceIndex': item.selectedDeviceIndex,
                  'selectedThemePalette': item.selectedThemePalette
                }),
        _appSettingsDeletionAdapter = DeletionAdapter(
            database,
            'app_settings',
            ['id'],
            (AppSettings item) => <String, Object?>{
                  'id': item.id,
                  'appPassword': item.appPassword,
                  'appVersion': item.appVersion,
                  'showPassPage': item.showPassPage ? 1 : 0,
                  'selectedDeviceIndex': item.selectedDeviceIndex,
                  'selectedThemePalette': item.selectedThemePalette
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<AppSettings> _appSettingsInsertionAdapter;

  final UpdateAdapter<AppSettings> _appSettingsUpdateAdapter;

  final DeletionAdapter<AppSettings> _appSettingsDeletionAdapter;

  @override
  Future<AppSettings?> getAppSettings() async {
    return _queryAdapter.query('SELECT * FROM app_settings WHERE id = 1',
        mapper: (Map<String, Object?> row) => AppSettings(
            id: row['id'] as int,
            appPassword: row['appPassword'] as String,
            appVersion: row['appVersion'] as String,
            showPassPage: (row['showPassPage'] as int) != 0,
            selectedDeviceIndex: row['selectedDeviceIndex'] as int,
            selectedThemePalette: row['selectedThemePalette'] as int));
  }

  @override
  Future<void> insertAppSettings(AppSettings appSettings) async {
    await _appSettingsInsertionAdapter.insert(
        appSettings, OnConflictStrategy.replace);
  }

  @override
  Future<void> updateAppSettings(AppSettings appSettings) async {
    await _appSettingsUpdateAdapter.update(
        appSettings, OnConflictStrategy.replace);
  }

  @override
  Future<void> deleteAppSettings(AppSettings appSettings) async {
    await _appSettingsDeletionAdapter.delete(appSettings);
  }
}

class _$DeviceDAO extends DeviceDAO {
  _$DeviceDAO(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _deviceInsertionAdapter = InsertionAdapter(
            database,
            'device',
            (Device item) => <String, Object?>{
                  'id': item.id,
                  'deviceName': item.deviceName,
                  'devicePassword': item.devicePassword,
                  'devicePhone': item.devicePhone,
                  'deviceModel': item.deviceModel,
                  'deviceState': item.deviceState,
                  'isManager': item.isManager ? 1 : 0,
                  'alarmTime': item.alarmTime,
                  'remoteAmount': item.remoteAmount,
                  'simChargeAmount': item.simChargeAmount,
                  'antennaAmount': item.antennaAmount,
                  'batteryAmount': item.batteryAmount,
                  'cityPowerState': item.cityPowerState ? 1 : 0,
                  'gsmState': item.gsmState ? 1 : 0,
                  'speakerState': item.speakerState ? 1 : 0,
                  'networkState': item.networkState ? 1 : 0,
                  'capsulMax': item.capsulMax,
                  'capsulMin': item.capsulMin,
                  'totalContactsAmount': item.totalContactsAmount,
                  'spyAmount': item.spyAmount,
                  'chargePeriodictReport': item.chargePeriodictReport,
                  'batteryPeriodictReport': item.batteryPeriodictReport,
                  'callOrder': item.callOrder,
                  'alarmDuration': item.alarmDuration,
                  'callDuration': item.callDuration,
                  'controlRelaysWithRemote':
                      item.controlRelaysWithRemote ? 1 : 0,
                  'monitoring': item.monitoring ? 1 : 0,
                  'remoteReporting': item.remoteReporting ? 1 : 0,
                  'scenarioReporting': item.scenarioReporting ? 1 : 0,
                  'callPriority': item.callPriority ? 1 : 0,
                  'smsPriority': item.smsPriority ? 1 : 0,
                  'operator': item.operator,
                  'deviceLang': item.deviceLang,
                  'deviceSimLang': item.deviceSimLang,
                  'silentOnSiren': item.silentOnSiren ? 1 : 0,
                  'relayOnDingDong': item.relayOnDingDong ? 1 : 0,
                  'callOnPowerLoss': item.callOnPowerLoss ? 1 : 0,
                  'manageWithContacts': item.manageWithContacts ? 1 : 0,
                  'gsmStateVisibility': item.gsmStateVisibility ? 1 : 0,
                  'remoteAmountVisibility': item.remoteAmountVisibility ? 1 : 0,
                  'antennaAmountVisibility':
                      item.antennaAmountVisibility ? 1 : 0,
                  'contactsAmountVisibility':
                      item.contactsAmountVisibility ? 1 : 0,
                  'networkStateVisibility': item.networkStateVisibility ? 1 : 0,
                  'batteryShapeVisibility': item.batteryShapeVisibility ? 1 : 0,
                  'zone1Visibility': item.zone1Visibility ? 1 : 0,
                  'zone2Visibility': item.zone2Visibility ? 1 : 0,
                  'zone3Visibility': item.zone3Visibility ? 1 : 0,
                  'zone4Visibility': item.zone4Visibility ? 1 : 0,
                  'zone5Visibility': item.zone5Visibility ? 1 : 0,
                  'relay1Visibility': item.relay1Visibility ? 1 : 0,
                  'relay2Visibility': item.relay2Visibility ? 1 : 0,
                  'relay1SectionVisibility':
                      item.relay1SectionVisibility ? 1 : 0,
                  'relay2SectionVisibility':
                      item.relay2SectionVisibility ? 1 : 0,
                  'semiActiveVisibility': item.semiActiveVisibility ? 1 : 0,
                  'silentVisibility': item.silentVisibility ? 1 : 0,
                  'spyVisibility': item.spyVisibility ? 1 : 0,
                  'relay1ActiveBtnVisibility':
                      item.relay1ActiveBtnVisibility ? 1 : 0,
                  'relay2ActiveBtnVisibility':
                      item.relay2ActiveBtnVisibility ? 1 : 0,
                  'relay1TriggerBtnVisibility':
                      item.relay1TriggerBtnVisibility ? 1 : 0,
                  'relay2TriggerBtnVisibility':
                      item.relay2TriggerBtnVisibility ? 1 : 0,
                  'zone1Name': item.zone1Name,
                  'zone1Condition': item.zone1Condition,
                  'zone1State': item.zone1State ? 1 : 0,
                  'zone1SemiActive': item.zone1SemiActive ? 1 : 0,
                  'zone2Name': item.zone2Name,
                  'zone2Condition': item.zone2Condition,
                  'zone2State': item.zone2State ? 1 : 0,
                  'zone2SemiActive': item.zone2SemiActive ? 1 : 0,
                  'zone3Name': item.zone3Name,
                  'zone3Condition': item.zone3Condition,
                  'zone3State': item.zone3State ? 1 : 0,
                  'zone3SemiActive': item.zone3SemiActive ? 1 : 0,
                  'zone4Name': item.zone4Name,
                  'zone4Condition': item.zone4Condition,
                  'zone4State': item.zone4State ? 1 : 0,
                  'zone4SemiActive': item.zone4SemiActive ? 1 : 0,
                  'zone5Name': item.zone5Name,
                  'zone5Condition': item.zone5Condition,
                  'zone5State': item.zone5State ? 1 : 0,
                  'zone5SemiActive': item.zone5SemiActive ? 1 : 0,
                  'deviceStatus1': item.deviceStatus1,
                  'inputType1': item.inputType1,
                  'inputSelect1': item.inputSelect1,
                  'actionType1': item.actionType1,
                  'actionSelect1': item.actionSelect1,
                  'scenarioName1': item.scenarioName1,
                  'deviceStatus2': item.deviceStatus2,
                  'inputType2': item.inputType2,
                  'inputSelect2': item.inputSelect2,
                  'actionType2': item.actionType2,
                  'actionSelect2': item.actionSelect2,
                  'scenarioName2': item.scenarioName2,
                  'deviceStatus3': item.deviceStatus3,
                  'inputType3': item.inputType3,
                  'inputSelect3': item.inputSelect3,
                  'actionType3': item.actionType3,
                  'actionSelect3': item.actionSelect3,
                  'scenarioName3': item.scenarioName3,
                  'deviceStatus4': item.deviceStatus4,
                  'inputType4': item.inputType4,
                  'inputSelect4': item.inputSelect4,
                  'actionType4': item.actionType4,
                  'actionSelect4': item.actionSelect4,
                  'scenarioName4': item.scenarioName4,
                  'deviceStatus5': item.deviceStatus5,
                  'inputType5': item.inputType5,
                  'inputSelect5': item.inputSelect5,
                  'actionType5': item.actionType5,
                  'actionSelect5': item.actionSelect5,
                  'scenarioName5': item.scenarioName5,
                  'deviceStatus6': item.deviceStatus6,
                  'inputType6': item.inputType6,
                  'inputSelect6': item.inputSelect6,
                  'actionType6': item.actionType6,
                  'actionSelect6': item.actionSelect6,
                  'scenarioName6': item.scenarioName6,
                  'deviceStatus7': item.deviceStatus7,
                  'inputType7': item.inputType7,
                  'inputSelect7': item.inputSelect7,
                  'actionType7': item.actionType7,
                  'actionSelect7': item.actionSelect7,
                  'scenarioName7': item.scenarioName7,
                  'deviceStatus8': item.deviceStatus8,
                  'inputType8': item.inputType8,
                  'inputSelect8': item.inputSelect8,
                  'actionType8': item.actionType8,
                  'actionSelect8': item.actionSelect8,
                  'scenarioName8': item.scenarioName8,
                  'deviceStatus9': item.deviceStatus9,
                  'inputType9': item.inputType9,
                  'inputSelect9': item.inputSelect9,
                  'actionType9': item.actionType9,
                  'actionSelect9': item.actionSelect9,
                  'scenarioName9': item.scenarioName9,
                  'deviceStatus10': item.deviceStatus10,
                  'inputType10': item.inputType10,
                  'inputSelect10': item.inputSelect10,
                  'actionType10': item.actionType10,
                  'actionSelect10': item.actionSelect10,
                  'scenarioName10': item.scenarioName10,
                  'contact1Phone': item.contact1Phone,
                  'contact1SMS': item.contact1SMS ? 1 : 0,
                  'contact1Call': item.contact1Call ? 1 : 0,
                  'contact1Manager': item.contact1Manager ? 1 : 0,
                  'contact2Phone': item.contact2Phone,
                  'contact2SMS': item.contact2SMS ? 1 : 0,
                  'contact2Call': item.contact2Call ? 1 : 0,
                  'contact2Manager': item.contact2Manager ? 1 : 0,
                  'contact3Phone': item.contact3Phone,
                  'contact3SMS': item.contact3SMS ? 1 : 0,
                  'contact3Call': item.contact3Call ? 1 : 0,
                  'contact3Manager': item.contact3Manager ? 1 : 0,
                  'contact4Phone': item.contact4Phone,
                  'contact4SMS': item.contact4SMS ? 1 : 0,
                  'contact4Call': item.contact4Call ? 1 : 0,
                  'contact4Manager': item.contact4Manager ? 1 : 0,
                  'contact5Phone': item.contact5Phone,
                  'contact5SMS': item.contact5SMS ? 1 : 0,
                  'contact5Call': item.contact5Call ? 1 : 0,
                  'contact5Manager': item.contact5Manager ? 1 : 0,
                  'contact6Phone': item.contact6Phone,
                  'contact6SMS': item.contact6SMS ? 1 : 0,
                  'contact6Call': item.contact6Call ? 1 : 0,
                  'contact6Manager': item.contact6Manager ? 1 : 0,
                  'contact7Phone': item.contact7Phone,
                  'contact7SMS': item.contact7SMS ? 1 : 0,
                  'contact7Call': item.contact7Call ? 1 : 0,
                  'contact7Manager': item.contact7Manager ? 1 : 0,
                  'contact8Phone': item.contact8Phone,
                  'contact8SMS': item.contact8SMS ? 1 : 0,
                  'contact8Call': item.contact8Call ? 1 : 0,
                  'contact8Manager': item.contact8Manager ? 1 : 0,
                  'contact9Phone': item.contact9Phone,
                  'contact9SMS': item.contact9SMS ? 1 : 0,
                  'contact9Call': item.contact9Call ? 1 : 0,
                  'contact9Manager': item.contact9Manager ? 1 : 0,
                  'contact10Phone': item.contact10Phone,
                  'contact10SMS': item.contact10SMS ? 1 : 0,
                  'contact10Call': item.contact10Call ? 1 : 0,
                  'contact10Manager': item.contact10Manager ? 1 : 0
                }),
        _deviceUpdateAdapter = UpdateAdapter(
            database,
            'device',
            ['id'],
            (Device item) => <String, Object?>{
                  'id': item.id,
                  'deviceName': item.deviceName,
                  'devicePassword': item.devicePassword,
                  'devicePhone': item.devicePhone,
                  'deviceModel': item.deviceModel,
                  'deviceState': item.deviceState,
                  'isManager': item.isManager ? 1 : 0,
                  'alarmTime': item.alarmTime,
                  'remoteAmount': item.remoteAmount,
                  'simChargeAmount': item.simChargeAmount,
                  'antennaAmount': item.antennaAmount,
                  'batteryAmount': item.batteryAmount,
                  'cityPowerState': item.cityPowerState ? 1 : 0,
                  'gsmState': item.gsmState ? 1 : 0,
                  'speakerState': item.speakerState ? 1 : 0,
                  'networkState': item.networkState ? 1 : 0,
                  'capsulMax': item.capsulMax,
                  'capsulMin': item.capsulMin,
                  'totalContactsAmount': item.totalContactsAmount,
                  'spyAmount': item.spyAmount,
                  'chargePeriodictReport': item.chargePeriodictReport,
                  'batteryPeriodictReport': item.batteryPeriodictReport,
                  'callOrder': item.callOrder,
                  'alarmDuration': item.alarmDuration,
                  'callDuration': item.callDuration,
                  'controlRelaysWithRemote':
                      item.controlRelaysWithRemote ? 1 : 0,
                  'monitoring': item.monitoring ? 1 : 0,
                  'remoteReporting': item.remoteReporting ? 1 : 0,
                  'scenarioReporting': item.scenarioReporting ? 1 : 0,
                  'callPriority': item.callPriority ? 1 : 0,
                  'smsPriority': item.smsPriority ? 1 : 0,
                  'operator': item.operator,
                  'deviceLang': item.deviceLang,
                  'deviceSimLang': item.deviceSimLang,
                  'silentOnSiren': item.silentOnSiren ? 1 : 0,
                  'relayOnDingDong': item.relayOnDingDong ? 1 : 0,
                  'callOnPowerLoss': item.callOnPowerLoss ? 1 : 0,
                  'manageWithContacts': item.manageWithContacts ? 1 : 0,
                  'gsmStateVisibility': item.gsmStateVisibility ? 1 : 0,
                  'remoteAmountVisibility': item.remoteAmountVisibility ? 1 : 0,
                  'antennaAmountVisibility':
                      item.antennaAmountVisibility ? 1 : 0,
                  'contactsAmountVisibility':
                      item.contactsAmountVisibility ? 1 : 0,
                  'networkStateVisibility': item.networkStateVisibility ? 1 : 0,
                  'batteryShapeVisibility': item.batteryShapeVisibility ? 1 : 0,
                  'zone1Visibility': item.zone1Visibility ? 1 : 0,
                  'zone2Visibility': item.zone2Visibility ? 1 : 0,
                  'zone3Visibility': item.zone3Visibility ? 1 : 0,
                  'zone4Visibility': item.zone4Visibility ? 1 : 0,
                  'zone5Visibility': item.zone5Visibility ? 1 : 0,
                  'relay1Visibility': item.relay1Visibility ? 1 : 0,
                  'relay2Visibility': item.relay2Visibility ? 1 : 0,
                  'relay1SectionVisibility':
                      item.relay1SectionVisibility ? 1 : 0,
                  'relay2SectionVisibility':
                      item.relay2SectionVisibility ? 1 : 0,
                  'semiActiveVisibility': item.semiActiveVisibility ? 1 : 0,
                  'silentVisibility': item.silentVisibility ? 1 : 0,
                  'spyVisibility': item.spyVisibility ? 1 : 0,
                  'relay1ActiveBtnVisibility':
                      item.relay1ActiveBtnVisibility ? 1 : 0,
                  'relay2ActiveBtnVisibility':
                      item.relay2ActiveBtnVisibility ? 1 : 0,
                  'relay1TriggerBtnVisibility':
                      item.relay1TriggerBtnVisibility ? 1 : 0,
                  'relay2TriggerBtnVisibility':
                      item.relay2TriggerBtnVisibility ? 1 : 0,
                  'zone1Name': item.zone1Name,
                  'zone1Condition': item.zone1Condition,
                  'zone1State': item.zone1State ? 1 : 0,
                  'zone1SemiActive': item.zone1SemiActive ? 1 : 0,
                  'zone2Name': item.zone2Name,
                  'zone2Condition': item.zone2Condition,
                  'zone2State': item.zone2State ? 1 : 0,
                  'zone2SemiActive': item.zone2SemiActive ? 1 : 0,
                  'zone3Name': item.zone3Name,
                  'zone3Condition': item.zone3Condition,
                  'zone3State': item.zone3State ? 1 : 0,
                  'zone3SemiActive': item.zone3SemiActive ? 1 : 0,
                  'zone4Name': item.zone4Name,
                  'zone4Condition': item.zone4Condition,
                  'zone4State': item.zone4State ? 1 : 0,
                  'zone4SemiActive': item.zone4SemiActive ? 1 : 0,
                  'zone5Name': item.zone5Name,
                  'zone5Condition': item.zone5Condition,
                  'zone5State': item.zone5State ? 1 : 0,
                  'zone5SemiActive': item.zone5SemiActive ? 1 : 0,
                  'deviceStatus1': item.deviceStatus1,
                  'inputType1': item.inputType1,
                  'inputSelect1': item.inputSelect1,
                  'actionType1': item.actionType1,
                  'actionSelect1': item.actionSelect1,
                  'scenarioName1': item.scenarioName1,
                  'deviceStatus2': item.deviceStatus2,
                  'inputType2': item.inputType2,
                  'inputSelect2': item.inputSelect2,
                  'actionType2': item.actionType2,
                  'actionSelect2': item.actionSelect2,
                  'scenarioName2': item.scenarioName2,
                  'deviceStatus3': item.deviceStatus3,
                  'inputType3': item.inputType3,
                  'inputSelect3': item.inputSelect3,
                  'actionType3': item.actionType3,
                  'actionSelect3': item.actionSelect3,
                  'scenarioName3': item.scenarioName3,
                  'deviceStatus4': item.deviceStatus4,
                  'inputType4': item.inputType4,
                  'inputSelect4': item.inputSelect4,
                  'actionType4': item.actionType4,
                  'actionSelect4': item.actionSelect4,
                  'scenarioName4': item.scenarioName4,
                  'deviceStatus5': item.deviceStatus5,
                  'inputType5': item.inputType5,
                  'inputSelect5': item.inputSelect5,
                  'actionType5': item.actionType5,
                  'actionSelect5': item.actionSelect5,
                  'scenarioName5': item.scenarioName5,
                  'deviceStatus6': item.deviceStatus6,
                  'inputType6': item.inputType6,
                  'inputSelect6': item.inputSelect6,
                  'actionType6': item.actionType6,
                  'actionSelect6': item.actionSelect6,
                  'scenarioName6': item.scenarioName6,
                  'deviceStatus7': item.deviceStatus7,
                  'inputType7': item.inputType7,
                  'inputSelect7': item.inputSelect7,
                  'actionType7': item.actionType7,
                  'actionSelect7': item.actionSelect7,
                  'scenarioName7': item.scenarioName7,
                  'deviceStatus8': item.deviceStatus8,
                  'inputType8': item.inputType8,
                  'inputSelect8': item.inputSelect8,
                  'actionType8': item.actionType8,
                  'actionSelect8': item.actionSelect8,
                  'scenarioName8': item.scenarioName8,
                  'deviceStatus9': item.deviceStatus9,
                  'inputType9': item.inputType9,
                  'inputSelect9': item.inputSelect9,
                  'actionType9': item.actionType9,
                  'actionSelect9': item.actionSelect9,
                  'scenarioName9': item.scenarioName9,
                  'deviceStatus10': item.deviceStatus10,
                  'inputType10': item.inputType10,
                  'inputSelect10': item.inputSelect10,
                  'actionType10': item.actionType10,
                  'actionSelect10': item.actionSelect10,
                  'scenarioName10': item.scenarioName10,
                  'contact1Phone': item.contact1Phone,
                  'contact1SMS': item.contact1SMS ? 1 : 0,
                  'contact1Call': item.contact1Call ? 1 : 0,
                  'contact1Manager': item.contact1Manager ? 1 : 0,
                  'contact2Phone': item.contact2Phone,
                  'contact2SMS': item.contact2SMS ? 1 : 0,
                  'contact2Call': item.contact2Call ? 1 : 0,
                  'contact2Manager': item.contact2Manager ? 1 : 0,
                  'contact3Phone': item.contact3Phone,
                  'contact3SMS': item.contact3SMS ? 1 : 0,
                  'contact3Call': item.contact3Call ? 1 : 0,
                  'contact3Manager': item.contact3Manager ? 1 : 0,
                  'contact4Phone': item.contact4Phone,
                  'contact4SMS': item.contact4SMS ? 1 : 0,
                  'contact4Call': item.contact4Call ? 1 : 0,
                  'contact4Manager': item.contact4Manager ? 1 : 0,
                  'contact5Phone': item.contact5Phone,
                  'contact5SMS': item.contact5SMS ? 1 : 0,
                  'contact5Call': item.contact5Call ? 1 : 0,
                  'contact5Manager': item.contact5Manager ? 1 : 0,
                  'contact6Phone': item.contact6Phone,
                  'contact6SMS': item.contact6SMS ? 1 : 0,
                  'contact6Call': item.contact6Call ? 1 : 0,
                  'contact6Manager': item.contact6Manager ? 1 : 0,
                  'contact7Phone': item.contact7Phone,
                  'contact7SMS': item.contact7SMS ? 1 : 0,
                  'contact7Call': item.contact7Call ? 1 : 0,
                  'contact7Manager': item.contact7Manager ? 1 : 0,
                  'contact8Phone': item.contact8Phone,
                  'contact8SMS': item.contact8SMS ? 1 : 0,
                  'contact8Call': item.contact8Call ? 1 : 0,
                  'contact8Manager': item.contact8Manager ? 1 : 0,
                  'contact9Phone': item.contact9Phone,
                  'contact9SMS': item.contact9SMS ? 1 : 0,
                  'contact9Call': item.contact9Call ? 1 : 0,
                  'contact9Manager': item.contact9Manager ? 1 : 0,
                  'contact10Phone': item.contact10Phone,
                  'contact10SMS': item.contact10SMS ? 1 : 0,
                  'contact10Call': item.contact10Call ? 1 : 0,
                  'contact10Manager': item.contact10Manager ? 1 : 0
                }),
        _deviceDeletionAdapter = DeletionAdapter(
            database,
            'device',
            ['id'],
            (Device item) => <String, Object?>{
                  'id': item.id,
                  'deviceName': item.deviceName,
                  'devicePassword': item.devicePassword,
                  'devicePhone': item.devicePhone,
                  'deviceModel': item.deviceModel,
                  'deviceState': item.deviceState,
                  'isManager': item.isManager ? 1 : 0,
                  'alarmTime': item.alarmTime,
                  'remoteAmount': item.remoteAmount,
                  'simChargeAmount': item.simChargeAmount,
                  'antennaAmount': item.antennaAmount,
                  'batteryAmount': item.batteryAmount,
                  'cityPowerState': item.cityPowerState ? 1 : 0,
                  'gsmState': item.gsmState ? 1 : 0,
                  'speakerState': item.speakerState ? 1 : 0,
                  'networkState': item.networkState ? 1 : 0,
                  'capsulMax': item.capsulMax,
                  'capsulMin': item.capsulMin,
                  'totalContactsAmount': item.totalContactsAmount,
                  'spyAmount': item.spyAmount,
                  'chargePeriodictReport': item.chargePeriodictReport,
                  'batteryPeriodictReport': item.batteryPeriodictReport,
                  'callOrder': item.callOrder,
                  'alarmDuration': item.alarmDuration,
                  'callDuration': item.callDuration,
                  'controlRelaysWithRemote':
                      item.controlRelaysWithRemote ? 1 : 0,
                  'monitoring': item.monitoring ? 1 : 0,
                  'remoteReporting': item.remoteReporting ? 1 : 0,
                  'scenarioReporting': item.scenarioReporting ? 1 : 0,
                  'callPriority': item.callPriority ? 1 : 0,
                  'smsPriority': item.smsPriority ? 1 : 0,
                  'operator': item.operator,
                  'deviceLang': item.deviceLang,
                  'deviceSimLang': item.deviceSimLang,
                  'silentOnSiren': item.silentOnSiren ? 1 : 0,
                  'relayOnDingDong': item.relayOnDingDong ? 1 : 0,
                  'callOnPowerLoss': item.callOnPowerLoss ? 1 : 0,
                  'manageWithContacts': item.manageWithContacts ? 1 : 0,
                  'gsmStateVisibility': item.gsmStateVisibility ? 1 : 0,
                  'remoteAmountVisibility': item.remoteAmountVisibility ? 1 : 0,
                  'antennaAmountVisibility':
                      item.antennaAmountVisibility ? 1 : 0,
                  'contactsAmountVisibility':
                      item.contactsAmountVisibility ? 1 : 0,
                  'networkStateVisibility': item.networkStateVisibility ? 1 : 0,
                  'batteryShapeVisibility': item.batteryShapeVisibility ? 1 : 0,
                  'zone1Visibility': item.zone1Visibility ? 1 : 0,
                  'zone2Visibility': item.zone2Visibility ? 1 : 0,
                  'zone3Visibility': item.zone3Visibility ? 1 : 0,
                  'zone4Visibility': item.zone4Visibility ? 1 : 0,
                  'zone5Visibility': item.zone5Visibility ? 1 : 0,
                  'relay1Visibility': item.relay1Visibility ? 1 : 0,
                  'relay2Visibility': item.relay2Visibility ? 1 : 0,
                  'relay1SectionVisibility':
                      item.relay1SectionVisibility ? 1 : 0,
                  'relay2SectionVisibility':
                      item.relay2SectionVisibility ? 1 : 0,
                  'semiActiveVisibility': item.semiActiveVisibility ? 1 : 0,
                  'silentVisibility': item.silentVisibility ? 1 : 0,
                  'spyVisibility': item.spyVisibility ? 1 : 0,
                  'relay1ActiveBtnVisibility':
                      item.relay1ActiveBtnVisibility ? 1 : 0,
                  'relay2ActiveBtnVisibility':
                      item.relay2ActiveBtnVisibility ? 1 : 0,
                  'relay1TriggerBtnVisibility':
                      item.relay1TriggerBtnVisibility ? 1 : 0,
                  'relay2TriggerBtnVisibility':
                      item.relay2TriggerBtnVisibility ? 1 : 0,
                  'zone1Name': item.zone1Name,
                  'zone1Condition': item.zone1Condition,
                  'zone1State': item.zone1State ? 1 : 0,
                  'zone1SemiActive': item.zone1SemiActive ? 1 : 0,
                  'zone2Name': item.zone2Name,
                  'zone2Condition': item.zone2Condition,
                  'zone2State': item.zone2State ? 1 : 0,
                  'zone2SemiActive': item.zone2SemiActive ? 1 : 0,
                  'zone3Name': item.zone3Name,
                  'zone3Condition': item.zone3Condition,
                  'zone3State': item.zone3State ? 1 : 0,
                  'zone3SemiActive': item.zone3SemiActive ? 1 : 0,
                  'zone4Name': item.zone4Name,
                  'zone4Condition': item.zone4Condition,
                  'zone4State': item.zone4State ? 1 : 0,
                  'zone4SemiActive': item.zone4SemiActive ? 1 : 0,
                  'zone5Name': item.zone5Name,
                  'zone5Condition': item.zone5Condition,
                  'zone5State': item.zone5State ? 1 : 0,
                  'zone5SemiActive': item.zone5SemiActive ? 1 : 0,
                  'deviceStatus1': item.deviceStatus1,
                  'inputType1': item.inputType1,
                  'inputSelect1': item.inputSelect1,
                  'actionType1': item.actionType1,
                  'actionSelect1': item.actionSelect1,
                  'scenarioName1': item.scenarioName1,
                  'deviceStatus2': item.deviceStatus2,
                  'inputType2': item.inputType2,
                  'inputSelect2': item.inputSelect2,
                  'actionType2': item.actionType2,
                  'actionSelect2': item.actionSelect2,
                  'scenarioName2': item.scenarioName2,
                  'deviceStatus3': item.deviceStatus3,
                  'inputType3': item.inputType3,
                  'inputSelect3': item.inputSelect3,
                  'actionType3': item.actionType3,
                  'actionSelect3': item.actionSelect3,
                  'scenarioName3': item.scenarioName3,
                  'deviceStatus4': item.deviceStatus4,
                  'inputType4': item.inputType4,
                  'inputSelect4': item.inputSelect4,
                  'actionType4': item.actionType4,
                  'actionSelect4': item.actionSelect4,
                  'scenarioName4': item.scenarioName4,
                  'deviceStatus5': item.deviceStatus5,
                  'inputType5': item.inputType5,
                  'inputSelect5': item.inputSelect5,
                  'actionType5': item.actionType5,
                  'actionSelect5': item.actionSelect5,
                  'scenarioName5': item.scenarioName5,
                  'deviceStatus6': item.deviceStatus6,
                  'inputType6': item.inputType6,
                  'inputSelect6': item.inputSelect6,
                  'actionType6': item.actionType6,
                  'actionSelect6': item.actionSelect6,
                  'scenarioName6': item.scenarioName6,
                  'deviceStatus7': item.deviceStatus7,
                  'inputType7': item.inputType7,
                  'inputSelect7': item.inputSelect7,
                  'actionType7': item.actionType7,
                  'actionSelect7': item.actionSelect7,
                  'scenarioName7': item.scenarioName7,
                  'deviceStatus8': item.deviceStatus8,
                  'inputType8': item.inputType8,
                  'inputSelect8': item.inputSelect8,
                  'actionType8': item.actionType8,
                  'actionSelect8': item.actionSelect8,
                  'scenarioName8': item.scenarioName8,
                  'deviceStatus9': item.deviceStatus9,
                  'inputType9': item.inputType9,
                  'inputSelect9': item.inputSelect9,
                  'actionType9': item.actionType9,
                  'actionSelect9': item.actionSelect9,
                  'scenarioName9': item.scenarioName9,
                  'deviceStatus10': item.deviceStatus10,
                  'inputType10': item.inputType10,
                  'inputSelect10': item.inputSelect10,
                  'actionType10': item.actionType10,
                  'actionSelect10': item.actionSelect10,
                  'scenarioName10': item.scenarioName10,
                  'contact1Phone': item.contact1Phone,
                  'contact1SMS': item.contact1SMS ? 1 : 0,
                  'contact1Call': item.contact1Call ? 1 : 0,
                  'contact1Manager': item.contact1Manager ? 1 : 0,
                  'contact2Phone': item.contact2Phone,
                  'contact2SMS': item.contact2SMS ? 1 : 0,
                  'contact2Call': item.contact2Call ? 1 : 0,
                  'contact2Manager': item.contact2Manager ? 1 : 0,
                  'contact3Phone': item.contact3Phone,
                  'contact3SMS': item.contact3SMS ? 1 : 0,
                  'contact3Call': item.contact3Call ? 1 : 0,
                  'contact3Manager': item.contact3Manager ? 1 : 0,
                  'contact4Phone': item.contact4Phone,
                  'contact4SMS': item.contact4SMS ? 1 : 0,
                  'contact4Call': item.contact4Call ? 1 : 0,
                  'contact4Manager': item.contact4Manager ? 1 : 0,
                  'contact5Phone': item.contact5Phone,
                  'contact5SMS': item.contact5SMS ? 1 : 0,
                  'contact5Call': item.contact5Call ? 1 : 0,
                  'contact5Manager': item.contact5Manager ? 1 : 0,
                  'contact6Phone': item.contact6Phone,
                  'contact6SMS': item.contact6SMS ? 1 : 0,
                  'contact6Call': item.contact6Call ? 1 : 0,
                  'contact6Manager': item.contact6Manager ? 1 : 0,
                  'contact7Phone': item.contact7Phone,
                  'contact7SMS': item.contact7SMS ? 1 : 0,
                  'contact7Call': item.contact7Call ? 1 : 0,
                  'contact7Manager': item.contact7Manager ? 1 : 0,
                  'contact8Phone': item.contact8Phone,
                  'contact8SMS': item.contact8SMS ? 1 : 0,
                  'contact8Call': item.contact8Call ? 1 : 0,
                  'contact8Manager': item.contact8Manager ? 1 : 0,
                  'contact9Phone': item.contact9Phone,
                  'contact9SMS': item.contact9SMS ? 1 : 0,
                  'contact9Call': item.contact9Call ? 1 : 0,
                  'contact9Manager': item.contact9Manager ? 1 : 0,
                  'contact10Phone': item.contact10Phone,
                  'contact10SMS': item.contact10SMS ? 1 : 0,
                  'contact10Call': item.contact10Call ? 1 : 0,
                  'contact10Manager': item.contact10Manager ? 1 : 0
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Device> _deviceInsertionAdapter;

  final UpdateAdapter<Device> _deviceUpdateAdapter;

  final DeletionAdapter<Device> _deviceDeletionAdapter;

  @override
  Future<Device?> getDevice(int id) async {
    return _queryAdapter.query('SELECT * FROM device WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Device(
            id: row['id'] as int?,
            deviceName: row['deviceName'] as String,
            devicePassword: row['devicePassword'] as String,
            devicePhone: row['devicePhone'] as String,
            deviceModel: row['deviceModel'] as String,
            deviceState: row['deviceState'] as String,
            isManager: (row['isManager'] as int) != 0,
            alarmTime: row['alarmTime'] as String,
            remoteAmount: row['remoteAmount'] as int,
            simChargeAmount: row['simChargeAmount'] as int,
            antennaAmount: row['antennaAmount'] as int,
            batteryAmount: row['batteryAmount'] as int,
            cityPowerState: (row['cityPowerState'] as int) != 0,
            gsmState: (row['gsmState'] as int) != 0,
            speakerState: (row['speakerState'] as int) != 0,
            networkState: (row['networkState'] as int) != 0,
            capsulMax: row['capsulMax'] as int,
            capsulMin: row['capsulMin'] as int,
            totalContactsAmount: row['totalContactsAmount'] as int,
            spyAmount: row['spyAmount'] as int,
            chargePeriodictReport: row['chargePeriodictReport'] as int,
            batteryPeriodictReport: row['batteryPeriodictReport'] as int,
            callOrder: row['callOrder'] as int,
            operator: row['operator'] as String,
            deviceLang: row['deviceLang'] as String,
            deviceSimLang: row['deviceSimLang'] as String,
            silentOnSiren: (row['silentOnSiren'] as int) != 0,
            relayOnDingDong: (row['relayOnDingDong'] as int) != 0,
            callOnPowerLoss: (row['callOnPowerLoss'] as int) != 0,
            manageWithContacts: (row['manageWithContacts'] as int) != 0,
            gsmStateVisibility: (row['gsmStateVisibility'] as int) != 0,
            remoteAmountVisibility: (row['remoteAmountVisibility'] as int) != 0,
            antennaAmountVisibility:
                (row['antennaAmountVisibility'] as int) != 0,
            contactsAmountVisibility:
                (row['contactsAmountVisibility'] as int) != 0,
            batteryShapeVisibility: (row['batteryShapeVisibility'] as int) != 0,
            networkStateVisibility: (row['networkStateVisibility'] as int) != 0,
            zone1Visibility: (row['zone1Visibility'] as int) != 0,
            zone2Visibility: (row['zone2Visibility'] as int) != 0,
            zone3Visibility: (row['zone3Visibility'] as int) != 0,
            zone4Visibility: (row['zone4Visibility'] as int) != 0,
            zone5Visibility: (row['zone5Visibility'] as int) != 0,
            relay1Visibility: (row['relay1Visibility'] as int) != 0,
            relay2Visibility: (row['relay2Visibility'] as int) != 0,
            relay1SectionVisibility:
                (row['relay1SectionVisibility'] as int) != 0,
            relay2SectionVisibility:
                (row['relay2SectionVisibility'] as int) != 0,
            semiActiveVisibility: (row['semiActiveVisibility'] as int) != 0,
            silentVisibility: (row['silentVisibility'] as int) != 0,
            spyVisibility: (row['spyVisibility'] as int) != 0,
            relay1ActiveBtnVisibility:
                (row['relay1ActiveBtnVisibility'] as int) != 0,
            relay2ActiveBtnVisibility:
                (row['relay2ActiveBtnVisibility'] as int) != 0,
            relay1TriggerBtnVisibility:
                (row['relay1TriggerBtnVisibility'] as int) != 0,
            relay2TriggerBtnVisibility:
                (row['relay2TriggerBtnVisibility'] as int) != 0,
            zone1Name: row['zone1Name'] as String,
            zone1Condition: row['zone1Condition'] as String,
            zone1State: (row['zone1State'] as int) != 0,
            zone1SemiActive: (row['zone1SemiActive'] as int) != 0,
            zone2Name: row['zone2Name'] as String,
            zone2Condition: row['zone2Condition'] as String,
            zone2State: (row['zone2State'] as int) != 0,
            zone2SemiActive: (row['zone2SemiActive'] as int) != 0,
            zone3Name: row['zone3Name'] as String,
            zone3Condition: row['zone3Condition'] as String,
            zone3State: (row['zone3State'] as int) != 0,
            zone3SemiActive: (row['zone3SemiActive'] as int) != 0,
            zone4Name: row['zone4Name'] as String,
            zone4Condition: row['zone4Condition'] as String,
            zone4State: (row['zone4State'] as int) != 0,
            zone4SemiActive: (row['zone4SemiActive'] as int) != 0,
            zone5Name: row['zone5Name'] as String,
            zone5Condition: row['zone5Condition'] as String,
            zone5State: (row['zone5State'] as int) != 0,
            zone5SemiActive: (row['zone5SemiActive'] as int) != 0,
            deviceStatus1: row['deviceStatus1'] as String?,
            inputType1: row['inputType1'] as String?,
            inputSelect1: row['inputSelect1'] as String?,
            actionType1: row['actionType1'] as String?,
            actionSelect1: row['actionSelect1'] as String?,
            scenarioName1: row['scenarioName1'] as String?,
            deviceStatus2: row['deviceStatus2'] as String?,
            inputType2: row['inputType2'] as String?,
            inputSelect2: row['inputSelect2'] as String?,
            actionType2: row['actionType2'] as String?,
            actionSelect2: row['actionSelect2'] as String?,
            scenarioName2: row['scenarioName2'] as String?,
            deviceStatus3: row['deviceStatus3'] as String?,
            inputType3: row['inputType3'] as String?,
            inputSelect3: row['inputSelect3'] as String?,
            actionType3: row['actionType3'] as String?,
            actionSelect3: row['actionSelect3'] as String?,
            scenarioName3: row['scenarioName3'] as String?,
            deviceStatus4: row['deviceStatus4'] as String?,
            inputType4: row['inputType4'] as String?,
            inputSelect4: row['inputSelect4'] as String?,
            actionType4: row['actionType4'] as String?,
            actionSelect4: row['actionSelect4'] as String?,
            scenarioName4: row['scenarioName4'] as String?,
            deviceStatus5: row['deviceStatus5'] as String?,
            inputType5: row['inputType5'] as String?,
            inputSelect5: row['inputSelect5'] as String?,
            actionType5: row['actionType5'] as String?,
            actionSelect5: row['actionSelect5'] as String?,
            scenarioName5: row['scenarioName5'] as String?,
            deviceStatus6: row['deviceStatus6'] as String?,
            inputType6: row['inputType6'] as String?,
            inputSelect6: row['inputSelect6'] as String?,
            actionType6: row['actionType6'] as String?,
            actionSelect6: row['actionSelect6'] as String?,
            scenarioName6: row['scenarioName6'] as String?,
            deviceStatus7: row['deviceStatus7'] as String?,
            inputType7: row['inputType7'] as String?,
            inputSelect7: row['inputSelect7'] as String?,
            actionType7: row['actionType7'] as String?,
            actionSelect7: row['actionSelect7'] as String?,
            scenarioName7: row['scenarioName7'] as String?,
            deviceStatus8: row['deviceStatus8'] as String?,
            inputType8: row['inputType8'] as String?,
            inputSelect8: row['inputSelect8'] as String?,
            actionType8: row['actionType8'] as String?,
            actionSelect8: row['actionSelect8'] as String?,
            scenarioName8: row['scenarioName8'] as String?,
            deviceStatus9: row['deviceStatus9'] as String?,
            inputType9: row['inputType9'] as String?,
            inputSelect9: row['inputSelect9'] as String?,
            actionType9: row['actionType9'] as String?,
            actionSelect9: row['actionSelect9'] as String?,
            scenarioName9: row['scenarioName9'] as String?,
            deviceStatus10: row['deviceStatus10'] as String?,
            inputType10: row['inputType10'] as String?,
            inputSelect10: row['inputSelect10'] as String?,
            actionType10: row['actionType10'] as String?,
            actionSelect10: row['actionSelect10'] as String?,
            scenarioName10: row['scenarioName10'] as String?,
            contact1Phone: row['contact1Phone'] as String,
            contact1SMS: (row['contact1SMS'] as int) != 0,
            contact1Call: (row['contact1Call'] as int) != 0,
            contact1Manager: (row['contact1Manager'] as int) != 0,
            contact2Phone: row['contact2Phone'] as String,
            contact2SMS: (row['contact2SMS'] as int) != 0,
            contact2Call: (row['contact2Call'] as int) != 0,
            contact2Manager: (row['contact2Manager'] as int) != 0,
            contact3Phone: row['contact3Phone'] as String,
            contact3SMS: (row['contact3SMS'] as int) != 0,
            contact3Call: (row['contact3Call'] as int) != 0,
            contact3Manager: (row['contact3Manager'] as int) != 0,
            contact4Phone: row['contact4Phone'] as String,
            contact4SMS: (row['contact4SMS'] as int) != 0,
            contact4Call: (row['contact4Call'] as int) != 0,
            contact4Manager: (row['contact4Manager'] as int) != 0,
            contact5Phone: row['contact5Phone'] as String,
            contact5SMS: (row['contact5SMS'] as int) != 0,
            contact5Call: (row['contact5Call'] as int) != 0,
            contact5Manager: (row['contact5Manager'] as int) != 0,
            contact6Phone: row['contact6Phone'] as String,
            contact6SMS: (row['contact6SMS'] as int) != 0,
            contact6Call: (row['contact6Call'] as int) != 0,
            contact6Manager: (row['contact6Manager'] as int) != 0,
            contact7Phone: row['contact7Phone'] as String,
            contact7SMS: (row['contact7SMS'] as int) != 0,
            contact7Call: (row['contact7Call'] as int) != 0,
            contact7Manager: (row['contact7Manager'] as int) != 0,
            contact8Phone: row['contact8Phone'] as String,
            contact8SMS: (row['contact8SMS'] as int) != 0,
            contact8Call: (row['contact8Call'] as int) != 0,
            contact8Manager: (row['contact8Manager'] as int) != 0,
            contact9Phone: row['contact9Phone'] as String,
            contact9SMS: (row['contact9SMS'] as int) != 0,
            contact9Call: (row['contact9Call'] as int) != 0,
            contact9Manager: (row['contact9Manager'] as int) != 0,
            contact10Phone: row['contact10Phone'] as String,
            contact10SMS: (row['contact10SMS'] as int) != 0,
            contact10Call: (row['contact10Call'] as int) != 0,
            contact10Manager: (row['contact10Manager'] as int) != 0,
            alarmDuration: row['alarmDuration'] as int,
            callDuration: row['callDuration'] as int,
            controlRelaysWithRemote:
                (row['controlRelaysWithRemote'] as int) != 0,
            monitoring: (row['monitoring'] as int) != 0,
            remoteReporting: (row['remoteReporting'] as int) != 0,
            scenarioReporting: (row['scenarioReporting'] as int) != 0,
            callPriority: (row['callPriority'] as int) != 0,
            smsPriority: (row['smsPriority'] as int) != 0),
        arguments: [id]);
  }

  @override
  Future<List<Device?>> getAllDevices() async {
    return _queryAdapter.queryList('SELECT * FROM device',
        mapper: (Map<String, Object?> row) => Device(
            id: row['id'] as int?,
            deviceName: row['deviceName'] as String,
            devicePassword: row['devicePassword'] as String,
            devicePhone: row['devicePhone'] as String,
            deviceModel: row['deviceModel'] as String,
            deviceState: row['deviceState'] as String,
            isManager: (row['isManager'] as int) != 0,
            alarmTime: row['alarmTime'] as String,
            remoteAmount: row['remoteAmount'] as int,
            simChargeAmount: row['simChargeAmount'] as int,
            antennaAmount: row['antennaAmount'] as int,
            batteryAmount: row['batteryAmount'] as int,
            cityPowerState: (row['cityPowerState'] as int) != 0,
            gsmState: (row['gsmState'] as int) != 0,
            speakerState: (row['speakerState'] as int) != 0,
            networkState: (row['networkState'] as int) != 0,
            capsulMax: row['capsulMax'] as int,
            capsulMin: row['capsulMin'] as int,
            totalContactsAmount: row['totalContactsAmount'] as int,
            spyAmount: row['spyAmount'] as int,
            chargePeriodictReport: row['chargePeriodictReport'] as int,
            batteryPeriodictReport: row['batteryPeriodictReport'] as int,
            callOrder: row['callOrder'] as int,
            operator: row['operator'] as String,
            deviceLang: row['deviceLang'] as String,
            deviceSimLang: row['deviceSimLang'] as String,
            silentOnSiren: (row['silentOnSiren'] as int) != 0,
            relayOnDingDong: (row['relayOnDingDong'] as int) != 0,
            callOnPowerLoss: (row['callOnPowerLoss'] as int) != 0,
            manageWithContacts: (row['manageWithContacts'] as int) != 0,
            gsmStateVisibility: (row['gsmStateVisibility'] as int) != 0,
            remoteAmountVisibility: (row['remoteAmountVisibility'] as int) != 0,
            antennaAmountVisibility:
                (row['antennaAmountVisibility'] as int) != 0,
            contactsAmountVisibility:
                (row['contactsAmountVisibility'] as int) != 0,
            batteryShapeVisibility: (row['batteryShapeVisibility'] as int) != 0,
            networkStateVisibility: (row['networkStateVisibility'] as int) != 0,
            zone1Visibility: (row['zone1Visibility'] as int) != 0,
            zone2Visibility: (row['zone2Visibility'] as int) != 0,
            zone3Visibility: (row['zone3Visibility'] as int) != 0,
            zone4Visibility: (row['zone4Visibility'] as int) != 0,
            zone5Visibility: (row['zone5Visibility'] as int) != 0,
            relay1Visibility: (row['relay1Visibility'] as int) != 0,
            relay2Visibility: (row['relay2Visibility'] as int) != 0,
            relay1SectionVisibility:
                (row['relay1SectionVisibility'] as int) != 0,
            relay2SectionVisibility:
                (row['relay2SectionVisibility'] as int) != 0,
            semiActiveVisibility: (row['semiActiveVisibility'] as int) != 0,
            silentVisibility: (row['silentVisibility'] as int) != 0,
            spyVisibility: (row['spyVisibility'] as int) != 0,
            relay1ActiveBtnVisibility:
                (row['relay1ActiveBtnVisibility'] as int) != 0,
            relay2ActiveBtnVisibility:
                (row['relay2ActiveBtnVisibility'] as int) != 0,
            relay1TriggerBtnVisibility:
                (row['relay1TriggerBtnVisibility'] as int) != 0,
            relay2TriggerBtnVisibility:
                (row['relay2TriggerBtnVisibility'] as int) != 0,
            zone1Name: row['zone1Name'] as String,
            zone1Condition: row['zone1Condition'] as String,
            zone1State: (row['zone1State'] as int) != 0,
            zone1SemiActive: (row['zone1SemiActive'] as int) != 0,
            zone2Name: row['zone2Name'] as String,
            zone2Condition: row['zone2Condition'] as String,
            zone2State: (row['zone2State'] as int) != 0,
            zone2SemiActive: (row['zone2SemiActive'] as int) != 0,
            zone3Name: row['zone3Name'] as String,
            zone3Condition: row['zone3Condition'] as String,
            zone3State: (row['zone3State'] as int) != 0,
            zone3SemiActive: (row['zone3SemiActive'] as int) != 0,
            zone4Name: row['zone4Name'] as String,
            zone4Condition: row['zone4Condition'] as String,
            zone4State: (row['zone4State'] as int) != 0,
            zone4SemiActive: (row['zone4SemiActive'] as int) != 0,
            zone5Name: row['zone5Name'] as String,
            zone5Condition: row['zone5Condition'] as String,
            zone5State: (row['zone5State'] as int) != 0,
            zone5SemiActive: (row['zone5SemiActive'] as int) != 0,
            deviceStatus1: row['deviceStatus1'] as String?,
            inputType1: row['inputType1'] as String?,
            inputSelect1: row['inputSelect1'] as String?,
            actionType1: row['actionType1'] as String?,
            actionSelect1: row['actionSelect1'] as String?,
            scenarioName1: row['scenarioName1'] as String?,
            deviceStatus2: row['deviceStatus2'] as String?,
            inputType2: row['inputType2'] as String?,
            inputSelect2: row['inputSelect2'] as String?,
            actionType2: row['actionType2'] as String?,
            actionSelect2: row['actionSelect2'] as String?,
            scenarioName2: row['scenarioName2'] as String?,
            deviceStatus3: row['deviceStatus3'] as String?,
            inputType3: row['inputType3'] as String?,
            inputSelect3: row['inputSelect3'] as String?,
            actionType3: row['actionType3'] as String?,
            actionSelect3: row['actionSelect3'] as String?,
            scenarioName3: row['scenarioName3'] as String?,
            deviceStatus4: row['deviceStatus4'] as String?,
            inputType4: row['inputType4'] as String?,
            inputSelect4: row['inputSelect4'] as String?,
            actionType4: row['actionType4'] as String?,
            actionSelect4: row['actionSelect4'] as String?,
            scenarioName4: row['scenarioName4'] as String?,
            deviceStatus5: row['deviceStatus5'] as String?,
            inputType5: row['inputType5'] as String?,
            inputSelect5: row['inputSelect5'] as String?,
            actionType5: row['actionType5'] as String?,
            actionSelect5: row['actionSelect5'] as String?,
            scenarioName5: row['scenarioName5'] as String?,
            deviceStatus6: row['deviceStatus6'] as String?,
            inputType6: row['inputType6'] as String?,
            inputSelect6: row['inputSelect6'] as String?,
            actionType6: row['actionType6'] as String?,
            actionSelect6: row['actionSelect6'] as String?,
            scenarioName6: row['scenarioName6'] as String?,
            deviceStatus7: row['deviceStatus7'] as String?,
            inputType7: row['inputType7'] as String?,
            inputSelect7: row['inputSelect7'] as String?,
            actionType7: row['actionType7'] as String?,
            actionSelect7: row['actionSelect7'] as String?,
            scenarioName7: row['scenarioName7'] as String?,
            deviceStatus8: row['deviceStatus8'] as String?,
            inputType8: row['inputType8'] as String?,
            inputSelect8: row['inputSelect8'] as String?,
            actionType8: row['actionType8'] as String?,
            actionSelect8: row['actionSelect8'] as String?,
            scenarioName8: row['scenarioName8'] as String?,
            deviceStatus9: row['deviceStatus9'] as String?,
            inputType9: row['inputType9'] as String?,
            inputSelect9: row['inputSelect9'] as String?,
            actionType9: row['actionType9'] as String?,
            actionSelect9: row['actionSelect9'] as String?,
            scenarioName9: row['scenarioName9'] as String?,
            deviceStatus10: row['deviceStatus10'] as String?,
            inputType10: row['inputType10'] as String?,
            inputSelect10: row['inputSelect10'] as String?,
            actionType10: row['actionType10'] as String?,
            actionSelect10: row['actionSelect10'] as String?,
            scenarioName10: row['scenarioName10'] as String?,
            contact1Phone: row['contact1Phone'] as String,
            contact1SMS: (row['contact1SMS'] as int) != 0,
            contact1Call: (row['contact1Call'] as int) != 0,
            contact1Manager: (row['contact1Manager'] as int) != 0,
            contact2Phone: row['contact2Phone'] as String,
            contact2SMS: (row['contact2SMS'] as int) != 0,
            contact2Call: (row['contact2Call'] as int) != 0,
            contact2Manager: (row['contact2Manager'] as int) != 0,
            contact3Phone: row['contact3Phone'] as String,
            contact3SMS: (row['contact3SMS'] as int) != 0,
            contact3Call: (row['contact3Call'] as int) != 0,
            contact3Manager: (row['contact3Manager'] as int) != 0,
            contact4Phone: row['contact4Phone'] as String,
            contact4SMS: (row['contact4SMS'] as int) != 0,
            contact4Call: (row['contact4Call'] as int) != 0,
            contact4Manager: (row['contact4Manager'] as int) != 0,
            contact5Phone: row['contact5Phone'] as String,
            contact5SMS: (row['contact5SMS'] as int) != 0,
            contact5Call: (row['contact5Call'] as int) != 0,
            contact5Manager: (row['contact5Manager'] as int) != 0,
            contact6Phone: row['contact6Phone'] as String,
            contact6SMS: (row['contact6SMS'] as int) != 0,
            contact6Call: (row['contact6Call'] as int) != 0,
            contact6Manager: (row['contact6Manager'] as int) != 0,
            contact7Phone: row['contact7Phone'] as String,
            contact7SMS: (row['contact7SMS'] as int) != 0,
            contact7Call: (row['contact7Call'] as int) != 0,
            contact7Manager: (row['contact7Manager'] as int) != 0,
            contact8Phone: row['contact8Phone'] as String,
            contact8SMS: (row['contact8SMS'] as int) != 0,
            contact8Call: (row['contact8Call'] as int) != 0,
            contact8Manager: (row['contact8Manager'] as int) != 0,
            contact9Phone: row['contact9Phone'] as String,
            contact9SMS: (row['contact9SMS'] as int) != 0,
            contact9Call: (row['contact9Call'] as int) != 0,
            contact9Manager: (row['contact9Manager'] as int) != 0,
            contact10Phone: row['contact10Phone'] as String,
            contact10SMS: (row['contact10SMS'] as int) != 0,
            contact10Call: (row['contact10Call'] as int) != 0,
            contact10Manager: (row['contact10Manager'] as int) != 0,
            alarmDuration: row['alarmDuration'] as int,
            callDuration: row['callDuration'] as int,
            controlRelaysWithRemote:
                (row['controlRelaysWithRemote'] as int) != 0,
            monitoring: (row['monitoring'] as int) != 0,
            remoteReporting: (row['remoteReporting'] as int) != 0,
            scenarioReporting: (row['scenarioReporting'] as int) != 0,
            callPriority: (row['callPriority'] as int) != 0,
            smsPriority: (row['smsPriority'] as int) != 0));
  }

  @override
  Future<int> insertDevice(Device device) {
    return _deviceInsertionAdapter.insertAndReturnId(
        device, OnConflictStrategy.replace);
  }

  @override
  Future<int> updateDevice(Device device) {
    return _deviceUpdateAdapter.updateAndReturnChangedRows(
        device, OnConflictStrategy.replace);
  }

  @override
  Future<void> deleteDevice(Device device) async {
    await _deviceDeletionAdapter.delete(device);
  }
}

class _$RelayDAO extends RelayDAO {
  _$RelayDAO(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _relayInsertionAdapter = InsertionAdapter(
            database,
            'relay',
            (Relay item) => <String, Object?>{
                  'id': item.id,
                  'device_id': item.deviceId,
                  'relayName': item.relayName,
                  'relayTriggerTime': item.relayTriggerTime,
                  'relayState': item.relayState ? 1 : 0
                }),
        _relayUpdateAdapter = UpdateAdapter(
            database,
            'relay',
            ['id'],
            (Relay item) => <String, Object?>{
                  'id': item.id,
                  'device_id': item.deviceId,
                  'relayName': item.relayName,
                  'relayTriggerTime': item.relayTriggerTime,
                  'relayState': item.relayState ? 1 : 0
                }),
        _relayDeletionAdapter = DeletionAdapter(
            database,
            'relay',
            ['id'],
            (Relay item) => <String, Object?>{
                  'id': item.id,
                  'device_id': item.deviceId,
                  'relayName': item.relayName,
                  'relayTriggerTime': item.relayTriggerTime,
                  'relayState': item.relayState ? 1 : 0
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Relay> _relayInsertionAdapter;

  final UpdateAdapter<Relay> _relayUpdateAdapter;

  final DeletionAdapter<Relay> _relayDeletionAdapter;

  @override
  Future<List<Relay?>> getRelays(int deviceId) async {
    return _queryAdapter.queryList('SELECT * FROM relay WHERE device_id = ?1',
        mapper: (Map<String, Object?> row) => Relay(
            id: row['id'] as int?,
            deviceId: row['device_id'] as int,
            relayName: row['relayName'] as String,
            relayTriggerTime: row['relayTriggerTime'] as String,
            relayState: (row['relayState'] as int) != 0),
        arguments: [deviceId]);
  }

  @override
  Future<int> insertRelay(Relay relay) {
    return _relayInsertionAdapter.insertAndReturnId(
        relay, OnConflictStrategy.replace);
  }

  @override
  Future<int> updateRelay(Relay relay) {
    return _relayUpdateAdapter.updateAndReturnChangedRows(
        relay, OnConflictStrategy.replace);
  }

  @override
  Future<void> deleteRelay(Relay relay) async {
    await _relayDeletionAdapter.delete(relay);
  }
}

class _$AudioNotificationDAO extends AudioNotificationDAO {
  _$AudioNotificationDAO(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _audioNotificationInsertionAdapter = InsertionAdapter(
            database,
            'audio_notification',
            (AudioNotification item) => <String, Object?>{
                  'id': item.id,
                  'deviceId': item.deviceId,
                  'volume': item.volume,
                  'generalArmed': item.generalArmed ? 1 : 0,
                  'generalDisarmed': item.generalDisarmed ? 1 : 0,
                  'generalReportByUser': item.generalReportByUser ? 1 : 0,
                  'noAccess': item.noAccess ? 1 : 0,
                  'powerOn': item.powerOn ? 1 : 0,
                  'powerOff': item.powerOff ? 1 : 0,
                  'sirenTriggered': item.sirenTriggered ? 1 : 0,
                  'sirenTimeExpired': item.sirenTimeExpired ? 1 : 0,
                  'chargeLow': item.chargeLow ? 1 : 0,
                  'batteryLow': item.batteryLow ? 1 : 0,
                  'batteryDisconnected': item.batteryDisconnected ? 1 : 0,
                  'sirenOff': item.sirenOff ? 1 : 0,
                  'reportByAdmin': item.reportByAdmin ? 1 : 0,
                  'deviceBackupDeleted': item.deviceBackupDeleted ? 1 : 0,
                  'generalArmedVolume': item.generalArmedVolume,
                  'generalDisarmedVolume': item.generalDisarmedVolume,
                  'generalReportByUserVolume': item.generalReportByUserVolume,
                  'noAccessVolume': item.noAccessVolume,
                  'powerOnVolume': item.powerOnVolume,
                  'powerOffVolume': item.powerOffVolume,
                  'sirenTriggeredVolume': item.sirenTriggeredVolume,
                  'sirenTimeExpiredVolume': item.sirenTimeExpiredVolume,
                  'chargeLowVolume': item.chargeLowVolume,
                  'batteryLowVolume': item.batteryLowVolume,
                  'batteryDisconnectedVolume': item.batteryDisconnectedVolume,
                  'sirenOffVolume': item.sirenOffVolume,
                  'reportByAdminVolume': item.reportByAdminVolume,
                  'deviceBackupDeletedVolume': item.deviceBackupDeletedVolume,
                  'zone1Alert': item.zone1Alert ? 1 : 0,
                  'zone2Alert': item.zone2Alert ? 1 : 0,
                  'zone3Alert': item.zone3Alert ? 1 : 0,
                  'zone4Alert': item.zone4Alert ? 1 : 0,
                  'zone5Alert': item.zone5Alert ? 1 : 0,
                  'zone1SemiAlert': item.zone1SemiAlert ? 1 : 0,
                  'zone2SemiAlert': item.zone2SemiAlert ? 1 : 0,
                  'zone3SemiAlert': item.zone3SemiAlert ? 1 : 0,
                  'zone4SemiAlert': item.zone4SemiAlert ? 1 : 0,
                  'zone5SemiAlert': item.zone5SemiAlert ? 1 : 0,
                  'allZonesSemiAlert': item.allZonesSemiAlert ? 1 : 0,
                  'semiActiveZones': item.semiActiveZones ? 1 : 0,
                  'zone1AlertVolume': item.zone1AlertVolume,
                  'zone2AlertVolume': item.zone2AlertVolume,
                  'zone3AlertVolume': item.zone3AlertVolume,
                  'zone4AlertVolume': item.zone4AlertVolume,
                  'zone5AlertVolume': item.zone5AlertVolume,
                  'zone1SemiAlertVolume': item.zone1SemiAlertVolume,
                  'zone2SemiAlertVolume': item.zone2SemiAlertVolume,
                  'zone3SemiAlertVolume': item.zone3SemiAlertVolume,
                  'zone4SemiAlertVolume': item.zone4SemiAlertVolume,
                  'zone5SemiAlertVolume': item.zone5SemiAlertVolume,
                  'allZonesSemiAlertVolume': item.allZonesSemiAlertVolume,
                  'semiActiveZonesVolume': item.semiActiveZonesVolume,
                  'zonesStatus': item.zonesStatus ? 1 : 0,
                  'relaysStatus': item.relaysStatus ? 1 : 0,
                  'connectStatus': item.connectStatus ? 1 : 0,
                  'batteryStatus': item.batteryStatus ? 1 : 0,
                  'simStatus': item.simStatus ? 1 : 0,
                  'powerStatus': item.powerStatus ? 1 : 0,
                  'deviceLossPower': item.deviceLossPower ? 1 : 0,
                  'simCredit': item.simCredit ? 1 : 0,
                  'deviceLostConnection': item.deviceLostConnection ? 1 : 0,
                  'zonesStatusVolume': item.zonesStatusVolume,
                  'relaysStatusVolume': item.relaysStatusVolume,
                  'connectStatusVolume': item.connectStatusVolume,
                  'batteryStatusVolume': item.batteryStatusVolume,
                  'simStatusVolume': item.simStatusVolume,
                  'powerStatusVolume': item.powerStatusVolume,
                  'deviceLossPowerVolume': item.deviceLossPowerVolume,
                  'simCreditVolume': item.simCreditVolume,
                  'deviceLostConnectionVolume': item.deviceLostConnectionVolume,
                  'sirenEnabled': item.sirenEnabled ? 1 : 0,
                  'incorrectCode': item.incorrectCode ? 1 : 0,
                  'disconnectedSensor': item.disconnectedSensor ? 1 : 0,
                  'adminManager': item.adminManager ? 1 : 0,
                  'activateRelay': item.activateRelay ? 1 : 0,
                  'deactivateRelay': item.deactivateRelay ? 1 : 0,
                  'deleteBackup': item.deleteBackup ? 1 : 0,
                  'networkLost': item.networkLost ? 1 : 0,
                  'deactivatedByUser': item.deactivatedByUser ? 1 : 0,
                  'deactivatedByAdmin': item.deactivatedByAdmin ? 1 : 0,
                  'deactivatedByTimer': item.deactivatedByTimer ? 1 : 0,
                  'deactivatedByBackup': item.deactivatedByBackup ? 1 : 0,
                  'silenceMode': item.silenceMode ? 1 : 0,
                  'sirenEnabledVolume': item.sirenEnabledVolume,
                  'incorrectCodeVolume': item.incorrectCodeVolume,
                  'disconnectedSensorVolume': item.disconnectedSensorVolume,
                  'adminManagerVolume': item.adminManagerVolume,
                  'activateRelayVolume': item.activateRelayVolume,
                  'deactivateRelayVolume': item.deactivateRelayVolume,
                  'deleteBackupVolume': item.deleteBackupVolume,
                  'networkLostVolume': item.networkLostVolume,
                  'deactivatedByUserVolume': item.deactivatedByUserVolume,
                  'deactivatedByAdminVolume': item.deactivatedByAdminVolume,
                  'deactivatedByTimerVolume': item.deactivatedByTimerVolume,
                  'deactivatedByBackupVolume': item.deactivatedByBackupVolume,
                  'silenceModeVolume': item.silenceModeVolume
                }),
        _audioNotificationUpdateAdapter = UpdateAdapter(
            database,
            'audio_notification',
            ['id'],
            (AudioNotification item) => <String, Object?>{
                  'id': item.id,
                  'deviceId': item.deviceId,
                  'volume': item.volume,
                  'generalArmed': item.generalArmed ? 1 : 0,
                  'generalDisarmed': item.generalDisarmed ? 1 : 0,
                  'generalReportByUser': item.generalReportByUser ? 1 : 0,
                  'noAccess': item.noAccess ? 1 : 0,
                  'powerOn': item.powerOn ? 1 : 0,
                  'powerOff': item.powerOff ? 1 : 0,
                  'sirenTriggered': item.sirenTriggered ? 1 : 0,
                  'sirenTimeExpired': item.sirenTimeExpired ? 1 : 0,
                  'chargeLow': item.chargeLow ? 1 : 0,
                  'batteryLow': item.batteryLow ? 1 : 0,
                  'batteryDisconnected': item.batteryDisconnected ? 1 : 0,
                  'sirenOff': item.sirenOff ? 1 : 0,
                  'reportByAdmin': item.reportByAdmin ? 1 : 0,
                  'deviceBackupDeleted': item.deviceBackupDeleted ? 1 : 0,
                  'generalArmedVolume': item.generalArmedVolume,
                  'generalDisarmedVolume': item.generalDisarmedVolume,
                  'generalReportByUserVolume': item.generalReportByUserVolume,
                  'noAccessVolume': item.noAccessVolume,
                  'powerOnVolume': item.powerOnVolume,
                  'powerOffVolume': item.powerOffVolume,
                  'sirenTriggeredVolume': item.sirenTriggeredVolume,
                  'sirenTimeExpiredVolume': item.sirenTimeExpiredVolume,
                  'chargeLowVolume': item.chargeLowVolume,
                  'batteryLowVolume': item.batteryLowVolume,
                  'batteryDisconnectedVolume': item.batteryDisconnectedVolume,
                  'sirenOffVolume': item.sirenOffVolume,
                  'reportByAdminVolume': item.reportByAdminVolume,
                  'deviceBackupDeletedVolume': item.deviceBackupDeletedVolume,
                  'zone1Alert': item.zone1Alert ? 1 : 0,
                  'zone2Alert': item.zone2Alert ? 1 : 0,
                  'zone3Alert': item.zone3Alert ? 1 : 0,
                  'zone4Alert': item.zone4Alert ? 1 : 0,
                  'zone5Alert': item.zone5Alert ? 1 : 0,
                  'zone1SemiAlert': item.zone1SemiAlert ? 1 : 0,
                  'zone2SemiAlert': item.zone2SemiAlert ? 1 : 0,
                  'zone3SemiAlert': item.zone3SemiAlert ? 1 : 0,
                  'zone4SemiAlert': item.zone4SemiAlert ? 1 : 0,
                  'zone5SemiAlert': item.zone5SemiAlert ? 1 : 0,
                  'allZonesSemiAlert': item.allZonesSemiAlert ? 1 : 0,
                  'semiActiveZones': item.semiActiveZones ? 1 : 0,
                  'zone1AlertVolume': item.zone1AlertVolume,
                  'zone2AlertVolume': item.zone2AlertVolume,
                  'zone3AlertVolume': item.zone3AlertVolume,
                  'zone4AlertVolume': item.zone4AlertVolume,
                  'zone5AlertVolume': item.zone5AlertVolume,
                  'zone1SemiAlertVolume': item.zone1SemiAlertVolume,
                  'zone2SemiAlertVolume': item.zone2SemiAlertVolume,
                  'zone3SemiAlertVolume': item.zone3SemiAlertVolume,
                  'zone4SemiAlertVolume': item.zone4SemiAlertVolume,
                  'zone5SemiAlertVolume': item.zone5SemiAlertVolume,
                  'allZonesSemiAlertVolume': item.allZonesSemiAlertVolume,
                  'semiActiveZonesVolume': item.semiActiveZonesVolume,
                  'zonesStatus': item.zonesStatus ? 1 : 0,
                  'relaysStatus': item.relaysStatus ? 1 : 0,
                  'connectStatus': item.connectStatus ? 1 : 0,
                  'batteryStatus': item.batteryStatus ? 1 : 0,
                  'simStatus': item.simStatus ? 1 : 0,
                  'powerStatus': item.powerStatus ? 1 : 0,
                  'deviceLossPower': item.deviceLossPower ? 1 : 0,
                  'simCredit': item.simCredit ? 1 : 0,
                  'deviceLostConnection': item.deviceLostConnection ? 1 : 0,
                  'zonesStatusVolume': item.zonesStatusVolume,
                  'relaysStatusVolume': item.relaysStatusVolume,
                  'connectStatusVolume': item.connectStatusVolume,
                  'batteryStatusVolume': item.batteryStatusVolume,
                  'simStatusVolume': item.simStatusVolume,
                  'powerStatusVolume': item.powerStatusVolume,
                  'deviceLossPowerVolume': item.deviceLossPowerVolume,
                  'simCreditVolume': item.simCreditVolume,
                  'deviceLostConnectionVolume': item.deviceLostConnectionVolume,
                  'sirenEnabled': item.sirenEnabled ? 1 : 0,
                  'incorrectCode': item.incorrectCode ? 1 : 0,
                  'disconnectedSensor': item.disconnectedSensor ? 1 : 0,
                  'adminManager': item.adminManager ? 1 : 0,
                  'activateRelay': item.activateRelay ? 1 : 0,
                  'deactivateRelay': item.deactivateRelay ? 1 : 0,
                  'deleteBackup': item.deleteBackup ? 1 : 0,
                  'networkLost': item.networkLost ? 1 : 0,
                  'deactivatedByUser': item.deactivatedByUser ? 1 : 0,
                  'deactivatedByAdmin': item.deactivatedByAdmin ? 1 : 0,
                  'deactivatedByTimer': item.deactivatedByTimer ? 1 : 0,
                  'deactivatedByBackup': item.deactivatedByBackup ? 1 : 0,
                  'silenceMode': item.silenceMode ? 1 : 0,
                  'sirenEnabledVolume': item.sirenEnabledVolume,
                  'incorrectCodeVolume': item.incorrectCodeVolume,
                  'disconnectedSensorVolume': item.disconnectedSensorVolume,
                  'adminManagerVolume': item.adminManagerVolume,
                  'activateRelayVolume': item.activateRelayVolume,
                  'deactivateRelayVolume': item.deactivateRelayVolume,
                  'deleteBackupVolume': item.deleteBackupVolume,
                  'networkLostVolume': item.networkLostVolume,
                  'deactivatedByUserVolume': item.deactivatedByUserVolume,
                  'deactivatedByAdminVolume': item.deactivatedByAdminVolume,
                  'deactivatedByTimerVolume': item.deactivatedByTimerVolume,
                  'deactivatedByBackupVolume': item.deactivatedByBackupVolume,
                  'silenceModeVolume': item.silenceModeVolume
                }),
        _audioNotificationDeletionAdapter = DeletionAdapter(
            database,
            'audio_notification',
            ['id'],
            (AudioNotification item) => <String, Object?>{
                  'id': item.id,
                  'deviceId': item.deviceId,
                  'volume': item.volume,
                  'generalArmed': item.generalArmed ? 1 : 0,
                  'generalDisarmed': item.generalDisarmed ? 1 : 0,
                  'generalReportByUser': item.generalReportByUser ? 1 : 0,
                  'noAccess': item.noAccess ? 1 : 0,
                  'powerOn': item.powerOn ? 1 : 0,
                  'powerOff': item.powerOff ? 1 : 0,
                  'sirenTriggered': item.sirenTriggered ? 1 : 0,
                  'sirenTimeExpired': item.sirenTimeExpired ? 1 : 0,
                  'chargeLow': item.chargeLow ? 1 : 0,
                  'batteryLow': item.batteryLow ? 1 : 0,
                  'batteryDisconnected': item.batteryDisconnected ? 1 : 0,
                  'sirenOff': item.sirenOff ? 1 : 0,
                  'reportByAdmin': item.reportByAdmin ? 1 : 0,
                  'deviceBackupDeleted': item.deviceBackupDeleted ? 1 : 0,
                  'generalArmedVolume': item.generalArmedVolume,
                  'generalDisarmedVolume': item.generalDisarmedVolume,
                  'generalReportByUserVolume': item.generalReportByUserVolume,
                  'noAccessVolume': item.noAccessVolume,
                  'powerOnVolume': item.powerOnVolume,
                  'powerOffVolume': item.powerOffVolume,
                  'sirenTriggeredVolume': item.sirenTriggeredVolume,
                  'sirenTimeExpiredVolume': item.sirenTimeExpiredVolume,
                  'chargeLowVolume': item.chargeLowVolume,
                  'batteryLowVolume': item.batteryLowVolume,
                  'batteryDisconnectedVolume': item.batteryDisconnectedVolume,
                  'sirenOffVolume': item.sirenOffVolume,
                  'reportByAdminVolume': item.reportByAdminVolume,
                  'deviceBackupDeletedVolume': item.deviceBackupDeletedVolume,
                  'zone1Alert': item.zone1Alert ? 1 : 0,
                  'zone2Alert': item.zone2Alert ? 1 : 0,
                  'zone3Alert': item.zone3Alert ? 1 : 0,
                  'zone4Alert': item.zone4Alert ? 1 : 0,
                  'zone5Alert': item.zone5Alert ? 1 : 0,
                  'zone1SemiAlert': item.zone1SemiAlert ? 1 : 0,
                  'zone2SemiAlert': item.zone2SemiAlert ? 1 : 0,
                  'zone3SemiAlert': item.zone3SemiAlert ? 1 : 0,
                  'zone4SemiAlert': item.zone4SemiAlert ? 1 : 0,
                  'zone5SemiAlert': item.zone5SemiAlert ? 1 : 0,
                  'allZonesSemiAlert': item.allZonesSemiAlert ? 1 : 0,
                  'semiActiveZones': item.semiActiveZones ? 1 : 0,
                  'zone1AlertVolume': item.zone1AlertVolume,
                  'zone2AlertVolume': item.zone2AlertVolume,
                  'zone3AlertVolume': item.zone3AlertVolume,
                  'zone4AlertVolume': item.zone4AlertVolume,
                  'zone5AlertVolume': item.zone5AlertVolume,
                  'zone1SemiAlertVolume': item.zone1SemiAlertVolume,
                  'zone2SemiAlertVolume': item.zone2SemiAlertVolume,
                  'zone3SemiAlertVolume': item.zone3SemiAlertVolume,
                  'zone4SemiAlertVolume': item.zone4SemiAlertVolume,
                  'zone5SemiAlertVolume': item.zone5SemiAlertVolume,
                  'allZonesSemiAlertVolume': item.allZonesSemiAlertVolume,
                  'semiActiveZonesVolume': item.semiActiveZonesVolume,
                  'zonesStatus': item.zonesStatus ? 1 : 0,
                  'relaysStatus': item.relaysStatus ? 1 : 0,
                  'connectStatus': item.connectStatus ? 1 : 0,
                  'batteryStatus': item.batteryStatus ? 1 : 0,
                  'simStatus': item.simStatus ? 1 : 0,
                  'powerStatus': item.powerStatus ? 1 : 0,
                  'deviceLossPower': item.deviceLossPower ? 1 : 0,
                  'simCredit': item.simCredit ? 1 : 0,
                  'deviceLostConnection': item.deviceLostConnection ? 1 : 0,
                  'zonesStatusVolume': item.zonesStatusVolume,
                  'relaysStatusVolume': item.relaysStatusVolume,
                  'connectStatusVolume': item.connectStatusVolume,
                  'batteryStatusVolume': item.batteryStatusVolume,
                  'simStatusVolume': item.simStatusVolume,
                  'powerStatusVolume': item.powerStatusVolume,
                  'deviceLossPowerVolume': item.deviceLossPowerVolume,
                  'simCreditVolume': item.simCreditVolume,
                  'deviceLostConnectionVolume': item.deviceLostConnectionVolume,
                  'sirenEnabled': item.sirenEnabled ? 1 : 0,
                  'incorrectCode': item.incorrectCode ? 1 : 0,
                  'disconnectedSensor': item.disconnectedSensor ? 1 : 0,
                  'adminManager': item.adminManager ? 1 : 0,
                  'activateRelay': item.activateRelay ? 1 : 0,
                  'deactivateRelay': item.deactivateRelay ? 1 : 0,
                  'deleteBackup': item.deleteBackup ? 1 : 0,
                  'networkLost': item.networkLost ? 1 : 0,
                  'deactivatedByUser': item.deactivatedByUser ? 1 : 0,
                  'deactivatedByAdmin': item.deactivatedByAdmin ? 1 : 0,
                  'deactivatedByTimer': item.deactivatedByTimer ? 1 : 0,
                  'deactivatedByBackup': item.deactivatedByBackup ? 1 : 0,
                  'silenceMode': item.silenceMode ? 1 : 0,
                  'sirenEnabledVolume': item.sirenEnabledVolume,
                  'incorrectCodeVolume': item.incorrectCodeVolume,
                  'disconnectedSensorVolume': item.disconnectedSensorVolume,
                  'adminManagerVolume': item.adminManagerVolume,
                  'activateRelayVolume': item.activateRelayVolume,
                  'deactivateRelayVolume': item.deactivateRelayVolume,
                  'deleteBackupVolume': item.deleteBackupVolume,
                  'networkLostVolume': item.networkLostVolume,
                  'deactivatedByUserVolume': item.deactivatedByUserVolume,
                  'deactivatedByAdminVolume': item.deactivatedByAdminVolume,
                  'deactivatedByTimerVolume': item.deactivatedByTimerVolume,
                  'deactivatedByBackupVolume': item.deactivatedByBackupVolume,
                  'silenceModeVolume': item.silenceModeVolume
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<AudioNotification> _audioNotificationInsertionAdapter;

  final UpdateAdapter<AudioNotification> _audioNotificationUpdateAdapter;

  final DeletionAdapter<AudioNotification> _audioNotificationDeletionAdapter;

  @override
  Future<AudioNotification?> getNotificationSettings(int deviceId) async {
    return _queryAdapter.query(
        'SELECT * FROM audio_notification WHERE deviceId = ?1',
        mapper: (Map<String, Object?> row) => AudioNotification(
            id: row['id'] as int?,
            deviceId: row['deviceId'] as int,
            volume: row['volume'] as double,
            generalArmed: (row['generalArmed'] as int) != 0,
            generalDisarmed: (row['generalDisarmed'] as int) != 0,
            generalReportByUser: (row['generalReportByUser'] as int) != 0,
            noAccess: (row['noAccess'] as int) != 0,
            powerOn: (row['powerOn'] as int) != 0,
            powerOff: (row['powerOff'] as int) != 0,
            sirenTriggered: (row['sirenTriggered'] as int) != 0,
            sirenTimeExpired: (row['sirenTimeExpired'] as int) != 0,
            chargeLow: (row['chargeLow'] as int) != 0,
            batteryLow: (row['batteryLow'] as int) != 0,
            batteryDisconnected: (row['batteryDisconnected'] as int) != 0,
            sirenOff: (row['sirenOff'] as int) != 0,
            reportByAdmin: (row['reportByAdmin'] as int) != 0,
            deviceBackupDeleted: (row['deviceBackupDeleted'] as int) != 0,
            generalArmedVolume: row['generalArmedVolume'] as double,
            generalDisarmedVolume: row['generalDisarmedVolume'] as double,
            generalReportByUserVolume:
                row['generalReportByUserVolume'] as double,
            noAccessVolume: row['noAccessVolume'] as double,
            powerOnVolume: row['powerOnVolume'] as double,
            powerOffVolume: row['powerOffVolume'] as double,
            sirenTriggeredVolume: row['sirenTriggeredVolume'] as double,
            sirenTimeExpiredVolume: row['sirenTimeExpiredVolume'] as double,
            chargeLowVolume: row['chargeLowVolume'] as double,
            batteryLowVolume: row['batteryLowVolume'] as double,
            batteryDisconnectedVolume:
                row['batteryDisconnectedVolume'] as double,
            sirenOffVolume: row['sirenOffVolume'] as double,
            reportByAdminVolume: row['reportByAdminVolume'] as double,
            deviceBackupDeletedVolume:
                row['deviceBackupDeletedVolume'] as double,
            zone1Alert: (row['zone1Alert'] as int) != 0,
            zone2Alert: (row['zone2Alert'] as int) != 0,
            zone3Alert: (row['zone3Alert'] as int) != 0,
            zone4Alert: (row['zone4Alert'] as int) != 0,
            zone5Alert: (row['zone5Alert'] as int) != 0,
            zone1SemiAlert: (row['zone1SemiAlert'] as int) != 0,
            zone2SemiAlert: (row['zone2SemiAlert'] as int) != 0,
            zone3SemiAlert: (row['zone3SemiAlert'] as int) != 0,
            zone4SemiAlert: (row['zone4SemiAlert'] as int) != 0,
            zone5SemiAlert: (row['zone5SemiAlert'] as int) != 0,
            allZonesSemiAlert: (row['allZonesSemiAlert'] as int) != 0,
            semiActiveZones: (row['semiActiveZones'] as int) != 0,
            zone1AlertVolume: row['zone1AlertVolume'] as double,
            zone2AlertVolume: row['zone2AlertVolume'] as double,
            zone3AlertVolume: row['zone3AlertVolume'] as double,
            zone4AlertVolume: row['zone4AlertVolume'] as double,
            zone5AlertVolume: row['zone5AlertVolume'] as double,
            zone1SemiAlertVolume: row['zone1SemiAlertVolume'] as double,
            zone2SemiAlertVolume: row['zone2SemiAlertVolume'] as double,
            zone3SemiAlertVolume: row['zone3SemiAlertVolume'] as double,
            zone4SemiAlertVolume: row['zone4SemiAlertVolume'] as double,
            zone5SemiAlertVolume: row['zone5SemiAlertVolume'] as double,
            allZonesSemiAlertVolume: row['allZonesSemiAlertVolume'] as double,
            semiActiveZonesVolume: row['semiActiveZonesVolume'] as double,
            zonesStatus: (row['zonesStatus'] as int) != 0,
            relaysStatus: (row['relaysStatus'] as int) != 0,
            connectStatus: (row['connectStatus'] as int) != 0,
            batteryStatus: (row['batteryStatus'] as int) != 0,
            simStatus: (row['simStatus'] as int) != 0,
            powerStatus: (row['powerStatus'] as int) != 0,
            deviceLossPower: (row['deviceLossPower'] as int) != 0,
            simCredit: (row['simCredit'] as int) != 0,
            deviceLostConnection: (row['deviceLostConnection'] as int) != 0,
            zonesStatusVolume: row['zonesStatusVolume'] as double,
            relaysStatusVolume: row['relaysStatusVolume'] as double,
            connectStatusVolume: row['connectStatusVolume'] as double,
            batteryStatusVolume: row['batteryStatusVolume'] as double,
            simStatusVolume: row['simStatusVolume'] as double,
            powerStatusVolume: row['powerStatusVolume'] as double,
            deviceLossPowerVolume: row['deviceLossPowerVolume'] as double,
            simCreditVolume: row['simCreditVolume'] as double,
            deviceLostConnectionVolume:
                row['deviceLostConnectionVolume'] as double,
            sirenEnabled: (row['sirenEnabled'] as int) != 0,
            incorrectCode: (row['incorrectCode'] as int) != 0,
            disconnectedSensor: (row['disconnectedSensor'] as int) != 0,
            adminManager: (row['adminManager'] as int) != 0,
            activateRelay: (row['activateRelay'] as int) != 0,
            deactivateRelay: (row['deactivateRelay'] as int) != 0,
            deleteBackup: (row['deleteBackup'] as int) != 0,
            networkLost: (row['networkLost'] as int) != 0,
            deactivatedByUser: (row['deactivatedByUser'] as int) != 0,
            deactivatedByAdmin: (row['deactivatedByAdmin'] as int) != 0,
            deactivatedByTimer: (row['deactivatedByTimer'] as int) != 0,
            deactivatedByBackup: (row['deactivatedByBackup'] as int) != 0,
            silenceMode: (row['silenceMode'] as int) != 0,
            sirenEnabledVolume: row['sirenEnabledVolume'] as double,
            incorrectCodeVolume: row['incorrectCodeVolume'] as double,
            disconnectedSensorVolume: row['disconnectedSensorVolume'] as double,
            adminManagerVolume: row['adminManagerVolume'] as double,
            activateRelayVolume: row['activateRelayVolume'] as double,
            deactivateRelayVolume: row['deactivateRelayVolume'] as double,
            deleteBackupVolume: row['deleteBackupVolume'] as double,
            networkLostVolume: row['networkLostVolume'] as double,
            deactivatedByUserVolume: row['deactivatedByUserVolume'] as double,
            deactivatedByAdminVolume: row['deactivatedByAdminVolume'] as double,
            deactivatedByTimerVolume: row['deactivatedByTimerVolume'] as double,
            deactivatedByBackupVolume:
                row['deactivatedByBackupVolume'] as double,
            silenceModeVolume: row['silenceModeVolume'] as double),
        arguments: [deviceId]);
  }

  @override
  Future<List<AudioNotification?>> getAllNotificationSettings() async {
    return _queryAdapter.queryList('SELECT * FROM audio_notification',
        mapper: (Map<String, Object?> row) => AudioNotification(
            id: row['id'] as int?,
            deviceId: row['deviceId'] as int,
            volume: row['volume'] as double,
            generalArmed: (row['generalArmed'] as int) != 0,
            generalDisarmed: (row['generalDisarmed'] as int) != 0,
            generalReportByUser: (row['generalReportByUser'] as int) != 0,
            noAccess: (row['noAccess'] as int) != 0,
            powerOn: (row['powerOn'] as int) != 0,
            powerOff: (row['powerOff'] as int) != 0,
            sirenTriggered: (row['sirenTriggered'] as int) != 0,
            sirenTimeExpired: (row['sirenTimeExpired'] as int) != 0,
            chargeLow: (row['chargeLow'] as int) != 0,
            batteryLow: (row['batteryLow'] as int) != 0,
            batteryDisconnected: (row['batteryDisconnected'] as int) != 0,
            sirenOff: (row['sirenOff'] as int) != 0,
            reportByAdmin: (row['reportByAdmin'] as int) != 0,
            deviceBackupDeleted: (row['deviceBackupDeleted'] as int) != 0,
            generalArmedVolume: row['generalArmedVolume'] as double,
            generalDisarmedVolume: row['generalDisarmedVolume'] as double,
            generalReportByUserVolume:
                row['generalReportByUserVolume'] as double,
            noAccessVolume: row['noAccessVolume'] as double,
            powerOnVolume: row['powerOnVolume'] as double,
            powerOffVolume: row['powerOffVolume'] as double,
            sirenTriggeredVolume: row['sirenTriggeredVolume'] as double,
            sirenTimeExpiredVolume: row['sirenTimeExpiredVolume'] as double,
            chargeLowVolume: row['chargeLowVolume'] as double,
            batteryLowVolume: row['batteryLowVolume'] as double,
            batteryDisconnectedVolume:
                row['batteryDisconnectedVolume'] as double,
            sirenOffVolume: row['sirenOffVolume'] as double,
            reportByAdminVolume: row['reportByAdminVolume'] as double,
            deviceBackupDeletedVolume:
                row['deviceBackupDeletedVolume'] as double,
            zone1Alert: (row['zone1Alert'] as int) != 0,
            zone2Alert: (row['zone2Alert'] as int) != 0,
            zone3Alert: (row['zone3Alert'] as int) != 0,
            zone4Alert: (row['zone4Alert'] as int) != 0,
            zone5Alert: (row['zone5Alert'] as int) != 0,
            zone1SemiAlert: (row['zone1SemiAlert'] as int) != 0,
            zone2SemiAlert: (row['zone2SemiAlert'] as int) != 0,
            zone3SemiAlert: (row['zone3SemiAlert'] as int) != 0,
            zone4SemiAlert: (row['zone4SemiAlert'] as int) != 0,
            zone5SemiAlert: (row['zone5SemiAlert'] as int) != 0,
            allZonesSemiAlert: (row['allZonesSemiAlert'] as int) != 0,
            semiActiveZones: (row['semiActiveZones'] as int) != 0,
            zone1AlertVolume: row['zone1AlertVolume'] as double,
            zone2AlertVolume: row['zone2AlertVolume'] as double,
            zone3AlertVolume: row['zone3AlertVolume'] as double,
            zone4AlertVolume: row['zone4AlertVolume'] as double,
            zone5AlertVolume: row['zone5AlertVolume'] as double,
            zone1SemiAlertVolume: row['zone1SemiAlertVolume'] as double,
            zone2SemiAlertVolume: row['zone2SemiAlertVolume'] as double,
            zone3SemiAlertVolume: row['zone3SemiAlertVolume'] as double,
            zone4SemiAlertVolume: row['zone4SemiAlertVolume'] as double,
            zone5SemiAlertVolume: row['zone5SemiAlertVolume'] as double,
            allZonesSemiAlertVolume: row['allZonesSemiAlertVolume'] as double,
            semiActiveZonesVolume: row['semiActiveZonesVolume'] as double,
            zonesStatus: (row['zonesStatus'] as int) != 0,
            relaysStatus: (row['relaysStatus'] as int) != 0,
            connectStatus: (row['connectStatus'] as int) != 0,
            batteryStatus: (row['batteryStatus'] as int) != 0,
            simStatus: (row['simStatus'] as int) != 0,
            powerStatus: (row['powerStatus'] as int) != 0,
            deviceLossPower: (row['deviceLossPower'] as int) != 0,
            simCredit: (row['simCredit'] as int) != 0,
            deviceLostConnection: (row['deviceLostConnection'] as int) != 0,
            zonesStatusVolume: row['zonesStatusVolume'] as double,
            relaysStatusVolume: row['relaysStatusVolume'] as double,
            connectStatusVolume: row['connectStatusVolume'] as double,
            batteryStatusVolume: row['batteryStatusVolume'] as double,
            simStatusVolume: row['simStatusVolume'] as double,
            powerStatusVolume: row['powerStatusVolume'] as double,
            deviceLossPowerVolume: row['deviceLossPowerVolume'] as double,
            simCreditVolume: row['simCreditVolume'] as double,
            deviceLostConnectionVolume:
                row['deviceLostConnectionVolume'] as double,
            sirenEnabled: (row['sirenEnabled'] as int) != 0,
            incorrectCode: (row['incorrectCode'] as int) != 0,
            disconnectedSensor: (row['disconnectedSensor'] as int) != 0,
            adminManager: (row['adminManager'] as int) != 0,
            activateRelay: (row['activateRelay'] as int) != 0,
            deactivateRelay: (row['deactivateRelay'] as int) != 0,
            deleteBackup: (row['deleteBackup'] as int) != 0,
            networkLost: (row['networkLost'] as int) != 0,
            deactivatedByUser: (row['deactivatedByUser'] as int) != 0,
            deactivatedByAdmin: (row['deactivatedByAdmin'] as int) != 0,
            deactivatedByTimer: (row['deactivatedByTimer'] as int) != 0,
            deactivatedByBackup: (row['deactivatedByBackup'] as int) != 0,
            silenceMode: (row['silenceMode'] as int) != 0,
            sirenEnabledVolume: row['sirenEnabledVolume'] as double,
            incorrectCodeVolume: row['incorrectCodeVolume'] as double,
            disconnectedSensorVolume: row['disconnectedSensorVolume'] as double,
            adminManagerVolume: row['adminManagerVolume'] as double,
            activateRelayVolume: row['activateRelayVolume'] as double,
            deactivateRelayVolume: row['deactivateRelayVolume'] as double,
            deleteBackupVolume: row['deleteBackupVolume'] as double,
            networkLostVolume: row['networkLostVolume'] as double,
            deactivatedByUserVolume: row['deactivatedByUserVolume'] as double,
            deactivatedByAdminVolume: row['deactivatedByAdminVolume'] as double,
            deactivatedByTimerVolume: row['deactivatedByTimerVolume'] as double,
            deactivatedByBackupVolume:
                row['deactivatedByBackupVolume'] as double,
            silenceModeVolume: row['silenceModeVolume'] as double));
  }

  @override
  Future<int> insertNotificationSettings(AudioNotification settings) {
    return _audioNotificationInsertionAdapter.insertAndReturnId(
        settings, OnConflictStrategy.replace);
  }

  @override
  Future<int> updateNotificationSettings(AudioNotification settings) {
    return _audioNotificationUpdateAdapter.updateAndReturnChangedRows(
        settings, OnConflictStrategy.replace);
  }

  @override
  Future<void> deleteNotificationSettings(AudioNotification settings) async {
    await _audioNotificationDeletionAdapter.delete(settings);
  }
}

class _$ScheduleDAO extends ScheduleDAO {
  _$ScheduleDAO(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _scheduleItemInsertionAdapter = InsertionAdapter(
            database,
            'ScheduleItem',
            (ScheduleItem item) => <String, Object?>{
                  'id': item.id,
                  'deviceId': item.deviceId,
                  'relayName': item.relayName,
                  'isActivating': item.isActivating,
                  'mode': item.mode,
                  'type': item.type,
                  'timeHour': item.timeHour,
                  'timeMinute': item.timeMinute,
                  'date': item.date,
                  'weekday': item.weekday
                }),
        _scheduleItemDeletionAdapter = DeletionAdapter(
            database,
            'ScheduleItem',
            ['id'],
            (ScheduleItem item) => <String, Object?>{
                  'id': item.id,
                  'deviceId': item.deviceId,
                  'relayName': item.relayName,
                  'isActivating': item.isActivating,
                  'mode': item.mode,
                  'type': item.type,
                  'timeHour': item.timeHour,
                  'timeMinute': item.timeMinute,
                  'date': item.date,
                  'weekday': item.weekday
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<ScheduleItem> _scheduleItemInsertionAdapter;

  final DeletionAdapter<ScheduleItem> _scheduleItemDeletionAdapter;

  @override
  Future<List<ScheduleItem>> getSchedulesForDevice(String deviceId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM ScheduleItem WHERE deviceId = ?1',
        mapper: (Map<String, Object?> row) => ScheduleItem(
            id: row['id'] as String,
            deviceId: row['deviceId'] as String,
            relayName: row['relayName'] as String,
            isActivating: row['isActivating'] as int,
            mode: row['mode'] as int,
            type: row['type'] as int,
            timeHour: row['timeHour'] as int,
            timeMinute: row['timeMinute'] as int,
            date: row['date'] as int?,
            weekday: row['weekday'] as int?),
        arguments: [deviceId]);
  }

  @override
  Future<void> deleteScheduleById(
    String id,
    String deviceId,
  ) async {
    await _queryAdapter.queryNoReturn(
        'DELETE FROM ScheduleItem WHERE id = ?1 AND deviceId = ?2',
        arguments: [id, deviceId]);
  }

  @override
  Future<void> deleteAllSchedulesForDevice(String deviceId) async {
    await _queryAdapter.queryNoReturn(
        'DELETE FROM ScheduleItem WHERE deviceId = ?1',
        arguments: [deviceId]);
  }

  @override
  Future<void> insertSchedule(ScheduleItem schedule) async {
    await _scheduleItemInsertionAdapter.insert(
        schedule, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteSchedule(ScheduleItem schedule) async {
    await _scheduleItemDeletionAdapter.delete(schedule);
  }
}

class _$SmartControlDAO extends SmartControlDAO {
  _$SmartControlDAO(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _smartControlInsertionAdapter = InsertionAdapter(
            database,
            'smart_control',
            (SmartControl item) => <String, Object?>{
                  'id': item.id,
                  'deviceId': item.deviceId,
                  'controlType': item.controlType,
                  'speakerEnabled': item.speakerEnabled ? 1 : 0,
                  'remoteCodeEnabled': item.remoteCodeEnabled ? 1 : 0,
                  'remoteEnabled': item.remoteEnabled ? 1 : 0,
                  'relay1Enabled': item.relay1Enabled ? 1 : 0,
                  'relay2Enabled': item.relay2Enabled ? 1 : 0,
                  'relay3Enabled': item.relay3Enabled ? 1 : 0,
                  'scenarioEnabled': item.scenarioEnabled ? 1 : 0,
                  'activeMode': item.activeMode
                }),
        _smartControlUpdateAdapter = UpdateAdapter(
            database,
            'smart_control',
            ['id'],
            (SmartControl item) => <String, Object?>{
                  'id': item.id,
                  'deviceId': item.deviceId,
                  'controlType': item.controlType,
                  'speakerEnabled': item.speakerEnabled ? 1 : 0,
                  'remoteCodeEnabled': item.remoteCodeEnabled ? 1 : 0,
                  'remoteEnabled': item.remoteEnabled ? 1 : 0,
                  'relay1Enabled': item.relay1Enabled ? 1 : 0,
                  'relay2Enabled': item.relay2Enabled ? 1 : 0,
                  'relay3Enabled': item.relay3Enabled ? 1 : 0,
                  'scenarioEnabled': item.scenarioEnabled ? 1 : 0,
                  'activeMode': item.activeMode
                }),
        _smartControlDeletionAdapter = DeletionAdapter(
            database,
            'smart_control',
            ['id'],
            (SmartControl item) => <String, Object?>{
                  'id': item.id,
                  'deviceId': item.deviceId,
                  'controlType': item.controlType,
                  'speakerEnabled': item.speakerEnabled ? 1 : 0,
                  'remoteCodeEnabled': item.remoteCodeEnabled ? 1 : 0,
                  'remoteEnabled': item.remoteEnabled ? 1 : 0,
                  'relay1Enabled': item.relay1Enabled ? 1 : 0,
                  'relay2Enabled': item.relay2Enabled ? 1 : 0,
                  'relay3Enabled': item.relay3Enabled ? 1 : 0,
                  'scenarioEnabled': item.scenarioEnabled ? 1 : 0,
                  'activeMode': item.activeMode
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<SmartControl> _smartControlInsertionAdapter;

  final UpdateAdapter<SmartControl> _smartControlUpdateAdapter;

  final DeletionAdapter<SmartControl> _smartControlDeletionAdapter;

  @override
  Future<List<SmartControl>> getAllSmartControls() async {
    return _queryAdapter.queryList('SELECT * FROM smart_control',
        mapper: (Map<String, Object?> row) => SmartControl(
            id: row['id'] as int?,
            deviceId: row['deviceId'] as int,
            controlType: row['controlType'] as String,
            speakerEnabled: (row['speakerEnabled'] as int) != 0,
            remoteCodeEnabled: (row['remoteCodeEnabled'] as int) != 0,
            remoteEnabled: (row['remoteEnabled'] as int) != 0,
            relay1Enabled: (row['relay1Enabled'] as int) != 0,
            relay2Enabled: (row['relay2Enabled'] as int) != 0,
            relay3Enabled: (row['relay3Enabled'] as int) != 0,
            scenarioEnabled: (row['scenarioEnabled'] as int) != 0,
            activeMode: row['activeMode'] as String));
  }

  @override
  Future<List<SmartControl>> getSmartControlsByDeviceId(int deviceId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM smart_control WHERE deviceId = ?1',
        mapper: (Map<String, Object?> row) => SmartControl(
            id: row['id'] as int?,
            deviceId: row['deviceId'] as int,
            controlType: row['controlType'] as String,
            speakerEnabled: (row['speakerEnabled'] as int) != 0,
            remoteCodeEnabled: (row['remoteCodeEnabled'] as int) != 0,
            remoteEnabled: (row['remoteEnabled'] as int) != 0,
            relay1Enabled: (row['relay1Enabled'] as int) != 0,
            relay2Enabled: (row['relay2Enabled'] as int) != 0,
            relay3Enabled: (row['relay3Enabled'] as int) != 0,
            scenarioEnabled: (row['scenarioEnabled'] as int) != 0,
            activeMode: row['activeMode'] as String),
        arguments: [deviceId]);
  }

  @override
  Future<SmartControl?> getSmartControlByTypeAndDeviceId(
    int deviceId,
    String controlType,
  ) async {
    return _queryAdapter.query(
        'SELECT * FROM smart_control WHERE deviceId = ?1 AND controlType = ?2',
        mapper: (Map<String, Object?> row) => SmartControl(
            id: row['id'] as int?,
            deviceId: row['deviceId'] as int,
            controlType: row['controlType'] as String,
            speakerEnabled: (row['speakerEnabled'] as int) != 0,
            remoteCodeEnabled: (row['remoteCodeEnabled'] as int) != 0,
            remoteEnabled: (row['remoteEnabled'] as int) != 0,
            relay1Enabled: (row['relay1Enabled'] as int) != 0,
            relay2Enabled: (row['relay2Enabled'] as int) != 0,
            relay3Enabled: (row['relay3Enabled'] as int) != 0,
            scenarioEnabled: (row['scenarioEnabled'] as int) != 0,
            activeMode: row['activeMode'] as String),
        arguments: [deviceId, controlType]);
  }

  @override
  Future<void> deleteSmartControlsByDeviceId(int deviceId) async {
    await _queryAdapter.queryNoReturn(
        'DELETE FROM smart_control WHERE deviceId = ?1',
        arguments: [deviceId]);
  }

  @override
  Future<int> insertSmartControl(SmartControl smartControl) {
    return _smartControlInsertionAdapter.insertAndReturnId(
        smartControl, OnConflictStrategy.abort);
  }

  @override
  Future<int> updateSmartControl(SmartControl smartControl) {
    return _smartControlUpdateAdapter.updateAndReturnChangedRows(
        smartControl, OnConflictStrategy.abort);
  }

  @override
  Future<int> deleteSmartControl(SmartControl smartControl) {
    return _smartControlDeletionAdapter
        .deleteAndReturnChangedRows(smartControl);
  }
}

class _$ZonesDao extends ZonesDao {
  _$ZonesDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _zonesTableInsertionAdapter = InsertionAdapter(
            database,
            'ZonesTable',
            (ZonesTable item) => <String, Object?>{
                  'id': item.id,
                  'deviceId': item.deviceId,
                  'zonesJson': item.zonesJson
                }),
        _zonesTableUpdateAdapter = UpdateAdapter(
            database,
            'ZonesTable',
            ['id'],
            (ZonesTable item) => <String, Object?>{
                  'id': item.id,
                  'deviceId': item.deviceId,
                  'zonesJson': item.zonesJson
                }),
        _zonesTableDeletionAdapter = DeletionAdapter(
            database,
            'ZonesTable',
            ['id'],
            (ZonesTable item) => <String, Object?>{
                  'id': item.id,
                  'deviceId': item.deviceId,
                  'zonesJson': item.zonesJson
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<ZonesTable> _zonesTableInsertionAdapter;

  final UpdateAdapter<ZonesTable> _zonesTableUpdateAdapter;

  final DeletionAdapter<ZonesTable> _zonesTableDeletionAdapter;

  @override
  Future<List<ZonesTable?>> getZones(int deviceId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM ZonesTable WHERE deviceId = ?1',
        mapper: (Map<String, Object?> row) => ZonesTable(
            id: row['id'] as int,
            deviceId: row['deviceId'] as int,
            zonesJson: row['zonesJson'] as String),
        arguments: [deviceId]);
  }

  @override
  Future<void> deleteZonesByDeviceId(int deviceId) async {
    await _queryAdapter.queryNoReturn(
        'DELETE FROM ZonesTable WHERE deviceId = ?1',
        arguments: [deviceId]);
  }

  @override
  Future<void> insertZone(ZonesTable zone) async {
    await _zonesTableInsertionAdapter.insert(zone, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateZone(ZonesTable zone) async {
    await _zonesTableUpdateAdapter.update(zone, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteZone(ZonesTable zone) async {
    await _zonesTableDeletionAdapter.delete(zone);
  }
}

class _$ScenarioDAO extends ScenarioDAO {
  _$ScenarioDAO(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _scenarioInsertionAdapter = InsertionAdapter(
            database,
            'Scenario',
            (Scenario item) => <String, Object?>{
                  'id': item.id,
                  'deviceId': item.deviceId,
                  'scenarioText1': item.scenarioText1,
                  'scenarioText2': item.scenarioText2,
                  'scenarioText3': item.scenarioText3,
                  'scenarioText4': item.scenarioText4,
                  'scenarioText5': item.scenarioText5,
                  'scenarioText6': item.scenarioText6,
                  'scenarioText7': item.scenarioText7,
                  'scenarioText8': item.scenarioText8,
                  'scenarioText9': item.scenarioText9,
                  'scenarioText10': item.scenarioText10,
                  'smsFormat': item.smsFormat,
                  'modeFormat': item.modeFormat
                }),
        _scenarioUpdateAdapter = UpdateAdapter(
            database,
            'Scenario',
            ['id'],
            (Scenario item) => <String, Object?>{
                  'id': item.id,
                  'deviceId': item.deviceId,
                  'scenarioText1': item.scenarioText1,
                  'scenarioText2': item.scenarioText2,
                  'scenarioText3': item.scenarioText3,
                  'scenarioText4': item.scenarioText4,
                  'scenarioText5': item.scenarioText5,
                  'scenarioText6': item.scenarioText6,
                  'scenarioText7': item.scenarioText7,
                  'scenarioText8': item.scenarioText8,
                  'scenarioText9': item.scenarioText9,
                  'scenarioText10': item.scenarioText10,
                  'smsFormat': item.smsFormat,
                  'modeFormat': item.modeFormat
                }),
        _scenarioDeletionAdapter = DeletionAdapter(
            database,
            'Scenario',
            ['id'],
            (Scenario item) => <String, Object?>{
                  'id': item.id,
                  'deviceId': item.deviceId,
                  'scenarioText1': item.scenarioText1,
                  'scenarioText2': item.scenarioText2,
                  'scenarioText3': item.scenarioText3,
                  'scenarioText4': item.scenarioText4,
                  'scenarioText5': item.scenarioText5,
                  'scenarioText6': item.scenarioText6,
                  'scenarioText7': item.scenarioText7,
                  'scenarioText8': item.scenarioText8,
                  'scenarioText9': item.scenarioText9,
                  'scenarioText10': item.scenarioText10,
                  'smsFormat': item.smsFormat,
                  'modeFormat': item.modeFormat
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Scenario> _scenarioInsertionAdapter;

  final UpdateAdapter<Scenario> _scenarioUpdateAdapter;

  final DeletionAdapter<Scenario> _scenarioDeletionAdapter;

  @override
  Future<Scenario?> getScenarioByDeviceId(int deviceId) async {
    return _queryAdapter.query('SELECT * FROM Scenario WHERE deviceId = ?1',
        mapper: (Map<String, Object?> row) => Scenario(
            id: row['id'] as int,
            deviceId: row['deviceId'] as int,
            scenarioText1: row['scenarioText1'] as String,
            scenarioText2: row['scenarioText2'] as String,
            scenarioText3: row['scenarioText3'] as String,
            scenarioText4: row['scenarioText4'] as String,
            scenarioText5: row['scenarioText5'] as String,
            scenarioText6: row['scenarioText6'] as String,
            scenarioText7: row['scenarioText7'] as String,
            scenarioText8: row['scenarioText8'] as String,
            scenarioText9: row['scenarioText9'] as String,
            scenarioText10: row['scenarioText10'] as String,
            smsFormat: row['smsFormat'] as String,
            modeFormat: row['modeFormat'] as String),
        arguments: [deviceId]);
  }

  @override
  Future<List<Scenario?>> getAllScenarios() async {
    return _queryAdapter.queryList('SELECT * FROM Scenario',
        mapper: (Map<String, Object?> row) => Scenario(
            id: row['id'] as int,
            deviceId: row['deviceId'] as int,
            scenarioText1: row['scenarioText1'] as String,
            scenarioText2: row['scenarioText2'] as String,
            scenarioText3: row['scenarioText3'] as String,
            scenarioText4: row['scenarioText4'] as String,
            scenarioText5: row['scenarioText5'] as String,
            scenarioText6: row['scenarioText6'] as String,
            scenarioText7: row['scenarioText7'] as String,
            scenarioText8: row['scenarioText8'] as String,
            scenarioText9: row['scenarioText9'] as String,
            scenarioText10: row['scenarioText10'] as String,
            smsFormat: row['smsFormat'] as String,
            modeFormat: row['modeFormat'] as String));
  }

  @override
  Future<void> deleteScenarioByDeviceId(int deviceId) async {
    await _queryAdapter.queryNoReturn(
        'DELETE FROM Scenario WHERE deviceId = ?1',
        arguments: [deviceId]);
  }

  @override
  Future<int> insertScenario(Scenario scenario) {
    return _scenarioInsertionAdapter.insertAndReturnId(
        scenario, OnConflictStrategy.replace);
  }

  @override
  Future<int> updateScenario(Scenario scenario) {
    return _scenarioUpdateAdapter.updateAndReturnChangedRows(
        scenario, OnConflictStrategy.replace);
  }

  @override
  Future<void> deleteScenario(Scenario scenario) async {
    await _scenarioDeletionAdapter.delete(scenario);
  }
}
