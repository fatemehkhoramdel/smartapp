import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import '../injector.dart';
import '../models/audio_notification.dart';
import '../repository/cache_repository.dart';
import 'main_provider.dart';

class AudioNotificationProvider extends ChangeNotifier {
  late final MainProvider _mainProvider;
  AudioNotification? _notificationSettings;
  final AudioPlayer _audioPlayer = AudioPlayer();
  final CacheRepository _repository = injector<CacheRepository>();
  bool _isSaving = false;
  
  // تب فعلی که کاربر در آن قرار دارد
  int _currentTabIndex = 0;
  
  // وضعیت چک باکس اصلی برای هر تب
  bool _isAllSystemChecked = false;
  bool _isAllZonesChecked = false;
  bool _isAllSettingsChecked = false;
  bool _isAllSecurityChecked = false;
  
  // گتر برای تب فعلی
  int get currentTabIndex => _currentTabIndex;
  
  // گتر برای وضعیت چک باکس ها
  bool get isAllSystemChecked => _isAllSystemChecked;
  bool get isAllZonesChecked => _isAllZonesChecked;
  bool get isAllSettingsChecked => _isAllSettingsChecked;
  bool get isAllSecurityChecked => _isAllSecurityChecked;
  bool get isSaving => _isSaving;
  
  // گتر برای شدت صدا
  double get volume => _notificationSettings?.volume ?? 0.7;
  
  // گتر برای تنظیمات هشدار صوتی
  AudioNotification? get notificationSettings => _notificationSettings;
  
  AudioNotificationProvider(MainProvider? mainProvider) {
    if (mainProvider != null) {
      _mainProvider = mainProvider;
      _loadNotificationSettings();
    }
  }
  
  // بارگذاری تنظیمات هشدار صوتی از دیتابیس
  Future<void> _loadNotificationSettings() async {
    try {
      final deviceId = _mainProvider.selectedDevice.id;
      if (deviceId == null) {
        debugPrint('Device ID is null');
        return;
      }
      
      try {
        _notificationSettings = await _repository.getNotificationSettings(deviceId);
        
        // اگر تنظیمات برای این دستگاه وجود نداشت، یک نمونه جدید ایجاد می‌کنیم
        if (_notificationSettings == null) {
          _notificationSettings = AudioNotification(deviceId: deviceId);
          await _repository.insertNotificationSettings(_notificationSettings!);
        }
        
        _updateAllCheckedState();
        notifyListeners();
      } catch (e) {
        debugPrint('Error loading notification settings: $e');
        // در صورت خطا، یک نمونه پیش‌فرض بسازیم تا برنامه کرش نکند
        _notificationSettings = AudioNotification(deviceId: deviceId);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error in _loadNotificationSettings: $e');
    }
  }
  
  // تغییر تب فعلی
  void changeTab(int index) {
    _currentTabIndex = index;
    notifyListeners();
  }
  
  // تغییر شدت صدا
  Future<void> setVolume(double value) async {
    if (_notificationSettings == null) return;
    
    // تنظیم صدای کلی
    _notificationSettings = _notificationSettings!.copyWith(volume: value);
    
    // اعمال تغییرات صدا روی تمام گزینه‌های انتخاب شده در تب فعلی
    if (_currentTabIndex == 0 && _isAllSystemChecked) {
      // تب هشدارهای سیستم
      _updateSystemNotificationsVolume(value);
    } else if (_currentTabIndex == 1 && _isAllZonesChecked) {
      // تب هشدارهای زون‌ها
      _updateZonesNotificationsVolume(value);
    } else if (_currentTabIndex == 2 && _isAllSettingsChecked) {
      // تب اعلام تنظیمات
      _updateSettingsNotificationsVolume(value);
    } else if (_currentTabIndex == 3 && _isAllSecurityChecked) {
      // تب هشدارهای امنیتی
      _updateSecurityNotificationsVolume(value);
    }
    
    await _saveSettings();
  }
  
  // به‌روزرسانی میزان صدای تمام هشدارهای سیستم
  void _updateSystemNotificationsVolume(double value) {
    if (_notificationSettings == null) return;
    
    _notificationSettings = _notificationSettings!.copyWith(
      generalArmedVolume: _notificationSettings!.generalArmed ? value : null,
      generalDisarmedVolume: _notificationSettings!.generalDisarmed ? value : null,
      generalReportByUserVolume: _notificationSettings!.generalReportByUser ? value : null,
      noAccessVolume: _notificationSettings!.noAccess ? value : null,
      powerOnVolume: _notificationSettings!.powerOn ? value : null,
      powerOffVolume: _notificationSettings!.powerOff ? value : null,
      sirenTriggeredVolume: _notificationSettings!.sirenTriggered ? value : null,
      sirenTimeExpiredVolume: _notificationSettings!.sirenTimeExpired ? value : null,
      chargeLowVolume: _notificationSettings!.chargeLow ? value : null,
      batteryLowVolume: _notificationSettings!.batteryLow ? value : null,
      batteryDisconnectedVolume: _notificationSettings!.batteryDisconnected ? value : null,
      sirenOffVolume: _notificationSettings!.sirenOff ? value : null,
      reportByAdminVolume: _notificationSettings!.reportByAdmin ? value : null,
      deviceBackupDeletedVolume: _notificationSettings!.deviceBackupDeleted ? value : null,
    );
    
    notifyListeners();
  }
  
  // به‌روزرسانی میزان صدای تمام هشدارهای زون‌ها
  void _updateZonesNotificationsVolume(double value) {
    if (_notificationSettings == null) return;
    
    _notificationSettings = _notificationSettings!.copyWith(
      zone1AlertVolume: _notificationSettings!.zone1Alert ? value : null,
      zone2AlertVolume: _notificationSettings!.zone2Alert ? value : null,
      zone3AlertVolume: _notificationSettings!.zone3Alert ? value : null,
      zone4AlertVolume: _notificationSettings!.zone4Alert ? value : null,
      zone5AlertVolume: _notificationSettings!.zone5Alert ? value : null,
      zone1SemiAlertVolume: _notificationSettings!.zone1SemiAlert ? value : null,
      zone2SemiAlertVolume: _notificationSettings!.zone2SemiAlert ? value : null,
      zone3SemiAlertVolume: _notificationSettings!.zone3SemiAlert ? value : null,
      zone4SemiAlertVolume: _notificationSettings!.zone4SemiAlert ? value : null,
      zone5SemiAlertVolume: _notificationSettings!.zone5SemiAlert ? value : null,
      allZonesSemiAlertVolume: _notificationSettings!.allZonesSemiAlert ? value : null,
      semiActiveZonesVolume: _notificationSettings!.semiActiveZones ? value : null,
    );
    
    notifyListeners();
  }
  
  // به‌روزرسانی میزان صدای تمام اعلام تنظیمات
  void _updateSettingsNotificationsVolume(double value) {
    if (_notificationSettings == null) return;
    
    _notificationSettings = _notificationSettings!.copyWith(
      zonesStatusVolume: _notificationSettings!.zonesStatus ? value : null,
      relaysStatusVolume: _notificationSettings!.relaysStatus ? value : null,
      connectStatusVolume: _notificationSettings!.connectStatus ? value : null,
      batteryStatusVolume: _notificationSettings!.batteryStatus ? value : null,
      simStatusVolume: _notificationSettings!.simStatus ? value : null,
      powerStatusVolume: _notificationSettings!.powerStatus ? value : null,
      deviceLossPowerVolume: _notificationSettings!.deviceLossPower ? value : null,
      simCreditVolume: _notificationSettings!.simCredit ? value : null,
      deviceLostConnectionVolume: _notificationSettings!.deviceLostConnection ? value : null,
    );
    
    notifyListeners();
  }
  
  // به‌روزرسانی میزان صدای تمام هشدارهای امنیتی
  void _updateSecurityNotificationsVolume(double value) {
    if (_notificationSettings == null) return;
    
    _notificationSettings = _notificationSettings!.copyWith(
      sirenEnabledVolume: _notificationSettings!.sirenEnabled ? value : null,
      incorrectCodeVolume: _notificationSettings!.incorrectCode ? value : null,
      disconnectedSensorVolume: _notificationSettings!.disconnectedSensor ? value : null,
      adminManagerVolume: _notificationSettings!.adminManager ? value : null,
      activateRelayVolume: _notificationSettings!.activateRelay ? value : null,
      deactivateRelayVolume: _notificationSettings!.deactivateRelay ? value : null,
      deleteBackupVolume: _notificationSettings!.deleteBackup ? value : null,
      networkLostVolume: _notificationSettings!.networkLost ? value : null,
      deactivatedByUserVolume: _notificationSettings!.deactivatedByUser ? value : null,
      deactivatedByAdminVolume: _notificationSettings!.deactivatedByAdmin ? value : null,
      deactivatedByTimerVolume: _notificationSettings!.deactivatedByTimer ? value : null,
      deactivatedByBackupVolume: _notificationSettings!.deactivatedByBackup ? value : null,
      silenceModeVolume: _notificationSettings!.silenceMode ? value : null,
    );
    
    notifyListeners();
  }
  
  // تغییر وضعیت چک باکس اصلی هر تب
  Future<void> toggleAllSystemNotifications(bool value) async {
    if (_notificationSettings == null) return;
    
    _notificationSettings = _notificationSettings!.copyWith(
      generalArmed: value,
      generalDisarmed: value,
      generalReportByUser: value,
      noAccess: value,
      powerOn: value,
      powerOff: value,
      sirenTriggered: value,
      sirenTimeExpired: value,
      chargeLow: value,
      batteryLow: value,
      batteryDisconnected: value,
      sirenOff: value,
      reportByAdmin: value,
      deviceBackupDeleted: value,
    );
    
    _isAllSystemChecked = value;
    await _saveSettings();
  }
  
  Future<void> toggleAllZonesNotifications(bool value) async {
    if (_notificationSettings == null) return;
    
    _notificationSettings = _notificationSettings!.copyWith(
      zone1Alert: value,
      zone2Alert: value,
      zone3Alert: value,
      zone4Alert: value,
      zone5Alert: value,
      zone1SemiAlert: value,
      zone2SemiAlert: value,
      zone3SemiAlert: value,
      zone4SemiAlert: value,
      zone5SemiAlert: value,
      allZonesSemiAlert: value,
      semiActiveZones: value,
    );
    
    _isAllZonesChecked = value;
    await _saveSettings();
  }
  
  Future<void> toggleAllSettingsNotifications(bool value) async {
    if (_notificationSettings == null) return;
    
    _notificationSettings = _notificationSettings!.copyWith(
      zonesStatus: value,
      relaysStatus: value,
      connectStatus: value,
      batteryStatus: value,
      simStatus: value,
      powerStatus: value,
      deviceLossPower: value,
      simCredit: value,
      deviceLostConnection: value,
    );
    
    _isAllSettingsChecked = value;
    await _saveSettings();
  }
  
  Future<void> toggleAllSecurityNotifications(bool value) async {
    if (_notificationSettings == null) return;
    
    _notificationSettings = _notificationSettings!.copyWith(
      sirenEnabled: value,
      incorrectCode: value,
      disconnectedSensor: value,
      adminManager: value,
      activateRelay: value,
      deactivateRelay: value,
      deleteBackup: value,
      networkLost: value,
      deactivatedByUser: value,
      deactivatedByAdmin: value,
      deactivatedByTimer: value,
      deactivatedByBackup: value,
      silenceMode: value,
    );
    
    _isAllSecurityChecked = value;
    await _saveSettings();
  }
  
  // تغییر وضعیت یک هشدار خاص
  Future<void> toggleNotification(String notificationType, bool value) async {
    if (_notificationSettings == null) return;
    
    Map<String, bool> updates = {};
    updates[notificationType] = value;
    
    _notificationSettings = _notificationSettings!.copyWith(
      generalArmed: notificationType == 'generalArmed' ? value : null,
      generalDisarmed: notificationType == 'generalDisarmed' ? value : null,
      generalReportByUser: notificationType == 'generalReportByUser' ? value : null,
      noAccess: notificationType == 'noAccess' ? value : null,
      powerOn: notificationType == 'powerOn' ? value : null,
      powerOff: notificationType == 'powerOff' ? value : null,
      sirenTriggered: notificationType == 'sirenTriggered' ? value : null,
      sirenTimeExpired: notificationType == 'sirenTimeExpired' ? value : null,
      chargeLow: notificationType == 'chargeLow' ? value : null,
      batteryLow: notificationType == 'batteryLow' ? value : null,
      batteryDisconnected: notificationType == 'batteryDisconnected' ? value : null,
      sirenOff: notificationType == 'sirenOff' ? value : null,
      reportByAdmin: notificationType == 'reportByAdmin' ? value : null,
      deviceBackupDeleted: notificationType == 'deviceBackupDeleted' ? value : null,
      
      zone1Alert: notificationType == 'zone1Alert' ? value : null,
      zone2Alert: notificationType == 'zone2Alert' ? value : null,
      zone3Alert: notificationType == 'zone3Alert' ? value : null,
      zone4Alert: notificationType == 'zone4Alert' ? value : null,
      zone5Alert: notificationType == 'zone5Alert' ? value : null,
      zone1SemiAlert: notificationType == 'zone1SemiAlert' ? value : null,
      zone2SemiAlert: notificationType == 'zone2SemiAlert' ? value : null,
      zone3SemiAlert: notificationType == 'zone3SemiAlert' ? value : null,
      zone4SemiAlert: notificationType == 'zone4SemiAlert' ? value : null,
      zone5SemiAlert: notificationType == 'zone5SemiAlert' ? value : null,
      allZonesSemiAlert: notificationType == 'allZonesSemiAlert' ? value : null,
      semiActiveZones: notificationType == 'semiActiveZones' ? value : null,
      
      zonesStatus: notificationType == 'zonesStatus' ? value : null,
      relaysStatus: notificationType == 'relaysStatus' ? value : null,
      connectStatus: notificationType == 'connectStatus' ? value : null,
      batteryStatus: notificationType == 'batteryStatus' ? value : null,
      simStatus: notificationType == 'simStatus' ? value : null,
      powerStatus: notificationType == 'powerStatus' ? value : null,
      deviceLossPower: notificationType == 'deviceLossPower' ? value : null,
      simCredit: notificationType == 'simCredit' ? value : null,
      deviceLostConnection: notificationType == 'deviceLostConnection' ? value : null,
      
      sirenEnabled: notificationType == 'sirenEnabled' ? value : null,
      incorrectCode: notificationType == 'incorrectCode' ? value : null,
      disconnectedSensor: notificationType == 'disconnectedSensor' ? value : null,
      adminManager: notificationType == 'adminManager' ? value : null,
      activateRelay: notificationType == 'activateRelay' ? value : null,
      deactivateRelay: notificationType == 'deactivateRelay' ? value : null,
      deleteBackup: notificationType == 'deleteBackup' ? value : null,
      networkLost: notificationType == 'networkLost' ? value : null,
      deactivatedByUser: notificationType == 'deactivatedByUser' ? value : null,
      deactivatedByAdmin: notificationType == 'deactivatedByAdmin' ? value : null,
      deactivatedByTimer: notificationType == 'deactivatedByTimer' ? value : null,
      deactivatedByBackup: notificationType == 'deactivatedByBackup' ? value : null,
      silenceMode: notificationType == 'silenceMode' ? value : null,
    );
    
    _updateAllCheckedState();
    await _saveSettings();
  }
  
  // به‌روزرسانی وضعیت چک باکس‌های اصلی هر تب
  void _updateAllCheckedState() {
    if (_notificationSettings == null) return;
    
    // بررسی وضعیت همه هشدارهای سیستم
    _isAllSystemChecked = _notificationSettings!.generalArmed &&
        _notificationSettings!.generalDisarmed &&
        _notificationSettings!.generalReportByUser &&
        _notificationSettings!.noAccess &&
        _notificationSettings!.powerOn &&
        _notificationSettings!.powerOff &&
        _notificationSettings!.sirenTriggered &&
        _notificationSettings!.sirenTimeExpired &&
        _notificationSettings!.chargeLow &&
        _notificationSettings!.batteryLow &&
        _notificationSettings!.batteryDisconnected &&
        _notificationSettings!.sirenOff &&
        _notificationSettings!.reportByAdmin &&
        _notificationSettings!.deviceBackupDeleted;
    
    // بررسی وضعیت همه هشدارهای زون‌ها
    _isAllZonesChecked = _notificationSettings!.zone1Alert &&
        _notificationSettings!.zone2Alert &&
        _notificationSettings!.zone3Alert &&
        _notificationSettings!.zone4Alert &&
        _notificationSettings!.zone5Alert &&
        _notificationSettings!.zone1SemiAlert &&
        _notificationSettings!.zone2SemiAlert &&
        _notificationSettings!.zone3SemiAlert &&
        _notificationSettings!.zone4SemiAlert &&
        _notificationSettings!.zone5SemiAlert &&
        _notificationSettings!.allZonesSemiAlert &&
        _notificationSettings!.semiActiveZones;
    
    // بررسی وضعیت همه اعلام‌های تنظیمات
    _isAllSettingsChecked = _notificationSettings!.zonesStatus &&
        _notificationSettings!.relaysStatus &&
        _notificationSettings!.connectStatus &&
        _notificationSettings!.batteryStatus &&
        _notificationSettings!.simStatus &&
        _notificationSettings!.powerStatus &&
        _notificationSettings!.deviceLossPower &&
        _notificationSettings!.simCredit &&
        _notificationSettings!.deviceLostConnection;
    
    // بررسی وضعیت همه هشدارهای امنیتی
    _isAllSecurityChecked = _notificationSettings!.sirenEnabled &&
        _notificationSettings!.incorrectCode &&
        _notificationSettings!.disconnectedSensor &&
        _notificationSettings!.adminManager &&
        _notificationSettings!.activateRelay &&
        _notificationSettings!.deactivateRelay &&
        _notificationSettings!.deleteBackup &&
        _notificationSettings!.networkLost &&
        _notificationSettings!.deactivatedByUser &&
        _notificationSettings!.deactivatedByAdmin &&
        _notificationSettings!.deactivatedByTimer &&
        _notificationSettings!.deactivatedByBackup &&
        _notificationSettings!.silenceMode;
  }
  
  // ذخیره تنظیمات در دیتابیس
  Future<void> _saveSettings() async {
    if (_notificationSettings == null) return;
    
    try {
      // ابتدا مطمئن شویم که تنظیمات در دیتابیس وجود دارد
      final deviceId = _mainProvider.selectedDevice.id;
      if (deviceId == null) {
        debugPrint('Device ID is null');
        return;
      }
      
      final existingSettings = await injector<CacheRepository>().getNotificationSettings(deviceId);
      
      if (existingSettings == null) {
        // اگر تنظیمات وجود ندارد، یک رکورد جدید ایجاد می‌کنیم
        await injector<CacheRepository>().insertNotificationSettings(_notificationSettings!);
      } else {
        // اگر تنظیمات وجود دارد، آن را به‌روزرسانی می‌کنیم
        await injector<CacheRepository>().updateNotificationSettings(_notificationSettings!);
      }
      
      notifyListeners();
    } catch (e) {
      debugPrint('Error in _saveSettings: $e');
    }
  }
  
  // Method to set volume for a specific notification item
  void setItemVolume(String type, double volume) {
    if (_notificationSettings == null) return;
    
    final settings = _notificationSettings!;
    AudioNotification updatedSettings;
    
    switch (type) {
      // System alerts
      case 'generalArmed': 
        updatedSettings = settings.copyWith(generalArmedVolume: volume);
        break;
      case 'generalDisarmed': 
        updatedSettings = settings.copyWith(generalDisarmedVolume: volume);
        break;
      case 'generalReportByUser': 
        updatedSettings = settings.copyWith(generalReportByUserVolume: volume);
        break;
      case 'noAccess': 
        updatedSettings = settings.copyWith(noAccessVolume: volume);
        break;
      case 'powerOn': 
        updatedSettings = settings.copyWith(powerOnVolume: volume);
        break;
      case 'powerOff': 
        updatedSettings = settings.copyWith(powerOffVolume: volume);
        break;
      case 'sirenTriggered': 
        updatedSettings = settings.copyWith(sirenTriggeredVolume: volume);
        break;
      case 'sirenTimeExpired': 
        updatedSettings = settings.copyWith(sirenTimeExpiredVolume: volume);
        break;
      case 'chargeLow': 
        updatedSettings = settings.copyWith(chargeLowVolume: volume);
        break;
      case 'batteryLow': 
        updatedSettings = settings.copyWith(batteryLowVolume: volume);
        break;
      case 'batteryDisconnected': 
        updatedSettings = settings.copyWith(batteryDisconnectedVolume: volume);
        break;
      case 'sirenOff': 
        updatedSettings = settings.copyWith(sirenOffVolume: volume);
        break;
      case 'reportByAdmin': 
        updatedSettings = settings.copyWith(reportByAdminVolume: volume);
        break;
      case 'deviceBackupDeleted': 
        updatedSettings = settings.copyWith(deviceBackupDeletedVolume: volume);
        break;
      
      // Zone alerts
      case 'zone1Alert': 
        updatedSettings = settings.copyWith(zone1AlertVolume: volume);
        break;
      case 'zone2Alert': 
        updatedSettings = settings.copyWith(zone2AlertVolume: volume);
        break;
      case 'zone3Alert': 
        updatedSettings = settings.copyWith(zone3AlertVolume: volume);
        break;
      case 'zone4Alert': 
        updatedSettings = settings.copyWith(zone4AlertVolume: volume);
        break;
      case 'zone5Alert': 
        updatedSettings = settings.copyWith(zone5AlertVolume: volume);
        break;
      case 'zone1SemiAlert': 
        updatedSettings = settings.copyWith(zone1SemiAlertVolume: volume);
        break;
      case 'zone2SemiAlert': 
        updatedSettings = settings.copyWith(zone2SemiAlertVolume: volume);
        break;
      case 'zone3SemiAlert': 
        updatedSettings = settings.copyWith(zone3SemiAlertVolume: volume);
        break;
      case 'zone4SemiAlert': 
        updatedSettings = settings.copyWith(zone4SemiAlertVolume: volume);
        break;
      case 'zone5SemiAlert': 
        updatedSettings = settings.copyWith(zone5SemiAlertVolume: volume);
        break;
      case 'allZonesSemiAlert': 
        updatedSettings = settings.copyWith(allZonesSemiAlertVolume: volume);
        break;
      case 'semiActiveZones': 
        updatedSettings = settings.copyWith(semiActiveZonesVolume: volume);
        break;
      
      // Settings notifications
      case 'zonesStatus': 
        updatedSettings = settings.copyWith(zonesStatusVolume: volume);
        break;
      case 'relaysStatus': 
        updatedSettings = settings.copyWith(relaysStatusVolume: volume);
        break;
      case 'connectStatus': 
        updatedSettings = settings.copyWith(connectStatusVolume: volume);
        break;
      case 'batteryStatus': 
        updatedSettings = settings.copyWith(batteryStatusVolume: volume);
        break;
      case 'simStatus': 
        updatedSettings = settings.copyWith(simStatusVolume: volume);
        break;
      case 'powerStatus': 
        updatedSettings = settings.copyWith(powerStatusVolume: volume);
        break;
      case 'deviceLossPower': 
        updatedSettings = settings.copyWith(deviceLossPowerVolume: volume);
        break;
      case 'simCredit': 
        updatedSettings = settings.copyWith(simCreditVolume: volume);
        break;
      case 'deviceLostConnection': 
        updatedSettings = settings.copyWith(deviceLostConnectionVolume: volume);
        break;
      
      // Security alerts
      case 'sirenEnabled': 
        updatedSettings = settings.copyWith(sirenEnabledVolume: volume);
        break;
      case 'incorrectCode': 
        updatedSettings = settings.copyWith(incorrectCodeVolume: volume);
        break;
      case 'disconnectedSensor': 
        updatedSettings = settings.copyWith(disconnectedSensorVolume: volume);
        break;
      case 'adminManager': 
        updatedSettings = settings.copyWith(adminManagerVolume: volume);
        break;
      case 'activateRelay': 
        updatedSettings = settings.copyWith(activateRelayVolume: volume);
        break;
      case 'deactivateRelay': 
        updatedSettings = settings.copyWith(deactivateRelayVolume: volume);
        break;
      case 'deleteBackup': 
        updatedSettings = settings.copyWith(deleteBackupVolume: volume);
        break;
      case 'networkLost': 
        updatedSettings = settings.copyWith(networkLostVolume: volume);
        break;
      case 'deactivatedByUser': 
        updatedSettings = settings.copyWith(deactivatedByUserVolume: volume);
        break;
      case 'deactivatedByAdmin': 
        updatedSettings = settings.copyWith(deactivatedByAdminVolume: volume);
        break;
      case 'deactivatedByTimer': 
        updatedSettings = settings.copyWith(deactivatedByTimerVolume: volume);
        break;
      case 'deactivatedByBackup': 
        updatedSettings = settings.copyWith(deactivatedByBackupVolume: volume);
        break;
      case 'silenceMode': 
        updatedSettings = settings.copyWith(silenceModeVolume: volume);
        break;
      default:
        return;
    }
    
    _notificationSettings = updatedSettings;
    notifyListeners();
  }
  
  // Save all changes to the database
  Future<void> saveAllChanges() async {
    if (_notificationSettings == null) return;
    
    try {
      _isSaving = true;
      notifyListeners();
      
      // Update volume settings for the master volume
      final updatedSettings = _notificationSettings!.copyWith(volume: volume);
      
      // Save to database
      await _repository.updateNotificationSettings(updatedSettings);
      
      // Update the local settings
      _notificationSettings = updatedSettings;
      
      _isSaving = false;
      notifyListeners();
    } catch (e) {
      _isSaving = false;
      notifyListeners();
      rethrow;
    }
  }
  
  // پخش صدای نوتیفیکیشن برای تست
  Future<void> playNotificationSound() async {
    try {
      await _audioPlayer.setVolume(volume);
      // استفاده از try-catch داخلی برای هر عملیات مجزا
      try {
        await _audioPlayer.play(AssetSource('sounds/notification.mp3'));
      } catch (e) {
        debugPrint('Could not play sound from assets: $e');
        // سعی کنید با URL پیش‌فرض
        try {
          await _audioPlayer.play(UrlSource('https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3'));
        } catch (e) {
          debugPrint('Could not play sound from URL: $e');
        }
      }
    } catch (e) {
      debugPrint('Error in playNotificationSound: $e');
    }
  }
  
  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
} 