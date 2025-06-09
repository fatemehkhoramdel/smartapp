import 'dart:io';

import 'package:flutter/material.dart';
import '../services/remote/flutter_sms_listener.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:security_alarm/widgets/dialogs/editable_dialog_widget.dart';

import '../core/constants/global_keys.dart';
import '../core/constants/sms_codes.dart';
import '../core/utils/enums.dart';
import '../core/utils/extensions.dart';
import '../core/utils/helper.dart';
import '../core/utils/validators.dart';
import '../injector.dart';
import '../repository/sms_repository.dart';
import 'main_provider.dart';

class ChargeDeviceProvider extends ChangeNotifier {
  late MainProvider _mainProvider;
  late String operator;

  ChargeDeviceProvider(MainProvider? mainProvider) {
    if (mainProvider != null) {
      _mainProvider = mainProvider;
      operator = _mainProvider.selectedDevice.operator;
    }
  }

  Future performChargeDevice(String chargeCode) async {
    String? validationOperator = Validators.isTextEmpty(operator);
    String? validationChargeCode = Validators.isTextEmpty(chargeCode);
    if (validationOperator != null) {
      toastGenerator(translate('choose_operator_desc'));
      return;
    }
    if (validationChargeCode != null) {
      toastGenerator(translate('insert_charge_code'));
      return;
    }
    var smsCode = smsCodeGenerator(
      _mainProvider.selectedDevice.devicePassword,
      kUSSDExecuteCode + chargeCode,
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

  Future getChargeAmountFromDevice(TextEditingController inquiryDialogTEC) async {
    String? validationOperator = Validators.isTextEmpty(operator);
    if (validationOperator != null) {
      toastGenerator(translate('choose_operator_desc'));
      return;
    }
    var smsCode = smsCodeGenerator(
      _mainProvider.selectedDevice.devicePassword,
      operator == Operators.irancell.value
          ? kIrancellChargeCode
          : operator == Operators.mci.value
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
        if (Platform.isAndroid) {
          rootScaffoldMessengerKey.currentState?.removeCurrentSnackBar();
          snackbarGenerator(
            translate('waiting_for_inquiry'),
          );
          _mainProvider.smsListener.onSmsReceived!.listen(
            (SmsMessage message) async => processChargeAmountSMS(
              message,
            ),
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
              await processChargeAmountSMS(
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

  Future processChargeAmountSMS(SmsMessage message) async {
    if (message.address == null ||
        !message.address!
            .contains(_mainProvider.selectedDevice.devicePhone.substring(1)) ||
        message.body == null) {
      return;
    }
    String messageBody = message.body!.toUpperCase();
    int? chargeAmountInt;
    if (messageBody.contains('RIAL')) {
      chargeAmountInt = _searchForChargeAmount(messageBody, 'RIAL');
    } else if (messageBody.contains('IRR')) {
      chargeAmountInt = _searchForChargeAmount(messageBody, 'IRR');
    } else if (messageBody.contains('ریال')) {
      chargeAmountInt = _searchForChargeAmount(messageBody, 'ریال');
    }
    if (chargeAmountInt != null) {
      await _updateSimChargeAmount(chargeAmountInt);
    }
    rootScaffoldMessengerKey.currentState?.removeCurrentSnackBar();
    rootScaffoldMessengerKey.currentState!.hideCurrentSnackBar();
  }

  int _searchForChargeAmount(String messageBody, String searchKey) {
    String chargeAmount = '';
    String fromFirstToSearchKey = messageBody.substring(
      0,
      messageBody.indexOf(searchKey),
    );
    for (int i = 0; i < fromFirstToSearchKey.length; i++) {
      if (isNumeric(messageBody[i])) chargeAmount += messageBody[i];
    }
    return int.parse(chargeAmount) >= 10
        ? (int.parse(chargeAmount) / 10).round()
        : 0;
  }

  Future _updateSimChargeAmount(int chargeAmount) async {
    await _mainProvider.updateDevice(
      _mainProvider.selectedDevice.copyWith(
        simChargeAmount: chargeAmount,
      ),
    );
  }
}
