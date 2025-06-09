import '../models/app_settings.dart';
import '../models/audio_notification.dart';
import '../models/device.dart';
import '../models/relay.dart';
import '../models/scenario.dart';
import '../services/local/app_database.dart';
import '../services/local/DAOs/zones_dao.dart';
import '../views/zones/zone_settings/mobile/zone_mode_settings_view.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

class CacheRepository {
  final AppDatabase _appDatabase;
  const CacheRepository(this._appDatabase);

  Future<void> deleteAppSettings(AppSettings appSettings) async {
    return await _appDatabase.appSettingsDao.deleteAppSettings(appSettings);
  }

  Future<AppSettings?> getAppSettings() async {
    return await _appDatabase.appSettingsDao.getAppSettings();
  }

  Future<void> insertAppSettings(AppSettings appSettings) async {
    return await _appDatabase.appSettingsDao.insertAppSettings(appSettings);
  }

  Future<void> updateAppSettings(AppSettings appSettings) async {
    return await _appDatabase.appSettingsDao.updateAppSettings(appSettings);
  }

  Future<void> deleteDevice(Device device) async {
    return await _appDatabase.deviceDao.deleteDevice(device);
  }

  Future<Device?> getDevice(int id) async {
    return await _appDatabase.deviceDao.getDevice(id);
  }

  Future<List<Device?>> getAllDevices() async {
    return await _appDatabase.deviceDao.getAllDevices();
  }

  Future<int> insertDevice(Device device) async {
    return await _appDatabase.deviceDao.insertDevice(device);
  }

  Future<int> updateDevice(Device device) async {
    return await _appDatabase.deviceDao.updateDevice(device);
  }

  Future<void> deleteRelay(Relay relay) async {
    return await _appDatabase.relayDao.deleteRelay(relay);
  }

  Future<List<Relay?>> getRelays(int deviceId) async {
    return await _appDatabase.relayDao.getRelays(deviceId);
  }

  Future<int> insertRelay(Relay relay) async {
    return await _appDatabase.relayDao.insertRelay(relay);
  }

  Future<int> updateRelay(Relay relay) async {
    return await _appDatabase.relayDao.updateRelay(relay);
  }
  
  Future<void> deleteNotificationSettings(AudioNotification settings) async {
    return await _appDatabase.audioNotificationDao.deleteNotificationSettings(settings);
  }

  Future<AudioNotification?> getNotificationSettings(int deviceId) async {
    return await _appDatabase.audioNotificationDao.getNotificationSettings(deviceId);
  }

  Future<List<AudioNotification?>> getAllNotificationSettings() async {
    return await _appDatabase.audioNotificationDao.getAllNotificationSettings();
  }

  Future<int> insertNotificationSettings(AudioNotification settings) async {
    return await _appDatabase.audioNotificationDao.insertNotificationSettings(settings);
  }

  Future<int> updateNotificationSettings(AudioNotification settings) async {
    return await _appDatabase.audioNotificationDao.updateNotificationSettings(settings);
  }

  // Zone related methods
  Future<List<ZoneModel>> getZonesByDeviceId(int deviceId) async {
    final zonesTableList = await _appDatabase.zonesDao.getZones(deviceId);
    if (zonesTableList.isNotEmpty && zonesTableList[0] != null) {
      return zonesTableList[0]!.toZonesList();
    }
    return [];
  }
  
  Future<void> saveZones(int deviceId, List<ZoneModel> zones) async {
    // First delete any existing zones for this device
    await _appDatabase.zonesDao.deleteZonesByDeviceId(deviceId);
    
    // Then save the new zones
    final zonesTable = ZonesTable.fromZonesList(deviceId, zones);
    await _appDatabase.zonesDao.insertZone(zonesTable);
  }
  
  Future<void> deleteZonesByDeviceId(int deviceId) async {
    await _appDatabase.zonesDao.deleteZonesByDeviceId(deviceId);
  }
  
  // Helper method to manually create the Scenario table if it doesn't exist
  Future<void> ensureScenarioTableExists() async {
    try {
      // Try a simple query to check if table exists
      await _appDatabase.scenarioDao.getAllScenarios();
    } catch (e) {
      if (e.toString().contains('no such table: Scenario')) {
        // Manually create the table if it doesn't exist
        try {
          final db = await _appDatabase.database;
          await db.execute(
            'CREATE TABLE IF NOT EXISTS `Scenario` (`id` INTEGER NOT NULL, `deviceId` INTEGER NOT NULL, `scenarioText1` TEXT NOT NULL, `scenarioText2` TEXT NOT NULL, `scenarioText3` TEXT NOT NULL, `scenarioText4` TEXT NOT NULL, `scenarioText5` TEXT NOT NULL, `scenarioText6` TEXT NOT NULL, `scenarioText7` TEXT NOT NULL, `scenarioText8` TEXT NOT NULL, `scenarioText9` TEXT NOT NULL, `scenarioText10` TEXT NOT NULL, `smsFormat` TEXT NOT NULL, `modeFormat` TEXT NOT NULL, PRIMARY KEY (`id`))'
          );
          print('Successfully created Scenario table');
        } catch (dbError) {
          print('Error creating Scenario table: $dbError');
        }
      }
    }
  }
  
  // Scenario related methods
  Future<Scenario?> getScenarioByDeviceId(int deviceId) async {
    await ensureScenarioTableExists();
    try {
      print('Attempting to get scenario for device ID: $deviceId');
      final scenario = await _appDatabase.scenarioDao.getScenarioByDeviceId(deviceId);
      if (scenario != null) {
        print('Found scenario for device $deviceId with ${scenario.toScenarioTextsList().length} texts');
      } else {
        print('No scenario found for device ID: $deviceId');
      }
      return scenario;
    } catch (e) {
      print('Error getting scenario by device ID: $e');
      // If there's still an issue, return null
      return null;
    }
  }
  
  Future<List<Scenario?>> getAllScenarios() async {
    await ensureScenarioTableExists();
    try {
      return await _appDatabase.scenarioDao.getAllScenarios();
    } catch (e) {
      // If there's still an issue, return empty list
      return [];
    }
  }

  Future<void> saveScenarios(int deviceId, List<String?> scenarioTexts, String smsFormat, String modeFormat) async {
    await ensureScenarioTableExists();
    
    try {
      // First try to delete any existing scenarios
      try {
        print('Attempting to delete existing scenarios for device ID: $deviceId');
        await _appDatabase.scenarioDao.deleteScenarioByDeviceId(deviceId);
        print('Successfully deleted existing scenarios for device ID: $deviceId');
      } catch (e) {
        print('Error deleting existing scenarios (continuing anyway): $e');
      }
      
      // Create a copy of the scenario texts to avoid modifying the original list
      List<String?> scenarioTextsCopy = List.from(scenarioTexts);
      print('Saving ${scenarioTextsCopy.length} scenarios for device ID: $deviceId');
      
      // Convert null values to empty strings
      List<String> safeTexts = scenarioTextsCopy.map((text) => text ?? '').toList();
      
      // Create a new scenario with auto-incrementing ID
      final scenario = Scenario(
        id: DateTime.now().millisecondsSinceEpoch, // Use timestamp as unique ID
        deviceId: deviceId,
        scenarioText1: safeTexts.length > 0 ? safeTexts[0] : '',
        scenarioText2: safeTexts.length > 1 ? safeTexts[1] : '',
        scenarioText3: safeTexts.length > 2 ? safeTexts[2] : '',
        scenarioText4: safeTexts.length > 3 ? safeTexts[3] : '',
        scenarioText5: safeTexts.length > 4 ? safeTexts[4] : '',
        scenarioText6: safeTexts.length > 5 ? safeTexts[5] : '',
        scenarioText7: safeTexts.length > 6 ? safeTexts[6] : '',
        scenarioText8: safeTexts.length > 7 ? safeTexts[7] : '',
        scenarioText9: safeTexts.length > 8 ? safeTexts[8] : '',
        scenarioText10: safeTexts.length > 9 ? safeTexts[9] : '',
        smsFormat: smsFormat,
        modeFormat: modeFormat,
      );
      
      // Insert the new scenario
      final id = await _appDatabase.scenarioDao.insertScenario(scenario);
      print('Successfully saved scenario for device ID: $deviceId, insert ID: $id');
      
      // Verify that the scenario was saved correctly
      final savedScenario = await getScenarioByDeviceId(deviceId);
      if (savedScenario != null) {
        print('Verification: Successfully retrieved saved scenario with ${savedScenario.toScenarioTextsList().length} texts');
      } else {
        print('Warning: Failed to verify saved scenario - not found after save');
      }
    } catch (e) {
      print('Error saving scenarios: $e');
      // Try to save again with a simpler approach as fallback
      try {
        print('Attempting fallback save method...');
        final scenario = Scenario(
          id: DateTime.now().millisecondsSinceEpoch,
          deviceId: deviceId,
          scenarioText1: scenarioTexts.isNotEmpty && scenarioTexts[0] != null ? scenarioTexts[0]! : '',
          scenarioText2: scenarioTexts.length > 1 && scenarioTexts[1] != null ? scenarioTexts[1]! : '',
          scenarioText3: scenarioTexts.length > 2 && scenarioTexts[2] != null ? scenarioTexts[2]! : '',
          scenarioText4: scenarioTexts.length > 3 && scenarioTexts[3] != null ? scenarioTexts[3]! : '',
          scenarioText5: scenarioTexts.length > 4 && scenarioTexts[4] != null ? scenarioTexts[4]! : '',
          scenarioText6: scenarioTexts.length > 5 && scenarioTexts[5] != null ? scenarioTexts[5]! : '',
          scenarioText7: scenarioTexts.length > 6 && scenarioTexts[6] != null ? scenarioTexts[6]! : '',
          scenarioText8: scenarioTexts.length > 7 && scenarioTexts[7] != null ? scenarioTexts[7]! : '',
          scenarioText9: scenarioTexts.length > 8 && scenarioTexts[8] != null ? scenarioTexts[8]! : '',
          scenarioText10: scenarioTexts.length > 9 && scenarioTexts[9] != null ? scenarioTexts[9]! : '',
          smsFormat: smsFormat,
          modeFormat: modeFormat,
        );
        
        final db = await _appDatabase.database;
        await db.insert('Scenario', scenario.toMap(), conflictAlgorithm: sqflite.ConflictAlgorithm.replace);
        print('Fallback save method successful');
      } catch (fallbackError) {
        print('Fallback save method also failed: $fallbackError');
      }
    }
  }
  
  Future<void> deleteScenarioByDeviceId(int deviceId) async {
    await ensureScenarioTableExists();
    try {
      await _appDatabase.scenarioDao.deleteScenarioByDeviceId(deviceId);
    } catch (e) {
      // Ignore errors
    }
  }
}
