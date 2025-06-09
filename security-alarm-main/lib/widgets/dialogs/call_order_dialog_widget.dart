import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import '../../core/utils/helper.dart';
import '../elevated_button_widget.dart';
import '../outlined_button_widget.dart';

class CallOrderDialogWidget extends StatelessWidget {
  final int selectedItemIndex;
  final List<Function()> onTapButtonList;
  CallOrderDialogWidget({
    Key? key,
    this.selectedItemIndex = -1,
    required this.onTapButtonList,
  }) : super(key: key);

  final List<String> _callOrderTitles = [
    translate('sms_call_line'),
    translate('call_sms_line'),
    translate('call_line_sms'),
    translate('line_call_sms'),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          translate('choose_call_order'),
          style: styleGenerator(fontSize: 14),
        ),
        SizedBox(height: 20.h),
        _buildButton(0),
        SizedBox(height: 10.h),
        _buildButton(1),
        SizedBox(height: 10.h),
        _buildButton(2),
        SizedBox(height: 10.h),
        _buildButton(3),
        SizedBox(height: 10.h),
      ],
    );
  }

  Widget _buildButton(int index) {
    if (selectedItemIndex == index) {
      return ElevatedButtonWidget(
        btnText: _callOrderTitles[index],
        width: double.infinity,
        onPressBtn: onTapButtonList[index],
      );
    }
    return OutlinedButtonWidget(
      btnText: _callOrderTitles[index],
      width: double.infinity,
      onPressBtn: onTapButtonList[index],
    );
  }
}
