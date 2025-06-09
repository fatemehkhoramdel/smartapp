import 'package:floor/floor.dart';
import '../../../core/constants/database_constants.dart';

import '../../../models/device.dart';

@dao
abstract class DeviceDAO {
  @Query("SELECT * FROM $kDeviceTable WHERE id = :id")
  Future<Device?> getDevice(int id);

  @Query("SELECT * FROM $kDeviceTable")
  Future<List<Device?>> getAllDevices();

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<int> insertDevice(Device device);

  @Update(onConflict: OnConflictStrategy.replace)
  Future<int> updateDevice(Device device);

  @delete
  Future<void> deleteDevice(Device device);
}
