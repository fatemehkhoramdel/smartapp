import 'package:floor/floor.dart';
import '../../../core/constants/database_constants.dart';
import '../../../models/audio_notification.dart';

@dao
abstract class AudioNotificationDAO {
  @Query("SELECT * FROM $kAudioNotificationTable WHERE deviceId = :deviceId")
  Future<AudioNotification?> getNotificationSettings(int deviceId);

  @Query("SELECT * FROM $kAudioNotificationTable")
  Future<List<AudioNotification?>> getAllNotificationSettings();

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<int> insertNotificationSettings(AudioNotification settings);

  @Update(onConflict: OnConflictStrategy.replace)
  Future<int> updateNotificationSettings(AudioNotification settings);

  @delete
  Future<void> deleteNotificationSettings(AudioNotification settings);
} 