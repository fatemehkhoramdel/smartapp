import 'package:flutter/material.dart';

import '../core/utils/helper.dart';
import '../injector.dart';
import '../models/smart_control.dart';
import '../providers/main_provider.dart';
import '../repository/smart_control_repository.dart';
import '../views/smart_control/mobile/control_panel_view.dart';

class SmartControlProvider extends ChangeNotifier {
  final MainProvider? _mainProvider;
  final _repository = SmartControlRepository(injector());

  SmartControlProvider(this._mainProvider);

  // Control types
  static const safeEntry = 'ورود امن';
  static const safeExit = 'خروج امن';
  static const safeTravel = 'مسافرت امن';
  static const safeSleep = 'خواب امن';
  static const customControlPrefix = 'کنترل سفارشی';

  // Active modes
  static const activeMode = 'فعال';
  static const inactiveMode = 'غیر فعال';
  static const semiActiveMode = 'نیمه فعال';
  static const silentActiveMode = 'بی‌صدا فعال';
  static const silentSemiActiveMode = 'بی‌صدا نیمه فعال';

  List<SmartControl> _smartControls = [];
  SmartControl? _currentControl;
  String _selectedControlType = safeEntry;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<SmartControl> get smartControls => _smartControls;
  SmartControl? get currentControl => _currentControl;
  String get selectedControlType => _selectedControlType;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // List of available control types
  List<String> get controlTypes => [safeEntry, safeExit, safeTravel, safeSleep];
  
  // List of available active modes
  List<String> get activeModes => [
    activeMode,
    inactiveMode,
    semiActiveMode,
    silentActiveMode,
    silentSemiActiveMode,
  ];

  // Initialize SmartControls for a device
  Future<void> initSmartControls() async {
    if (_mainProvider?.selectedDevice == null || 
        _mainProvider?.selectedDevice.id == null) {
      _errorMessage = 'هیچ دستگاهی انتخاب نشده است';
      notifyListeners();
      return;
    }

    try {
      _isLoading = true;
      notifyListeners();

      final deviceId = _mainProvider!.selectedDevice.id!;
      _smartControls = await _repository.getSmartControlsByDeviceId(deviceId);

      // If there are no controls for this device, create default ones
      if (_smartControls.isEmpty) {
        await _createDefaultSmartControls(deviceId);
        _smartControls = await _repository.getSmartControlsByDeviceId(deviceId);
      }
      
      // Set the current control to the first type (Safe Entry)
      await selectControlType(safeEntry);
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'خطا در بارگیری تنظیمات کنترل هوشمند: $e';
      notifyListeners();
    }
  }

  // Create default smart controls for a device
  Future<void> _createDefaultSmartControls(int deviceId) async {
    final controlTypes = [safeEntry, safeExit, safeTravel, safeSleep];
    
    for (var type in controlTypes) {
      final control = SmartControl(
        deviceId: deviceId,
        controlType: type,
        speakerEnabled: true,
        activeMode: activeMode,
      );
      
      await _repository.saveSmartControl(control);
    }
  }

  // Select a control type
  Future<void> selectControlType(String controlType) async {
    if (_mainProvider?.selectedDevice == null || 
        _mainProvider?.selectedDevice.id == null) {
      _errorMessage = 'هیچ دستگاهی انتخاب نشده است';
      notifyListeners();
      return;
    }

    try {
      _selectedControlType = controlType;
      
      final deviceId = _mainProvider!.selectedDevice.id!;
      _currentControl = await _repository.getSmartControlByTypeAndDeviceId(
        deviceId,
        controlType,
      );

      // If no control exists for this type, create a default one
      if (_currentControl == null) {
        _currentControl = SmartControl(
          deviceId: deviceId,
          controlType: controlType,
          speakerEnabled: true,
          activeMode: activeMode,
        );
        
        await _repository.saveSmartControl(_currentControl!);
      }
      
      notifyListeners();
    } catch (e) {
      _errorMessage = 'خطا در انتخاب نوع کنترل: $e';
      notifyListeners();
    }
  }

  // Toggle device settings
  void toggleSpeaker(bool value) {
    if (_currentControl != null) {
      _currentControl = _currentControl!.copyWith(speakerEnabled: value);
      notifyListeners();
    }
  }

  void toggleRemoteCode(bool value) {
    if (_currentControl != null) {
      _currentControl = _currentControl!.copyWith(remoteCodeEnabled: value);
      notifyListeners();
    }
  }

  void toggleRemote(bool value) {
    if (_currentControl != null) {
      _currentControl = _currentControl!.copyWith(remoteEnabled: value);
      notifyListeners();
    }
  }

  void toggleRelay1(bool value) {
    if (_currentControl != null) {
      _currentControl = _currentControl!.copyWith(relay1Enabled: value);
      notifyListeners();
    }
  }

  void toggleRelay2(bool value) {
    if (_currentControl != null) {
      _currentControl = _currentControl!.copyWith(relay2Enabled: value);
      notifyListeners();
    }
  }

  void toggleRelay3(bool value) {
    if (_currentControl != null) {
      _currentControl = _currentControl!.copyWith(relay3Enabled: value);
      notifyListeners();
    }
  }

  void toggleScenario(bool value) {
    if (_currentControl != null) {
      _currentControl = _currentControl!.copyWith(scenarioEnabled: value);
      notifyListeners();
    }
  }

  // Save control panel settings
  Future<void> saveControlPanelSettings({
    required bool speakerEnabled,
    required bool remoteCodeEnabled,
    required bool remoteEnabled,
    required bool relay1Enabled,
    required bool relay2Enabled,
    required bool relay3Enabled, 
    required bool scenarioEnabled,
  }) async {
    if (_mainProvider?.selectedDevice == null || 
        _mainProvider?.selectedDevice.id == null) {
      _errorMessage = 'هیچ دستگاهی انتخاب نشده است';
      notifyListeners();
      return;
    }

    try {
      _isLoading = true;
      notifyListeners();

      final deviceId = _mainProvider!.selectedDevice.id!;
      
      // Create a new control for control panel
      final controlPanelControl = SmartControl(
        deviceId: deviceId,
        controlType: kControlPanelType,
        speakerEnabled: speakerEnabled,
        remoteCodeEnabled: remoteCodeEnabled,
        remoteEnabled: remoteEnabled,
        relay1Enabled: relay1Enabled,
        relay2Enabled: relay2Enabled,
        relay3Enabled: relay3Enabled,
        scenarioEnabled: scenarioEnabled,
        activeMode: activeMode,
      );
      
      // Save to database
      await _repository.saveSmartControl(controlPanelControl);
      
      // TODO: Send settings to device if needed
      // await sendSettingsToDevice();
      
      _isLoading = false;
      notifyListeners();
      
      toastGenerator('تنظیمات با موفقیت ذخیره شد');
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'خطا در ذخیره تنظیمات: $e';
      notifyListeners();
    }
  }

  // Set active mode
  void setActiveMode(String mode) {
    if (_currentControl != null) {
      _currentControl = _currentControl!.copyWith(activeMode: mode);
      notifyListeners();
    }
  }

  // Save current control settings
  Future<void> saveCurrentControl() async {
    if (_currentControl == null) {
      _errorMessage = 'هیچ کنترلی انتخاب نشده است';
      notifyListeners();
      return;
    }

    try {
      _isLoading = true;
      notifyListeners();

      await _repository.saveSmartControl(_currentControl!);
      
      _isLoading = false;
      notifyListeners();
      
      toastGenerator('تنظیمات با موفقیت ذخیره شد');
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'خطا در ذخیره تنظیمات: $e';
      notifyListeners();
    }
  }
  
  // Send settings to device
  Future<void> sendSettingsToDevice() async {
    if (_mainProvider?.selectedDevice == null || 
        _mainProvider?.selectedDevice.id == null) {
      _errorMessage = 'هیچ دستگاهی انتخاب نشده است';
      notifyListeners();
      return;
    }
    
    // Simulate sending to device
    toastGenerator('ارسال تنظیمات به دستگاه در حال انجام است');
    
    // Add the actual implementation for sending to device here
    
    // For now, just simulate with a delay
    await Future.delayed(const Duration(seconds: 2));
    
    toastGenerator('تنظیمات با موفقیت به دستگاه ارسال شد');
  }
  
  // Query settings from device
  Future<void> querySettingsFromDevice() async {
    if (_mainProvider?.selectedDevice == null || 
        _mainProvider?.selectedDevice.id == null) {
      _errorMessage = 'هیچ دستگاهی انتخاب نشده است';
      notifyListeners();
      return;
    }
    
    // Simulate querying from device
    toastGenerator('در حال استعلام تنظیمات از دستگاه');
    
    // Add the actual implementation for querying from device here
    
    // For now, just simulate with a delay
    await Future.delayed(const Duration(seconds: 2));
    
    toastGenerator('تنظیمات با موفقیت از دستگاه دریافت شد');
  }

  Future<void> addNewCustomControl() async {
    try {
      // Get all existing custom controls to determine the next number
      _isLoading = true;
      notifyListeners();
      
      final allControls = await _repository.getSmartControlsByDeviceId(_mainProvider!.selectedDevice!.id!);
      
      // Filter to get only custom controls
      final customControls = allControls.where(
        (control) => control.controlType.startsWith(customControlPrefix)
      ).toList();
      
      // Find the next number
      int nextNumber = 1;
      if (customControls.isNotEmpty) {
        for (final control in customControls) {
          final parts = control.controlType.split(' ');
          if (parts.length > 2) {
            final number = int.tryParse(parts.last);
            if (number != null && number >= nextNumber) {
              nextNumber = number + 1;
            }
          }
        }
      }
      
      // Create new control with incremented name
      final newControlType = '$customControlPrefix $nextNumber';
      final newControl = SmartControl(
        deviceId: _mainProvider!.selectedDevice!.id!,
        controlType: newControlType,
        speakerEnabled: false,
        remoteCodeEnabled: false,
        remoteEnabled: false,
        relay1Enabled: false,
        relay2Enabled: false,
        relay3Enabled: false,
        scenarioEnabled: false,
        activeMode: activeMode,
      );
      
      // Save to database
      await _repository.saveSmartControl(newControl);
      
      // Refresh list
      await initSmartControls();
      
      _isLoading = false;
      notifyListeners();
      
      toastGenerator('کنترل جدید با موفقیت اضافه شد');
      
    } catch (e) {
      _errorMessage = 'خطا در افزودن کنترل جدید: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  // Save custom control settings
  Future<void> saveCustomControlSettings({
    required String controlType,
    required bool speakerEnabled,
    required bool remoteCodeEnabled,
    required bool remoteEnabled,
    required bool relay1Enabled,
    required bool relay2Enabled,
    required bool relay3Enabled, 
    required bool scenarioEnabled,
  }) async {
    if (_mainProvider?.selectedDevice == null || 
        _mainProvider?.selectedDevice.id == null) {
      _errorMessage = 'هیچ دستگاهی انتخاب نشده است';
      notifyListeners();
      return;
    }

    try {
      _isLoading = true;
      notifyListeners();

      final deviceId = _mainProvider!.selectedDevice.id!;
      
      // Create a control with the provided custom type
      final customControl = SmartControl(
        deviceId: deviceId,
        controlType: controlType,
        speakerEnabled: speakerEnabled,
        remoteCodeEnabled: remoteCodeEnabled,
        remoteEnabled: remoteEnabled,
        relay1Enabled: relay1Enabled,
        relay2Enabled: relay2Enabled,
        relay3Enabled: relay3Enabled,
        scenarioEnabled: scenarioEnabled,
        activeMode: activeMode,
      );
      
      // Save to database
      await _repository.saveSmartControl(customControl);
      
      // TODO: Send settings to device if needed
      // await sendSettingsToDevice();
      
      _isLoading = false;
      notifyListeners();
      
      toastGenerator('تنظیمات با موفقیت ذخیره شد');
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'خطا در ذخیره تنظیمات: $e';
      notifyListeners();
    }
  }
} 