import 'dart:convert';
import 'package:floor/floor.dart';
import '../../../views/zones/zone_settings/mobile/zone_mode_settings_view.dart';

@dao
abstract class ZonesDao {
  @Query('SELECT * FROM ZonesTable WHERE deviceId = :deviceId')
  Future<List<ZonesTable?>> getZones(int deviceId);
  
  @insert
  Future<void> insertZone(ZonesTable zone);
  
  @update
  Future<void> updateZone(ZonesTable zone);
  
  @delete
  Future<void> deleteZone(ZonesTable zone);
  
  @Query('DELETE FROM ZonesTable WHERE deviceId = :deviceId')
  Future<void> deleteZonesByDeviceId(int deviceId);
}

@Entity(tableName: 'ZonesTable')
class ZonesTable {
  @primaryKey
  final int id;
  
  final int deviceId;
  final String zonesJson;
  
  ZonesTable({
    required this.id,
    required this.deviceId,
    required this.zonesJson,
  });
  
  // Convert a list of ZoneModel to ZonesTable
  static ZonesTable fromZonesList(int deviceId, List<ZoneModel> zones) {
    final List<Map<String, dynamic>> zonesMapList = zones.map((zone) => {
      'id': zone.id,
      'name': zone.name,
      'connectionType': zone.connectionType,
      'conditions': zone.conditions,
    }).toList();
    
    return ZonesTable(
      id: deviceId, // Using deviceId as the primary key for simplicity
      deviceId: deviceId,
      zonesJson: jsonEncode(zonesMapList),
    );
  }
  
  // Convert ZonesTable to a list of ZoneModel
  List<ZoneModel> toZonesList() {
    final List<dynamic> decodedJson = jsonDecode(zonesJson);
    
    return decodedJson.map<ZoneModel>((item) => ZoneModel(
      id: item['id'],
      name: item['name'],
      connectionType: item['connectionType'],
      conditions: List<String>.from(item['conditions']),
    )).toList();
  }
} 