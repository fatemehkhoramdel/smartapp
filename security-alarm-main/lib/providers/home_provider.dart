import 'dart:io';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import '../services/remote/flutter_sms_listener.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:security_alarm/widgets/dialogs/editable_dialog_widget.dart';

import '../core/constants/global_keys.dart';
import '../core/constants/sms_codes.dart';
import '../core/utils/extensions.dart';
import '../core/utils/helper.dart';
import '../core/utils/sms_helper.dart';
import '../injector.dart';
import '../models/device.dart';
import '../models/relay.dart';
import '../repository/sms_repository.dart';
import 'charge_device_provider.dart';
import 'main_provider.dart';

class HomeProvider extends ChangeNotifier {
  late MainProvider _mainProvider;
  late ChargeDeviceProvider _chargeDeviceProvider;
  bool spyButtonActivated = false;

  HomeProvider(
    MainProvider? mainProvider,
    ChargeDeviceProvider? chargeDeviceProvider,
  ) {
    if (mainProvider != null) {
      _mainProvider = mainProvider;
    }
    if (chargeDeviceProvider != null) {
      _chargeDeviceProvider = chargeDeviceProvider;
    }
  }

  double capsulPercentCalculator(int currentDeviceCharge) {
    var capsulMax = _mainProvider.selectedDevice.capsulMax;
    var capsulMin = _mainProvider.selectedDevice.capsulMin;
    var dividerFactor = (capsulMax - capsulMin) / 100;
    var correctCurrentDeviceCharge =
        currentDeviceCharge < capsulMin ? 0 : currentDeviceCharge - capsulMin;
    double capsulPercent = double.parse(
      (correctCurrentDeviceCharge / dividerFactor).toStringAsFixed(3),
    );
    if (capsulPercent > 100) {
      capsulPercent = 100;
    } else if (capsulPercent < 0) {
      capsulPercent = 0;
    }
    return capsulPercent;
  }

  Future getCapsulData() async {
    final selectedOperator = await _showChooseOperator();
    if (selectedOperator == null) {
      toastGenerator(translate('choose_operator_desc'));
      return;
    }
    var smsCode = smsCodeGenerator(
      _mainProvider.selectedDevice.devicePassword,
      selectedOperator == 0
          ? kIrancellChargeCode
          : selectedOperator == 1
              ? kMCIChargeCode
              : kRightelChargeCode,
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
        rootScaffoldMessengerKey.currentState!.hideCurrentSnackBar();
        snackbarGenerator(
          translate('waiting_for_inquiry'),
        );
        _mainProvider.smsListener.onSmsReceived!.listen(
          (SmsMessage message) async =>
              _chargeDeviceProvider.processChargeAmountSMS(
            message,
          ),
        );
      },
    );
  }

  Future<int?> _showChooseOperator() async {
    return showConfirmationDialog<int>(
      context: kNavigatorKey.currentContext!,
      title: translate('choose_operator'),
      initialSelectedActionKey:
          _mainProvider.selectedDevice.operator == translate('irancell')
              ? 0
              : _mainProvider.selectedDevice.operator == translate('mci')
                  ? 1
                  : 2,
      message: translate('choose_operator_for_charge_inquiry'),
      actions: [
        ...List.generate(
          3,
          (index) => AlertDialogAction(
            label: index == 0
                ? translate('irancell')
                : index == 1
                    ? translate('mci')
                    : translate('rightel'),
            key: index,
          ),
        ),
      ],
    );
  }

  Future<void> getDeviceFullData(TextEditingController inquiryDialogTEC) async {
    var smsCode = smsCodeGenerator(
      _mainProvider.selectedDevice.devicePassword,
      kDeviceInquiryCode,
    );
    final sendSMSResult = await injector<SMSRepository>().doSendSMS(
      message: smsCode,
      isInquiry: true,
      phoneNumber: _mainProvider.selectedDevice.devicePhone,
      smsCoolDownFinished: _mainProvider.smsCooldownFinished,
      isManager: _mainProvider.selectedDevice.isManager,
    );
    sendSMSResult.fold(
      (l) => toastGenerator(l),
      (r) async {
        _mainProvider.startSMSCooldown();
        if (Platform.isAndroid) {
          rootScaffoldMessengerKey.currentState!.hideCurrentSnackBar();
          snackbarGenerator(
            translate('waiting_for_inquiry'),
          );
          _mainProvider.smsListener.onSmsReceived!.listen(
            (SmsMessage message) async =>
                _processRecievedDeviceDataSMS(message),
          );
        } else if (Platform.isIOS) {
          await dialogGenerator(
            translate('inquiry_sms_content'),
            '',
            contentWidget: EditableDialogWidget(
              controller: inquiryDialogTEC,
              textDirection: TextDirection.ltr,
              contentText: translate('inquiry_sms_content_description'),
              hintText: translate('inquiry_sms_content'),
              maxLength: 500,
            ),
            onPressCancel: () {
              inquiryDialogTEC.clear();
              Navigator.pop(kNavigatorKey.currentContext!);
            },
            onPressAccept: () async {
              await _processRecievedDeviceDataSMS(
                SmsMessage(
                  address: _mainProvider.selectedDevice.devicePhone,
                  body: inquiryDialogTEC.text,
                ),
              );
              inquiryDialogTEC.clear();
              Navigator.pop(kNavigatorKey.currentContext!);
            },
          );
        }
      },
    );
  }

  Future _processRecievedDeviceDataSMS(SmsMessage message) async {
    if (message.address == null ||
        !message.address!
            .contains(_mainProvider.selectedDevice.devicePhone.substring(1)) ||
        message.body == null) {
      return;
    }
    String messageBody = message.body!;
    if (messageBody.contains(',')) {
      /// String tempString = '1,1,1,11010,1,3,16,4,0,50,0;'; its for test
      List<int> commaIndexes = _searchForCommaIndexes(messageBody);
      String deviceState = messageBody.substring(0, commaIndexes[0]);
      deviceState = deviceState.contains('0')
          ? 'deactive'
          : deviceState.contains('4')
              ? 'active'
              : deviceState.contains('2')
                  ? 'semi_active'
                  : deviceState.contains('3')
                      ? 'silent'
                      : translate('undefiened');
      bool cityPower =
          messageBody.substring(commaIndexes[0], commaIndexes[1]).contains('1');
      bool gsmState =
          messageBody.substring(commaIndexes[1], commaIndexes[2]).contains('1');
      String tZonesString =
          messageBody.substring(commaIndexes[2] + 1, commaIndexes[3]);
      bool speakerState =
          messageBody.substring(commaIndexes[3], commaIndexes[4]).contains('1');
      int remoteAmount = int.parse(
        messageBody.substring(commaIndexes[4] + 1, commaIndexes[5]),
      );
      int antennaAmount = int.parse(
        messageBody.substring(commaIndexes[5] + 1, commaIndexes[6]),
      );
      int totalContactsAmount = int.parse(
        messageBody.substring(commaIndexes[6] + 1, commaIndexes[7]),
      );
      bool networkState =
          messageBody.substring(commaIndexes[7], commaIndexes[8]).contains('1');
      int batteryAmount = int.parse(
        messageBody.substring(commaIndexes[8] + 1, commaIndexes[9]),
      );
      String tRelayString =
          messageBody.substring(commaIndexes[9] + 1, commaIndexes[10]);
      Device tempDevice = _mainProvider.selectedDevice.copyWith(
        deviceState: deviceState,
        remoteAmount: remoteAmount,
        antennaAmount: antennaAmount,
        batteryAmount: batteryAmount,
        cityPowerState: cityPower,
        gsmState: gsmState,
        speakerState: speakerState,
        networkState: networkState,
        totalContactsAmount: totalContactsAmount,
        zone1State: tZonesString[0].contains('1'),
        zone2State: tZonesString[1].contains('1'),
        zone3State: tZonesString[2].contains('1'),
        zone4State: tZonesString[3].contains('1'),
        zone5State: tZonesString[4].contains('1'),
        isManager: true,
      );
      await _mainProvider.updateDevice(tempDevice);
      for (var i = 0; i < 2; i++) {
        Relay tempRelay = _mainProvider.relays[i].copyWith(
          relayState: tRelayString[i].contains('1'),
        );
        await _mainProvider.updateRelay(tempRelay);
      }
      rootScaffoldMessengerKey.currentState!.hideCurrentSnackBar();
      kHomePageExpansionKeys[_mainProvider.appSettings.selectedDeviceIndex]
          .currentState
          ?.expand();
    } else if (messageBody.contains('not manager')) {
      await _mainProvider.updateDevice(
          _mainProvider.selectedDevice.copyWith(isManager: false));
    } else if (messageBody.contains(translate('allowed'))) {
      await _mainProvider
          .updateDevice(_mainProvider.selectedDevice.copyWith(isManager: true));
    }
    rootScaffoldMessengerKey.currentState!.hideCurrentSnackBar();
    kHomePageExpansionKeys[_mainProvider.appSettings.selectedDeviceIndex]
        .currentState
        ?.expand();
  }

  List<int> _searchForCommaIndexes(String messageBody) {
    List<int> commaIndexes = [];
    for (int i = 0; i < messageBody.length; i++) {
      if (messageBody[i] == ',' || messageBody[i] == ';') {
        commaIndexes.add(i);
      }
    }
    return commaIndexes;
  }

  Future activateDevice() async {
    var smsCode = smsCodeGenerator(
      _mainProvider.selectedDevice.devicePassword,
      kActivateDeviceCode,
    );
    
    final result = await SmsHelper.sendSmsWithUI(
      message: smsCode,
      phoneNumber: _mainProvider.selectedDevice.devicePhone,
      smsCoolDownFinished: _mainProvider.smsCooldownFinished,
      isManager: _mainProvider.selectedDevice.isManager,
    );
    
    result.fold(
      (l) {}, // Error already handled by SmsHelper
      (r) async {
        _mainProvider.startSMSCooldown();
        Device tempDevice = _mainProvider.selectedDevice.copyWith(
          deviceState: 'active',
        );
        await _mainProvider.updateDevice(tempDevice);
      },
    );
  }

  Future deactiveDevice() async {
    var smsCode = smsCodeGenerator(
      _mainProvider.selectedDevice.devicePassword,
      kDeactivateDeviceCode,
    );
    
    final result = await SmsHelper.sendSmsWithUI(
      message: smsCode,
      phoneNumber: _mainProvider.selectedDevice.devicePhone,
      smsCoolDownFinished: _mainProvider.smsCooldownFinished,
      isManager: _mainProvider.selectedDevice.isManager,
    );
    
    result.fold(
      (l) {}, // Error already handled by SmsHelper
      (r) async {
        _mainProvider.startSMSCooldown();
        Device tempDevice = _mainProvider.selectedDevice.copyWith(
          deviceState: 'deactive',
        );
        await _mainProvider.updateDevice(tempDevice);
      },
    );
  }

  Future semiActiveDevice() async {
    var smsCode = smsCodeGenerator(
      _mainProvider.selectedDevice.devicePassword,
      kSemiActivateDeviceCode,
    );
    
    final result = await SmsHelper.sendSmsWithUI(
      message: smsCode,
      phoneNumber: _mainProvider.selectedDevice.devicePhone,
      smsCoolDownFinished: _mainProvider.smsCooldownFinished,
      isManager: _mainProvider.selectedDevice.isManager,
    );
    
    result.fold(
      (l) {}, // Error already handled by SmsHelper
      (r) async {
        _mainProvider.startSMSCooldown();
        Device tempDevice = _mainProvider.selectedDevice.copyWith(
          deviceState: 'semi_active',
        );
        await _mainProvider.updateDevice(tempDevice);
      },
    );
  }

  Future<void> silentDevice() async {
    var smsCode = smsCodeGenerator(
      _mainProvider.selectedDevice.devicePassword,
      kSilentDeviceCode,
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
        if (_mainProvider.selectedDevice.deviceState != 'silent') {
          await _mainProvider.updateDevice(
            _mainProvider.selectedDevice.copyWith(deviceState: 'silent'),
          );
        }
      },
    );
  }

  Future<void> activateSpy() async {
    var smsCode = smsCodeGenerator(
      _mainProvider.selectedDevice.devicePassword,
      kSpyCode + _mainProvider.selectedDevice.spyAmount.toString(),
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
        spyButtonActivated = true;
        notifyListeners();
      },
    );
  }

  Future<void> activeRelay(int index) async {
    var smsCode = smsCodeGenerator(
      _mainProvider.selectedDevice.devicePassword,
      RelaysExt.getRelaysList()[index].activeSMSCode,
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
        Relay tempRelay = _mainProvider.relays[index].copyWith(
          relayState: true,
        );
        await _mainProvider.updateRelay(tempRelay);
      },
    );
  }

  Future<void> triggerRelay(int index) async {
    String relayTriggerSms = (index == 0
            ? kRelay1Code
            : RelaysExt.getRelaysList()[index].triggerSMSCode) +
        _mainProvider.relays[index].relayTriggerTime;
    var smsCode = smsCodeGenerator(
      _mainProvider.selectedDevice.devicePassword,
      relayTriggerSms,
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

  Future<void> deactiveRelay(int index) async {
    var smsCode = smsCodeGenerator(
      _mainProvider.selectedDevice.devicePassword,
      RelaysExt.getRelaysList()[index].deactiveSMSCode,
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
        Relay tempRelay = _mainProvider.relays[index].copyWith(
          relayState: false,
        );
        await _mainProvider.updateRelay(tempRelay);
      },
    );
  }
}
