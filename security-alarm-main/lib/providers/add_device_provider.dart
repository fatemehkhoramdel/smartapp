import 'dart:async';

import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

import '../../../core/utils/enums.dart';
import '../../../core/utils/extensions.dart';
import '../../../core/utils/helper.dart';
import '../../../models/device.dart';
import '../../../providers/main_provider.dart';
import '../core/constants/global_keys.dart';
import '../injector.dart';
import '../models/relay.dart';
import '../repository/sms_repository.dart';

class AddDeviceProvider extends ChangeNotifier {
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
  AddDeviceProvider(MainProvider? mainProvider) {
    if (mainProvider != null) _mainProvider = mainProvider;
  }

  void setOperatorBasedOnPhoneNumber(String text, FocusNode devicePhoneFN) {
    if (text.length == 3) {
      String preCode = text.substring(0, 3);
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
    devicePhoneFN.requestFocus();
  }

  String validateNewDeviceData(String deviceName, String devicePhone) {
    if (deviceName.isEmpty || deviceName.length < 3) {
      return translate('device_name_length');
    } else if (devicePhone.isEmpty) {
      return translate('insert_device_phone');
    } else if (devicePhone.length < 11 || !devicePhone.startsWith('0')) {
      return translate('wrong_device_phone');
    } else if (selectedOperator == Operators.none) {
      return translate('choose_operator_desc');
    }
    return '';
  }

  String checkIfNewDeviceAlreadyExist(String deviceName, String devicePhone) {
    for (int i = 0; i < _mainProvider.deviceListLength; i++) {
      if (deviceName == _mainProvider.devices[i].deviceName ||
          devicePhone == _mainProvider.devices[i].devicePhone) {
        return translate('device_exist');
      }
    }
    return '';
  }

  Device generateNewDeviceModel(
    String deviceName,
    String devicePhone,
    String deviceModel,
  ) {
    return Device(
      id: _mainProvider.devices.last.id! + 1,
      deviceName: deviceName,
      devicePhone: devicePhone,
      deviceModel: deviceModel,
      operator: selectedOperator.value,
    );
  }

  Future addNewDevice(
    String deviceName,
    String devicePhone,
    String deviceModel,
  ) async {
    String isValidResult = validateNewDeviceData(deviceName, devicePhone);
    if (isValidResult.isNotEmpty) {
      toastGenerator(isValidResult);
      return;
    }
    String newDeviceExistResult = checkIfNewDeviceAlreadyExist(
      deviceName,
      devicePhone,
    );
    if (newDeviceExistResult.isNotEmpty) {
      toastGenerator(newDeviceExistResult);
      return;
    }
    closeSoftKeyboard();
    var smsCode = smsCodeGenerator(
      _mainProvider.selectedDevice.devicePassword,
      selectedOperator.code,
    );
    final sendSMSResult = await injector<SMSRepository>().doSendSMS(
      message: smsCode,
      phoneNumber: devicePhone,
      smsCoolDownFinished: _mainProvider.smsCooldownFinished,
      isManager: _mainProvider.selectedDevice.isManager,
    );
    sendSMSResult.fold(
      (l) => toastGenerator(l),
      (r) async {
        _mainProvider.startSMSCooldown();
        final newDevice = generateNewDeviceModel(
          deviceName,
          devicePhone,
          deviceModel,
        );
        kHomePageExpansionKeys.add(GlobalKey<ExpansionTileCardState>());
        await _mainProvider.insertDevice(newDevice);
        if (deviceModel == DeviceModels.series300.value) {
          for (int i = 0; i < 2; i++) {
            await _mainProvider.insertRelay(
              Relay(
                deviceId: newDevice.id!,
                relayName: RelaysExt.getRelaysList()[i].value,
              ),
            );
          }
        } else {
          for (int i = 0; i < RelaysExt.getRelaysList().length; i++) {
            await _mainProvider.insertRelay(
              Relay(
                deviceId: newDevice.id!,
                relayName: RelaysExt.getRelaysList()[i].value,
              ),
            );
          }
        }
        toastGenerator(translate('device_added'));
        Navigator.pop(kNavigatorKey.currentContext!);
      },
    );
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
