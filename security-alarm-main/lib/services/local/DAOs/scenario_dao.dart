import 'package:floor/floor.dart';
import '../../../models/scenario.dart';

@dao
abstract class ScenarioDAO {
  @Query('SELECT * FROM Scenario WHERE deviceId = :deviceId')
  Future<Scenario?> getScenarioByDeviceId(int deviceId);
  
  @Query('SELECT * FROM Scenario')
  Future<List<Scenario?>> getAllScenarios();
  
  @Insert(onConflict: OnConflictStrategy.replace)
  Future<int> insertScenario(Scenario scenario);
  
  @Update(onConflict: OnConflictStrategy.replace)
  Future<int> updateScenario(Scenario scenario);
  
  @delete
  Future<void> deleteScenario(Scenario scenario);
  
  @Query('DELETE FROM Scenario WHERE deviceId = :deviceId')
  Future<void> deleteScenarioByDeviceId(int deviceId);
} 