import 'dart:developer';
import 'dart:io';

import 'package:security_alarm/core/constants/constants.dart';
import 'package:security_alarm/models/scenario.dart';
import 'package:security_alarm/widgets/dialogs/editable_dialog_widget.dart';
import 'package:flutter/material.dart';
import '../services/remote/flutter_sms_listener.dart';
import 'package:flutter_translate/flutter_translate.dart';

import '../core/constants/global_keys.dart';
import '../core/constants/sms_codes.dart';
import '../core/utils/helper.dart';
import '../injector.dart';
import '../models/device.dart';
import '../repository/sms_repository.dart';
import 'main_provider.dart';
import '../repository/cache_repository.dart';
import '../views/zones/zone_settings/mobile/zone_mode_settings_view.dart';

class ScenarioProvider extends ChangeNotifier {
  late MainProvider _mainProvider;
  List<String?> scenario = [];
  List<String?> scenariosText = [];
  List<List<String?>> scenarios = [];

  // List<List<bool?>> localData = List.generate(
  //   9,
  //   (index) => <bool?>[]..length = 6,
  // );

  ScenarioProvider(MainProvider? mainProvider) {
    if (mainProvider != null) {
      _mainProvider = mainProvider;
      scenario = [
        'فعال',
        'زون های بسته',
        null,
        'رله',
        null,
        'سناریو',
      ];
      scenarios = [
        [
          mainProvider.selectedDevice.deviceStatus1,
          mainProvider.selectedDevice.inputType1,
          mainProvider.selectedDevice.inputSelect1,
          mainProvider.selectedDevice.actionType1,
          mainProvider.selectedDevice.actionSelect1,
          mainProvider.selectedDevice.scenarioName1,
        ],
        [
          mainProvider.selectedDevice.deviceStatus2,
          mainProvider.selectedDevice.inputType2,
          mainProvider.selectedDevice.inputSelect2,
          mainProvider.selectedDevice.actionType2,
          mainProvider.selectedDevice.actionSelect2,
          mainProvider.selectedDevice.scenarioName2,
        ],
        [
          mainProvider.selectedDevice.deviceStatus3,
          mainProvider.selectedDevice.inputType3,
          mainProvider.selectedDevice.inputSelect3,
          mainProvider.selectedDevice.actionType3,
          mainProvider.selectedDevice.actionSelect3,
          mainProvider.selectedDevice.scenarioName3,
        ],
        [
          mainProvider.selectedDevice.deviceStatus4,
          mainProvider.selectedDevice.inputType4,
          mainProvider.selectedDevice.inputSelect4,
          mainProvider.selectedDevice.actionType4,
          mainProvider.selectedDevice.actionSelect4,
          mainProvider.selectedDevice.scenarioName4,
        ],
        [
          mainProvider.selectedDevice.deviceStatus5,
          mainProvider.selectedDevice.inputType5,
          mainProvider.selectedDevice.inputSelect5,
          mainProvider.selectedDevice.actionType5,
          mainProvider.selectedDevice.actionSelect5,
          mainProvider.selectedDevice.scenarioName5,
        ],
        [
          mainProvider.selectedDevice.deviceStatus6,
          mainProvider.selectedDevice.inputType6,
          mainProvider.selectedDevice.inputSelect6,
          mainProvider.selectedDevice.actionType6,
          mainProvider.selectedDevice.actionSelect6,
          mainProvider.selectedDevice.scenarioName6,
        ],
        [
          mainProvider.selectedDevice.deviceStatus7,
          mainProvider.selectedDevice.inputType7,
          mainProvider.selectedDevice.inputSelect7,
          mainProvider.selectedDevice.actionType7,
          mainProvider.selectedDevice.actionSelect7,
          mainProvider.selectedDevice.scenarioName7,
        ],
        [
          mainProvider.selectedDevice.deviceStatus8,
          mainProvider.selectedDevice.inputType8,
          mainProvider.selectedDevice.inputSelect8,
          mainProvider.selectedDevice.actionType8,
          mainProvider.selectedDevice.actionSelect8,
          mainProvider.selectedDevice.scenarioName8,
        ],
        [
          mainProvider.selectedDevice.deviceStatus9,
          mainProvider.selectedDevice.inputType9,
          mainProvider.selectedDevice.inputSelect9,
          mainProvider.selectedDevice.actionType9,
          mainProvider.selectedDevice.actionSelect9,
          mainProvider.selectedDevice.scenarioName9,
        ],
        [
          mainProvider.selectedDevice.deviceStatus10,
          mainProvider.selectedDevice.inputType10,
          mainProvider.selectedDevice.inputSelect10,
          mainProvider.selectedDevice.actionType10,
          mainProvider.selectedDevice.actionSelect10,
          mainProvider.selectedDevice.scenarioName10,
        ],
      ];

      if (mainProvider.selectedDevice.deviceStatus1 != null) {
        scenariosText.add(
            '${mainProvider.selectedDevice.scenarioName1}: اگر دستگاه ${mainProvider.selectedDevice.deviceStatus1} باشد و ${mainProvider.selectedDevice.inputSelect1} شود، ${mainProvider.selectedDevice.actionSelect1} می شود.');
      }
      if (mainProvider.selectedDevice.deviceStatus2 != null) {
        scenariosText.add(
            '${mainProvider.selectedDevice.scenarioName2}: اگر دستگاه ${mainProvider.selectedDevice.deviceStatus2} باشد و ${mainProvider.selectedDevice.inputSelect2} شود، ${mainProvider.selectedDevice.actionSelect2} می شود.');
      }
      if (mainProvider.selectedDevice.deviceStatus3 != null) {
        scenariosText.add(
            '${mainProvider.selectedDevice.scenarioName3}: اگر دستگاه ${mainProvider.selectedDevice.deviceStatus3} باشد و ${mainProvider.selectedDevice.inputSelect3} شود، ${mainProvider.selectedDevice.actionSelect3} می شود.');
      }
      if (mainProvider.selectedDevice.deviceStatus4 != null) {
        scenariosText.add(
            '${mainProvider.selectedDevice.scenarioName4}: اگر دستگاه ${mainProvider.selectedDevice.deviceStatus4} باشد و ${mainProvider.selectedDevice.inputSelect4} شود، ${mainProvider.selectedDevice.actionSelect4} می شود.');
      }
      if (mainProvider.selectedDevice.deviceStatus5 != null) {
        scenariosText.add(
            '${mainProvider.selectedDevice.scenarioName5}: اگر دستگاه ${mainProvider.selectedDevice.deviceStatus5} باشد و ${mainProvider.selectedDevice.inputSelect5} شود، ${mainProvider.selectedDevice.actionSelect5} می شود.');
      }
      if (mainProvider.selectedDevice.deviceStatus6 != null) {
        scenariosText.add(
            '${mainProvider.selectedDevice.scenarioName6}: اگر دستگاه ${mainProvider.selectedDevice.deviceStatus6} باشد و ${mainProvider.selectedDevice.inputSelect6} شود، ${mainProvider.selectedDevice.actionSelect6} می شود.');
      }
      if (mainProvider.selectedDevice.deviceStatus7 != null) {
        scenariosText.add(
            '${mainProvider.selectedDevice.scenarioName7}: اگر دستگاه ${mainProvider.selectedDevice.deviceStatus7} باشد و ${mainProvider.selectedDevice.inputSelect7} شود، ${mainProvider.selectedDevice.actionSelect7} می شود.');
      }
      if (mainProvider.selectedDevice.deviceStatus8 != null) {
        scenariosText.add(
            '${mainProvider.selectedDevice.scenarioName8}: اگر دستگاه ${mainProvider.selectedDevice.deviceStatus8} باشد و ${mainProvider.selectedDevice.inputSelect8} شود، ${mainProvider.selectedDevice.actionSelect8} می شود.');
      }
      if (mainProvider.selectedDevice.deviceStatus9 != null) {
        scenariosText.add(
            '${mainProvider.selectedDevice.scenarioName9}: اگر دستگاه ${mainProvider.selectedDevice.deviceStatus9} باشد و ${mainProvider.selectedDevice.inputSelect9} شود، ${mainProvider.selectedDevice.actionSelect9} می شود.');
      }
      if (mainProvider.selectedDevice.deviceStatus10 != null) {
        scenariosText.add(
            '${mainProvider.selectedDevice.scenarioName10}: اگر دستگاه ${mainProvider.selectedDevice.deviceStatus10} باشد و ${mainProvider.selectedDevice.inputSelect10} شود، ${mainProvider.selectedDevice.actionSelect10} می شود.');
      }
    }
  }

  String deviceStatusCode(String? name) {
    switch (name) {
      case 'فعال':
        return 'L';
      case 'غیرفعال':
        return 'U';
      case 'نیمه فعال':
        return 'H';
      case 'سایلنت':
        return 'S';
      case '24 ساعت':
        return 'F';
      default:
        return 'F';
    }
  }

  String deviceStatusString(String? code) {
    switch (code) {
      case 'L':
        return 'فعال';
      case 'U':
        return 'غیرفعال';
      case 'H':
        return 'نیمه فعال';
      case 'S':
        return 'سایلنت';
      case 'F':
        return '24 ساعت';
      default:
        return '24 ساعت';
    }
  }

  String inputSelectCode(String? name) {
    switch (name) {
      case 'زون 1 بسته':
        return '0';
      case 'زون 2 بسته':
        return '2';
      case 'زون 3 بسته':
        return '4';
      case 'زون 4 بسته':
        return '6';
      case 'زون 5 بسته':
        return '8';
      case 'زون 6 بسته':
        return 'q';
      case 'زون 7 بسته':
        return 'e';
      case 'زون 8 بسته':
        return 't';
      case 'زون 9 بسته':
        return 'u';
      case 'زون 10 بسته':
        return 'o';
      case 'زون 1 باز':
        return '1';
      case 'زون 2 باز':
        return '3';
      case 'زون 3 باز':
        return '5';
      case 'زون 4 باز':
        return '7';
      case 'زون 5 باز':
        return '9';
      case 'زون 6 باز':
        return 'w';
      case 'زون 7 باز':
        return 'r';
      case 'زون 8 باز':
        return 'y';
      case 'زون 9 باز':
        return 'i';
      case 'زون 10 باز':
        return 'p';
      case 'آژیر فعال':
        return 'a';
      case 'اسپیکر وصل':
        return 'x';
      case 'اسپیکر قطع':
        return 'D';
      default:
        return 'a';
    }
  }

  String inputSelectString(String? code) {
    switch (code) {
      case '0':
        return 'زون 1 بسته';
      case '2':
        return 'زون 2 بسته';
      case '4':
        return 'زون 3 بسته';
      case '6':
        return 'زون 4 بسته';
      case '8':
        return 'زون 5 بسته';
      case 'q':
        return 'زون 6 بسته';
      case 'e':
        return 'زون 7 بسته';
      case 't':
        return 'زون 8 بسته';
      case 'u':
        return 'زون 9 بسته';
      case 'o':
        return 'زون 10 بسته';
      case '1':
        return 'زون 1 باز';
      case '3':
        return 'زون 2 باز';
      case '5':
        return 'زون 3 باز';
      case '7':
        return 'زون 4 باز';
      case '9':
        return 'زون 5 باز';
      case 'w':
        return 'زون 6 باز';
      case 'r':
        return 'زون 7 باز';
      case 'y':
        return 'زون 8 باز';
      case 'i':
        return 'زون 9 باز';
      case 'p':
        return 'زون 10 باز';
      case 'a':
        return 'آژیر فعال';
      case 'x':
        return 'اسپیکر وصل';
      case 'D':
        return 'اسپیکر قطع';
      default:
        return 'اسپیکر قطع';
    }
  }

  String actionSelectCode(String? name) {
    switch (name) {
      case 'رله 1 وصل':
        return 'R';
      case 'رله 1 قطع':
        return 'Q';
      case 'رله 2 وصل':
        return 'T';
      case 'رله 2 قطع':
        return 'E';
      case 'رله 3 وصل':
        return 'Y';
      case 'رله 3 قطع':
        return 'I';
      case 'سیستم فعال':
        return 'L';
      case 'سیستم غیرفعال':
        return 'U';
      case 'سیستم فعال در حالت سایلنت':
        return 'S';
      case 'سیستم نیمه فعال':
        return 'H';
      case 'آژیر فعال':
        return 'O';
      case 'آژیر گارد فعال':
        return 'P';
      case 'سیرن فعال':
        return 'A';
      default:
        return 'a';
    }
  }

  String inputTypeString(String? action) {
    if ((action ?? '').contains('بسته')) {
      return 'زون های بسته';
    } else if ((action ?? '').contains('باز')) {
      return 'زون های باز';
    } else if ((action ?? '').contains('آژیر')) {
      return 'آژیر فعال';
    } else {
      return 'اسپیکر';
    }
  }

  String actionTypeString(String? action) {
    if ((action ?? '').contains('رله')) {
      return 'رله';
    } else {
      return 'وضعیت دستگاه';
    }
  }

  String actionSelectString(String? code) {
    switch (code) {
      case 'R':
        return 'رله 1 وصل';
      case 'Q':
        return 'رله 1 قطع';
      case 'T':
        return 'رله 2 وصل';
      case 'E':
        return 'رله 2 قطع';
      case 'Y':
        return 'رله 3 وصل';
      case 'I':
        return 'رله 3 قطع';
      case 'L':
        return 'سیستم فعال';
      case 'U':
        return 'سیستم غیرفعال';
      case 'S':
        return 'سیستم فعال در حالت سایلنت';
      case 'H':
        return 'سیستم نیمه فعال';
      case 'O':
        return 'آژیر فعال';
      case 'P':
        return 'آژیر گارد فعال';
      case 'A':
        return 'سیرن فعال';
      default:
        return 'سیرن فعال';
    }
  }

  /// Method to save scenarios to the database
  Future<void> _saveScenariosToDB() async {
    try {
      // Get device ID
      final deviceId = _mainProvider.selectedDevice.id;
      if (deviceId == null) {
        log('Device ID is null, cannot save scenarios to DB');
        return;
      }
      
      // Create a backup of scenariosText before database operations
      List<String?> scenariosBackup = List.from(scenariosText);
      log('Backing up scenariosText before DB operations, count: ${scenariosBackup.length}');
      
      log('Saving scenarios to database for device $deviceId - Total scenarios: ${scenariosText.length}');
      
      // Convert the list to individual fields
      List<String> safeTexts = scenariosText.map((text) => text ?? '').toList();
      
      // Create a new scenario with auto-incrementing ID
      final scenario = await injector<CacheRepository>().getScenarioByDeviceId(deviceId) ?? 
          Scenario(
            id: DateTime.now().millisecondsSinceEpoch, // Use timestamp as unique ID
            deviceId: deviceId,
            scenarioText1: '',
            scenarioText2: '',
            scenarioText3: '',
            scenarioText4: '',
            scenarioText5: '',
            scenarioText6: '',
            scenarioText7: '',
            scenarioText8: '',
            scenarioText9: '',
            scenarioText10: '',
            smsFormat: _smsFormat,
            modeFormat: _modeFormat,
          );
      
      // Create a new scenario with updated field values
      final updatedScenario = Scenario(
        id: scenario.id,
        deviceId: deviceId,
        scenarioText1: safeTexts.length > 0 ? safeTexts[0] : '',
        scenarioText2: safeTexts.length > 1 ? safeTexts[1] : '',
        scenarioText3: safeTexts.length > 2 ? safeTexts[2] : '',
        scenarioText4: safeTexts.length > 3 ? safeTexts[3] : '',
        scenarioText5: safeTexts.length > 4 ? safeTexts[4] : '',
        scenarioText6: safeTexts.length > 5 ? safeTexts[5] : '',
        scenarioText7: safeTexts.length > 6 ? safeTexts[6] : '',
        scenarioText8: safeTexts.length > 7 ? safeTexts[7] : '',
        scenarioText9: safeTexts.length > 8 ? safeTexts[8] : '',
        scenarioText10: safeTexts.length > 9 ? safeTexts[9] : '',
        smsFormat: _smsFormat,
        modeFormat: _modeFormat,
      );
      
      // First delete any existing scenario for this device
      try {
        await injector<CacheRepository>().deleteScenarioByDeviceId(deviceId);
      } catch (e) {
        log('Error deleting scenario: $e');
        // Continue anyway
      }
      
      // Save the updated scenario
      try {
        await injector<CacheRepository>().saveScenarios(
          deviceId, 
          scenariosText, 
          _smsFormat,
          _modeFormat
        );
      } catch (e) {
        log('Error saving scenarios: $e');
      }
      
      // Check if scenariosText was unexpectedly cleared
      if (scenariosText.isEmpty && scenariosBackup.isNotEmpty) {
        log('Warning: scenariosText was cleared during database operations! Restoring from backup...');
        scenariosText = List.from(scenariosBackup);
      }
      
      // Debug logs
      for (int i = 0; i < safeTexts.length; i++) {
        log('Saved scenario $i: ${safeTexts[i]}');
      }
      
      log('Scenarios saved successfully to database, count: ${scenariosText.length}');
    } catch (e) {
      log('Error saving scenarios to database: $e');
    }
  }

  Future registerScenario() async {
    try {
      log('شروع ارسال سناریو...');
      
      // بررسی وجود شماره تلفن دستگاه
      final String devicePhone = _mainProvider.selectedDevice.devicePhone;
      if (devicePhone.isEmpty) {
        log('Device phone number is empty, cannot send SMS');
        toastGenerator('شماره تلفن دستگاه خالی است');
        return;
      }
      
      // بررسی وجود فرمت‌های اس‌ام‌اس
      if (_smsFormat.isEmpty) {
        log('SMS format is not set, cannot send SMS');
        toastGenerator('فرمت پیام تنظیم نشده است');
        return;
      }
      
      log('ارسال اس‌ام‌اس به شماره: $devicePhone');
      log('متن اس‌ام‌اس: $_smsFormat');
      
      // Create a backup of scenarios before SMS operations
      List<String?> scenariosBackup = List.from(scenariosText);
      log('Created backup of scenarios, count: ${scenariosBackup.length}');
      
      // تلاش مستقیم برای ارسال پیام با متد sendDirectSMS
      toastGenerator('در حال ارسال سناریو...');
      
      // نمایش فرمت‌های ارسالی در کنسول برای دیباگ
      log('====== DEBUG SMS FORMAT ======');
      log('SMS FORMAT: $_smsFormat');
      if (_modeFormat.isNotEmpty) {
        log('MODE FORMAT: $_modeFormat');
      }
      log('==============================');
      
      // ارسال مستقیم اس‌ام‌اس سناریو
      final successSMS = await sendDirectSMS(devicePhone, _smsFormat, false);
      
      if (successSMS) {
        log('SMS sent successfully: $_smsFormat');
        toastGenerator('سناریو با موفقیت ارسال شد');
        
        // اگر فرمت مد عملکرد تنظیم شده باشد، آن را هم ارسال کنیم
        if (_modeFormat.isNotEmpty) {
          log('ارسال اس‌ام‌اس مد عملکرد: $_modeFormat');
          toastGenerator('در حال ارسال مد عملکرد...');
          
          final successMode = await sendDirectSMS(devicePhone, _modeFormat, true);
          if (successMode) {
            log('Mode SMS sent successfully: $_modeFormat');
            toastGenerator('مد عملکرد با موفقیت ارسال شد');
          } else {
            log('Failed to send mode SMS');
            toastGenerator('خطا در ارسال مد عملکرد');
          }
        }
        
        // This is critical - save scenarios to database
        // Make sure scenarios are not cleared
        log('Before saving: Current scenarios count: ${scenariosText.length}');
        for (int i = 0; i < scenariosText.length; i++) {
          log('  Scenario $i: ${scenariosText[i]}');
        }
        
        // ذخیره سناریوها در دیتابیس - به جای پاک کردن آنها
        await _saveScenariosToDB();
        
        // به‌روزرسانی وضعیت دستگاه در صورت نیاز
        Device tempDevice = _mainProvider.selectedDevice.copyWith();
    await _mainProvider.updateDevice(tempDevice);
        
        // Check if scenariosText was cleared during operations
        if (scenariosText.isEmpty && scenariosBackup.isNotEmpty) {
          log('Warning: scenariosText was cleared! Restoring from backup...');
          scenariosText = List.from(scenariosBackup);
        }
        
        // اطمینان از حفظ سناریوها بعد از ارسال موفقیت‌آمیز
        log('After saving: Current scenarios count: ${scenariosText.length}');
        notifyListeners();
      } else {
        log('Failed to send SMS scenario');
        toastGenerator('خطا در ارسال سناریو');
      }
    } catch (e) {
      log('Error in registerScenario: $e');
      toastGenerator('خطای غیرمنتظره: $e');
    }
  }

  // Future updateRemoteNames(List<TextEditingController> remotesNameTECList) async {
  //   Navigator.pop(kNavigatorKey.currentContext!);
  //   showLoadingDialog();
  //   Device tempDevice = _mainProvider.selectedDevice.copyWith(
  //     remote1Name: remotesNameTECList[0].text,
  //     remote2Name: remotesNameTECList[1].text,
  //     remote3Name: remotesNameTECList[2].text,
  //     remote4Name: remotesNameTECList[3].text,
  //     remote5Name: remotesNameTECList[4].text,
  //     remote6Name: remotesNameTECList[5].text,
  //     remote7Name: remotesNameTECList[6].text,
  //     remote8Name: remotesNameTECList[7].text,
  //     remote9Name: remotesNameTECList[8].text,
  //     remote10Name: remotesNameTECList[9].text,
  //     remote11Name: remotesNameTECList[10].text,
  //     remote12Name: remotesNameTECList[11].text,
  //     remote13Name: remotesNameTECList[12].text,
  //     remote14Name: remotesNameTECList[13].text,
  //   );
  //   await _mainProvider.updateDevice(tempDevice);
  //   toastGenerator(translate('remote_saved_successfully'));
  //   await hideLoadingDialog();
  // }

  Future updateScenario(
    String selectedValue,
    int index,
  ) async {
    scenario[index] = selectedValue;
    log('(index = $index');
    log('(selectedValue = $selectedValue');
    if (index == 1) {
      if (selectedValue.contains('بسته')) {
        scenario[2] = 'زون 1 بسته';
      } else if (selectedValue.contains('باز')) {
        scenario[2] = 'زون 1 باز';
      } else if (selectedValue.contains('آژیر')) {
        scenario[2] = 'آژیر فعال';
      } else if (selectedValue.contains('اسپیکر')) {
        scenario[2] = 'اسپیکر وصل';
      }
    } else if (index == 3) {
      if (selectedValue.contains('رله')) {
        scenario[4] = 'رله 1 وصل';
      } else if (selectedValue.contains('دستگاه')) {
        scenario[4] = 'سیستم فعال';
      }
    }
    notifyListeners();
  }

  Future getScenarioFromDevice() async {
    var smsCode = smsCodeGenerator(
      _mainProvider.selectedDevice.devicePassword,
      kScenarioInquiryCode,
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
            (SmsMessage message) async => _processReceivedScenarioSMS(
              message,
            ),
          );
        } else if (Platform.isIOS) {
          await dialogGenerator(
            translate('inquiry_sms_content'),
            '',
            contentWidget: EditableDialogWidget(
              // controller: inquiryDialogTEC,
              ////////////////////////////////
              ////////////////////////////////
              ////////////////////////////////
              controller: TextEditingController(),
              ////////////////////////////////
              ////////////////////////////////
              ////////////////////////////////
              ////////////////////////////////
              textDirection: TextDirection.ltr,
              contentText: translate('inquiry_sms_content_description'),
              hintText: translate('inquiry_sms_content'),
              maxLength: 500,
            ),
            onPressCancel: () {
              // inquiryDialogTEC.clear();
              Navigator.pop(kNavigatorKey.currentContext!);
            },
            onPressAccept: () async {
              await _processReceivedScenarioSMS(
                SmsMessage(
                  address: _mainProvider.selectedDevice.devicePhone,
                  // body: inquiryDialogTEC.text,
                ),
              );
              // inquiryDialogTEC.clear();
              Navigator.pop(kNavigatorKey.currentContext!);
            },
          );
        }
      },
    );
  }

  Future _processReceivedScenarioSMS(SmsMessage message) async {
    if (message.address == null ||
        !message.address!.contains(
          _mainProvider.selectedDevice.devicePhone.substring(1),
        ) ||
        message.body == null) {
      return;
    }
    String messageBody =
        message.body!.substring((message.body?.length ?? 60) - 60);

    // List<List<bool>> remotesState2 = scenario;
    List<List<bool>> remotesState2 = [];

    for (int i = 0; i < 60; i + 6) {
      String tempSubString = messageBody.substring(
        i,
        i + 7,
      );

      // for (int i = 0; i < 10; i++) {
      if (tempSubString[0] != '@') {
        scenarios[i ~/ 6] = [
          deviceStatusString(tempSubString[1]),
          inputTypeString(actionSelectString(tempSubString[2])),
          inputSelectString(tempSubString[2]),
          actionTypeString(actionSelectString(tempSubString[3])),
          actionSelectString(tempSubString[3]),
          kScenarioName,
        ];

        scenariosText.add(
            '$kScenarioName: اگر دستگاه ${scenarios[i ~/ 6][0]} باشد و ${scenarios[i ~/ 6][2]} شود، ${scenarios[i ~/ 6][4]} می شود.');
        notifyListeners();
      }

      await _mainProvider.updateDevice(
        _mainProvider.selectedDevice.copyWith(
          deviceStatus1: scenarios[i ~/ 6][0],
          inputType1: scenarios[i ~/ 6][1],
          inputSelect1: scenarios[i ~/ 6][2],
          actionType1: scenarios[i ~/ 6][3],
          actionSelect1: scenarios[i ~/ 6][4],
          scenarioName1: scenarios[i ~/ 6][5],
          deviceStatus2: scenarios[i ~/ 6][0],
          inputType2: scenarios[i ~/ 6][1],
          inputSelect2: scenarios[i ~/ 6][2],
          actionType2: scenarios[i ~/ 6][3],
          actionSelect2: scenarios[i ~/ 6][4],
          scenarioName2: scenarios[i ~/ 6][5],
          deviceStatus3: scenarios[i ~/ 6][0],
          inputType3: scenarios[i ~/ 6][1],
          inputSelect3: scenarios[i ~/ 6][2],
          actionType3: scenarios[i ~/ 6][3],
          actionSelect3: scenarios[i ~/ 6][4],
          scenarioName3: scenarios[i ~/ 6][5],
          deviceStatus4: scenarios[i ~/ 6][0],
          inputType4: scenarios[i ~/ 6][1],
          inputSelect4: scenarios[i ~/ 6][2],
          actionType4: scenarios[i ~/ 6][3],
          actionSelect4: scenarios[i ~/ 6][4],
          scenarioName4: scenarios[i ~/ 6][5],
          deviceStatus5: scenarios[i ~/ 6][0],
          inputType5: scenarios[i ~/ 6][1],
          inputSelect5: scenarios[i ~/ 6][2],
          actionType5: scenarios[i ~/ 6][3],
          actionSelect5: scenarios[i ~/ 6][4],
          scenarioName5: scenarios[i ~/ 6][5],
          deviceStatus6: scenarios[i ~/ 6][0],
          inputType6: scenarios[i ~/ 6][1],
          inputSelect6: scenarios[i ~/ 6][2],
          actionType6: scenarios[i ~/ 6][3],
          actionSelect6: scenarios[i ~/ 6][4],
          scenarioName6: scenarios[i ~/ 6][5],
          deviceStatus7: scenarios[i ~/ 6][0],
          inputType7: scenarios[i ~/ 6][1],
          inputSelect7: scenarios[i ~/ 6][2],
          actionType7: scenarios[i ~/ 6][3],
          actionSelect7: scenarios[i ~/ 6][4],
          scenarioName7: scenarios[i ~/ 6][5],
          deviceStatus8: scenarios[i ~/ 6][0],
          inputType8: scenarios[i ~/ 6][1],
          inputSelect8: scenarios[i ~/ 6][2],
          actionType8: scenarios[i ~/ 6][3],
          actionSelect8: scenarios[i ~/ 6][4],
          scenarioName8: scenarios[i ~/ 6][5],
          deviceStatus9: scenarios[i ~/ 6][0],
          inputType9: scenarios[i ~/ 6][1],
          inputSelect9: scenarios[i ~/ 6][2],
          actionType9: scenarios[i ~/ 6][3],
          actionSelect9: scenarios[i ~/ 6][4],
          scenarioName9: scenarios[i ~/ 6][5],
          deviceStatus10: scenarios[i ~/ 6][0],
          inputType10: scenarios[i ~/ 6][1],
          inputSelect10: scenarios[i ~/ 6][2],
          actionType10: scenarios[i ~/ 6][3],
          actionSelect10: scenarios[i ~/ 6][4],
          scenarioName10: scenarios[i ~/ 6][5],
        ),
      );
      rootScaffoldMessengerKey.currentState!.hideCurrentSnackBar();
    }
  }

  /// Add a new scenario text to the list
  void addScenarioText(String text) {
    if (!scenariosText.contains(text)) {
      scenariosText.add(text);
      notifyListeners();
    }
  }

  // نوع و شماره دستگاه
  String? deviceNumber;
  String? deviceType;

  // فرمت SMS - متغیرهای جدید برای نگهداری فرمت SMS و مد عملکرد
  String _smsFormat = '';
  String _modeFormat = '';

  // متد برای تنظیم فرمت SMS
  void setSMSFormat(String format) {
    _smsFormat = format;
    notifyListeners();
  }

  // متد برای تنظیم فرمت مد عملکرد
  void setModeFormat(String format) {
    _modeFormat = format;
    notifyListeners();
  }

  void clearScenariosText() {
    scenariosText.clear();
    notifyListeners();
  }

  // void updateScenarioOne(dynamic scenarioMap) {
  //   if (scenarioMap is Map<String, dynamic>) {
  //     // Convert Map to List<String?>
  //     List<String?> newScenario = [];
  //     scenarioMap.forEach((key, value) {
  //       if (value is String) {
  //         newScenario.add(value);
  //       } else {
  //         newScenario.add(value?.toString());
  //       }
  //     });
  //     scenario = newScenario;
  //     notifyListeners();
  //   }
  // }

  // ارسال مستقیم SMS بدون استفاده از registerScenario
  Future<bool> sendDirectSMS(String phoneNumber, String message, bool startSMSCooldown) async {
    try {
      log('درخواست ارسال پیامک به شماره $phoneNumber با متن: $message');
      
      if (phoneNumber.isEmpty || message.isEmpty) {
        log('شماره تلفن یا متن پیام خالی است');
        return false;
      }
      
      log('Sending SMS to $phoneNumber: $message');
      
      // افزودن گزینه‌های بیشتر برای اطمینان از ارسال صحیح پیام
      final sendSMSResult = await injector<SMSRepository>().doSendSMS(
        message: message,
        phoneNumber: phoneNumber,
        smsCoolDownFinished: _mainProvider.smsCooldownFinished,
        isManager: _mainProvider.selectedDevice.isManager,
        showConfirmDialog: false, // عدم نمایش دیالوگ تایید برای ارسال خودکار
      );
      
      return sendSMSResult.fold(
        (l) {
          log('SMS sending failed: $l');
          toastGenerator('خطا در ارسال پیامک: $l');
          return false;
        },
        (r) {
          log('SMS sent successfully, starting cooldown');
          if(startSMSCooldown) _mainProvider.startSMSCooldown();
          return true;
        },
      );
    } catch (e) {
      log('Error in sendDirectSMS: $e');
      toastGenerator('خطا در ارسال پیامک: $e');
      return false;
    }
  }

  // Override original registerScenario with a simplified version that uses our new methods
  // Future registerScenario2() async {
  //   try {
  //     // اگر شماره تلفن دستگاه موجود است
  //     final String devicePhone = _mainProvider.selectedDevice.devicePhone;
  //     if (devicePhone.isNotEmpty) {
  //       // این قسمت همان متد اصلی است که به دستگاه پیام می‌فرستد
  //       // اگر فرمت SMS تنظیم شده باشد، از آن استفاده می‌کنیم
  //       if (_smsFormat.isNotEmpty) {
  //         await sendDirectSMS(devicePhone, _smsFormat, false);
  //
  //         // اگر فرمت مد عملکرد هم تنظیم شده باشد، آن را هم ارسال می‌کنیم
  //         if (_modeFormat.isNotEmpty) {
  //           await sendDirectSMS(devicePhone, _modeFormat, true);
  //         }
  //       } else {
  //         log('SMS format is not set');
  //       }
  //     } else {
  //       log('Device number is not available');
  //     }
  //   } catch (e) {
  //     log('Error in registerScenario2: $e');
  //   }
  // }
}
