import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

import '../core/constants/global_keys.dart';
import '../core/constants/sms_codes.dart';
import '../core/utils/helper.dart';
import '../core/utils/validators.dart';
import '../injector.dart';
import '../repository/sms_repository.dart';
import 'main_provider.dart';

class AdvanceToolsProvider extends ChangeNotifier {
  late MainProvider _mainProvider;

  AdvanceToolsProvider(MainProvider? mainProvider) {
    if (mainProvider != null) {
      _mainProvider = mainProvider;
    }
  }

  Future selectMCIOperator() async {
    var smsCode = smsCodeGenerator(
      _mainProvider.selectedDevice.devicePassword,
      kOperatorMCICode,
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
        await _mainProvider.updateDevice(
          _mainProvider.selectedDevice.copyWith(
            operator: translate('mci'),
          ),
        );
      },
    );
  }

  Future selectIrancellOperator() async {
    var smsCode = smsCodeGenerator(
      _mainProvider.selectedDevice.devicePassword,
      kOperatorIrancellCode,
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
        await _mainProvider.updateDevice(
          _mainProvider.selectedDevice.copyWith(
            operator: translate('irancell'),
          ),
        );
      },
    );
  }

  Future selectRightelOperator() async {
    var smsCode = smsCodeGenerator(
      _mainProvider.selectedDevice.devicePassword,
      kOperatorRightelCode,
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
        await _mainProvider.updateDevice(
          _mainProvider.selectedDevice.copyWith(
            operator: translate('rightel'),
          ),
        );
      },
    );
  }

  Future selectEnglishAsDeviceLang() async {
    var smsCode = smsCodeGenerator(
      _mainProvider.selectedDevice.devicePassword,
      kDeviceEnglishLanguageCode,
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
        await _mainProvider.updateDevice(
          _mainProvider.selectedDevice.copyWith(
            deviceLang: translate('english'),
          ),
        );
      },
    );
  }

  Future selectPresianAsDeviceLang() async {
    var smsCode = smsCodeGenerator(
      _mainProvider.selectedDevice.devicePassword,
      kDevicePersianLanguageCode,
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
        await _mainProvider.updateDevice(
          _mainProvider.selectedDevice.copyWith(
            deviceLang: translate('persian'),
          ),
        );
      },
    );
  }

  Future selectEnglishAsSimCardLang() async {
    var smsCode = smsCodeGenerator(
      _mainProvider.selectedDevice.devicePassword,
      kIrancellLanguageEnglishCode,
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
        await _mainProvider.updateDevice(
          _mainProvider.selectedDevice.copyWith(
            deviceSimLang: translate('english'),
          ),
        );
      },
    );
  }

  Future selectPersianAsSimCardLang() async {
    var smsCode = smsCodeGenerator(
      _mainProvider.selectedDevice.devicePassword,
      kIrancellPersianLanguageCode,
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
        await _mainProvider.updateDevice(
          _mainProvider.selectedDevice.copyWith(
            deviceSimLang: translate('persian'),
          ),
        );
      },
    );
  }

  Future activeSilentOnSiren() async {
    var smsCode = smsCodeGenerator(
      _mainProvider.selectedDevice.devicePassword,
      kSilentSirenActiveCode,
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
        await _mainProvider.updateDevice(
          _mainProvider.selectedDevice.copyWith(
            silentOnSiren: true,
          ),
        );
      },
    );
  }

  Future deactiveSilentOnSiren() async {
    var smsCode = smsCodeGenerator(
      _mainProvider.selectedDevice.devicePassword,
      kSilentSirenDeactiveCode,
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
        await _mainProvider.updateDevice(
          _mainProvider.selectedDevice.copyWith(
            silentOnSiren: false,
          ),
        );
      },
    );
  }

  Future activeRelayOnDingDong() async {
    var smsCode = smsCodeGenerator(
      _mainProvider.selectedDevice.devicePassword,
      kRelayDingDongActiveCode,
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
        await _mainProvider.updateDevice(
          _mainProvider.selectedDevice.copyWith(
            relayOnDingDong: true,
          ),
        );
      },
    );
  }

  Future deactiveRelayOnDingDong() async {
    var smsCode = smsCodeGenerator(
      _mainProvider.selectedDevice.devicePassword,
      kRelayDingDongDeactiveCode,
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
        await _mainProvider.updateDevice(
          _mainProvider.selectedDevice.copyWith(
            relayOnDingDong: false,
          ),
        );
      },
    );
  }

  Future activeCallOnPowerLost() async {
    var smsCode = smsCodeGenerator(
      _mainProvider.selectedDevice.devicePassword,
      kCallOnPowerLostActiveCode,
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
        await _mainProvider.updateDevice(
          _mainProvider.selectedDevice.copyWith(
            callOnPowerLoss: true,
          ),
        );
      },
    );
  }

  Future deactiveCallOnPowerLost() async {
    var smsCode = smsCodeGenerator(
      _mainProvider.selectedDevice.devicePassword,
      kCallOnPowerLostDeactiveCode,
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
        await _mainProvider.updateDevice(
          _mainProvider.selectedDevice.copyWith(
            callOnPowerLoss: false,
          ),
        );
      },
    );
  }

  Future activeManageByContacts() async {
    var smsCode = smsCodeGenerator(
      _mainProvider.selectedDevice.devicePassword,
      kManageByContactsActiveCode,
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
        await _mainProvider.updateDevice(
          _mainProvider.selectedDevice.copyWith(
            manageWithContacts: true,
          ),
        );
      },
    );
  }

  Future deactiveManageByContacts() async {
    var smsCode = smsCodeGenerator(
      _mainProvider.selectedDevice.devicePassword,
      kManageByContactsDeactiveCode,
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
        await _mainProvider.updateDevice(
          _mainProvider.selectedDevice.copyWith(
            manageWithContacts: false,
          ),
        );
      },
    );
  }

  Future updateAlertTime(String newAlarmTime) async {
    String? validation = Validators.isTextEmpty(newAlarmTime);
    if (validation != null) {
      toastGenerator(validation);
      return;
    }
    Navigator.pop(kNavigatorKey.currentContext!);
    var smsCode = smsCodeGenerator(
      _mainProvider.selectedDevice.devicePassword,
      kAlarmCode + newAlarmTime,
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
        _mainProvider.updateDevice(
          _mainProvider.selectedDevice.copyWith(
            alarmTime: newAlarmTime,
          ),
        );
      },
    );
  }

  String? validateNewSpyVolume(String newSpyVolume) {
    if (newSpyVolume.isNotEmpty && int.parse(newSpyVolume) > 15) {
      return translate('max_volume_desc');
    }
    return Validators.isTextEmpty(newSpyVolume);
  }

  Future updateSpyVolume(String newSpyVolume) async {
    String? validation = validateNewSpyVolume(newSpyVolume);
    if (validation != null) {
      toastGenerator(validation);
      return;
    }
    Navigator.pop(kNavigatorKey.currentContext!);
    var smsCode = smsCodeGenerator(
      _mainProvider.selectedDevice.devicePassword,
      kSpyCode + newSpyVolume,
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
        await _mainProvider.updateDevice(
          _mainProvider.selectedDevice
              .copyWith(spyAmount: int.parse(newSpyVolume)),
        );
      },
    );
  }

  Future updateChargeReportPeriod(String newChargeReportPeriod) async {
    String? validation = Validators.isTextEmpty(
      newChargeReportPeriod,
    );
    if (validation != null) {
      toastGenerator(validation);
      return;
    }
    Navigator.pop(kNavigatorKey.currentContext!);
    var smsCode = smsCodeGenerator(
      _mainProvider.selectedDevice.devicePassword,
      kReportChargePriodicCode + newChargeReportPeriod,
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
        await _mainProvider.updateDevice(
          _mainProvider.selectedDevice.copyWith(
            chargePeriodictReport: int.parse(newChargeReportPeriod),
          ),
        );
      },
    );
  }

  Future updateBatteryReportPeriod(String newBatteryReportPeriod) async {
    String? validation = Validators.isTextEmpty(
      newBatteryReportPeriod,
    );
    if (validation != null) {
      toastGenerator(validation);
      return;
    }
    Navigator.pop(kNavigatorKey.currentContext!);
    var smsCode = smsCodeGenerator(
      _mainProvider.selectedDevice.devicePassword,
      kReportBatteryPriodicCode + newBatteryReportPeriod,
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
        await _mainProvider.updateDevice(
          _mainProvider.selectedDevice.copyWith(
            batteryPeriodictReport: int.parse(newBatteryReportPeriod),
          ),
        );
      },
    );
  }

  Future selectFirstCallOrder() async {
    Navigator.pop(kNavigatorKey.currentContext!);
    var smsCode = smsCodeGenerator(
      _mainProvider.selectedDevice.devicePassword,
      kCallOrder1Code,
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
        await _mainProvider
            .updateDevice(_mainProvider.selectedDevice.copyWith(callOrder: 1));
      },
    );
  }

  Future selectSecondCallOrder() async {
    Navigator.pop(kNavigatorKey.currentContext!);
    var smsCode = smsCodeGenerator(
      _mainProvider.selectedDevice.devicePassword,
      kCallOrder2Code,
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
        await _mainProvider
            .updateDevice(_mainProvider.selectedDevice.copyWith(callOrder: 2));
      },
    );
  }

  Future selectThirdCallOrder() async {
    Navigator.pop(kNavigatorKey.currentContext!);
    var smsCode = smsCodeGenerator(
      _mainProvider.selectedDevice.devicePassword,
      kCallOrder3Code,
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
        await _mainProvider
            .updateDevice(_mainProvider.selectedDevice.copyWith(callOrder: 3));
      },
    );
  }

  Future selectFourthCallOrder() async {
    Navigator.pop(kNavigatorKey.currentContext!);
    var smsCode = smsCodeGenerator(
      _mainProvider.selectedDevice.devicePassword,
      kCallOrder4Code,
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
        await _mainProvider
            .updateDevice(_mainProvider.selectedDevice.copyWith(callOrder: 1));
      },
    );
  }
}
