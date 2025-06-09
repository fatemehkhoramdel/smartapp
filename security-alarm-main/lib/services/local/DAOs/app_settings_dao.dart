import 'package:floor/floor.dart';
import '../../../core/constants/database_constants.dart';

import '../../../models/app_settings.dart';

@dao
abstract class AppSettingsDAO {
  @Query('SELECT * FROM $kAppSettingsTable WHERE id = 1')
  Future<AppSettings?> getAppSettings();

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertAppSettings(AppSettings appSettings);

  @Update(onConflict: OnConflictStrategy.replace)
  Future<void> updateAppSettings(AppSettings appSettings);

  @delete
  Future<void> deleteAppSettings(AppSettings appSettings);
}
