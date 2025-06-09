import 'package:floor/floor.dart';

import '../../../core/constants/database_constants.dart';
import '../../../models/relay.dart';

@dao
abstract class RelayDAO {
  @Query("SELECT * FROM $kRelayTable WHERE device_id = :deviceId")
  Future<List<Relay?>> getRelays(int deviceId);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<int> insertRelay(Relay relay);

  @Update(onConflict: OnConflictStrategy.replace)
  Future<int> updateRelay(Relay relay);

  @delete
  Future<void> deleteRelay(Relay relay);
}
