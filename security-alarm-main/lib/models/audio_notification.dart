import 'package:equatable/equatable.dart';
import 'package:floor/floor.dart';

import '../core/constants/database_constants.dart';

@Entity(
  tableName: kAudioNotificationTable,
)
class AudioNotification extends Equatable {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final int deviceId;
  final double volume;
  
  // هشدارهای سیستم
  final bool generalArmed;
  final bool generalDisarmed;
  final bool generalReportByUser;
  final bool noAccess;
  final bool powerOn;
  final bool powerOff;
  final bool sirenTriggered;
  final bool sirenTimeExpired;
  final bool chargeLow;
  final bool batteryLow;
  final bool batteryDisconnected;
  final bool sirenOff;
  final bool reportByAdmin;
  final bool deviceBackupDeleted;
  
  // میزان صدای هشدارهای سیستم
  final double generalArmedVolume;
  final double generalDisarmedVolume;
  final double generalReportByUserVolume;
  final double noAccessVolume;
  final double powerOnVolume;
  final double powerOffVolume;
  final double sirenTriggeredVolume;
  final double sirenTimeExpiredVolume;
  final double chargeLowVolume;
  final double batteryLowVolume;
  final double batteryDisconnectedVolume;
  final double sirenOffVolume;
  final double reportByAdminVolume;
  final double deviceBackupDeletedVolume;
  
  // هشدارهای زون‌ها
  final bool zone1Alert;
  final bool zone2Alert;
  final bool zone3Alert;
  final bool zone4Alert;
  final bool zone5Alert;
  final bool zone1SemiAlert;
  final bool zone2SemiAlert;
  final bool zone3SemiAlert;
  final bool zone4SemiAlert;
  final bool zone5SemiAlert;
  final bool allZonesSemiAlert;
  final bool semiActiveZones;
  
  // میزان صدای هشدارهای زون‌ها
  final double zone1AlertVolume;
  final double zone2AlertVolume;
  final double zone3AlertVolume;
  final double zone4AlertVolume;
  final double zone5AlertVolume;
  final double zone1SemiAlertVolume;
  final double zone2SemiAlertVolume;
  final double zone3SemiAlertVolume;
  final double zone4SemiAlertVolume;
  final double zone5SemiAlertVolume;
  final double allZonesSemiAlertVolume;
  final double semiActiveZonesVolume;
  
  // اعلام تنظیمات
  final bool zonesStatus;
  final bool relaysStatus;
  final bool connectStatus;
  final bool batteryStatus;
  final bool simStatus;
  final bool powerStatus;
  final bool deviceLossPower;
  final bool simCredit; 
  final bool deviceLostConnection;
  
  // میزان صدای اعلام تنظیمات
  final double zonesStatusVolume;
  final double relaysStatusVolume;
  final double connectStatusVolume;
  final double batteryStatusVolume;
  final double simStatusVolume;
  final double powerStatusVolume;
  final double deviceLossPowerVolume;
  final double simCreditVolume;
  final double deviceLostConnectionVolume;
  
  // هشدارهای امنیتی
  final bool sirenEnabled;
  final bool incorrectCode;
  final bool disconnectedSensor;
  final bool adminManager;
  final bool activateRelay;
  final bool deactivateRelay;
  final bool deleteBackup;
  final bool networkLost;
  final bool deactivatedByUser;
  final bool deactivatedByAdmin;
  final bool deactivatedByTimer;
  final bool deactivatedByBackup;
  final bool silenceMode;
  
  // میزان صدای هشدارهای امنیتی
  final double sirenEnabledVolume;
  final double incorrectCodeVolume;
  final double disconnectedSensorVolume;
  final double adminManagerVolume;
  final double activateRelayVolume;
  final double deactivateRelayVolume;
  final double deleteBackupVolume;
  final double networkLostVolume;
  final double deactivatedByUserVolume;
  final double deactivatedByAdminVolume;
  final double deactivatedByTimerVolume;
  final double deactivatedByBackupVolume;
  final double silenceModeVolume;

  const AudioNotification({
    this.id,
    required this.deviceId,
    this.volume = 0.7,
    
    // هشدارهای سیستم
    this.generalArmed = true,
    this.generalDisarmed = true,
    this.generalReportByUser = true,
    this.noAccess = true,
    this.powerOn = true,
    this.powerOff = true,
    this.sirenTriggered = true,
    this.sirenTimeExpired = true,
    this.chargeLow = true,
    this.batteryLow = true, 
    this.batteryDisconnected = true,
    this.sirenOff = true,
    this.reportByAdmin = true,
    this.deviceBackupDeleted = true,
    
    // میزان صدای هشدارهای سیستم
    this.generalArmedVolume = 0.7,
    this.generalDisarmedVolume = 0.7,
    this.generalReportByUserVolume = 0.7,
    this.noAccessVolume = 0.7,
    this.powerOnVolume = 0.7,
    this.powerOffVolume = 0.7,
    this.sirenTriggeredVolume = 0.7,
    this.sirenTimeExpiredVolume = 0.7,
    this.chargeLowVolume = 0.7,
    this.batteryLowVolume = 0.7,
    this.batteryDisconnectedVolume = 0.7,
    this.sirenOffVolume = 0.7,
    this.reportByAdminVolume = 0.7,
    this.deviceBackupDeletedVolume = 0.7,
    
    // هشدارهای زون‌ها
    this.zone1Alert = true,
    this.zone2Alert = true,
    this.zone3Alert = true,
    this.zone4Alert = true,
    this.zone5Alert = true,
    this.zone1SemiAlert = true,
    this.zone2SemiAlert = true,
    this.zone3SemiAlert = true,
    this.zone4SemiAlert = true,
    this.zone5SemiAlert = true,
    this.allZonesSemiAlert = true,
    this.semiActiveZones = true,
    
    // میزان صدای هشدارهای زون‌ها
    this.zone1AlertVolume = 0.7,
    this.zone2AlertVolume = 0.7,
    this.zone3AlertVolume = 0.7,
    this.zone4AlertVolume = 0.7,
    this.zone5AlertVolume = 0.7,
    this.zone1SemiAlertVolume = 0.7,
    this.zone2SemiAlertVolume = 0.7,
    this.zone3SemiAlertVolume = 0.7,
    this.zone4SemiAlertVolume = 0.7,
    this.zone5SemiAlertVolume = 0.7,
    this.allZonesSemiAlertVolume = 0.7,
    this.semiActiveZonesVolume = 0.7,
    
    // اعلام تنظیمات
    this.zonesStatus = true,
    this.relaysStatus = true,
    this.connectStatus = true,
    this.batteryStatus = true,
    this.simStatus = true,
    this.powerStatus = true,
    this.deviceLossPower = true,
    this.simCredit = true,
    this.deviceLostConnection = true,
    
    // میزان صدای اعلام تنظیمات
    this.zonesStatusVolume = 0.7,
    this.relaysStatusVolume = 0.7,
    this.connectStatusVolume = 0.7,
    this.batteryStatusVolume = 0.7,
    this.simStatusVolume = 0.7,
    this.powerStatusVolume = 0.7,
    this.deviceLossPowerVolume = 0.7,
    this.simCreditVolume = 0.7,
    this.deviceLostConnectionVolume = 0.7,
    
    // هشدارهای امنیتی
    this.sirenEnabled = true,
    this.incorrectCode = true,
    this.disconnectedSensor = true,
    this.adminManager = true,
    this.activateRelay = true,
    this.deactivateRelay = true,
    this.deleteBackup = true,
    this.networkLost = true,
    this.deactivatedByUser = true,
    this.deactivatedByAdmin = true,
    this.deactivatedByTimer = true,
    this.deactivatedByBackup = true,
    this.silenceMode = true,
    
    // میزان صدای هشدارهای امنیتی
    this.sirenEnabledVolume = 0.7,
    this.incorrectCodeVolume = 0.7,
    this.disconnectedSensorVolume = 0.7,
    this.adminManagerVolume = 0.7,
    this.activateRelayVolume = 0.7,
    this.deactivateRelayVolume = 0.7,
    this.deleteBackupVolume = 0.7,
    this.networkLostVolume = 0.7,
    this.deactivatedByUserVolume = 0.7,
    this.deactivatedByAdminVolume = 0.7,
    this.deactivatedByTimerVolume = 0.7,
    this.deactivatedByBackupVolume = 0.7,
    this.silenceModeVolume = 0.7,
  });

  @override
  List<Object?> get props => [
        id,
        deviceId,
        volume,
        generalArmed,
        generalDisarmed,
        generalReportByUser,
        noAccess,
        powerOn,
        powerOff,
        sirenTriggered,
        sirenTimeExpired,
        chargeLow,
        batteryLow,
        batteryDisconnected,
        sirenOff,
        reportByAdmin,
        deviceBackupDeleted,
        zone1Alert,
        zone2Alert,
        zone3Alert,
        zone4Alert,
        zone5Alert,
        zone1SemiAlert,
        zone2SemiAlert,
        zone3SemiAlert,
        zone4SemiAlert,
        zone5SemiAlert,
        allZonesSemiAlert,
        semiActiveZones,
        zonesStatus,
        relaysStatus,
        connectStatus,
        batteryStatus,
        simStatus,
        powerStatus,
        deviceLossPower,
        simCredit,
        deviceLostConnection,
        sirenEnabled,
        incorrectCode,
        disconnectedSensor,
        adminManager,
        activateRelay,
        deactivateRelay,
        deleteBackup,
        networkLost,
        deactivatedByUser,
        deactivatedByAdmin,
        deactivatedByTimer,
        deactivatedByBackup,
        silenceMode,
      ];
      
  AudioNotification copyWith({
    int? id,
    int? deviceId,
    double? volume,
    bool? generalArmed,
    bool? generalDisarmed,
    bool? generalReportByUser,
    bool? noAccess,
    bool? powerOn,
    bool? powerOff,
    bool? sirenTriggered,
    bool? sirenTimeExpired,
    bool? chargeLow,
    bool? batteryLow,
    bool? batteryDisconnected,
    bool? sirenOff,
    bool? reportByAdmin,
    bool? deviceBackupDeleted,
    
    // میزان صدای هشدارهای سیستم
    double? generalArmedVolume,
    double? generalDisarmedVolume,
    double? generalReportByUserVolume,
    double? noAccessVolume,
    double? powerOnVolume,
    double? powerOffVolume,
    double? sirenTriggeredVolume,
    double? sirenTimeExpiredVolume,
    double? chargeLowVolume,
    double? batteryLowVolume,
    double? batteryDisconnectedVolume,
    double? sirenOffVolume,
    double? reportByAdminVolume,
    double? deviceBackupDeletedVolume,
    
    bool? zone1Alert,
    bool? zone2Alert,
    bool? zone3Alert,
    bool? zone4Alert,
    bool? zone5Alert,
    bool? zone1SemiAlert,
    bool? zone2SemiAlert,
    bool? zone3SemiAlert,
    bool? zone4SemiAlert,
    bool? zone5SemiAlert,
    bool? allZonesSemiAlert,
    bool? semiActiveZones,
    
    // میزان صدای هشدارهای زون‌ها
    double? zone1AlertVolume,
    double? zone2AlertVolume,
    double? zone3AlertVolume,
    double? zone4AlertVolume,
    double? zone5AlertVolume,
    double? zone1SemiAlertVolume,
    double? zone2SemiAlertVolume,
    double? zone3SemiAlertVolume,
    double? zone4SemiAlertVolume,
    double? zone5SemiAlertVolume,
    double? allZonesSemiAlertVolume,
    double? semiActiveZonesVolume,
    
    bool? zonesStatus,
    bool? relaysStatus,
    bool? connectStatus,
    bool? batteryStatus,
    bool? simStatus,
    bool? powerStatus,
    bool? deviceLossPower,
    bool? simCredit,
    bool? deviceLostConnection,
    
    // میزان صدای اعلام تنظیمات
    double? zonesStatusVolume,
    double? relaysStatusVolume,
    double? connectStatusVolume,
    double? batteryStatusVolume,
    double? simStatusVolume,
    double? powerStatusVolume,
    double? deviceLossPowerVolume,
    double? simCreditVolume,
    double? deviceLostConnectionVolume,
    
    bool? sirenEnabled,
    bool? incorrectCode,
    bool? disconnectedSensor,
    bool? adminManager,
    bool? activateRelay,
    bool? deactivateRelay,
    bool? deleteBackup,
    bool? networkLost,
    bool? deactivatedByUser,
    bool? deactivatedByAdmin,
    bool? deactivatedByTimer,
    bool? deactivatedByBackup,
    bool? silenceMode,
    
    // میزان صدای هشدارهای امنیتی
    double? sirenEnabledVolume,
    double? incorrectCodeVolume,
    double? disconnectedSensorVolume,
    double? adminManagerVolume,
    double? activateRelayVolume,
    double? deactivateRelayVolume,
    double? deleteBackupVolume,
    double? networkLostVolume,
    double? deactivatedByUserVolume,
    double? deactivatedByAdminVolume,
    double? deactivatedByTimerVolume,
    double? deactivatedByBackupVolume,
    double? silenceModeVolume,
  }) {
    return AudioNotification(
      id: id ?? this.id,
      deviceId: deviceId ?? this.deviceId,
      volume: volume ?? this.volume,
      generalArmed: generalArmed ?? this.generalArmed,
      generalDisarmed: generalDisarmed ?? this.generalDisarmed,
      generalReportByUser: generalReportByUser ?? this.generalReportByUser,
      noAccess: noAccess ?? this.noAccess,
      powerOn: powerOn ?? this.powerOn,
      powerOff: powerOff ?? this.powerOff,
      sirenTriggered: sirenTriggered ?? this.sirenTriggered,
      sirenTimeExpired: sirenTimeExpired ?? this.sirenTimeExpired,
      chargeLow: chargeLow ?? this.chargeLow,
      batteryLow: batteryLow ?? this.batteryLow,
      batteryDisconnected: batteryDisconnected ?? this.batteryDisconnected,
      sirenOff: sirenOff ?? this.sirenOff,
      reportByAdmin: reportByAdmin ?? this.reportByAdmin,
      deviceBackupDeleted: deviceBackupDeleted ?? this.deviceBackupDeleted,
      
      // میزان صدای هشدارهای سیستم
      generalArmedVolume: generalArmedVolume ?? this.generalArmedVolume,
      generalDisarmedVolume: generalDisarmedVolume ?? this.generalDisarmedVolume,
      generalReportByUserVolume: generalReportByUserVolume ?? this.generalReportByUserVolume,
      noAccessVolume: noAccessVolume ?? this.noAccessVolume,
      powerOnVolume: powerOnVolume ?? this.powerOnVolume,
      powerOffVolume: powerOffVolume ?? this.powerOffVolume,
      sirenTriggeredVolume: sirenTriggeredVolume ?? this.sirenTriggeredVolume,
      sirenTimeExpiredVolume: sirenTimeExpiredVolume ?? this.sirenTimeExpiredVolume,
      chargeLowVolume: chargeLowVolume ?? this.chargeLowVolume,
      batteryLowVolume: batteryLowVolume ?? this.batteryLowVolume,
      batteryDisconnectedVolume: batteryDisconnectedVolume ?? this.batteryDisconnectedVolume,
      sirenOffVolume: sirenOffVolume ?? this.sirenOffVolume,
      reportByAdminVolume: reportByAdminVolume ?? this.reportByAdminVolume,
      deviceBackupDeletedVolume: deviceBackupDeletedVolume ?? this.deviceBackupDeletedVolume,
      
      zone1Alert: zone1Alert ?? this.zone1Alert,
      zone2Alert: zone2Alert ?? this.zone2Alert,
      zone3Alert: zone3Alert ?? this.zone3Alert,
      zone4Alert: zone4Alert ?? this.zone4Alert,
      zone5Alert: zone5Alert ?? this.zone5Alert,
      zone1SemiAlert: zone1SemiAlert ?? this.zone1SemiAlert,
      zone2SemiAlert: zone2SemiAlert ?? this.zone2SemiAlert,
      zone3SemiAlert: zone3SemiAlert ?? this.zone3SemiAlert,
      zone4SemiAlert: zone4SemiAlert ?? this.zone4SemiAlert,
      zone5SemiAlert: zone5SemiAlert ?? this.zone5SemiAlert,
      allZonesSemiAlert: allZonesSemiAlert ?? this.allZonesSemiAlert,
      semiActiveZones: semiActiveZones ?? this.semiActiveZones,
      
      // میزان صدای هشدارهای زون‌ها
      zone1AlertVolume: zone1AlertVolume ?? this.zone1AlertVolume,
      zone2AlertVolume: zone2AlertVolume ?? this.zone2AlertVolume,
      zone3AlertVolume: zone3AlertVolume ?? this.zone3AlertVolume,
      zone4AlertVolume: zone4AlertVolume ?? this.zone4AlertVolume,
      zone5AlertVolume: zone5AlertVolume ?? this.zone5AlertVolume,
      zone1SemiAlertVolume: zone1SemiAlertVolume ?? this.zone1SemiAlertVolume,
      zone2SemiAlertVolume: zone2SemiAlertVolume ?? this.zone2SemiAlertVolume,
      zone3SemiAlertVolume: zone3SemiAlertVolume ?? this.zone3SemiAlertVolume,
      zone4SemiAlertVolume: zone4SemiAlertVolume ?? this.zone4SemiAlertVolume,
      zone5SemiAlertVolume: zone5SemiAlertVolume ?? this.zone5SemiAlertVolume,
      allZonesSemiAlertVolume: allZonesSemiAlertVolume ?? this.allZonesSemiAlertVolume,
      semiActiveZonesVolume: semiActiveZonesVolume ?? this.semiActiveZonesVolume,
      
      zonesStatus: zonesStatus ?? this.zonesStatus,
      relaysStatus: relaysStatus ?? this.relaysStatus,
      connectStatus: connectStatus ?? this.connectStatus,
      batteryStatus: batteryStatus ?? this.batteryStatus,
      simStatus: simStatus ?? this.simStatus,
      powerStatus: powerStatus ?? this.powerStatus,
      deviceLossPower: deviceLossPower ?? this.deviceLossPower,
      simCredit: simCredit ?? this.simCredit,
      deviceLostConnection: deviceLostConnection ?? this.deviceLostConnection,
      
      // میزان صدای اعلام تنظیمات
      zonesStatusVolume: zonesStatusVolume ?? this.zonesStatusVolume,
      relaysStatusVolume: relaysStatusVolume ?? this.relaysStatusVolume,
      connectStatusVolume: connectStatusVolume ?? this.connectStatusVolume,
      batteryStatusVolume: batteryStatusVolume ?? this.batteryStatusVolume,
      simStatusVolume: simStatusVolume ?? this.simStatusVolume,
      powerStatusVolume: powerStatusVolume ?? this.powerStatusVolume,
      deviceLossPowerVolume: deviceLossPowerVolume ?? this.deviceLossPowerVolume,
      simCreditVolume: simCreditVolume ?? this.simCreditVolume,
      deviceLostConnectionVolume: deviceLostConnectionVolume ?? this.deviceLostConnectionVolume,
      
      sirenEnabled: sirenEnabled ?? this.sirenEnabled,
      incorrectCode: incorrectCode ?? this.incorrectCode,
      disconnectedSensor: disconnectedSensor ?? this.disconnectedSensor,
      adminManager: adminManager ?? this.adminManager,
      activateRelay: activateRelay ?? this.activateRelay,
      deactivateRelay: deactivateRelay ?? this.deactivateRelay,
      deleteBackup: deleteBackup ?? this.deleteBackup,
      networkLost: networkLost ?? this.networkLost,
      deactivatedByUser: deactivatedByUser ?? this.deactivatedByUser,
      deactivatedByAdmin: deactivatedByAdmin ?? this.deactivatedByAdmin,
      deactivatedByTimer: deactivatedByTimer ?? this.deactivatedByTimer,
      deactivatedByBackup: deactivatedByBackup ?? this.deactivatedByBackup,
      silenceMode: silenceMode ?? this.silenceMode,
      
      // میزان صدای هشدارهای امنیتی
      sirenEnabledVolume: sirenEnabledVolume ?? this.sirenEnabledVolume,
      incorrectCodeVolume: incorrectCodeVolume ?? this.incorrectCodeVolume,
      disconnectedSensorVolume: disconnectedSensorVolume ?? this.disconnectedSensorVolume,
      adminManagerVolume: adminManagerVolume ?? this.adminManagerVolume,
      activateRelayVolume: activateRelayVolume ?? this.activateRelayVolume,
      deactivateRelayVolume: deactivateRelayVolume ?? this.deactivateRelayVolume,
      deleteBackupVolume: deleteBackupVolume ?? this.deleteBackupVolume,
      networkLostVolume: networkLostVolume ?? this.networkLostVolume,
      deactivatedByUserVolume: deactivatedByUserVolume ?? this.deactivatedByUserVolume,
      deactivatedByAdminVolume: deactivatedByAdminVolume ?? this.deactivatedByAdminVolume,
      deactivatedByTimerVolume: deactivatedByTimerVolume ?? this.deactivatedByTimerVolume,
      deactivatedByBackupVolume: deactivatedByBackupVolume ?? this.deactivatedByBackupVolume,
      silenceModeVolume: silenceModeVolume ?? this.silenceModeVolume,
    );
  }
} 