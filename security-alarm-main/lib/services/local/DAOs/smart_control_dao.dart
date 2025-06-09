import 'package:floor/floor.dart';

import '../../../models/smart_control.dart';

@dao
abstract class SmartControlDAO {
  @Query('SELECT * FROM smart_control')
  Future<List<SmartControl>> getAllSmartControls();

  @Query('SELECT * FROM smart_control WHERE deviceId = :deviceId')
  Future<List<SmartControl>> getSmartControlsByDeviceId(int deviceId);

  @Query('SELECT * FROM smart_control WHERE deviceId = :deviceId AND controlType = :controlType')
  Future<SmartControl?> getSmartControlByTypeAndDeviceId(int deviceId, String controlType);

  @insert
  Future<int> insertSmartControl(SmartControl smartControl);

  @update
  Future<int> updateSmartControl(SmartControl smartControl);

  @delete
  Future<int> deleteSmartControl(SmartControl smartControl);

  @Query('DELETE FROM smart_control WHERE deviceId = :deviceId')
  Future<void> deleteSmartControlsByDeviceId(int deviceId);
} 