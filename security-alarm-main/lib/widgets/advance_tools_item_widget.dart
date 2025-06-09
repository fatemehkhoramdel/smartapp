import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../core/constants/design_values.dart';

import '../core/utils/helper.dart';
import 'elevated_button_widget.dart';
import 'outlined_button_widget.dart';

class AdvanceToolsItemWidget extends StatelessWidget {
  final String title;
  final int selectedButtonIndex;
  final List<String> buttonTextList;
  final List<Function()> onTapBtnList;
  const AdvanceToolsItemWidget({
    Key? key,
    required this.title,
    this.selectedButtonIndex = -1,
    required this.buttonTextList,
    required this.onTapBtnList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final btnWidth = buttonTextList.length == 2
        ? 0.27.sw
        : buttonTextList.length == 3
            ? 0.22.sw
            : 0.20.sw;
    return Material(
      color: Colors.white,
      elevation: 2,
      borderRadius: BorderRadius.circular(kBorderRadius.r),
      child: Container(
        width: 1.0.sw,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTitle(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildButton(btnWidth, 0),
                if (buttonTextList.length >= 2) _buildButton(btnWidth, 1),
                if (buttonTextList.length >= 3) _buildButton(btnWidth, 2),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      title,
      overflow: TextOverflow.fade,
      textAlign: TextAlign.end,
      style: styleGenerator(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        fontColor: Colors.black87,
      ),
    );
  }

  Widget _buildButton(double width, int index) {
    if (selectedButtonIndex == index) {
      return ElevatedButtonWidget(
        btnText: buttonTextList[index],
        height: 35.h,
        width: width,
        onPressBtn: onTapBtnList[index],
      );
    } else {
      return OutlinedButtonWidget(
        btnText: buttonTextList[index],
        height: 35.h,
        width: width,
        onPressBtn: onTapBtnList[index],
      );
    }
  }
}
