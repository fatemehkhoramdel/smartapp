import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import '../constants/asset_constants.dart';
import '../constants/colors.dart';
import '../constants/sms_codes.dart';

import 'enums.dart';

extension ZoneConditionExt on ZoneCondition {
  String get value {
    switch (this) {
      case ZoneCondition.normalyClose:
        return translate('normaly_close');
      case ZoneCondition.normalyOpen:
        return translate('normaly_open');
      case ZoneCondition.fullHour:
        return translate('24_hour');
      case ZoneCondition.dingDong:
        return translate('ding_dong');
      case ZoneCondition.guard:
        return translate('guard');
      case ZoneCondition.inactive:
        return translate('inactive');
      case ZoneCondition.hiddenCall:
        return translate('hidden_call');
      case ZoneCondition.hiddenSMS:
        return translate('hidden_sms');
      default:
        return '';
    }
  }

  static String code(String name) {
    switch (name) {
      case 'Normaly Close':
        return 'N';
      case 'Normaly Open':
        return 'O';
      case '24 ساعت':
        return 'H';
      case 'دینگ دانگ':
        return 'D';
      case 'گارد':
        return 'G';
      case 'غیر فعال':
        return 'I';
      case 'تماس مخفی':
        return 'C';
      case 'پیامک مخفی':
        return 'S';
      default:
        return '';
    }
  }

  static List<String> getZoneConditionsAsList() {
    return <String>[
      ZoneCondition.normalyClose.value,
      ZoneCondition.normalyOpen.value,
      ZoneCondition.fullHour.value,
      ZoneCondition.dingDong.value,
      ZoneCondition.guard.value,
      ZoneCondition.inactive.value,
      ZoneCondition.hiddenCall.value,
      ZoneCondition.hiddenSMS.value,
    ];
  }
}

extension ZoneModeExt on ZoneMode {
  String get value {
    switch (this) {
      case ZoneMode.normal:
        return translate('normal_mode');
      case ZoneMode.semiActive:
        return translate('semi_active_mode');
      case ZoneMode.fullHour:
        return translate('full_hour_mode');
      case ZoneMode.inactive:
        return translate('inactive_mode');
    }
  }

  static List<ZoneMode> getZoneModesList() {
    return <ZoneMode>[
      ZoneMode.normal,
      ZoneMode.semiActive,
      ZoneMode.fullHour,
      ZoneMode.inactive,
    ];
  }
}

extension OperatorsExt on Operators {
  String get value {
    switch (this) {
      case Operators.mci:
        return translate('mci');
      case Operators.irancell:
        return translate('irancell');
      case Operators.rightel:
        return translate('rightel');
      default:
        return '';
    }
  }

  Color get color {
    switch (this) {
      case Operators.mci:
        return Colors.blue;
      case Operators.irancell:
        return Colors.orange;
      case Operators.rightel:
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  String get imageAddress {
    switch (this) {
      case Operators.mci:
        return kMCIAsset;
      case Operators.irancell:
        return kIrancellAsset;
      case Operators.rightel:
        return kRightelAsset;
      default:
        return kMCIAsset;
    }
  }

  String get code {
    switch (this) {
      case Operators.mci:
        return kOperatorMCICode;
      case Operators.irancell:
        return kOperatorIrancellCode;
      case Operators.rightel:
        return kOperatorRightelCode;
      default:
        return '';
    }
  }

  static List<Operators> getOperatorsList() {
    return <Operators>[
      Operators.none,
      Operators.mci,
      Operators.irancell,
      Operators.rightel,
    ];
  }
}

extension MenuItemsExt on MenuItems {
  String get value {
    switch (this) {
      case MenuItems.addDevice:
        return translate('add_device');
      case MenuItems.aboutus:
        return translate('about_us');
      case MenuItems.advanceTools:
        return translate('advance_tools');
      case MenuItems.applicationSettings:
        return translate('android_app_settings');
      case MenuItems.chargeDevice:
        return translate('charge_device');
      case MenuItems.contacts:
        return translate('contacts');
      case MenuItems.deviceSettings:
        return translate('device_setting');
      case MenuItems.guide:
        return translate('guide');
      case MenuItems.zones:
        return translate('zones');
      case MenuItems.scenario:
        return translate('scenario');
      case MenuItems.scheduling:
        return translate('scheduling');
      case MenuItems.editDevice:
        return translate('edit_device');
      case MenuItems.editRelay:
        return translate('edit_relay');
      case MenuItems.customizeHome:
        return translate('choose_home_items');
      case MenuItems.audioNotification:
        return translate('audio_notification');
      case MenuItems.zoneState:
        return translate('zone_state');
      case MenuItems.zoneName:
        return translate('zone_name');
      case MenuItems.semiActiveZone:
        return translate('semi_active_zone');
      case MenuItems.zoneMode:
        return translate('zone_mode_settings');
      case MenuItems.relaySettings:
        return translate('relay_settings');
      case MenuItems.remoteSettings:
        return translate('remote_settings');
      case MenuItems.generalSettings:
        return translate('general_settings');
      case MenuItems.patternLock:
        return translate('define_password');
      case MenuItems.none:
      default:
        return '';
    }
  }

  int get indexInGuidePage {
    switch (this) {
      case MenuItems.addDevice:
        return 1;
      case MenuItems.advanceTools:
        return 4;
      case MenuItems.applicationSettings:
        return 7;
      case MenuItems.chargeDevice:
        return 2;
      case MenuItems.contacts:
        return 5;
      case MenuItems.deviceSettings:
        return 3;
      case MenuItems.zones:
        return 6;
      default:
        return 0;
    }
  }
}

extension DeviceModelsExt on DeviceModels {
  String get value {
    switch (this) {
      case DeviceModels.series300:
        return translate('series300');
      case DeviceModels.series400:
        return translate('series400');
      case DeviceModels.series500:
        return translate('series500');
      default:
        return translate('series300');
    }
  }

  static List<String> getDeviceModelsList() {
    return <String>[
      DeviceModels.series300.value,
      DeviceModels.series400.value,
      DeviceModels.series500.value,
    ];
  }
}

extension ThemePalettesExt on ThemePalettes {
  List<Color> get value {
    switch (this) {
      case ThemePalettes.palette1:
        return kPalette1Colors;
      case ThemePalettes.palette2:
        return kPalette2Colors;
      case ThemePalettes.palette3:
        return kPalette3Colors;
      default:
        return kPalette1Colors;
    }
  }

  static List<ThemePalettes> getThemePalettesList() {
    return <ThemePalettes>[
      ThemePalettes.palette1,
      ThemePalettes.palette2,
      ThemePalettes.palette3,
    ];
  }
}

extension RelaysExt on Relays {
  String get value {
    switch (this) {
      case Relays.relay1:
        return translate('relay1');
      case Relays.relay2:
        return translate('relay2');
      case Relays.relay3:
        return translate('relay3');
      case Relays.relay4:
        return translate('relay4');
      case Relays.relay5:
        return translate('relay5');
      case Relays.relay6:
        return translate('relay6');
      case Relays.relay7:
        return translate('relay7');
      case Relays.relay8:
        return translate('relay8');
      default:
        return '';
    }
  }

  String get activeSMSCode {
    switch (this) {
      case Relays.relay1:
        return "${kRelay2Code}11";
      case Relays.relay2:
        return "${kRelay2Code}21";
      case Relays.relay3:
        return "${kRelay2Code}31";
      case Relays.relay4:
        return "${kRelay2Code}41";
      case Relays.relay5:
        return "${kRelay2Code}51";
      case Relays.relay6:
        return "${kRelay2Code}61";
      case Relays.relay7:
        return "${kRelay2Code}71";
      case Relays.relay8:
        return "${kRelay2Code}81";
      default:
        return "${kRelay2Code}11";
    }
  }

  String get triggerSMSCode {
    switch (this) {
      case Relays.relay1:
        return "${kRelay2Code}1T";
      case Relays.relay2:
        return "${kRelay2Code}2T";
      case Relays.relay3:
        return "${kRelay2Code}3T";
      case Relays.relay4:
        return "${kRelay2Code}4T";
      case Relays.relay5:
        return "${kRelay2Code}5T";
      case Relays.relay6:
        return "${kRelay2Code}6T";
      case Relays.relay7:
        return "${kRelay2Code}7T";
      case Relays.relay8:
        return "${kRelay2Code}8T";
      default:
        return "${kRelay2Code}1T";
    }
  }

  String get deactiveSMSCode {
    switch (this) {
      case Relays.relay1:
        return "${kRelay2Code}10";
      case Relays.relay2:
        return "${kRelay2Code}20";
      case Relays.relay3:
        return "${kRelay2Code}30";
      case Relays.relay4:
        return "${kRelay2Code}40";
      case Relays.relay5:
        return "${kRelay2Code}50";
      case Relays.relay6:
        return "${kRelay2Code}60";
      case Relays.relay7:
        return "${kRelay2Code}70";
      case Relays.relay8:
        return "${kRelay2Code}80";
      default:
        return "${kRelay2Code}10";
    }
  }

  static List<Relays> getRelaysList() {
    return <Relays>[
      Relays.relay1,
      Relays.relay2,
      Relays.relay3,
      Relays.relay4,
      Relays.relay5,
      Relays.relay6,
      Relays.relay7,
      Relays.relay8,
    ];
  }
}
