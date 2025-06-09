import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:restart_app/restart_app.dart';

import '../core/constants/global_keys.dart';
import '../core/utils/helper.dart';
import '../core/utils/validators.dart';
import '../models/app_settings.dart';
import '../models/device.dart';
import '../models/relay.dart';
import 'main_provider.dart';

class AppSettingsProvider extends ChangeNotifier {
  late MainProvider _mainProvider;

  AppSettingsProvider(MainProvider? mainProvider) {
    if (mainProvider != null) {
      _mainProvider = mainProvider;
    }
  }

  Future _updateDevice(Device newDevice) async {
    showLoadingDialog();
    await _mainProvider.updateDevice(newDevice);
    await hideLoadingDialog();
  }

  Future updateShowPassPage(bool value) async {
    showLoadingDialog();
    await _mainProvider.updateAppSettings(
      _mainProvider.appSettings.copyWith(showPassPage: value),
    );
    await hideLoadingDialog();
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
    } else if (oldPass != _mainProvider.appSettings.appPassword) {
      return translate('old_pass_wrong');
    } else if (newPass == _mainProvider.appSettings.appPassword) {
      return translate('new_pass_same_as_old');
    }
    return null;
  }

  Future updateAppPassword(
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
    showLoadingDialog();
    await _mainProvider.updateAppSettings(
      _mainProvider.appSettings.copyWith(appPassword: newPass),
    );
    await hideLoadingDialog();
  }

  String? validateRelayTriggerTime(
    String triggerHour,
    String triggerMinute,
    String triggerSeconds,
  ) {
    if (triggerHour.isEmpty ||
        triggerMinute.isEmpty ||
        triggerSeconds.isEmpty) {
      return translate('insert_time');
    } else if (triggerHour.length != 2 ||
        triggerMinute.length != 2 ||
        triggerSeconds.length != 2) {
      return translate('time_length_desc');
    } else if (int.parse(triggerHour) > 23) {
      return translate('hour_limit_desc');
    } else if (int.parse(triggerMinute) > 59 ||
        int.parse(triggerSeconds) > 59) {
      return translate('minute_seconds_limit_desc');
    }
    return null;
  }

  Future updateRelayTriggerTime(
    int index,
    String triggerHour,
    String triggerMinute,
    String triggerSeconds,
  ) async {
    String? validation = validateRelayTriggerTime(
      triggerHour,
      triggerMinute,
      triggerSeconds,
    );
    if (validation != null) {
      toastGenerator(validation);
      return;
    }
    Navigator.pop(kNavigatorKey.currentContext!);
    Relay tempRelay = _mainProvider.relays[index].copyWith(
      relayTriggerTime: triggerHour + triggerMinute + triggerSeconds,
    );
    await _mainProvider.updateRelay(tempRelay);
    toastGenerator(translate('successfully_recorded'));
  }

  String? validateCapsulRange(String capsulMax, String capsulMin) {
    if (capsulMax.isEmpty || capsulMin.isEmpty) {
      return translate('set_range_desc');
    } else if (int.parse(capsulMax) <= int.parse(capsulMin)) {
      return translate('min_bigger_than_max');
    } else if (int.parse(capsulMin) < 1000) {
      return translate('min_range_desc');
    }
    return null;
  }

  Future updateCapsulRange(String capsulMax, String capsulMin) async {
    String? validation = validateCapsulRange(capsulMax, capsulMin);
    if (validation != null) {
      toastGenerator(validation);
      return;
    }
    Navigator.pop(kNavigatorKey.currentContext!);
    Device tempDevice = _mainProvider.selectedDevice.copyWith(
      capsulMax: int.parse(capsulMax),
      capsulMin: int.parse(capsulMin),
    );
    await _updateDevice(tempDevice);
    toastGenerator(translate('successfully_recorded'));
  }

  Future updateRelaysName(String relay1, String relay2) async {
    String? validationRelay1 = Validators.isTextEmpty(relay1);
    String? validationRelay2 = Validators.isTextEmpty(relay2);
    if (validationRelay1 != null && validationRelay2 != null) {
      toastGenerator(translate('insert_something_desc'));
      return;
    }
    Navigator.pop(kNavigatorKey.currentContext!);
    String tRelay1Name =
        relay1.isNotEmpty ? relay1 : _mainProvider.relays[0].relayName;
    String tRelay2Name =
        relay2.isNotEmpty ? relay2 : _mainProvider.relays[1].relayName;
    late Relay tempRelay;
    for (var i = 0; i < 2; i++) {
      tempRelay = _mainProvider.relays[i].copyWith(
        relayName: i == 0 ? tRelay1Name : tRelay2Name,
      );
      await _mainProvider.updateRelay(tempRelay);
    }
    toastGenerator(translate('successfully_recorded'));
    Navigator.pop(kNavigatorKey.currentContext!);
  }

  Future updateHomeItems(Device newDevice) async {
    showLoadingDialog();
    await _mainProvider.updateDevice(newDevice);
    await hideLoadingDialog();
  }

  Future updateAppTheme(int selectedThemePalette) async {
    Navigator.pop(kNavigatorKey.currentContext!);
    showLoadingDialog();
    AppSettings tempAppSettings = _mainProvider.appSettings.copyWith(
      selectedThemePalette: selectedThemePalette,
    );
    await _mainProvider.updateAppSettings(tempAppSettings);
    await hideLoadingDialog();
    if (Platform.isAndroid) {
      Restart.restartApp();
    } else {
      toastGenerator(translate('apply_next_start'));
    }
  }
}
