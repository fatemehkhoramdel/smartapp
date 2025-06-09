import 'package:equatable/equatable.dart';
import 'package:floor/floor.dart';

import '../core/constants/constants.dart';
import '../core/constants/database_constants.dart';

@Entity(
  tableName: kDeviceTable,
  /* indices: [
    Index(value: ['devicePhone'], unique: true)
  ], */
)
class Device extends Equatable {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final String deviceName;
  final String devicePassword;
  //@ColumnInfo(name: 'devicePhone')
  final String devicePhone;
  final String deviceModel;
  final String deviceState;
  final bool isManager;
  final String alarmTime;
  final int remoteAmount;
  final int simChargeAmount;
  final int antennaAmount;
  final int batteryAmount;
  final bool cityPowerState;
  final bool gsmState;
  final bool speakerState;
  final bool networkState;
  final int capsulMax;
  final int capsulMin;
  final int totalContactsAmount;
  final int spyAmount;
  final int chargePeriodictReport;
  final int batteryPeriodictReport;
  final int callOrder;

  // General Settings
  final int alarmDuration;
  final int callDuration;
  final bool controlRelaysWithRemote;
  final bool monitoring;
  final bool remoteReporting;
  final bool scenarioReporting;
  final bool callPriority;
  final bool smsPriority;

  ///Buttons state
  final String operator;
  final String deviceLang;
  final String deviceSimLang;
  final bool silentOnSiren;
  final bool relayOnDingDong;
  final bool callOnPowerLoss;
  final bool manageWithContacts;

  ///Home visibility items
  final bool gsmStateVisibility;
  final bool remoteAmountVisibility;
  final bool antennaAmountVisibility;
  final bool contactsAmountVisibility;
  final bool networkStateVisibility;
  final bool batteryShapeVisibility;
  final bool zone1Visibility;
  final bool zone2Visibility;
  final bool zone3Visibility;
  final bool zone4Visibility;
  final bool zone5Visibility;
  final bool relay1Visibility;
  final bool relay2Visibility;
  final bool relay1SectionVisibility;
  final bool relay2SectionVisibility;
  final bool semiActiveVisibility;
  final bool silentVisibility;
  final bool spyVisibility;
  final bool relay1ActiveBtnVisibility;
  final bool relay2ActiveBtnVisibility;
  final bool relay1TriggerBtnVisibility;
  final bool relay2TriggerBtnVisibility;

  ///Relays
  /* final String relay1Name;
  final String relay1TriggerTime;
  final bool relay1State;
  final String relay2Name;
  final String relay2TriggerTime;
  final bool relay2State; */

  ///Zones
  final String zone1Name;
  final String zone1Condition;
  final bool zone1State;
  final bool zone1SemiActive;
  final String zone2Name;
  final String zone2Condition;
  final bool zone2State;
  final bool zone2SemiActive;
  final String zone3Name;
  final String zone3Condition;
  final bool zone3State;
  final bool zone3SemiActive;
  final String zone4Name;
  final String zone4Condition;
  final bool zone4State;
  final bool zone4SemiActive;
  final String zone5Name;
  final String zone5Condition;
  final bool zone5State;
  final bool zone5SemiActive;

  /// scenario
  final String? deviceStatus1;
  final String? inputType1;
  final String? inputSelect1;
  final String? actionType1;
  final String? actionSelect1;
  final String? scenarioName1;
  final String? deviceStatus2;
  final String? inputType2;
  final String? inputSelect2;
  final String? actionType2;
  final String? actionSelect2;
  final String? scenarioName2;
  final String? deviceStatus3;
  final String? inputType3;
  final String? inputSelect3;
  final String? actionType3;
  final String? actionSelect3;
  final String? scenarioName3;
  final String? deviceStatus4;
  final String? inputType4;
  final String? inputSelect4;
  final String? actionType4;
  final String? actionSelect4;
  final String? scenarioName4;
  final String? deviceStatus5;
  final String? inputType5;
  final String? inputSelect5;
  final String? actionType5;
  final String? actionSelect5;
  final String? scenarioName5;
  final String? deviceStatus6;
  final String? inputType6;
  final String? inputSelect6;
  final String? actionType6;
  final String? actionSelect6;
  final String? scenarioName6;
  final String? deviceStatus7;
  final String? inputType7;
  final String? inputSelect7;
  final String? actionType7;
  final String? actionSelect7;
  final String? scenarioName7;
  final String? deviceStatus8;
  final String? inputType8;
  final String? inputSelect8;
  final String? actionType8;
  final String? actionSelect8;
  final String? scenarioName8;
  final String? deviceStatus9;
  final String? inputType9;
  final String? inputSelect9;
  final String? actionType9;
  final String? actionSelect9;
  final String? scenarioName9;
  final String? deviceStatus10;
  final String? inputType10;
  final String? inputSelect10;
  final String? actionType10;
  final String? actionSelect10;
  final String? scenarioName10;

  /// contacts
  final String contact1Phone;
  final bool contact1SMS;
  final bool contact1Call;
  final bool contact1Manager;
  final String contact2Phone;
  final bool contact2SMS;
  final bool contact2Call;
  final bool contact2Manager;
  final String contact3Phone;
  final bool contact3SMS;
  final bool contact3Call;
  final bool contact3Manager;
  final String contact4Phone;
  final bool contact4SMS;
  final bool contact4Call;
  final bool contact4Manager;
  final String contact5Phone;
  final bool contact5SMS;
  final bool contact5Call;
  final bool contact5Manager;
  final String contact6Phone;
  final bool contact6SMS;
  final bool contact6Call;
  final bool contact6Manager;
  final String contact7Phone;
  final bool contact7SMS;
  final bool contact7Call;
  final bool contact7Manager;
  final String contact8Phone;
  final bool contact8SMS;
  final bool contact8Call;
  final bool contact8Manager;
  final String contact9Phone;
  final bool contact9SMS;
  final bool contact9Call;
  final bool contact9Manager;
  final String contact10Phone;
  final bool contact10SMS;
  final bool contact10Call;
  final bool contact10Manager;

  const Device({
    this.id,
    this.deviceName = kDefaultDeviceName,
    this.devicePassword = kDefaultDevicePassword,
    this.devicePhone = '',
    this.deviceModel = kDefaultDeviceModel,
    this.deviceState = kDefaultState,
    this.isManager = true,
    this.alarmTime = kDefaultAlertTime,
    this.remoteAmount = 0,
    this.simChargeAmount = 0,
    this.antennaAmount = 0,
    this.batteryAmount = -1,
    this.cityPowerState = false,
    this.gsmState = false,
    this.speakerState = false,
    this.networkState = false,
    this.capsulMax = 20000,
    this.capsulMin = 2000,
    this.totalContactsAmount = 0,
    this.spyAmount = 15,
    this.chargePeriodictReport = 12,
    this.batteryPeriodictReport = 0,
    this.callOrder = 1,
    this.operator = '',
    this.deviceLang = '',
    this.deviceSimLang = '',
    this.silentOnSiren = false,
    this.relayOnDingDong = false,
    this.callOnPowerLoss = false,
    this.manageWithContacts = false,
    this.gsmStateVisibility = false,
    this.remoteAmountVisibility = false,
    this.antennaAmountVisibility = false,
    this.contactsAmountVisibility = false,
    this.batteryShapeVisibility = false,
    this.networkStateVisibility = false,
    this.zone1Visibility = false,
    this.zone2Visibility = false,
    this.zone3Visibility = false,
    this.zone4Visibility = false,
    this.zone5Visibility = false,
    this.relay1Visibility = false,
    this.relay2Visibility = false,
    this.relay1SectionVisibility = false,
    this.relay2SectionVisibility = false,
    this.semiActiveVisibility = false,
    this.silentVisibility = false,
    this.spyVisibility = false,
    this.relay1ActiveBtnVisibility = false,
    this.relay2ActiveBtnVisibility = false,
    this.relay1TriggerBtnVisibility = true,
    this.relay2TriggerBtnVisibility = true,
    /* this.relay1Name = kRelay1Name,
    this.relay1TriggerTime = kDefaultRelayTrigger,
    this.relay1State = false,
    this.relay2Name = kRelay2Name,
    this.relay2TriggerTime = kDefaultRelayTrigger,
    this.relay2State = false, */
    this.zone1Name = kZone1Name,
    this.zone1Condition = kDefaultZoneType,
    this.zone1State = false,
    this.zone1SemiActive = false,
    this.zone2Name = kZone2Name,
    this.zone2Condition = kDefaultZoneType,
    this.zone2State = false,
    this.zone2SemiActive = false,
    this.zone3Name = kZone3Name,
    this.zone3Condition = kDefaultZoneType,
    this.zone3State = false,
    this.zone3SemiActive = false,
    this.zone4Name = kZone4Name,
    this.zone4Condition = kDefaultZoneType,
    this.zone4State = false,
    this.zone4SemiActive = false,
    this.zone5Name = kZone5Name,
    this.zone5Condition = kDefaultZoneType,
    this.zone5State = false,
    this.zone5SemiActive = false,
    // Initialize new contacts
    this.deviceStatus1,
    this.inputType1,
    this.inputSelect1,
    this.actionType1,
    this.actionSelect1,
    this.scenarioName1,
    this.deviceStatus2,
    this.inputType2,
    this.inputSelect2,
    this.actionType2,
    this.actionSelect2,
    this.scenarioName2,
    this.deviceStatus3,
    this.inputType3,
    this.inputSelect3,
    this.actionType3,
    this.actionSelect3,
    this.scenarioName3,
    this.deviceStatus4,
    this.inputType4,
    this.inputSelect4,
    this.actionType4,
    this.actionSelect4,
    this.scenarioName4,
    this.deviceStatus5,
    this.inputType5,
    this.inputSelect5,
    this.actionType5,
    this.actionSelect5,
    this.scenarioName5,
    this.deviceStatus6,
    this.inputType6,
    this.inputSelect6,
    this.actionType6,
    this.actionSelect6,
    this.scenarioName6,
    this.deviceStatus7,
    this.inputType7,
    this.inputSelect7,
    this.actionType7,
    this.actionSelect7,
    this.scenarioName7,
    this.deviceStatus8,
    this.inputType8,
    this.inputSelect8,
    this.actionType8,
    this.actionSelect8,
    this.scenarioName8,
    this.deviceStatus9,
    this.inputType9,
    this.inputSelect9,
    this.actionType9,
    this.actionSelect9,
    this.scenarioName9,
    this.deviceStatus10,
    this.inputType10,
    this.inputSelect10,
    this.actionType10,
    this.actionSelect10,
    this.scenarioName10,
    this.contact1Phone = '',
    this.contact1SMS = false,
    this.contact1Call = false,
    this.contact1Manager = false,
    this.contact2Phone = '',
    this.contact2SMS = false,
    this.contact2Call = false,
    this.contact2Manager = false,
    this.contact3Phone = '',
    this.contact3SMS = false,
    this.contact3Call = false,
    this.contact3Manager = false,
    this.contact4Phone = '',
    this.contact4SMS = false,
    this.contact4Call = false,
    this.contact4Manager = false,
    this.contact5Phone = '',
    this.contact5SMS = false,
    this.contact5Call = false,
    this.contact5Manager = false,
    this.contact6Phone = '',
    this.contact6SMS = false,
    this.contact6Call = false,
    this.contact6Manager = false,
    this.contact7Phone = '',
    this.contact7SMS = false,
    this.contact7Call = false,
    this.contact7Manager = false,
    this.contact8Phone = '',
    this.contact8SMS = false,
    this.contact8Call = false,
    this.contact8Manager = false,
    this.contact9Phone = '',
    this.contact9SMS = false,
    this.contact9Call = false,
    this.contact9Manager = false,
    this.contact10Phone = '',
    this.contact10SMS = false,
    this.contact10Call = false,
    this.contact10Manager = false,
    this.alarmDuration = 120,
    this.callDuration = 10,
    this.controlRelaysWithRemote = false,
    this.monitoring = false,
    this.remoteReporting = false,
    this.scenarioReporting = false,
    this.callPriority = false,
    this.smsPriority = false,
  });

  @override
  List<Object?> get props => [
        id,
        deviceName,
        devicePassword,
        devicePhone,
        deviceModel,
        deviceState,
        isManager,
        alarmTime,
        remoteAmount,
        simChargeAmount,
        antennaAmount,
        batteryAmount,
        cityPowerState,
        gsmState,
        speakerState,
        networkState,
        capsulMax,
        capsulMin,
        totalContactsAmount,
        spyAmount,
        chargePeriodictReport,
        batteryPeriodictReport,
        callOrder,
        operator,
        deviceLang,
        deviceSimLang,
        silentOnSiren,
        relayOnDingDong,
        callOnPowerLoss,
        manageWithContacts,
        gsmStateVisibility,
        remoteAmountVisibility,
        antennaAmountVisibility,
        contactsAmountVisibility,
        batteryShapeVisibility,
        networkStateVisibility,
        zone1Visibility,
        zone2Visibility,
        zone3Visibility,
        zone4Visibility,
        zone5Visibility,
        deviceStatus1,
        inputType1,
        inputSelect1,
        actionType1,
        actionSelect1,
        scenarioName1,
        deviceStatus2,
        inputType2,
        inputSelect2,
        actionType2,
        actionSelect2,
        scenarioName2,
        deviceStatus3,
        inputType3,
        inputSelect3,
        actionType3,
        actionSelect3,
        scenarioName3,
        deviceStatus4,
        inputType4,
        inputSelect4,
        actionType4,
        actionSelect4,
        scenarioName4,
        deviceStatus5,
        inputType5,
        inputSelect5,
        actionType5,
        actionSelect5,
        scenarioName5,
        deviceStatus6,
        inputType6,
        inputSelect6,
        actionType6,
        actionSelect6,
        scenarioName6,
        deviceStatus7,
        inputType7,
        inputSelect7,
        actionType7,
        actionSelect7,
        scenarioName7,
        deviceStatus8,
        inputType8,
        inputSelect8,
        actionType8,
        actionSelect8,
        scenarioName8,
        deviceStatus9,
        inputType9,
        inputSelect9,
        actionType9,
        actionSelect9,
        scenarioName9,
        deviceStatus10,
        inputType10,
        inputSelect10,
        actionType10,
        actionSelect10,
        scenarioName10,
        relay1Visibility,
        relay2Visibility,
        relay1SectionVisibility,
        relay2SectionVisibility,
        semiActiveVisibility,
        silentVisibility,
        spyVisibility,
        relay1ActiveBtnVisibility,
        relay2ActiveBtnVisibility,
        relay1TriggerBtnVisibility,
        relay2TriggerBtnVisibility,
        /* relay1Name,
        relay1TriggerTime,
        relay1State,
        relay2Name,
        relay2TriggerTime,
        relay2State, */
        zone1Name,
        zone1Condition,
        zone1State,
        zone1SemiActive,
        zone2Name,
        zone2Condition,
        zone2State,
        zone2SemiActive,
        zone3Name,
        zone3Condition,
        zone3State,
        zone3SemiActive,
        zone4Name,
        zone4Condition,
        zone4State,
        zone4SemiActive,
        zone5Name,
        zone5Condition,
        zone5State,
        zone5SemiActive,
        contact1Phone,
        contact1SMS,
        contact1Call,
        contact1Manager,
        contact2Phone,
        contact2SMS,
        contact2Call,
        contact2Manager,
        contact3Phone,
        contact3SMS,
        contact3Call,
        contact3Manager,
        contact4Phone,
        contact4SMS,
        contact4Call,
        contact4Manager,
        contact5Phone,
        contact5SMS,
        contact5Call,
        contact5Manager,
        contact6Phone,
        contact6SMS,
        contact6Call,
        contact6Manager,
        contact7Phone,
        contact7SMS,
        contact7Call,
        contact7Manager,
        contact8Phone,
        contact8SMS,
        contact8Call,
        contact8Manager,
        contact9Phone,
        contact9SMS,
        contact9Call,
        contact9Manager,
        contact10Phone,
        contact10SMS,
        contact10Call,
        contact10Manager,
        alarmDuration,
        callDuration,
        controlRelaysWithRemote,
        monitoring,
        remoteReporting,
        scenarioReporting,
        callPriority,
        smsPriority,
      ];

  @override
  bool? get stringify => true;

  Device copyWith({
    int? id,
    String? deviceName,
    String? devicePassword,
    String? devicePhone,
    String? deviceModel,
    String? deviceState,
    bool? isManager,
    String? alarmTime,
    int? remoteAmount,
    int? simChargeAmount,
    int? antennaAmount,
    int? batteryAmount,
    bool? cityPowerState,
    bool? gsmState,
    bool? speakerState,
    bool? networkState,
    int? capsulMax,
    int? capsulMin,
    int? totalContactsAmount,
    int? spyAmount,
    int? chargePeriodictReport,
    int? batteryPeriodictReport,
    int? callOrder,
    String? operator,
    String? deviceLang,
    String? deviceSimLang,
    bool? silentOnSiren,
    bool? relayOnDingDong,
    bool? callOnPowerLoss,
    bool? manageWithContacts,
    bool? gsmStateVisibility,
    bool? remoteAmountVisibility,
    bool? antennaAmountVisibility,
    bool? contactsAmountVisibility,
    bool? networkStateVisibility,
    bool? batteryShapeVisibility,
    bool? zone1Visibility,
    bool? zone2Visibility,
    bool? zone3Visibility,
    bool? zone4Visibility,
    bool? zone5Visibility,
    bool? relay1Visibility,
    bool? relay2Visibility,
    bool? relay1SectionVisibility,
    bool? relay2SectionVisibility,
    bool? semiActiveVisibility,
    bool? silentVisibility,
    bool? spyVisibility,
    bool? relay1ActiveBtnVisibility,
    bool? relay2ActiveBtnVisibility,
    bool? relay1TriggerBtnVisibility,
    bool? relay2TriggerBtnVisibility,
    /* String? relay1Name,
    String? relay1TriggerTime,
    bool? relay1State,
    String? relay2Name,
    String? relay2TriggerTime,
    bool? relay2State, */
    String? zone1Name,
    String? zone1Condition,
    bool? zone1State,
    bool? zone1SemiActive,
    String? zone2Name,
    String? zone2Condition,
    bool? zone2State,
    bool? zone2SemiActive,
    String? zone3Name,
    String? zone3Condition,
    bool? zone3State,
    bool? zone3SemiActive,
    String? zone4Name,
    String? zone4Condition,
    bool? zone4State,
    bool? zone4SemiActive,
    String? zone5Name,
    String? zone5Condition,
    bool? zone5State,
    bool? zone5SemiActive,
    String? deviceStatus1,
    String? inputType1,
    String? inputSelect1,
    String? actionType1,
    String? actionSelect1,
    String? scenarioName1,
    String? deviceStatus2,
    String? inputType2,
    String? inputSelect2,
    String? actionType2,
    String? actionSelect2,
    String? scenarioName2,
    String? deviceStatus3,
    String? inputType3,
    String? inputSelect3,
    String? actionType3,
    String? actionSelect3,
    String? scenarioName3,
    String? deviceStatus4,
    String? inputType4,
    String? inputSelect4,
    String? actionType4,
    String? actionSelect4,
    String? scenarioName4,
    String? deviceStatus5,
    String? inputType5,
    String? inputSelect5,
    String? actionType5,
    String? actionSelect5,
    String? scenarioName5,
    String? deviceStatus6,
    String? inputType6,
    String? inputSelect6,
    String? actionType6,
    String? actionSelect6,
    String? scenarioName6,
    String? deviceStatus7,
    String? inputType7,
    String? inputSelect7,
    String? actionType7,
    String? actionSelect7,
    String? scenarioName7,
    String? deviceStatus8,
    String? inputType8,
    String? inputSelect8,
    String? actionType8,
    String? actionSelect8,
    String? scenarioName8,
    String? deviceStatus9,
    String? inputType9,
    String? inputSelect9,
    String? actionType9,
    String? actionSelect9,
    String? scenarioName9,
    String? deviceStatus10,
    String? inputType10,
    String? inputSelect10,
    String? actionType10,
    String? actionSelect10,
    String? scenarioName10,
    String? contact1Phone,
    bool? contact1SMS,
    bool? contact1Call,
    bool? contact1Manager,
    String? contact2Phone,
    bool? contact2SMS,
    bool? contact2Call,
    bool? contact2Manager,
    String? contact3Phone,
    bool? contact3SMS,
    bool? contact3Call,
    bool? contact3Manager,
    String? contact4Phone,
    bool? contact4SMS,
    bool? contact4Call,
    bool? contact4Manager,
    String? contact5Phone,
    bool? contact5SMS,
    bool? contact5Call,
    bool? contact5Manager,
    String? contact6Phone,
    bool? contact6SMS,
    bool? contact6Call,
    bool? contact6Manager,
    String? contact7Phone,
    bool? contact7SMS,
    bool? contact7Call,
    bool? contact7Manager,
    String? contact8Phone,
    bool? contact8SMS,
    bool? contact8Call,
    bool? contact8Manager,
    String? contact9Phone,
    bool? contact9SMS,
    bool? contact9Call,
    bool? contact9Manager,
    String? contact10Phone,
    bool? contact10SMS,
    bool? contact10Call,
    bool? contact10Manager,
    int? alarmDuration,
    int? callDuration,
    bool? controlRelaysWithRemote,
    bool? monitoring,
    bool? remoteReporting,
    bool? scenarioReporting,
    bool? callPriority,
    bool? smsPriority,
  }) {
    return Device(
      id: id ?? this.id,
      deviceName: deviceName ?? this.deviceName,
      devicePassword: devicePassword ?? this.devicePassword,
      devicePhone: devicePhone ?? this.devicePhone,
      deviceModel: deviceModel ?? this.deviceModel,
      deviceState: deviceState ?? this.deviceState,
      isManager: isManager ?? this.isManager,
      alarmTime: alarmTime ?? this.alarmTime,
      remoteAmount: remoteAmount ?? this.remoteAmount,
      simChargeAmount: simChargeAmount ?? this.simChargeAmount,
      antennaAmount: antennaAmount ?? this.antennaAmount,
      batteryAmount: batteryAmount ?? this.batteryAmount,
      cityPowerState: cityPowerState ?? this.cityPowerState,
      gsmState: gsmState ?? this.gsmState,
      speakerState: speakerState ?? this.speakerState,
      networkState: networkState ?? this.networkState,
      capsulMax: capsulMax ?? this.capsulMax,
      capsulMin: capsulMin ?? this.capsulMin,
      totalContactsAmount: totalContactsAmount ?? this.totalContactsAmount,
      spyAmount: spyAmount ?? this.spyAmount,
      chargePeriodictReport:
          chargePeriodictReport ?? this.chargePeriodictReport,
      batteryPeriodictReport:
          batteryPeriodictReport ?? this.batteryPeriodictReport,
      callOrder: callOrder ?? this.callOrder,
      operator: operator ?? this.operator,
      deviceLang: deviceLang ?? this.deviceLang,
      deviceSimLang: deviceSimLang ?? this.deviceSimLang,
      silentOnSiren: silentOnSiren ?? this.silentOnSiren,
      relayOnDingDong: relayOnDingDong ?? this.relayOnDingDong,
      callOnPowerLoss: callOnPowerLoss ?? this.callOnPowerLoss,
      manageWithContacts: manageWithContacts ?? this.manageWithContacts,
      gsmStateVisibility: gsmStateVisibility ?? this.gsmStateVisibility,
      remoteAmountVisibility:
          remoteAmountVisibility ?? this.remoteAmountVisibility,
      antennaAmountVisibility:
          antennaAmountVisibility ?? this.antennaAmountVisibility,
      contactsAmountVisibility:
          contactsAmountVisibility ?? this.contactsAmountVisibility,
      networkStateVisibility:
          networkStateVisibility ?? this.networkStateVisibility,
      batteryShapeVisibility:
          batteryShapeVisibility ?? this.batteryShapeVisibility,
      zone1Visibility: zone1Visibility ?? this.zone1Visibility,
      zone2Visibility: zone2Visibility ?? this.zone2Visibility,
      zone3Visibility: zone3Visibility ?? this.zone3Visibility,
      zone4Visibility: zone4Visibility ?? this.zone4Visibility,
      zone5Visibility: zone5Visibility ?? this.zone5Visibility,
      deviceStatus1: deviceStatus1 ?? this.deviceStatus1,
      inputType1: inputType1 ?? this.inputType1,
      inputSelect1: inputSelect1 ?? this.inputSelect1,
      actionType1: actionType1 ?? this.actionType1,
      actionSelect1: actionSelect1 ?? this.actionSelect1,
      scenarioName1: scenarioName1 ?? this.scenarioName1,
      deviceStatus2: deviceStatus2 ?? this.deviceStatus2,
      inputType2: inputType2 ?? this.inputType2,
      inputSelect2: inputSelect2 ?? this.inputSelect2,
      actionType2: actionType2 ?? this.actionType2,
      actionSelect2: actionSelect2 ?? this.actionSelect2,
      scenarioName2: scenarioName2 ?? this.scenarioName2,
      deviceStatus3: deviceStatus3 ?? this.deviceStatus3,
      inputType3: inputType3 ?? this.inputType3,
      inputSelect3: inputSelect3 ?? this.inputSelect3,
      actionType3: actionType3 ?? this.actionType3,
      actionSelect3: actionSelect3 ?? this.actionSelect3,
      scenarioName3: scenarioName3 ?? this.scenarioName3,
      deviceStatus4: deviceStatus4 ?? this.deviceStatus4,
      inputType4: inputType4 ?? this.inputType4,
      inputSelect4: inputSelect4 ?? this.inputSelect4,
      actionType4: actionType4 ?? this.actionType4,
      actionSelect4: actionSelect4 ?? this.actionSelect4,
      scenarioName4: scenarioName4 ?? this.scenarioName4,
      deviceStatus5: deviceStatus5 ?? this.deviceStatus5,
      inputType5: inputType5 ?? this.inputType5,
      inputSelect5: inputSelect5 ?? this.inputSelect5,
      actionType5: actionType5 ?? this.actionType5,
      actionSelect5: actionSelect5 ?? this.actionSelect5,
      scenarioName5: scenarioName5 ?? this.scenarioName5,
      deviceStatus6: deviceStatus6 ?? this.deviceStatus6,
      inputType6: inputType6 ?? this.inputType6,
      inputSelect6: inputSelect6 ?? this.inputSelect6,
      actionType6: actionType6 ?? this.actionType6,
      actionSelect6: actionSelect6 ?? this.actionSelect6,
      scenarioName6: scenarioName6 ?? this.scenarioName6,
      deviceStatus7: deviceStatus7 ?? this.deviceStatus7,
      inputType7: inputType7 ?? this.inputType7,
      inputSelect7: inputSelect7 ?? this.inputSelect7,
      actionType7: actionType7 ?? this.actionType7,
      actionSelect7: actionSelect7 ?? this.actionSelect7,
      scenarioName7: scenarioName7 ?? this.scenarioName7,
      deviceStatus8: deviceStatus8 ?? this.deviceStatus8,
      inputType8: inputType8 ?? this.inputType8,
      inputSelect8: inputSelect8 ?? this.inputSelect8,
      actionType8: actionType8 ?? this.actionType8,
      actionSelect8: actionSelect8 ?? this.actionSelect8,
      scenarioName8: scenarioName8 ?? this.scenarioName8,
      deviceStatus9: deviceStatus9 ?? this.deviceStatus9,
      inputType9: inputType9 ?? this.inputType9,
      inputSelect9: inputSelect9 ?? this.inputSelect9,
      actionType9: actionType9 ?? this.actionType9,
      actionSelect9: actionSelect9 ?? this.actionSelect9,
      scenarioName9: scenarioName9 ?? this.scenarioName9,
      deviceStatus10: deviceStatus10 ?? this.deviceStatus10,
      inputType10: inputType10 ?? this.inputType10,
      inputSelect10: inputSelect10 ?? this.inputSelect10,
      actionType10: actionType10 ?? this.actionType10,
      actionSelect10: actionSelect10 ?? this.actionSelect10,
      scenarioName10: scenarioName10 ?? this.scenarioName10,
      relay1Visibility: relay1Visibility ?? this.relay1Visibility,
      relay2Visibility: relay2Visibility ?? this.relay2Visibility,
      relay1SectionVisibility:
          relay1SectionVisibility ?? this.relay1SectionVisibility,
      relay2SectionVisibility:
          relay2SectionVisibility ?? this.relay2SectionVisibility,
      semiActiveVisibility: semiActiveVisibility ?? this.semiActiveVisibility,
      silentVisibility: silentVisibility ?? this.silentVisibility,
      spyVisibility: spyVisibility ?? this.spyVisibility,
      relay1ActiveBtnVisibility:
          relay1ActiveBtnVisibility ?? this.relay1ActiveBtnVisibility,
      relay2ActiveBtnVisibility:
          relay2ActiveBtnVisibility ?? this.relay2ActiveBtnVisibility,
      relay1TriggerBtnVisibility:
          relay1TriggerBtnVisibility ?? this.relay1TriggerBtnVisibility,
      relay2TriggerBtnVisibility:
          relay2TriggerBtnVisibility ?? this.relay2TriggerBtnVisibility,
      /* relay1Name: relay1Name ?? this.relay1Name,
      relay1TriggerTime: relay1TriggerTime ?? this.relay1TriggerTime,
      relay1State: relay1State ?? this.relay1State,
      relay2Name: relay2Name ?? this.relay2Name,
      relay2TriggerTime: relay2TriggerTime ?? this.relay2TriggerTime,
      relay2State: relay2State ?? this.relay2State, */
      zone1Name: zone1Name ?? this.zone1Name,
      zone1Condition: zone1Condition ?? this.zone1Condition,
      zone1State: zone1State ?? this.zone1State,
      zone1SemiActive: zone1SemiActive ?? this.zone1SemiActive,
      zone2Name: zone2Name ?? this.zone2Name,
      zone2Condition: zone2Condition ?? this.zone2Condition,
      zone2State: zone2State ?? this.zone2State,
      zone2SemiActive: zone2SemiActive ?? this.zone2SemiActive,
      zone3Name: zone3Name ?? this.zone3Name,
      zone3Condition: zone3Condition ?? this.zone3Condition,
      zone3State: zone3State ?? this.zone3State,
      zone3SemiActive: zone3SemiActive ?? this.zone3SemiActive,
      zone4Name: zone4Name ?? this.zone4Name,
      zone4Condition: zone4Condition ?? this.zone4Condition,
      zone4State: zone4State ?? this.zone4State,
      zone4SemiActive: zone4SemiActive ?? this.zone4SemiActive,
      zone5Name: zone5Name ?? this.zone5Name,
      zone5Condition: zone5Condition ?? this.zone5Condition,
      zone5State: zone5State ?? this.zone5State,
      zone5SemiActive: zone5SemiActive ?? this.zone5SemiActive,
      contact1Phone: contact1Phone ?? this.contact1Phone,
      contact1SMS: contact1SMS ?? this.contact1SMS,
      contact1Call: contact1Call ?? this.contact1Call,
      contact1Manager: contact1Manager ?? this.contact1Manager,
      contact2Phone: contact2Phone ?? this.contact2Phone,
      contact2SMS: contact2SMS ?? this.contact2SMS,
      contact2Call: contact2Call ?? this.contact2Call,
      contact2Manager: contact2Manager ?? this.contact2Manager,
      contact3Phone: contact3Phone ?? this.contact3Phone,
      contact3SMS: contact3SMS ?? this.contact3SMS,
      contact3Call: contact3Call ?? this.contact3Call,
      contact3Manager: contact3Manager ?? this.contact3Manager,
      contact4Phone: contact4Phone ?? this.contact4Phone,
      contact4SMS: contact4SMS ?? this.contact4SMS,
      contact4Call: contact4Call ?? this.contact4Call,
      contact4Manager: contact4Manager ?? this.contact4Manager,
      contact5Phone: contact5Phone ?? this.contact5Phone,
      contact5SMS: contact5SMS ?? this.contact5SMS,
      contact5Call: contact5Call ?? this.contact5Call,
      contact5Manager: contact5Manager ?? this.contact5Manager,
      contact6Phone: contact6Phone ?? this.contact6Phone,
      contact6SMS: contact6SMS ?? this.contact6SMS,
      contact6Call: contact6Call ?? this.contact6Call,
      contact6Manager: contact6Manager ?? this.contact6Manager,
      contact7Phone: contact7Phone ?? this.contact7Phone,
      contact7SMS: contact7SMS ?? this.contact7SMS,
      contact7Call: contact7Call ?? this.contact7Call,
      contact7Manager: contact7Manager ?? this.contact7Manager,
      contact8Phone: contact8Phone ?? this.contact8Phone,
      contact8SMS: contact8SMS ?? this.contact8SMS,
      contact8Call: contact8Call ?? this.contact8Call,
      contact8Manager: contact8Manager ?? this.contact8Manager,
      contact9Phone: contact9Phone ?? this.contact9Phone,
      contact9SMS: contact9SMS ?? this.contact9SMS,
      contact9Call: contact9Call ?? this.contact9Call,
      contact9Manager: contact9Manager ?? this.contact9Manager,
      contact10Phone: contact10Phone ?? this.contact10Phone,
      contact10SMS: contact10SMS ?? this.contact10SMS,
      contact10Call: contact10Call ?? this.contact10Call,
      contact10Manager: contact10Manager ?? this.contact10Manager,
      alarmDuration: alarmDuration ?? this.alarmDuration,
      callDuration: callDuration ?? this.callDuration,
      controlRelaysWithRemote: controlRelaysWithRemote ?? this.controlRelaysWithRemote,
      monitoring: monitoring ?? this.monitoring,
      remoteReporting: remoteReporting ?? this.remoteReporting,
      scenarioReporting: scenarioReporting ?? this.scenarioReporting,
      callPriority: callPriority ?? this.callPriority,
      smsPriority: smsPriority ?? this.smsPriority,
    );
  }
}
