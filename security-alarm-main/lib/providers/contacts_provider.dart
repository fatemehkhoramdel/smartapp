import 'dart:io';

import 'package:flutter/material.dart';
import '../services/remote/flutter_sms_listener.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:security_alarm/widgets/dialogs/editable_dialog_widget.dart';
import 'package:supercharged/supercharged.dart';

import '../core/constants/constants.dart';
import '../core/constants/global_keys.dart';
import '../core/constants/sms_codes.dart';
import '../core/utils/helper.dart';
import '../core/utils/validators.dart';
import '../injector.dart';
import '../models/device.dart';
import '../repository/sms_repository.dart';
import 'main_provider.dart';

class ContactsProvider extends ChangeNotifier {
  late MainProvider _mainProvider;
  bool isEditMode = false;
  List<List<bool?>> localData = List.generate(
    9,
    (index) => <bool?>[]..length = 6,
  );
  final List<int> _contactsIndexesWithNumber = [];

  ContactsProvider(MainProvider? mainProvider) {
    if (mainProvider != null) {
      _mainProvider = mainProvider;
    }
  }

  void updateCheckbox(
    String currentContactPhone,
    bool? newCheckBoxValue,
    int currentContactIndex,
    int checkBoxIndex,
  ) {
    String? validationContactPhone = Validators.isTextEmpty(
      currentContactPhone,
    );
    if (validationContactPhone != null || newCheckBoxValue == null) {
      return;
    }
    if (!isEditMode) isEditMode = true;
    localData[currentContactIndex][checkBoxIndex] = newCheckBoxValue;
    notifyListeners();
  }

  Future deleteContact(int contactIndex) async {
    var smsCode = smsCodeGenerator(
      _mainProvider.selectedDevice.devicePassword,
      'P${contactIndex + 1}D',
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
          _generateFreshContact(contactIndex),
        );
      },
    );
  }

  Device _generateFreshContact(int contactIndex) {
    Device tempDevice = _mainProvider.selectedDevice;
    if (contactIndex == 0) {
      tempDevice = tempDevice.copyWith(
        contact1Phone: '',
        contact1Call: false,
        contact1Manager: false,
        contact1SMS: false,
      );
    } else if (contactIndex == 1) {
      tempDevice = tempDevice.copyWith(
        contact2Phone: '',
        contact2Call: false,
        contact2Manager: false,
        contact2SMS: false,
      );
    } else if (contactIndex == 2) {
      tempDevice = tempDevice.copyWith(
        contact3Phone: '',
        contact3Call: false,
        contact3Manager: false,
        contact3SMS: false,
      );
    } else if (contactIndex == 3) {
      tempDevice = tempDevice.copyWith(
        contact4Phone: '',
        contact4Call: false,
        contact4Manager: false,
        contact4SMS: false,
      );
    } else if (contactIndex == 4) {
      tempDevice = tempDevice.copyWith(
        contact5Phone: '',
        contact5Call: false,
        contact5Manager: false,
        contact5SMS: false,
      );
    } else if (contactIndex == 5) {
      tempDevice = tempDevice.copyWith(
        contact6Phone: '',
        contact6Call: false,
        contact6Manager: false,
        contact6SMS: false,
      );
    } else if (contactIndex == 6) {
      tempDevice = tempDevice.copyWith(
        contact7Phone: '',
        contact7Call: false,
        contact7Manager: false,
        contact7SMS: false,
      );
    } else if (contactIndex == 7) {
      tempDevice = tempDevice.copyWith(
        contact8Phone: '',
        contact8Call: false,
        contact8Manager: false,
        contact8SMS: false,
      );
    } else if (contactIndex == 8) {
      tempDevice = tempDevice.copyWith(
        contact9Phone: '',
        contact9Call: false,
        contact9Manager: false,
        contact9SMS: false,
      );
    } else if (contactIndex == 9) {
      tempDevice = tempDevice.copyWith(
        contact10Phone: '',
        contact10Call: false,
        contact10Manager: false,
        contact10SMS: false,
      );
    }
    return tempDevice;
  }

  Future updateContacts(
    List<TextEditingController> contactsPhoneTECList,
    List<TextEditingController> contactsNameTECList,
  ) async {
    _findContactsWithNumber(contactsPhoneTECList);
    if (_contactsIndexesWithNumber.isEmpty) {
      /// No contact inserted
      return;
    }
    // log('189 _contactsIndexesWithNumber.length: ${_contactsIndexesWithNumber.length}');
    StringBuffer smsCode = StringBuffer();
    if (_contactsIndexesWithNumber.length < 8) {
      /// Less than 8 contact edited
      // for(var x = 0; x < contactsPhoneTECList.length; x++) {
      //   log('194 x: $x contactsPhoneTECList[$x].text: ${contactsPhoneTECList[x].text}');
      // }
      smsCode.write(_generateSMSCode(contactsPhoneTECList));
      // log('197 smsCode: $smsCode');
      Device tempDevice = _generateNewDevice(
        contactsPhoneTECList,
        contactsNameTECList,
      );
      await _updateContactsInLocalAndDevice(smsCode.toString(), tempDevice);
    }
    else {
      //More than 7 contact edited so we send 2 message to device with sms coolDown
      smsCode.write(
        _generateSMSCode(contactsPhoneTECList, moreThan6ContactEdited: true),
      );
      String finalSMS = smsCodeGenerator(
        _mainProvider.selectedDevice.devicePassword,
        '${smsCode.toString()}#',
      );
      final sendSMSResult = await injector<SMSRepository>().doSendSMS(
        message: finalSMS,
        phoneNumber: _mainProvider.selectedDevice.devicePhone,
        smsCoolDownFinished: _mainProvider.smsCooldownFinished,
        isManager: _mainProvider.selectedDevice.isManager,
      );
      sendSMSResult.fold(
        (l) => toastGenerator(l),
        (r) async {
          _mainProvider.startSMSCooldown();
          showLoadingDialog(
            msg: translate('long_contacts_desc'),
          );
          await Future.delayed(kSMSCooldown.seconds, () async {
            smsCode.clear();
            smsCode.write(
              _generateSMSCode(
                contactsPhoneTECList,
                isGeneratingSecondPart: true,
              ),
            );
            Device tempDevice = _generateNewDevice(
              contactsPhoneTECList,
              contactsNameTECList,
            );
            await _updateContactsInLocalAndDevice(
              smsCode.toString(),
              tempDevice,
              showConfirmDialog: false,
            );
          });
          await hideLoadingDialog();
        },
      );
    }
  }

  Device _generateNewDevice(
    List<TextEditingController> contactsPhoneTECList,
    List<TextEditingController> contactsNameTECList,
  ) {
    return _mainProvider.selectedDevice.copyWith(
      contact1Phone: _contactsIndexesWithNumber.contains(0)
          ? contactsPhoneTECList[0].text
          : _mainProvider.selectedDevice.contact1Phone,
      contact1Call: contactsPhoneTECList[0].text.isNotEmpty
          ? localData[0][0]!
          : _mainProvider.selectedDevice.contact1Call,
      contact1Manager: contactsPhoneTECList[0].text.isNotEmpty
          ? localData[0][5]!
          : _mainProvider.selectedDevice.contact1Manager,
      contact1SMS: contactsPhoneTECList[0].text.isNotEmpty
          ? localData[0][1]!
          : _mainProvider.selectedDevice.contact1SMS,
      contact2Phone: _contactsIndexesWithNumber.contains(1)
          ? contactsPhoneTECList[1].text
          : _mainProvider.selectedDevice.contact2Phone,
      contact2Call: contactsPhoneTECList[1].text.isNotEmpty
          ? localData[1][0]!
          : _mainProvider.selectedDevice.contact2Call,
      contact2Manager: contactsPhoneTECList[1].text.isNotEmpty
          ? localData[1][5]!
          : _mainProvider.selectedDevice.contact2Manager,
      contact2SMS: contactsPhoneTECList[1].text.isNotEmpty
          ? localData[1][1]!
          : _mainProvider.selectedDevice.contact2SMS,
      contact3Phone: _contactsIndexesWithNumber.contains(2)
          ? contactsPhoneTECList[2].text
          : _mainProvider.selectedDevice.contact3Phone,
      contact3Call: contactsPhoneTECList[2].text.isNotEmpty
          ? localData[2][0]!
          : _mainProvider.selectedDevice.contact3Call,
      contact3Manager: contactsPhoneTECList[2].text.isNotEmpty
          ? localData[2][5]!
          : _mainProvider.selectedDevice.contact3Manager,
      contact3SMS: contactsPhoneTECList[2].text.isNotEmpty
          ? localData[2][1]!
          : _mainProvider.selectedDevice.contact3SMS,
      contact4Phone: _contactsIndexesWithNumber.contains(3)
          ? contactsPhoneTECList[3].text
          : _mainProvider.selectedDevice.contact4Phone,
      contact4Call: contactsPhoneTECList[3].text.isNotEmpty
          ? localData[3][0]!
          : _mainProvider.selectedDevice.contact4Call,
      contact4Manager: contactsPhoneTECList[3].text.isNotEmpty
          ? localData[3][5]!
          : _mainProvider.selectedDevice.contact4Manager,
      contact4SMS: contactsPhoneTECList[3].text.isNotEmpty
          ? localData[3][1]!
          : _mainProvider.selectedDevice.contact4SMS,
      contact5Phone: _contactsIndexesWithNumber.contains(4)
          ? contactsPhoneTECList[4].text
          : _mainProvider.selectedDevice.contact5Phone,
      contact5Call: contactsPhoneTECList[4].text.isNotEmpty
          ? localData[4][0]!
          : _mainProvider.selectedDevice.contact5Call,
      contact5Manager: contactsPhoneTECList[4].text.isNotEmpty
          ? localData[4][5]!
          : _mainProvider.selectedDevice.contact5Manager,
      contact5SMS: contactsPhoneTECList[4].text.isNotEmpty
          ? localData[4][1]!
          : _mainProvider.selectedDevice.contact5SMS,
      contact6Phone: _contactsIndexesWithNumber.contains(5)
          ? contactsPhoneTECList[5].text
          : _mainProvider.selectedDevice.contact6Phone,
      contact6Call: contactsPhoneTECList[5].text.isNotEmpty
          ? localData[5][0]!
          : _mainProvider.selectedDevice.contact6Call,
      contact6Manager: contactsPhoneTECList[5].text.isNotEmpty
          ? localData[5][5]!
          : _mainProvider.selectedDevice.contact6Manager,
      contact6SMS: contactsPhoneTECList[5].text.isNotEmpty
          ? localData[5][1]!
          : _mainProvider.selectedDevice.contact6SMS,
      contact7Phone: _contactsIndexesWithNumber.contains(6)
          ? contactsPhoneTECList[6].text
          : _mainProvider.selectedDevice.contact7Phone,
      contact7Call: contactsPhoneTECList[6].text.isNotEmpty
          ? localData[6][0]!
          : _mainProvider.selectedDevice.contact7Call,
      contact7Manager: contactsPhoneTECList[6].text.isNotEmpty
          ? localData[6][5]!
          : _mainProvider.selectedDevice.contact7Manager,
      contact7SMS: contactsPhoneTECList[6].text.isNotEmpty
          ? localData[6][1]!
          : _mainProvider.selectedDevice.contact7SMS,
      contact8Phone: _contactsIndexesWithNumber.contains(7)
          ? contactsPhoneTECList[7].text
          : _mainProvider.selectedDevice.contact8Phone,
      contact8Call: contactsPhoneTECList[7].text.isNotEmpty
          ? localData[7][0]!
          : _mainProvider.selectedDevice.contact8Call,
      contact8Manager: contactsPhoneTECList[7].text.isNotEmpty
          ? localData[7][5]!
          : _mainProvider.selectedDevice.contact8Manager,
      contact8SMS: contactsPhoneTECList[7].text.isNotEmpty
          ? localData[7][1]!
          : _mainProvider.selectedDevice.contact8SMS,
      contact9Phone: _contactsIndexesWithNumber.contains(8)
          ? contactsPhoneTECList[8].text
          : _mainProvider.selectedDevice.contact9Phone,
      contact9Call: contactsPhoneTECList[8].text.isNotEmpty
          ? localData[8][0]!
          : _mainProvider.selectedDevice.contact9Call,
      contact9Manager: contactsPhoneTECList[8].text.isNotEmpty
          ? localData[8][5]!
          : _mainProvider.selectedDevice.contact9Manager,
      contact9SMS: contactsPhoneTECList[8].text.isNotEmpty
          ? localData[8][1]!
          : _mainProvider.selectedDevice.contact9SMS,
      contact10Phone: _contactsIndexesWithNumber.contains(9)
          ? contactsPhoneTECList[9].text
          : _mainProvider.selectedDevice.contact10Phone,
      contact10Call: contactsPhoneTECList[9].text.isNotEmpty
          ? localData[9][0]!
          : _mainProvider.selectedDevice.contact10Call,
      contact10Manager: contactsPhoneTECList[9].text.isNotEmpty
          ? localData[9][5]!
          : _mainProvider.selectedDevice.contact10Manager,
      contact10SMS: contactsPhoneTECList[9].text.isNotEmpty
          ? localData[9][1]!
          : _mainProvider.selectedDevice.contact10SMS,
    );
  }

  void _findContactsWithNumber(
    List<TextEditingController> contactsPhoneTECList,
  ) {
    _contactsIndexesWithNumber.clear();
    for (int i = 0; i < contactsPhoneTECList.length; i++) {
      if (contactsPhoneTECList[i].text.isNotEmpty) {
        _contactsIndexesWithNumber.add(i);
      }
    }
  }

  String _generateSMSCode(
    List<TextEditingController> contactsPhoneTECList, {
    bool moreThan6ContactEdited = false,
    bool isGeneratingSecondPart = false,
  }) {
    StringBuffer smsCode = StringBuffer();
    for (int j = isGeneratingSecondPart ? 7 : 0;
        j < (moreThan6ContactEdited ? 7 : _contactsIndexesWithNumber.length);
        j++) {
      smsCode.write(
        'P${_contactsIndexesWithNumber[j] + 1}H${contactsPhoneTECList[_contactsIndexesWithNumber[j]].text}',
      );
      if (contactsPhoneTECList[_contactsIndexesWithNumber[j]].text.isNotEmpty) {
        if (localData[_contactsIndexesWithNumber[j]][0]!) smsCode.write('D');
        if (localData[_contactsIndexesWithNumber[j]][1]!) smsCode.write('S');
        if (localData[_contactsIndexesWithNumber[j]][4]!) smsCode.write('R');
        if (localData[_contactsIndexesWithNumber[j]][2]!) smsCode.write('P');
        if (localData[_contactsIndexesWithNumber[j]][3]!) smsCode.write('C');
        if (localData[_contactsIndexesWithNumber[j]][5]!) smsCode.write('A');
      }
      //If no item checked then we add call and sms
      if (!localData[_contactsIndexesWithNumber[j]].contains(true) &&
          contactsPhoneTECList[_contactsIndexesWithNumber[j]].text.isNotEmpty) {
        smsCode.write('DS');
        localData[_contactsIndexesWithNumber[j]][0] = true;
        localData[_contactsIndexesWithNumber[j]][1] = true;
      }
      if (j + 1 != _contactsIndexesWithNumber.length) {
        smsCode.write('*');
      }
    }
    return smsCode.toString();
  }

  Future _updateContactsInLocalAndDevice(
    String smsCode,
    Device newDevice, {
    bool showConfirmDialog = true,
  }) async {
    String finalSMS = smsCodeGenerator(
      _mainProvider.selectedDevice.devicePassword,
      '$smsCode#',
    );
    final sendSMSResult = await injector<SMSRepository>().doSendSMS(
      message: finalSMS,
      phoneNumber: _mainProvider.selectedDevice.devicePhone,
      smsCoolDownFinished: _mainProvider.smsCooldownFinished,
      isManager: _mainProvider.selectedDevice.isManager,
      showConfirmDialog: showConfirmDialog,
    );
    sendSMSResult.fold(
      (l) => toastGenerator(l),
      (r) async {
        _mainProvider.startSMSCooldown();
        await _mainProvider.updateDevice(newDevice);
        if (isEditMode) isEditMode = false;
      },
    );
  }

  Future getContactsFromDevice(TextEditingController inquiryDialogTEC) async {
    var smsCode = smsCodeGenerator(
      _mainProvider.selectedDevice.devicePassword,
      kContactInquiryCode,
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
          rootScaffoldMessengerKey.currentState!.hideCurrentSnackBar();
          snackbarGenerator(
            translate('waiting_for_inquiry'),
          );
          _mainProvider.smsListener.onSmsReceived!.listen(
            (SmsMessage message) async => _processReceivedContactsSMS(
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
              await _processReceivedContactsSMS(
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

  Future _processReceivedContactsSMS(SmsMessage message) async {
    if (message.address == null ||
        !message.address!.contains(
          _mainProvider.selectedDevice.devicePhone.substring(1),
        ) ||
        message.body == null ||
        !message.body!.contains('*') ||
        message.body!.contains('Z')) {
      return;
    }
    String messageBody = message.body!;
    List<int> detectionSymbols = [];
    Device tempDevice = _mainProvider.selectedDevice.copyWith();
    if (messageBody == "*#") {
      /// Remove all contacts from database
      tempDevice = _generateNewDeviceWithFreshContacts();
    } else {
      detectionSymbols.addAll(_countDetectionSymbols(messageBody));
      int howMuchTime = 1;
      for (var i = 0; i < 9; i++) {
        if (howMuchTime < detectionSymbols.length) {
          if (messageBody
              .substring(
                detectionSymbols[howMuchTime] - 1,
                detectionSymbols[howMuchTime],
              )
              .contains((i + 1).toString())) {
            var contactData = messageBody.substring(
              detectionSymbols[howMuchTime - 1],
              detectionSymbols[howMuchTime],
            );
            tempDevice = _generateDeviceForReceivedSMS(
              i,
              tempDevice,
              messageBody.substring(
                detectionSymbols[howMuchTime - 1] + 1,
                detectionSymbols[howMuchTime - 1] + 12,
              ),
              contactData,
            );
            howMuchTime++;
          } else {
            tempDevice = _generateFreshContact(i);
          }
        } else {
          tempDevice = _generateFreshContact(i);
        }
      }
    }
    await _mainProvider.updateDevice(tempDevice);
    rootScaffoldMessengerKey.currentState!.hideCurrentSnackBar();
    if (isEditMode) isEditMode = false;
  }

  Device _generateNewDeviceWithFreshContacts() {
    return _mainProvider.selectedDevice.copyWith(
      contact1Phone: '',
      contact1SMS: false,
      contact1Call: false,
      contact1Manager: false,
      contact2Phone: '',
      contact2SMS: false,
      contact2Call: false,
      contact2Manager: false,
      contact3Phone: '',
      contact3SMS: false,
      contact3Call: false,
      contact3Manager: false,
      contact4Phone: '',
      contact4SMS: false,
      contact4Call: false,
      contact4Manager: false,
      contact5Phone: '',
      contact5SMS: false,
      contact5Call: false,
      contact5Manager: false,
      contact6Phone: '',
      contact6SMS: false,
      contact6Call: false,
      contact6Manager: false,
      contact7Phone: '',
      contact7SMS: false,
      contact7Call: false,
      contact7Manager: false,
      contact8Phone: '',
      contact8SMS: false,
      contact8Call: false,
      contact8Manager: false,
      contact9Phone: '',
      contact9SMS: false,
      contact9Call: false,
      contact9Manager: false,
      contact10Phone: '',
      contact10SMS: false,
      contact10Call: false,
      contact10Manager: false,
    );
  }

  Device _generateDeviceForReceivedSMS(
    int index,
    Device device,
    String contactPhone,
    String contactData,
  ) {
    Device tempDevice = device;
    if (index == 0) {
      tempDevice = tempDevice.copyWith(
        contact1Phone: contactPhone,
        contact1Call: contactData.contains('D'),
        contact1Manager: contactData.contains('A'),
        contact1SMS: contactData.contains('S'),
      );
    } else if (index == 1) {
      tempDevice = tempDevice.copyWith(
        contact2Phone: contactPhone,
        contact2Call: contactData.contains('D'),
        contact2Manager: contactData.contains('A'),
        contact2SMS: contactData.contains('S'),
      );
    } else if (index == 2) {
      tempDevice = tempDevice.copyWith(
        contact3Phone: contactPhone,
        contact3Call: contactData.contains('D'),
        contact3Manager: contactData.contains('A'),
        contact3SMS: contactData.contains('S'),
      );
    } else if (index == 3) {
      tempDevice = tempDevice.copyWith(
        contact4Phone: contactPhone,
        contact4Call: contactData.contains('D'),
        contact4Manager: contactData.contains('A'),
        contact4SMS: contactData.contains('S'),
      );
    } else if (index == 4) {
      tempDevice = tempDevice.copyWith(
        contact5Phone: contactPhone,
        contact5Call: contactData.contains('D'),
        contact5Manager: contactData.contains('A'),
        contact5SMS: contactData.contains('S'),
      );
    } else if (index == 5) {
      tempDevice = tempDevice.copyWith(
        contact6Phone: contactPhone,
        contact6Call: contactData.contains('D'),
        contact6Manager: contactData.contains('A'),
        contact6SMS: contactData.contains('S'),
      );
    } else if (index == 6) {
      tempDevice = tempDevice.copyWith(
        contact7Phone: contactPhone,
        contact7Call: contactData.contains('D'),
        contact7Manager: contactData.contains('A'),
        contact7SMS: contactData.contains('S'),
      );
    } else if (index == 7) {
      tempDevice = tempDevice.copyWith(
        contact8Phone: contactPhone,
        contact8Call: contactData.contains('D'),
        contact8Manager: contactData.contains('A'),
        contact8SMS: contactData.contains('S'),
      );
    } else if (index == 8) {
      tempDevice = tempDevice.copyWith(
        contact9Phone: contactPhone,
        contact9Call: contactData.contains('D'),
        contact9Manager: contactData.contains('A'),
        contact9SMS: contactData.contains('S'),
      );
    }
    return tempDevice;
  }

  List<int> _countDetectionSymbols(String messageBody) {
    List<int> detectionSymbols = [];
    for (int i = 0; i < messageBody.length; i++) {
      if (messageBody[i] == '*' || messageBody[i] == '#') {
        detectionSymbols.add(i);
      }
    }
    return detectionSymbols;
  }

  /// Update contacts in a batch (for contacts 1-5 or 6-10)
  void updateContactsBatch(
    int startIndex,
    int endIndex,
    List<List<bool?>> localData,
    List<TextEditingController> contactsPhoneTECList,
  ) {
    // First, collect all contact phone controllers that need update
    for (int i = startIndex; i <= endIndex; i++) {
      if (i < 0 || i >= 10) continue;
      
      if (contactsPhoneTECList[i].text.isNotEmpty) {
        _contactsIndexesWithNumber.add(i);
      }
    }
    
    // Create a map to hold all parameters we want to update
    Map<String, dynamic> params = {};
    
    for (int i = startIndex; i <= endIndex; i++) {
      if (i < 0 || i >= 10) continue; // Ensure the index is within bounds
      
      final contactIndex = i + 1;
      
      // Set parameters based on the contact index
      switch (contactIndex) {
        case 1:
          if (_contactsIndexesWithNumber.contains(i)) {
            params['contact1Phone'] = contactsPhoneTECList[i].text;
          }
          if (contactsPhoneTECList[i].text.isNotEmpty) {
            params['contact1Call'] = localData[i][1]!;
            params['contact1SMS'] = localData[i][0]!;
            params['contact1Manager'] = localData[i][2]!;
          }
          break;
        case 2:
          if (_contactsIndexesWithNumber.contains(i)) {
            params['contact2Phone'] = contactsPhoneTECList[i].text;
          }
          if (contactsPhoneTECList[i].text.isNotEmpty) {
            params['contact2Call'] = localData[i][1]!;
            params['contact2SMS'] = localData[i][0]!;
            params['contact2Manager'] = localData[i][2]!;
          }
          break;
        case 3:
          if (_contactsIndexesWithNumber.contains(i)) {
            params['contact3Phone'] = contactsPhoneTECList[i].text;
          }
          if (contactsPhoneTECList[i].text.isNotEmpty) {
            params['contact3Call'] = localData[i][1]!;
            params['contact3SMS'] = localData[i][0]!;
            params['contact3Manager'] = localData[i][2]!;
          }
          break;
        case 4:
          if (_contactsIndexesWithNumber.contains(i)) {
            params['contact4Phone'] = contactsPhoneTECList[i].text;
          }
          if (contactsPhoneTECList[i].text.isNotEmpty) {
            params['contact4Call'] = localData[i][1]!;
            params['contact4SMS'] = localData[i][0]!;
            params['contact4Manager'] = localData[i][2]!;
          }
          break;
        case 5:
          if (_contactsIndexesWithNumber.contains(i)) {
            params['contact5Phone'] = contactsPhoneTECList[i].text;
          }
          if (contactsPhoneTECList[i].text.isNotEmpty) {
            params['contact5Call'] = localData[i][1]!;
            params['contact5SMS'] = localData[i][0]!;
            params['contact5Manager'] = localData[i][2]!;
          }
          break;
        case 6:
          if (_contactsIndexesWithNumber.contains(i)) {
            params['contact6Phone'] = contactsPhoneTECList[i].text;
          }
          if (contactsPhoneTECList[i].text.isNotEmpty) {
            params['contact6Call'] = localData[i][1]!;
            params['contact6SMS'] = localData[i][0]!;
            params['contact6Manager'] = localData[i][2]!;
          }
          break;
        case 7:
          if (_contactsIndexesWithNumber.contains(i)) {
            params['contact7Phone'] = contactsPhoneTECList[i].text;
          }
          if (contactsPhoneTECList[i].text.isNotEmpty) {
            params['contact7Call'] = localData[i][1]!;
            params['contact7SMS'] = localData[i][0]!;
            params['contact7Manager'] = localData[i][2]!;
          }
          break;
        case 8:
          if (_contactsIndexesWithNumber.contains(i)) {
            params['contact8Phone'] = contactsPhoneTECList[i].text;
          }
          if (contactsPhoneTECList[i].text.isNotEmpty) {
            params['contact8Call'] = localData[i][1]!;
            params['contact8SMS'] = localData[i][0]!;
            params['contact8Manager'] = localData[i][2]!;
          }
          break;
        case 9:
          if (_contactsIndexesWithNumber.contains(i)) {
            params['contact9Phone'] = contactsPhoneTECList[i].text;
          }
          if (contactsPhoneTECList[i].text.isNotEmpty) {
            params['contact9Call'] = localData[i][1]!;
            params['contact9SMS'] = localData[i][0]!;
            params['contact9Manager'] = localData[i][2]!;
          }
          break;
        case 10:
          if (_contactsIndexesWithNumber.contains(i)) {
            params['contact10Phone'] = contactsPhoneTECList[i].text;
          }
          if (contactsPhoneTECList[i].text.isNotEmpty) {
            params['contact10Call'] = localData[i][1]!;
            params['contact10SMS'] = localData[i][0]!;
            params['contact10Manager'] = localData[i][2]!;
          }
          break;
      }
    }
    
    // Now apply all updates in a single copyWith call
    Device updatedDevice = _mainProvider.selectedDevice.copyWith(
      contact1Phone: params['contact1Phone'],
      contact1Call: params['contact1Call'],
      contact1SMS: params['contact1SMS'],
      contact1Manager: params['contact1Manager'],
      contact2Phone: params['contact2Phone'],
      contact2Call: params['contact2Call'],
      contact2SMS: params['contact2SMS'],
      contact2Manager: params['contact2Manager'],
      contact3Phone: params['contact3Phone'],
      contact3Call: params['contact3Call'],
      contact3SMS: params['contact3SMS'],
      contact3Manager: params['contact3Manager'],
      contact4Phone: params['contact4Phone'],
      contact4Call: params['contact4Call'],
      contact4SMS: params['contact4SMS'],
      contact4Manager: params['contact4Manager'],
      contact5Phone: params['contact5Phone'],
      contact5Call: params['contact5Call'],
      contact5SMS: params['contact5SMS'],
      contact5Manager: params['contact5Manager'],
      contact6Phone: params['contact6Phone'],
      contact6Call: params['contact6Call'],
      contact6SMS: params['contact6SMS'],
      contact6Manager: params['contact6Manager'],
      contact7Phone: params['contact7Phone'],
      contact7Call: params['contact7Call'],
      contact7SMS: params['contact7SMS'],
      contact7Manager: params['contact7Manager'],
      contact8Phone: params['contact8Phone'],
      contact8Call: params['contact8Call'],
      contact8SMS: params['contact8SMS'],
      contact8Manager: params['contact8Manager'],
      contact9Phone: params['contact9Phone'],
      contact9Call: params['contact9Call'],
      contact9SMS: params['contact9SMS'],
      contact9Manager: params['contact9Manager'],
      contact10Phone: params['contact10Phone'],
      contact10Call: params['contact10Call'],
      contact10SMS: params['contact10SMS'],
      contact10Manager: params['contact10Manager'],
    );
    
    _mainProvider.updateDevice(updatedDevice);
  }

  Device _updateContactsBasedOnData(
    List<List<bool?>> localData,
    List<TextEditingController> contactsPhoneTECList,
  ) {
    return _mainProvider.selectedDevice.copyWith(
      contact1Phone: _contactsIndexesWithNumber.contains(0)
          ? contactsPhoneTECList[0].text
          : _mainProvider.selectedDevice.contact1Phone,
      contact1Call: contactsPhoneTECList[0].text.isNotEmpty
          ? localData[0][0]!
          : contactsPhoneTECList[0].text.isNotEmpty,
      contact1Manager: contactsPhoneTECList[0].text.isNotEmpty
          ? localData[0][5]!
          : contactsPhoneTECList[0].text.isNotEmpty,
      contact1SMS: contactsPhoneTECList[0].text.isNotEmpty
          ? localData[0][1]!
          : contactsPhoneTECList[0].text.isNotEmpty,
      contact2Phone: _contactsIndexesWithNumber.contains(1)
          ? contactsPhoneTECList[1].text
          : _mainProvider.selectedDevice.contact2Phone,
      contact2Call: contactsPhoneTECList[1].text.isNotEmpty
          ? localData[1][0]!
          : contactsPhoneTECList[1].text.isNotEmpty,
      contact2Manager: contactsPhoneTECList[1].text.isNotEmpty
          ? localData[1][5]!
          : contactsPhoneTECList[1].text.isNotEmpty,
      contact2SMS: contactsPhoneTECList[1].text.isNotEmpty
          ? localData[1][1]!
          : contactsPhoneTECList[1].text.isNotEmpty,
      contact3Phone: _contactsIndexesWithNumber.contains(2)
          ? contactsPhoneTECList[2].text
          : _mainProvider.selectedDevice.contact3Phone,
      contact3Call: contactsPhoneTECList[2].text.isNotEmpty
          ? localData[2][0]!
          : contactsPhoneTECList[2].text.isNotEmpty,
      contact3Manager: contactsPhoneTECList[2].text.isNotEmpty
          ? localData[2][5]!
          : contactsPhoneTECList[2].text.isNotEmpty,
      contact3SMS: contactsPhoneTECList[2].text.isNotEmpty
          ? localData[2][1]!
          : contactsPhoneTECList[2].text.isNotEmpty,
      contact4Phone: _contactsIndexesWithNumber.contains(3)
          ? contactsPhoneTECList[3].text
          : _mainProvider.selectedDevice.contact4Phone,
      contact4Call: contactsPhoneTECList[3].text.isNotEmpty
          ? localData[3][0]!
          : contactsPhoneTECList[3].text.isNotEmpty,
      contact4Manager: contactsPhoneTECList[3].text.isNotEmpty
          ? localData[3][5]!
          : contactsPhoneTECList[3].text.isNotEmpty,
      contact4SMS: contactsPhoneTECList[3].text.isNotEmpty
          ? localData[3][1]!
          : contactsPhoneTECList[3].text.isNotEmpty,
      contact5Phone: _contactsIndexesWithNumber.contains(4)
          ? contactsPhoneTECList[4].text
          : _mainProvider.selectedDevice.contact5Phone,
      contact5Call: contactsPhoneTECList[4].text.isNotEmpty
          ? localData[4][0]!
          : contactsPhoneTECList[4].text.isNotEmpty,
      contact5Manager: contactsPhoneTECList[4].text.isNotEmpty
          ? localData[4][5]!
          : contactsPhoneTECList[4].text.isNotEmpty,
      contact5SMS: contactsPhoneTECList[4].text.isNotEmpty
          ? localData[4][1]!
          : contactsPhoneTECList[4].text.isNotEmpty,
      contact6Phone: _contactsIndexesWithNumber.contains(5)
          ? contactsPhoneTECList[5].text
          : _mainProvider.selectedDevice.contact6Phone,
      contact6Call: contactsPhoneTECList[5].text.isNotEmpty
          ? localData[5][0]!
          : contactsPhoneTECList[5].text.isNotEmpty,
      contact6Manager: contactsPhoneTECList[5].text.isNotEmpty
          ? localData[5][5]!
          : contactsPhoneTECList[5].text.isNotEmpty,
      contact6SMS: contactsPhoneTECList[5].text.isNotEmpty
          ? localData[5][1]!
          : contactsPhoneTECList[5].text.isNotEmpty,
      contact7Phone: _contactsIndexesWithNumber.contains(6)
          ? contactsPhoneTECList[6].text
          : _mainProvider.selectedDevice.contact7Phone,
      contact7Call: contactsPhoneTECList[6].text.isNotEmpty
          ? localData[6][0]!
          : contactsPhoneTECList[6].text.isNotEmpty,
      contact7Manager: contactsPhoneTECList[6].text.isNotEmpty
          ? localData[6][5]!
          : contactsPhoneTECList[6].text.isNotEmpty,
      contact7SMS: contactsPhoneTECList[6].text.isNotEmpty
          ? localData[6][1]!
          : contactsPhoneTECList[6].text.isNotEmpty,
      contact8Phone: _contactsIndexesWithNumber.contains(7)
          ? contactsPhoneTECList[7].text
          : _mainProvider.selectedDevice.contact8Phone,
      contact8Call: contactsPhoneTECList[7].text.isNotEmpty
          ? localData[7][0]!
          : contactsPhoneTECList[7].text.isNotEmpty,
      contact8Manager: contactsPhoneTECList[7].text.isNotEmpty
          ? localData[7][5]!
          : contactsPhoneTECList[7].text.isNotEmpty,
      contact8SMS: contactsPhoneTECList[7].text.isNotEmpty
          ? localData[7][1]!
          : contactsPhoneTECList[7].text.isNotEmpty,
      contact9Phone: _contactsIndexesWithNumber.contains(8)
          ? contactsPhoneTECList[8].text
          : _mainProvider.selectedDevice.contact9Phone,
      contact9Call: contactsPhoneTECList[8].text.isNotEmpty
          ? localData[8][0]!
          : contactsPhoneTECList[8].text.isNotEmpty,
      contact9Manager: contactsPhoneTECList[8].text.isNotEmpty
          ? localData[8][5]!
          : contactsPhoneTECList[8].text.isNotEmpty,
      contact9SMS: contactsPhoneTECList[8].text.isNotEmpty
          ? localData[8][1]!
          : contactsPhoneTECList[8].text.isNotEmpty,
      contact10Phone: _contactsIndexesWithNumber.contains(9)
          ? contactsPhoneTECList[9].text
          : _mainProvider.selectedDevice.contact10Phone,
      contact10Call: contactsPhoneTECList[9].text.isNotEmpty
          ? localData[9][0]!
          : contactsPhoneTECList[9].text.isNotEmpty,
      contact10Manager: contactsPhoneTECList[9].text.isNotEmpty
          ? localData[9][5]!
          : contactsPhoneTECList[9].text.isNotEmpty,
      contact10SMS: contactsPhoneTECList[9].text.isNotEmpty
          ? localData[9][1]!
          : contactsPhoneTECList[9].text.isNotEmpty,
    );
  }

  // Method to send contacts via SMS in the required format
  Future<void> sendContactsSMS(String devicePhone, String formattedMessage) async {
    if (devicePhone.isEmpty) {
      toastGenerator(translate('please_select_device_first'));
      return;
    }
    
    // Send the SMS through the SMS repository
    final sendSMSResult = await injector<SMSRepository>().doSendSMS(
      message: formattedMessage,
      phoneNumber: devicePhone,
      smsCoolDownFinished: _mainProvider.smsCooldownFinished,
      isManager: _mainProvider.selectedDevice.isManager,
      showConfirmDialog: true, // Show confirm dialog since this is important
    );
    
    sendSMSResult.fold(
      (failure) => toastGenerator(failure),
      (success) {
        _mainProvider.startSMSCooldown();
        toastGenerator(translate('contacts_sent_successfully'));
      },
    );
  }
}
