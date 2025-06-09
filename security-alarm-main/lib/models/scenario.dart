import 'package:floor/floor.dart';

@entity
class Scenario {
  @primaryKey
  final int id;
  
  final int deviceId;
  final String scenarioText1;
  final String scenarioText2;
  final String scenarioText3;
  final String scenarioText4;
  final String scenarioText5;
  final String scenarioText6;
  final String scenarioText7;
  final String scenarioText8;
  final String scenarioText9;
  final String scenarioText10;
  final String smsFormat;
  final String modeFormat;
  
  const Scenario({
    required this.id,
    required this.deviceId,
    this.scenarioText1 = '',
    this.scenarioText2 = '',
    this.scenarioText3 = '',
    this.scenarioText4 = '',
    this.scenarioText5 = '',
    this.scenarioText6 = '',
    this.scenarioText7 = '',
    this.scenarioText8 = '',
    this.scenarioText9 = '',
    this.scenarioText10 = '',
    required this.smsFormat,
    required this.modeFormat,
  });
  
  factory Scenario.fromMap(Map<String, dynamic> map) {
    return Scenario(
      id: map['id'] as int,
      deviceId: map['deviceId'] as int,
      scenarioText1: map['scenarioText1'] as String? ?? '',
      scenarioText2: map['scenarioText2'] as String? ?? '',
      scenarioText3: map['scenarioText3'] as String? ?? '',
      scenarioText4: map['scenarioText4'] as String? ?? '',
      scenarioText5: map['scenarioText5'] as String? ?? '',
      scenarioText6: map['scenarioText6'] as String? ?? '',
      scenarioText7: map['scenarioText7'] as String? ?? '',
      scenarioText8: map['scenarioText8'] as String? ?? '',
      scenarioText9: map['scenarioText9'] as String? ?? '',
      scenarioText10: map['scenarioText10'] as String? ?? '',
      smsFormat: map['smsFormat'] as String? ?? '',
      modeFormat: map['modeFormat'] as String? ?? '',
    );
  }
  
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'deviceId': deviceId,
      'scenarioText1': scenarioText1,
      'scenarioText2': scenarioText2,
      'scenarioText3': scenarioText3,
      'scenarioText4': scenarioText4,
      'scenarioText5': scenarioText5,
      'scenarioText6': scenarioText6,
      'scenarioText7': scenarioText7,
      'scenarioText8': scenarioText8,
      'scenarioText9': scenarioText9,
      'scenarioText10': scenarioText10,
      'smsFormat': smsFormat,
      'modeFormat': modeFormat,
    };
  }
  
  // Helper method to convert to list for backward compatibility
  List<String> toScenarioTextsList() {
    return [
      scenarioText1,
      scenarioText2,
      scenarioText3,
      scenarioText4,
      scenarioText5,
      scenarioText6,
      scenarioText7,
      scenarioText8,
      scenarioText9,
      scenarioText10,
    ].where((text) => text.isNotEmpty).toList();
  }
  
  // Helper method to create a Scenario from a list of texts
  static Scenario fromScenarioTextsList({
    required int id,
    required int deviceId,
    required List<String> texts,
    required String smsFormat,
    required String modeFormat,
  }) {
    return Scenario(
      id: id,
      deviceId: deviceId,
      scenarioText1: texts.length > 0 ? texts[0] : '',
      scenarioText2: texts.length > 1 ? texts[1] : '',
      scenarioText3: texts.length > 2 ? texts[2] : '',
      scenarioText4: texts.length > 3 ? texts[3] : '',
      scenarioText5: texts.length > 4 ? texts[4] : '',
      scenarioText6: texts.length > 5 ? texts[5] : '',
      scenarioText7: texts.length > 6 ? texts[6] : '',
      scenarioText8: texts.length > 7 ? texts[7] : '',
      scenarioText9: texts.length > 8 ? texts[8] : '',
      scenarioText10: texts.length > 9 ? texts[9] : '',
      smsFormat: smsFormat,
      modeFormat: modeFormat,
    );
  }
  
  // Number of non-empty scenario texts
  int get nonEmptyCount {
    return toScenarioTextsList().length;
  }
  
  // Debug method to print scenario info
  void debugPrint() {
    print('Scenario ID: $id, Device ID: $deviceId');
    print('SMS Format: $smsFormat');
    print('Mode Format: $modeFormat');
    print('Scenario Texts (${nonEmptyCount} non-empty):');
    if (scenarioText1.isNotEmpty) print('1: $scenarioText1');
    if (scenarioText2.isNotEmpty) print('2: $scenarioText2');
    if (scenarioText3.isNotEmpty) print('3: $scenarioText3');
    if (scenarioText4.isNotEmpty) print('4: $scenarioText4');
    if (scenarioText5.isNotEmpty) print('5: $scenarioText5');
    if (scenarioText6.isNotEmpty) print('6: $scenarioText6');
    if (scenarioText7.isNotEmpty) print('7: $scenarioText7');
    if (scenarioText8.isNotEmpty) print('8: $scenarioText8');
    if (scenarioText9.isNotEmpty) print('9: $scenarioText9');
    if (scenarioText10.isNotEmpty) print('10: $scenarioText10');
  }
  
  @override
  String toString() {
    return 'Scenario{id: $id, deviceId: $deviceId, texts: $nonEmptyCount, smsFormat: $smsFormat}';
  }
} 