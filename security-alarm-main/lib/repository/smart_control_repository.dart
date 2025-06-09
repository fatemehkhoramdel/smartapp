import '../models/smart_control.dart';
import '../services/local/app_database.dart';

class SmartControlRepository {
  final AppDatabase _db;

  SmartControlRepository(this._db);

  Future<List<SmartControl>> getAllSmartControls() async {
    return await _db.smartControlDao.getAllSmartControls();
  }

  Future<List<SmartControl>> getSmartControlsByDeviceId(int deviceId) async {
    return await _db.smartControlDao.getSmartControlsByDeviceId(deviceId);
  }

  Future<SmartControl?> getSmartControlByTypeAndDeviceId(int deviceId, String controlType) async {
    return await _db.smartControlDao.getSmartControlByTypeAndDeviceId(deviceId, controlType);
  }

  Future<int> saveSmartControl(SmartControl smartControl) async {
    // Try to find if a control with the same type and device ID exists
    final existingControl = await _db.smartControlDao.getSmartControlByTypeAndDeviceId(
      smartControl.deviceId,
      smartControl.controlType,
    );

    if (existingControl != null) {
      // Update the existing control
      final updatedControl = existingControl.copyWith(
        speakerEnabled: smartControl.speakerEnabled,
        remoteCodeEnabled: smartControl.remoteCodeEnabled,
        remoteEnabled: smartControl.remoteEnabled,
        relay1Enabled: smartControl.relay1Enabled,
        relay2Enabled: smartControl.relay2Enabled,
        relay3Enabled: smartControl.relay3Enabled,
        scenarioEnabled: smartControl.scenarioEnabled,
        activeMode: smartControl.activeMode,
      );
      return await _db.smartControlDao.updateSmartControl(updatedControl);
    } else {
      // Insert a new control
      return await _db.smartControlDao.insertSmartControl(smartControl);
    }
  }

  Future<int> updateSmartControl(SmartControl smartControl) async {
    return await _db.smartControlDao.updateSmartControl(smartControl);
  }

  Future<int> deleteSmartControl(SmartControl smartControl) async {
    return await _db.smartControlDao.deleteSmartControl(smartControl);
  }

  Future<void> deleteSmartControlsByDeviceId(int deviceId) async {
    await _db.smartControlDao.deleteSmartControlsByDeviceId(deviceId);
  }
} 