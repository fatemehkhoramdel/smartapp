import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../services/remote/flutter_sms_listener.dart';
import 'package:supercharged/supercharged.dart';
import 'package:dartz/dartz.dart';

import '../core/constants/constants.dart';
import '../injector.dart';
import '../models/app_settings.dart';
import '../models/device.dart';
import '../models/relay.dart';
import '../repository/cache_repository.dart';
import 'zones_provider.dart';

class MainProvider extends ChangeNotifier {
  List<Device> devices = <Device>[];
  List<Relay> relays = <Relay>[];
  late Device selectedDevice;
  late AppSettings appSettings;
  //SharedPreferences? _sharedPreferences;
  bool smsCooldownFinished = true;
  FlutterSmsListener smsListener = FlutterSmsListener();
  int get deviceListLength => devices.length;

  ZonesProvider? _zonesProvider;
  
  void setZonesProvider(ZonesProvider zonesProvider) {
    _zonesProvider = zonesProvider;
  }

  void setSelectedDevice() {
    try {
      // Check if devices list is not empty and index is valid
      if (devices.isEmpty) {
        debugPrint('Error: Devices list is empty in setSelectedDevice');
        return;
      }
      
      int index = appSettings.selectedDeviceIndex;
      
      // Ensure index is valid
      if (index < 0 || index >= devices.length) {
        debugPrint('Error: Invalid device index $index, resetting to 0');
        index = 0;
        appSettings = appSettings.copyWith(selectedDeviceIndex: 0);
      }
      
      selectedDevice = devices[index];
    } catch (e) {
      debugPrint('Error in setSelectedDevice: $e');
      // If there's an error, try to recover by setting to the first device if available
      if (devices.isNotEmpty) {
        selectedDevice = devices[0];
      }
    }
  }

  Future<void> selectDevice(Device device) async {
    try {
      // Check if devices list is initialized and not empty
      if (devices.isEmpty) {
        debugPrint('Error: Devices list is empty');
        return;
      }

      int deviceIndex = devices.indexWhere((d) => d.id == device.id);
      if (deviceIndex == -1) {
        debugPrint('Error: Device not found in the list');
        return;
      }
      
      selectedDevice = device;
      
      appSettings = appSettings.copyWith(selectedDeviceIndex: deviceIndex);
      await injector<CacheRepository>().updateAppSettings(appSettings);
      
      if (device.id != null) {
        await getAllRelays();
        
        // Update zones provider if available
        if (_zonesProvider != null) {
          await _zonesProvider!.updateForSelectedDevice(device);
        }
      } else {
        relays.clear();
      }
      
      notifyListeners();
    } catch (e) {
      debugPrint('Error in selectDevice: $e');
    }
  }

  Future insertAppSettings(AppSettings newAppSettings) async {
    appSettings = newAppSettings;
    await injector<CacheRepository>().insertAppSettings(newAppSettings);
    notifyListeners();
    /* await initSP();
    appSettings = newValue;
    String json = jsonEncode(newValue);
    await _sharedPreferences!.setString(APP_SETTING, json); */
  }

  Future insertDevice(Device device) async {
    devices.add(device);
    await injector<CacheRepository>().insertDevice(device);
    notifyListeners();
    /* await initSP();
    deviceList.add(device);
    var json = jsonEncode(deviceList);
    await _sharedPreferences!.setString(DEVICE_DETAIL_LIST, json);
    notifyListeners(); */
  }

  Future insertRelay(Relay relay) async {
    relays.add(relay);
    await injector<CacheRepository>().insertRelay(relay);
    /* await initSP();
    deviceList.add(device);
    var json = jsonEncode(deviceList);
    await _sharedPreferences!.setString(DEVICE_DETAIL_LIST, json);
    notifyListeners(); */
  }

  Future updateAppSettings(AppSettings newAppSettings) async {
    appSettings = newAppSettings;
    await injector<CacheRepository>().updateAppSettings(newAppSettings);
    notifyListeners();
    /* await initSP();
    appSettings = newValue;
    String json = jsonEncode(newValue);
    await _sharedPreferences!.setString(APP_SETTING, json); */
  }

  Future<Either<String, Device>> updateDevice(Device device) async {
    try {
      // await initSP();
      devices[devices.indexOf(selectedDevice)] = device;
      setSelectedDevice();
      final result = await injector<CacheRepository>().updateDevice(device);
      if (result > 0) {
        /* var json = jsonEncode(deviceList);
        await _sharedPreferences!.setString(DEVICE_DETAIL_LIST, json); */
        notifyListeners();
        return Right(device);
      } else {
        return Left('Failed to update device');
      }
    } catch (e) {
      debugPrint('Error updating device: $e');
      return Left('Error updating device: $e');
    }
  }

  Future updateRelay(Relay relay) async {
    await injector<CacheRepository>().updateRelay(relay);
    await getAllRelays();
  }

  Future deleteRelay(Relay relay) async {
    await injector<CacheRepository>().deleteRelay(relay);
    relays.removeWhere((r) => r.id == relay.id);
    notifyListeners();
  }

  Future removeDevice(int index) async {
    // Get the device ID before removal
    int? deviceIdToRemove = devices[index].id;
    
    appSettings = appSettings.copyWith(selectedDeviceIndex: 0);
    selectedDevice = devices[0];
    await injector<CacheRepository>().updateAppSettings(appSettings);
    
    // Delete all relays for this device
    for (int i = 0; i < relays.length; i++) {
      await injector<CacheRepository>().deleteRelay(relays[i]);
    }
    
    // Delete all zones for this device
    if (deviceIdToRemove != null) {
      await injector<CacheRepository>().deleteZonesByDeviceId(deviceIdToRemove);
    }
    
    // Delete the device itself
    await injector<CacheRepository>().deleteDevice(devices[index]);
    devices.removeAt(index);
    /* var json = jsonEncode(deviceList);
    await _sharedPreferences!.setString(DEVICE_DETAIL_LIST, json); */
    notifyListeners();
  }

  Future getAppSettings() async {
    appSettings = await injector<CacheRepository>().getAppSettings() ??
        const AppSettings();
    notifyListeners();
    /* await initSP();
    String? jsonFromSP = _sharedPreferences!.getString(key);
    if (jsonFromSP != null) {
      String tempJsonAppSettings = jsonDecode(jsonFromSP) as String;
      appSettings = AppSettings.fromJson(tempJsonAppSettings);
    } else {
      appSettings = const AppSettings();
    }
    notifyListeners(); */
  }

  Future getAllDevices() async {
    final tempDevices = await injector<CacheRepository>().getAllDevices();
    if (tempDevices.isNotEmpty) {
      devices.clear();
      for (var device in tempDevices) {
        if (device != null) {
          devices.add(device);
        }
      }
    }
    /* await initSP();
    String? jsonFromSP = _sharedPreferences!.getString(key);
    if (jsonFromSP != null) {
      var tempJsonDeviceList = jsonDecode(jsonFromSP);
      List<Device> tempDeviceList = List.empty(growable: true);
      for (final String item in tempJsonDeviceList) {
        tempDeviceList.add(Device.fromJson(item));
      }
      deviceList = tempDeviceList;
    } else {
      deviceList = [
        const Device(zones: [], relays: [], contacts: []),
      ];
    }
    notifyListeners(); */
  }

  Future getAllRelays() async {
    if (selectedDevice.id == null) {
      debugPrint('Error: Device ID is null');
      return;
    }
    
    final tempRelays = await injector<CacheRepository>().getRelays(
      selectedDevice.id!,
    );
    if (tempRelays.isNotEmpty) {
      relays.clear();
      for (var relay in tempRelays) {
        if (relay != null) {
          relays = [...relays];
          relays.add(relay);
        }
      }
      notifyListeners();
    }
  }

  /* Future initSP() async {
    _sharedPreferences ??= await SharedPreferences.getInstance();
  } */

  void startSMSCooldown() {
    smsCooldownFinished = false;
    Timer(kSMSCooldown.seconds, () {
      smsCooldownFinished = true;
    });
  }
}
