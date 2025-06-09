import 'dart:io';

import 'package:flutter/material.dart';
import '../services/remote/flutter_sms_listener.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:security_alarm/widgets/dialogs/editable_dialog_widget.dart';

import '../core/constants/global_keys.dart';
import '../core/constants/sms_codes.dart';
import '../core/utils/enums.dart';
import '../core/utils/extensions.dart';
import '../core/utils/helper.dart';
import '../injector.dart';
import '../models/device.dart';
import '../repository/sms_repository.dart';
import 'main_provider.dart';
import '../views/zones/zone_settings/mobile/zone_mode_settings_view.dart';
import '../repository/cache_repository.dart';

class ZonesProvider extends ChangeNotifier {
  late MainProvider _mainProvider;
  List<String> zonesConditions = [];
  String? _errorMessage;
  
  // Store all zones (both default and dynamically added)
  List<ZoneModel> _allZones = [];

  ZonesProvider(MainProvider? mainProvider) {
    if (mainProvider != null) {
      _mainProvider = mainProvider;
      zonesConditions = [
        _mainProvider.selectedDevice.zone1Condition,
        _mainProvider.selectedDevice.zone2Condition,
        _mainProvider.selectedDevice.zone3Condition,
        _mainProvider.selectedDevice.zone4Condition,
        _mainProvider.selectedDevice.zone5Condition,
      ];
      
      // Initialize with default zones
      _initDefaultZones();
    }
  }
  
  /// Load zones from the database if available, otherwise initialize default zones
  Future<void> loadZones() async {
    if (_mainProvider.selectedDevice.id == null) return;
    
    try {
      // Try to load zones from database
      final savedZones = await injector<CacheRepository>().getZonesByDeviceId(_mainProvider.selectedDevice.id!);
      
      if (savedZones.isNotEmpty) {
        _allZones = savedZones;
        notifyListeners();
      } else {
        // If no saved zones found, initialize default zones
        _initDefaultZones();
      }
    } catch (e) {
      print('Error loading zones: $e');
      // If error, fall back to default zones
      _initDefaultZones();
    }
  }
  
  /// Save all zones to the database
  Future<void> saveZonesToDatabase() async {
    if (_mainProvider.selectedDevice.id == null) return;
    
    try {
      await injector<CacheRepository>().saveZones(_mainProvider.selectedDevice.id!, _allZones);
    } catch (e) {
      print('Error saving zones: $e');
      _errorMessage = 'Error saving zones: $e';
    }
  }
  
  // Initialize default zones from the device model
  void _initDefaultZones() {
    final device = _mainProvider.selectedDevice;
    
    _allZones = [
      // Add default wired zone (from zone1)
      ZoneModel(
        id: 1,
        name: device.zone1Name,
        connectionType: "wired",
        conditions: [device.zone1Condition],
      ),
      // Add default wireless zone (from zone2)
      ZoneModel(
        id: 2,
        name: device.zone2Name,
        connectionType: "wireless",
        conditions: [device.zone2Condition],
      ),
    ];
    
    // Add remaining zones if they exist
    if (device.zone3Name.isNotEmpty) {
      _allZones.add(ZoneModel(
        id: 3,
        name: device.zone3Name,
        connectionType: "wired", // Default to wired for existing zones
        conditions: [device.zone3Condition],
      ));
    }
    
    if (device.zone4Name.isNotEmpty) {
      _allZones.add(ZoneModel(
        id: 4,
        name: device.zone4Name,
        connectionType: "wired",
        conditions: [device.zone4Condition],
      ));
    }
    
    if (device.zone5Name.isNotEmpty) {
      _allZones.add(ZoneModel(
        id: 5,
        name: device.zone5Name,
        connectionType: "wired",
        conditions: [device.zone5Condition],
      ));
    }
  }
  
  // Get all zones
  List<ZoneModel> getAllZones() {
    return List.from(_allZones);
  }
  
  // Set all zones and save to database
  void setAllZones(List<ZoneModel> zones) {
    _allZones = List.from(zones);
    saveZonesToDatabase(); // Save to database
    notifyListeners();
  }
  
  // Add a new zone and save to database
  void addZone(ZoneModel zone) {
    _allZones.add(zone);
    saveZonesToDatabase(); // Save to database
    notifyListeners();
  }
  
  // Remove a zone and update database
  void removeZone(int zoneId) {
    _allZones.removeWhere((zone) => zone.id == zoneId);
    saveZonesToDatabase(); // Save to database
    notifyListeners();
  }
  
  // Update a zone and save to database
  void updateZone(ZoneModel updatedZone) {
    final index = _allZones.indexWhere((zone) => zone.id == updatedZone.id);
    if (index != -1) {
      _allZones[index] = updatedZone;
      saveZonesToDatabase(); // Save to database
      notifyListeners();
    }
  }

  Future updateZoneNames(List<TextEditingController> zonesNameTECList) async {
    Navigator.pop(kNavigatorKey.currentContext!);
    showLoadingDialog();
    Device tempDevice = _mainProvider.selectedDevice.copyWith(
      zone1Name: zonesNameTECList[0].text,
      zone2Name: zonesNameTECList[1].text,
      zone3Name: zonesNameTECList[2].text,
      zone4Name: zonesNameTECList[3].text,
      zone5Name: zonesNameTECList[4].text,
    );
    
    // Update names in our all zones list too
    for (int i = 0; i < 5 && i < _allZones.length; i++) {
      int zoneId = i + 1;
      final index = _allZones.indexWhere((zone) => zone.id == zoneId);
      if (index != -1 && i < zonesNameTECList.length) {
        _allZones[index] = ZoneModel(
          id: _allZones[index].id,
          name: zonesNameTECList[i].text,
          connectionType: _allZones[index].connectionType,
          conditions: _allZones[index].conditions,
        );
      }
    }
    
    // Save updated zones to database
    await saveZonesToDatabase();
    
    final result = await _mainProvider.updateDevice(tempDevice);
    result.fold(
      (l) => toastGenerator(l),
      (r) => toastGenerator(translate('zone_saved_successfully')),
    );
    
    await hideLoadingDialog();
    notifyListeners();
  }

  Future updateZoneCondition(
    int zoneIndex,
    String? newValue,
  ) async {
    if (newValue == null && zonesConditions[zoneIndex] == newValue) {
      return;
    }
    var smsCode = smsCodeGenerator(
      _mainProvider.selectedDevice.devicePassword,
      'Z${zoneIndex + 1}${ZoneConditionExt.code(newValue!)}',
    );
    final sendSMSResult = await injector<SMSRepository>().doSendSMS(
      message: smsCode,
      phoneNumber: _mainProvider.selectedDevice.devicePhone,
      smsCoolDownFinished: _mainProvider.smsCooldownFinished,
      isManager: _mainProvider.selectedDevice.isManager,
    );
    sendSMSResult.fold(
      (l) => toastGenerator(l),
      (r) async {
        _mainProvider.startSMSCooldown();
        Device tempDevice = _mainProvider.selectedDevice.copyWith(
          zone1Condition: zoneIndex == 0
              ? newValue
              : _mainProvider.selectedDevice.zone1Condition,
          zone2Condition: zoneIndex == 1
              ? newValue
              : _mainProvider.selectedDevice.zone2Condition,
          zone3Condition: zoneIndex == 2
              ? newValue
              : _mainProvider.selectedDevice.zone3Condition,
          zone4Condition: zoneIndex == 3
              ? newValue
              : _mainProvider.selectedDevice.zone4Condition,
          zone5Condition: zoneIndex == 4
              ? newValue
              : _mainProvider.selectedDevice.zone5Condition,
        );
        
        final result = await _mainProvider.updateDevice(tempDevice);
        result.fold(
          (l) => toastGenerator(l),
          (r) {
            zonesConditions = [...zonesConditions];
            zonesConditions[zoneIndex] = newValue;
          },
        );
      },
    );
  }

  Future removeZoneFromDevice(int zoneIndex) async {
    var smsCode = smsCodeGenerator(
      _mainProvider.selectedDevice.devicePassword,
      'Z${zoneIndex + 1}T',
    );
    final sendSMSResult = await injector<SMSRepository>().doSendSMS(
      message: smsCode,
      phoneNumber: _mainProvider.selectedDevice.devicePhone,
      smsCoolDownFinished: _mainProvider.smsCooldownFinished,
      isManager: _mainProvider.selectedDevice.isManager,
    );
    sendSMSResult.fold(
      (l) => toastGenerator(l),
      (r) async {
        _mainProvider.startSMSCooldown();
      },
    );
  }

  Future getZonesFromDevice(TextEditingController inquiryDialogTEC) async {
    var smsCode = smsCodeGenerator(
      _mainProvider.selectedDevice.devicePassword,
      kZoneInquiryCode,
    );
    final sendSMSResult = await injector<SMSRepository>().doSendSMS(
      message: smsCode,
      phoneNumber: _mainProvider.selectedDevice.devicePhone,
      smsCoolDownFinished: _mainProvider.smsCooldownFinished,
      isManager: _mainProvider.selectedDevice.isManager,
    );
    sendSMSResult.fold(
      (l) => toastGenerator(l),
      (r) async {
        _mainProvider.startSMSCooldown();
        if (Platform.isAndroid) {
          rootScaffoldMessengerKey.currentState!.hideCurrentSnackBar();
          snackbarGenerator(
            translate('waiting_for_inquiry'),
          );
          _mainProvider.smsListener.onSmsReceived!.listen(
            (SmsMessage message) async => _processRecievedZonesSMS(
              message,
            ),
          );
        } else if (Platform.isIOS) {
          await dialogGenerator(
            translate('inquiry_sms_content'),
            '',
            contentWidget: EditableDialogWidget(
              controller: inquiryDialogTEC,
              textDirection: TextDirection.ltr,
              contentText: translate('inquiry_sms_content_description'),
              hintText: translate('inquiry_sms_content'),
              maxLength: 500,
            ),
            onPressCancel: () {
              inquiryDialogTEC.clear();
              Navigator.pop(kNavigatorKey.currentContext!);
            },
            onPressAccept: () async {
              await _processRecievedZonesSMS(
                SmsMessage(
                  address: _mainProvider.selectedDevice.devicePhone,
                  body: inquiryDialogTEC.text,
                ),
              );
              inquiryDialogTEC.clear();
              Navigator.pop(kNavigatorKey.currentContext!);
            },
          );
        }
      },
    );
  }

  Future _processRecievedZonesSMS(SmsMessage message) async {
    if (message.address == null ||
        !message.address!.contains(
          _mainProvider.selectedDevice.devicePhone.substring(1),
        ) ||
        message.body == null) {
      return;
    }
    String messageBody = message.body!;
    List<int> detectionSymbols = _countDetectionSymbols(messageBody);
    List<String> zonesConditions = [
      _mainProvider.selectedDevice.zone1Condition,
      _mainProvider.selectedDevice.zone2Condition,
      _mainProvider.selectedDevice.zone3Condition,
      _mainProvider.selectedDevice.zone4Condition,
      _mainProvider.selectedDevice.zone5Condition,
    ];
    for (int y = 0; y < detectionSymbols.length; y++) {
      if (y + 1 != detectionSymbols.length) {
        String tempSubString = messageBody.substring(
          detectionSymbols[y],
          detectionSymbols[y + 1],
        );
        int indexOfZoneList = tempSubString.contains('1')
            ? 0
            : tempSubString.contains('2')
                ? 1
                : tempSubString.contains('3')
                    ? 2
                    : tempSubString.contains('4')
                        ? 3
                        : tempSubString.contains('5')
                            ? 4
                            : 0;
        String tZoneCondition = tempSubString.contains('N')
            ? ZoneCondition.normalyClose.value
            : tempSubString.contains('O')
                ? ZoneCondition.normalyOpen.value
                : tempSubString.contains('H')
                    ? ZoneCondition.fullHour.value
                    : tempSubString.contains('D')
                        ? ZoneCondition.dingDong.value
                        : tempSubString.contains('G')
                            ? ZoneCondition.guard.value
                            : ZoneCondition.normalyClose.value;
        zonesConditions[indexOfZoneList] = tZoneCondition;
      } else {
        String tempSubString = messageBody.substring(detectionSymbols[y]);
        int indexOfZoneList = tempSubString.contains('1')
            ? 0
            : tempSubString.contains('2')
                ? 1
                : tempSubString.contains('3')
                    ? 2
                    : tempSubString.contains('4')
                        ? 3
                        : tempSubString.contains('5')
                            ? 4
                            : 0;
        String tZoneCondition = tempSubString.contains('N')
            ? ZoneCondition.normalyClose.value
            : tempSubString.contains('O')
                ? ZoneCondition.normalyOpen.value
                : tempSubString.contains('H')
                    ? ZoneCondition.fullHour.value
                    : tempSubString.contains('D')
                        ? ZoneCondition.dingDong.value
                        : tempSubString.contains('G')
                            ? ZoneCondition.guard.value
                            : ZoneCondition.normalyClose.value;
        zonesConditions[indexOfZoneList] = tZoneCondition;
      }
    }
    final deviceUpdateResult = await _mainProvider.updateDevice(
      _mainProvider.selectedDevice.copyWith(
        zone1Condition: zonesConditions[0],
        zone2Condition: zonesConditions[1],
        zone3Condition: zonesConditions[2],
        zone4Condition: zonesConditions[3],
        zone5Condition: zonesConditions[4],
      ),
    );
    
    deviceUpdateResult.fold(
      (l) => toastGenerator(l),
      (r) {
        // Update was successful, display success message if needed
      },
    );
    
    rootScaffoldMessengerKey.currentState!.hideCurrentSnackBar();
  }

  List<int> _countDetectionSymbols(String messageBody) {
    List<int> detectionSymbols = [];
    for (int i = 0; i < messageBody.length; i++) {
      if (messageBody[i] == '*') {
        detectionSymbols.add(i);
      }
    }
    return detectionSymbols;
  }

  /// Updates the zone condition in the device directly
  Future<void> updateZoneConditionDirect(int zoneNumber, String condition) async {
    Device? currentDevice = _mainProvider.selectedDevice;

    switch (zoneNumber) {
      case 1:
        currentDevice = currentDevice.copyWith(zone1Condition: condition);
        break;
      case 2:
        currentDevice = currentDevice.copyWith(zone2Condition: condition);
        break;
      case 3:
        currentDevice = currentDevice.copyWith(zone3Condition: condition);
        break;
      case 4:
        currentDevice = currentDevice.copyWith(zone4Condition: condition);
        break;
      case 5:
        currentDevice = currentDevice.copyWith(zone5Condition: condition);
        break;
    }

    final deviceRes = await _mainProvider.updateDevice(currentDevice);
    deviceRes.fold(
      (l) => _errorMessage = l,
      (r) => zonesConditions = [r.zone1Condition, r.zone2Condition, r.zone3Condition, r.zone4Condition, r.zone5Condition],
    );
    notifyListeners();
  }

  /// Combines multiple zone conditions (like dingDong with other conditions)
  Future<void> combineZoneConditions(int zoneIndex, List<String> conditions) async {
    if (conditions.isEmpty) return;
    
    // If we have only one condition, just update directly
    if (conditions.length == 1) {
      await updateZoneCondition(zoneIndex, conditions.first);
      return;
    }
    
    // For now, just use the first condition and handle dingDong separately
    // This could be expanded with more complex logic in the future
    bool hasDingDong = conditions.contains(ZoneCondition.dingDong.value);
    String mainCondition = conditions.firstWhere((c) => c != ZoneCondition.dingDong.value, 
      orElse: () => ZoneCondition.normalyClose.value);
    
    // Todo: Implement proper condition combination logic based on device capabilities
    await updateZoneCondition(zoneIndex, hasDingDong ? ZoneCondition.dingDong.value : mainCondition);
  }

  /// Updates the semi-active status of a specific zone
  Future<void> updateSemiActiveZone(int zoneNumber, bool isActive) async {
    Device? currentDevice = _mainProvider.selectedDevice;

    switch (zoneNumber) {
      case 1:
        currentDevice = currentDevice.copyWith(zone1SemiActive: isActive);
        break;
      case 2:
        currentDevice = currentDevice.copyWith(zone2SemiActive: isActive);
        break;
      case 3:
        currentDevice = currentDevice.copyWith(zone3SemiActive: isActive);
        break;
      case 4:
        currentDevice = currentDevice.copyWith(zone4SemiActive: isActive);
        break;
      case 5:
        currentDevice = currentDevice.copyWith(zone5SemiActive: isActive);
        break;
    }

    _mainProvider.selectedDevice = currentDevice;
    notifyListeners();
  }

  /// Saves all semi-active zone changes to the database
  Future<void> saveSemiActiveZoneChanges() async {
    Device? currentDevice = _mainProvider.selectedDevice;

    try {
      // Format SMS for semi-active zones
      String formattedSMS = formatSemiActiveZoneSMS();
      
      // Send the SMS with semi-active zone information
      var smsCode = smsCodeGenerator(
        currentDevice.devicePassword,
        formattedSMS,
      );
      
      final result = await injector<SMSRepository>().doSendSMS(
        message: smsCode,
        phoneNumber: currentDevice.devicePhone,
        smsCoolDownFinished: _mainProvider.smsCooldownFinished,
        isManager: currentDevice.isManager,
      );
      
      result.fold(
        (l) {
          _errorMessage = 'SMS Error: $l';
          toastGenerator('Failed to send semi-active zones SMS: $l');
        },
        (r) async {
          _mainProvider.startSMSCooldown();
          
          try {
            // Update device in the database
            final deviceRes = await _mainProvider.updateDevice(currentDevice);
            
            deviceRes.fold(
              (l) {
                _errorMessage = l;
                toastGenerator('Failed to update device: $l');
              },
              (r) {
                _mainProvider.selectedDevice = r;
                
                // Update our zone models with the new semi-active states
                _updateZonesSemiActiveStates(r);
                
                // Save updated zones to database
                if (r.id != null) {
                  saveZonesToDatabase();
                }
                
                toastGenerator(translate('semi_active_zones_saved_successfully'));
              },
            );
          } catch (e) {
            // Handle any exceptions during updateDevice
            _errorMessage = 'Error updating device: $e';
            toastGenerator('Failed to update device: $e');
          }
        },
      );
    } catch (e) {
      toastGenerator('Error in saveSemiActiveZoneChanges: $e');
    }
    
    notifyListeners();
  }

  // Helper method to format SMS for semi-active zones
  String formatSemiActiveZoneSMS() {
    // Format: ZoneHalf=1010101010/
    // First 6 bits = wired zones, Last 4 bits = wireless zones
    Device device = _mainProvider.selectedDevice;
    List<ZoneModel> allZones = getAllZones();
    
    String formattedSMS = "ZoneHalf=";
    
    // Get all wired zones (up to 6)
    List<ZoneModel> wiredZones = allZones
        .where((zone) => zone.connectionType == "wired")
        .toList();
        
    // Get all wireless zones (up to 4)
    List<ZoneModel> wirelessZones = allZones
        .where((zone) => zone.connectionType == "wireless")
        .toList();
    
    // Add bits for wired zones (up to 6)
    for (int i = 0; i < 6; i++) {
      bool isActive = false;
      if (i < wiredZones.length) {
        int zoneId = wiredZones[i].id;
        if (zoneId <= 5) {
          // Get semi-active state from device model for zones 1-5
          switch (zoneId) {
            case 1: isActive = device.zone1SemiActive; break;
            case 2: isActive = device.zone2SemiActive; break;
            case 3: isActive = device.zone3SemiActive; break;
            case 4: isActive = device.zone4SemiActive; break;
            case 5: isActive = device.zone5SemiActive; break;
          }
        }
      }
      formattedSMS += isActive ? "1" : "0";
    }
    
    // Add bits for wireless zones (up to 4)
    for (int i = 0; i < 4; i++) {
      bool isActive = false;
      if (i < wirelessZones.length) {
        int zoneId = wirelessZones[i].id;
        if (zoneId <= 5) {
          // Get semi-active state from device model for zones 1-5
          switch (zoneId) {
            case 1: isActive = device.zone1SemiActive; break;
            case 2: isActive = device.zone2SemiActive; break;
            case 3: isActive = device.zone3SemiActive; break;
            case 4: isActive = device.zone4SemiActive; break;
            case 5: isActive = device.zone5SemiActive; break;
          }
        }
      }
      formattedSMS += isActive ? "1" : "0";
    }
    
    // End with /
    formattedSMS += "/";
    
    return formattedSMS;
  }

  // Helper method to update zone semi-active states from Device
  void _updateZonesSemiActiveStates(Device device) {
    // For zones with ids 1-5, update their semi-active state metadata 
    // (we could store this in the conditions or as a custom property)
    // For now, we're just updating the Device model, which is already done
    // This method is a placeholder for future enhancements where we might 
    // want to store semi-active state in the ZoneModel
  }

  /// Updates multiple zone conditions at once using the device's properties
  Future<void> updateZoneConditionBatch(Device device) async {
    try {
      // Validate device and phone number
      if (device.devicePhone.isEmpty) {
        toastGenerator('Cannot update: Device phone number is empty');
        return;
      }
      
      // Format SMS according to required pattern
      String formattedSMS = formatZoneSMS();
      
      // Send the SMS with all zone information
      var smsCode = smsCodeGenerator(
        device.devicePassword,
        formattedSMS,
      );
      
      final result = await injector<SMSRepository>().doSendSMS(
        message: smsCode,
        phoneNumber: device.devicePhone,
        smsCoolDownFinished: _mainProvider.smsCooldownFinished,
        isManager: device.isManager,
      );
      
      result.fold(
        (l) {
          _errorMessage = 'SMS Error: $l';
          toastGenerator('Failed to send update SMS: $l');
        },
        (r) async {
          _mainProvider.startSMSCooldown();
          
          try {
            // Update device and handle the result
            final deviceRes = await _mainProvider.updateDevice(device);
            
            // Use fold to handle the Either result
            deviceRes.fold(
              (l) {
                _errorMessage = l;
                toastGenerator('Failed to update device: $l');
              },
              (r) {
                // Update local zones conditions
                zonesConditions = [
                  r.zone1Condition,
                  r.zone2Condition,
                  r.zone3Condition,
                  r.zone4Condition,
                  r.zone5Condition,
                ];
                
                // Ensure zone condition changes are reflected in _allZones
                _updateZonesFromDevice(r);
                
                // Save updated zones to database
                if (r.id != null) {
                  saveZonesToDatabase();
                }
              },
            );
          } catch (e) {
            // Handle any exceptions during updateDevice
            _errorMessage = 'Error updating device: $e';
            toastGenerator('Failed to update device: $e');
          }
          
          notifyListeners();
        },
      );
    } catch (e) {
      toastGenerator('Error in updateZoneConditionBatch: $e');
    }
  }
  
  // Helper method to format SMS with zones data
  String formatZoneSMS() {
    // Sort zones by ID for consistent order
    List<ZoneModel> sortedZones = List.from(_allZones)..sort((a, b) => a.id.compareTo(b.id));
    
    // Format the SMS
    String formattedSMS = "Zmode=";
    
    // Add zone mode letters for main modes (A, B, C, D, Z) - for up to 5 zones
    for (int i = 0; i < 5; i++) {
      if (i < sortedZones.length) {
        formattedSMS += _getZoneModeCode(_getMainMode(sortedZones[i].conditions));
      } else {
        formattedSMS += "Z"; // Default to inactive for missing zones
      }
    }
    
    // Add zone numbers part
    formattedSMS += "/Zno=";
    for (int i = 0; i < 5; i++) {
      formattedSMS += (i < sortedZones.length) ? "1" : "0";
    }
    
    // Add ding dong part
    formattedSMS += "/Dingdang=";
    for (int i = 0; i < 5; i++) {
      if (i < sortedZones.length) {
        formattedSMS += sortedZones[i].conditions.contains(ZoneCondition.dingDong.value) ? "1" : "0";
      } else {
        formattedSMS += "0"; // Default for missing zones
      }
    }
    
    return formattedSMS;
  }
  
  // Helper to get main mode from conditions
  String _getMainMode(List<String> conditions) {
    // Filter out ding dong mode to get the main mode
    List<String> mainModes = conditions.where(
      (mode) => mode != ZoneCondition.dingDong.value
    ).toList();
    
    // Return the first main mode or default to normal mode if none found
    return mainModes.isNotEmpty ? mainModes.first : ZoneCondition.normalyClose.value;
  }
  
  // Helper to convert zone condition to letter code
  String _getZoneModeCode(String zoneCondition) {
    if (zoneCondition == ZoneCondition.normalyClose.value || 
        zoneCondition == ZoneCondition.normalyOpen.value) {
      return "A"; // Immediate (فوری)
    } else if (zoneCondition == ZoneCondition.fullHour.value) {
      return "B"; // 24 hours (24 ساعته)
    } else if (zoneCondition == ZoneCondition.hiddenSMS.value) {
      return "C"; // Hidden SMS (مخفی پیامک)
    } else if (zoneCondition == ZoneCondition.hiddenCall.value) {
      return "D"; // Hidden call (مخفی تماس)
    } else if (zoneCondition == ZoneCondition.inactive.value) {
      return "Z"; // Disabled (غیرفعال)
    } else {
      return "A"; // Default to immediate mode
    }
  }
  
  // Update _allZones from device
  void _updateZonesFromDevice(Device device) {
    // Find zones with ids 1-5 and update their conditions from device
    for (int i = 0; i < 5; i++) {
      final index = _allZones.indexWhere((zone) => zone.id == i + 1);
      if (index != -1) {
        String condition;
        switch (i) {
          case 0:
            condition = device.zone1Condition;
            break;
          case 1:
            condition = device.zone2Condition;
            break;
          case 2:
            condition = device.zone3Condition;
            break;
          case 3:
            condition = device.zone4Condition;
            break;
          case 4:
            condition = device.zone5Condition;
            break;
          default:
            condition = ZoneCondition.fullHour.value;
        }
        
        // Preserve ding dong state when updating
        List<String> conditions = List.from(_allZones[index].conditions);
        bool hasDingDong = conditions.contains(ZoneCondition.dingDong.value);
        
        // Remove all conditions except ding dong if it exists
        conditions.removeWhere((mode) => mode != ZoneCondition.dingDong.value);
        
        // Add the new condition
        if (!conditions.contains(condition)) {
          conditions.add(condition);
        }
        
        // Update the zone
        _allZones[index] = ZoneModel(
          id: _allZones[index].id,
          name: _allZones[index].name,
          connectionType: _allZones[index].connectionType,
          conditions: conditions,
        );
      }
    }
  }

  /// Update provider state when the selected device changes
  Future<void> updateForSelectedDevice(Device device) async {
    // Update device-specific data
    zonesConditions = [
      device.zone1Condition,
      device.zone2Condition,
      device.zone3Condition,
      device.zone4Condition,
      device.zone5Condition,
    ];
    
    // Load zones from database for this device
    if (device.id != null) {
      try {
        final savedZones = await injector<CacheRepository>().getZonesByDeviceId(device.id!);
        
        if (savedZones.isNotEmpty) {
          _allZones = savedZones;
        } else {
          // Reset to default zones based on new device
          _initDefaultZones();
        }
        
        notifyListeners();
      } catch (e) {
        print('Error loading zones for device: $e');
        // Fall back to default initialization
        _initDefaultZones();
        notifyListeners();
      }
    }
  }
}
