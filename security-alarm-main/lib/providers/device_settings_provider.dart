import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import '../core/constants/global_keys.dart';
import '../core/constants/sms_codes.dart';
import '../core/utils/enums.dart';
import '../core/utils/extensions.dart';

import '../core/utils/helper.dart';
import '../core/utils/validators.dart';
import '../injector.dart';
import '../models/device.dart';
import '../repository/sms_repository.dart';
import 'main_provider.dart';

class DeviceSettingsProvider extends ChangeNotifier {
  late MainProvider _mainProvider;
  String _deviceModelDropDownValue = DeviceModels.series300.value;
  Operators _selectedOperator = Operators.none;

  /// Getters
  String get deviceModelDropDownValue => _deviceModelDropDownValue;
  Operators get selectedOperator => _selectedOperator;

  /// Setters
  set deviceModelDropDownValue(String value) {
    _deviceModelDropDownValue = value;
    notifyListeners();
  }

  set selectedOperator(Operators operator) {
    _selectedOperator = operator;
    notifyListeners();
  }

  /// Constructor
  DeviceSettingsProvider(MainProvider? mainProvider) {
    if (mainProvider != null) {
      _mainProvider = mainProvider;
    }
  }

  String? validateNewAppPassword(
    String oldPass,
    String newPass,
    String reNewPass,
  ) {
    if (oldPass.isEmpty) {
      return translate('insert_old_pass');
    } else if (newPass.isEmpty) {
      return translate('insert_new_pass');
    } else if (reNewPass.isEmpty) {
      return translate('insert_re_new_pass');
    } else if (newPass.length != 6) {
      return translate('pass_length_desc');
    } else if (newPass != reNewPass) {
      return translate('re_new_pass_correction');
    // } else if (oldPass != _mainProvider.appSettings.appPassword) {
    } else if (oldPass != _mainProvider.selectedDevice.devicePassword) {
      return translate('old_pass_wrong');
    // } else if (newPass == _mainProvider.appSettings.appPassword) {
    } else if (newPass == _mainProvider.selectedDevice.devicePassword) {
      return translate('new_pass_same_as_old');
    }
    return null;
  }

  Future updateDevicePassword(
    String oldPass,
    String newPass,
    String reNewPass,
  ) async {
    String? validation = validateNewAppPassword(
      oldPass,
      newPass,
      reNewPass,
    );
    if (validation != null) {
      toastGenerator(validation);
      return;
    }
    Navigator.pop(kNavigatorKey.currentContext!);
    var smsCode = smsCodeGenerator(
      _mainProvider.selectedDevice.devicePassword,
      kChangeDevicePassCode + newPass,
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
        showLoadingDialog();
        await _mainProvider.updateDevice(
          _mainProvider.selectedDevice.copyWith(
            devicePassword: newPass,
          ),
        );
        await hideLoadingDialog();
      },
    );
  }

  Future removeRemoteFromDevice(String remoteNumber) async {
    String? validation = Validators.isTextEmpty(remoteNumber);
    if (validation != null) {
      toastGenerator(validation);
      return;
    }
    Navigator.pop(kNavigatorKey.currentContext!);
    var smsCode = smsCodeGenerator(
      _mainProvider.selectedDevice.devicePassword,
      kRemoveRemoteCode + remoteNumber,
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

  Future resetFactoryDevice() async {
    Navigator.pop(kNavigatorKey.currentContext!);
    var smsCode = smsCodeGenerator(
      _mainProvider.selectedDevice.devicePassword,
      kResetDeviceCode,
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
        showLoadingDialog();
        Device tempDevice = Device(
          deviceName: _mainProvider.selectedDevice.deviceName,
          devicePhone: _mainProvider.selectedDevice.devicePhone,
        );
        await _mainProvider.updateDevice(tempDevice);
        await hideLoadingDialog();
      },
    );
  }

  String? _validateNewDeviceInfo(
    String deviceName,
    String devicePhone,
  ) {
    if (deviceName.isEmpty && devicePhone.isEmpty) {
      return Validators.isTextEmpty(deviceName);
    } else if (deviceName.isNotEmpty && deviceName.length < 3) {
      return translate('name_length_limit');
    } else if (devicePhone.isNotEmpty && devicePhone.length < 11) {
      return translate('new_phone_wrong');
    }
    return null;
  }

  Future updateDeviceInfo(
    String deviceName,
    String devicePhone,
  ) async {
    Navigator.pop(kNavigatorKey.currentContext!);
    String? validation = _validateNewDeviceInfo(deviceName, devicePhone);
    if (validation != null) {
      toastGenerator(validation);
      return;
    }
    showLoadingDialog();
    Device tempDevice = _mainProvider.selectedDevice.copyWith(
      deviceName: deviceName.isEmpty
          ? _mainProvider.selectedDevice.deviceName
          : deviceName,
      devicePhone: devicePhone.isEmpty
          ? _mainProvider.selectedDevice.devicePhone
          : devicePhone,
      deviceModel: deviceModelDropDownValue,
    );
    await _mainProvider.updateDevice(tempDevice);
    toastGenerator(translate('device_successfully_editted'));
    await hideLoadingDialog();
    Navigator.pop(kNavigatorKey.currentContext!);
  }

  Future removeDeviceFromDatabase() async {
    Navigator.pop(kNavigatorKey.currentContext!);
    if (_mainProvider.deviceListLength <= 1) {
      toastGenerator(translate('cannot_remove_last_device'));

      return;
    }
    showLoadingDialog();
    final index = _mainProvider.appSettings.selectedDeviceIndex;
    await _mainProvider.removeDevice(index);
    kHomePageExpansionKeys.removeAt(index);
    toastGenerator(translate('device_removed_desc'));
    await hideLoadingDialog();
    Navigator.pop(kNavigatorKey.currentContext!);
    Navigator.pop(kNavigatorKey.currentContext!);
  }

  void autoDetectOperator(String value) {
    if (value.length == 3) {
      String preCode = value.substring(0, 3);
      if (preCode == '091' || preCode == '099') {
        selectedOperator = Operators.mci;
      } else if (preCode == '093' || preCode == '090') {
        selectedOperator = Operators.irancell;
      } else if (preCode == '092') {
        selectedOperator = Operators.rightel;
      } else {
        selectedOperator = Operators.none;
      }
    }
  }
}
