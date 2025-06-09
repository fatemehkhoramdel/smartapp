import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:security_alarm/providers/main_provider.dart';

import '../injector.dart';
import '../models/device.dart';
import '../repository/cache_repository.dart';

class GeneralSettingsProvider extends ChangeNotifier {
  final Device? device;
  
  bool _isLoading = false;
  bool _isSaving = false;
  String? _errorMessage;
  
  // Settings
  double _alarmDuration = 120; // Default 120 seconds
  double _callDuration = 10; // Default 10 seconds
  bool _controlRelaysWithRemote = true;
  bool _monitoring = false;
  bool _remoteReporting = true;
  bool _scenarioScheduleReporting = true;
  bool _callPriority = true;
  bool _smsPriority = false;
  
  // Getters
  bool get isLoading => _isLoading;
  bool get isSaving => _isSaving;
  String? get errorMessage => _errorMessage;
  double get alarmDuration => _alarmDuration;
  double get callDuration => _callDuration;
  bool get controlRelaysWithRemote => _controlRelaysWithRemote;
  bool get monitoring => _monitoring;
  bool get remoteReporting => _remoteReporting;
  bool get scenarioScheduleReporting => _scenarioScheduleReporting;
  bool get callPriority => _callPriority;
  bool get smsPriority => _smsPriority;
  
  GeneralSettingsProvider(this.device) {
    _loadSettings();
  }
  
  // Load settings from device model
  Future<void> _loadSettings() async {
    if (device == null) return;
    
    _isLoading = true;
    notifyListeners();
    
    try {
      // In a real implementation, you would load these values from the device model
      // For now, we'll use default values
      _alarmDuration = device?.alarmDuration.toDouble() ?? 120;
      _callDuration = device?.callDuration.toDouble() ?? 10;
      _controlRelaysWithRemote = device?.controlRelaysWithRemote ?? true;
      _monitoring = device?.monitoring ?? false;
      _remoteReporting = device?.remoteReporting ?? true;
      _scenarioScheduleReporting = device?.scenarioReporting ?? true;
      _callPriority = device?.callPriority ?? true;
      _smsPriority = device?.smsPriority ?? false;
    } catch (e) {
      _errorMessage = e.toString();
      debugPrint('Error loading general settings: $_errorMessage');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  // Update individual settings
  void setAlarmDuration(double value) {
    _alarmDuration = value;
    notifyListeners();
  }
  
  void setCallDuration(double value) {
    _callDuration = value;
    notifyListeners();
  }
  
  void setControlRelaysWithRemote(bool value) {
    _controlRelaysWithRemote = value;
    notifyListeners();
  }
  
  void setMonitoring(bool value) {
    _monitoring = value;
    notifyListeners();
  }
  
  void setRemoteReporting(bool value) {
    _remoteReporting = value;
    notifyListeners();
  }
  
  void setScenarioScheduleReporting(bool value) {
    _scenarioScheduleReporting = value;
    notifyListeners();
  }
  
  void setCallPriority(bool value) {
    _callPriority = value;
    notifyListeners();
  }
  
  void setSmsPriority(bool value) {
    _smsPriority = value;
    notifyListeners();
  }
  
  // Save all settings to the database
  Future<bool> saveSettings(BuildContext ctx) async {
    if (device == null) return false;
    
    _isSaving = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
      final updatedDevice = device!.copyWith(
        alarmDuration: _alarmDuration.toInt(),
        callDuration: _callDuration.toInt(),
        controlRelaysWithRemote: _controlRelaysWithRemote,
        monitoring: _monitoring,
        remoteReporting: _remoteReporting,
        scenarioReporting: _scenarioScheduleReporting,
        callPriority: _callPriority,
        smsPriority: _smsPriority,
      );
      final mainProvider = Provider.of<MainProvider>(ctx, listen: false);
      await mainProvider.updateDevice(updatedDevice);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      debugPrint('Error saving general settings: $_errorMessage');
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }
} 