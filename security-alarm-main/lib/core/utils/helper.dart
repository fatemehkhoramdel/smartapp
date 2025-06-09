import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:ndialog/ndialog.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:supercharged/supercharged.dart';

import '../../widgets/dialogs/alert_dialog_widget.dart';
import '../constants/design_values.dart';
import '../constants/global_keys.dart';

TextStyle styleGenerator({
  double fontSize = 15,
  Color fontColor = Colors.black,
  FontWeight fontWeight = FontWeight.normal,
  String fontName = kDefaultFont,
  double? lineHeight,
  List<Shadow>? shadow,
  TextDecoration? decoration,
}) {
  return TextStyle(
    color: fontColor,
    fontFamily: fontName,
    fontWeight: fontWeight,
    height: lineHeight,
    fontSize: fontSize,
    shadows: shadow,
    decoration: decoration,
  );
}

Future<bool?> dialogGenerator(
  String title,
  String contentText, {
  Widget? contentWidget,
  String? confirmBtnText,
  Function()? onPressAccept,
  Function()? onPressCancel,
  bool showAccept = true,
  bool showCancel = true,
}) async {
  return showDialog<bool?>(
    context: kNavigatorKey.currentContext!,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialogWidget(
        title: title,
        contentText: contentText,
        contentWidget: contentWidget,
        confirmBtnText: confirmBtnText,
        onPressCancel: onPressCancel,
        onPressAccept: onPressAccept,
        showAccept: showAccept,
        showCancel: showCancel,
      );
    },
  );
}

Future<bool> askForConfirmation() async {
  bool? confirmationResult = await dialogGenerator(
    translate('send_code'),
    translate('are_you_sure'),
    onPressAccept: () {
      Navigator.pop(kNavigatorKey.currentContext!, true);
    },
    onPressCancel: () {
      Navigator.pop(kNavigatorKey.currentContext!, false);
    },
  );
  if (confirmationResult == null) return false;
  return confirmationResult;
}

void toastGenerator(
  String msg, {
  Color? bgColor,
  Toast length = Toast.LENGTH_LONG,
}) {
  if (msg.isNotEmpty) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: length,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 3,
      backgroundColor: bgColor ??
          Theme.of(kNavigatorKey.currentContext!).colorScheme.secondary,
      textColor: Colors.white,
      fontSize: 17.0,
    );
  }
}

Future<bool> requestForSMSPermission() async {
  if (!await Permission.sms.isDenied && !await Permission.sms.isGranted) {
    await showGoToSettingsDialog();
    return false;
  }
  bool isGranted = await Permission.sms.request().isGranted;
  if (!isGranted) return false;
  return true;
}

Future<void> showGoToSettingsDialog() async {
  await dialogGenerator(
    translate('allow_access'),
    translate('denied_access'),
    confirmBtnText: translate('goto_setting'),
    onPressAccept: () {
      Navigator.pop(kNavigatorKey.currentContext!);
      openAppSettings();
    },
  );
}

//TODO: move this with hide method to a separate class in utils
late CustomProgressDialog progressDialog;

void showLoadingDialog({
  String? msg,
}) {
  progressDialog = CustomProgressDialog(
    kNavigatorKey.currentContext!,
    blur: 10,
    dismissable: false,
    loadingWidget: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        LoadingBouncingGrid.circle(
          backgroundColor: Colors.white,
          size: 60,
        ),
        SizedBox(height: 20.h),
        Text(
          msg ?? translate('loading'),
          style: styleGenerator(fontColor: Colors.white),
        )
      ],
    ),
  );
  progressDialog.show();
}

String smsCodeGenerator(String devicePass, String lastPartOfCode) => lastPartOfCode;

void snackbarGenerator(
  String? message,
) {
  rootScaffoldMessengerKey.currentState!.showSnackBar(
    SnackBar(
      content: Row(
        children: [
          const CircularProgressIndicator(),
          SizedBox(width: 16.w),
          Text(
            message ?? translate('waiting_for_inquiry'),
            style: styleGenerator(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              fontColor: Colors.white,
            ),
          ),
        ],
      ),
      backgroundColor: Colors.orangeAccent,
      elevation: 6.0,
      duration: 10.minutes,
      action: SnackBarAction(
        label: translate('close'),
        textColor: Colors.black,
        onPressed: () {
          rootScaffoldMessengerKey.currentState!.hideCurrentSnackBar();
        },
      ),
    ),
  );
}

Future hideLoadingDialog() async => Future.delayed(300.milliseconds).then(
      (value) => progressDialog.dismiss(),
    );

bool isNumeric(String str) => double.tryParse(str) != null;

Future<bool> hasSMSPermission() async => Permission.sms.isGranted;

void closeSoftKeyboard() => FocusScope.of(
      kNavigatorKey.currentContext!,
    ).unfocus();
