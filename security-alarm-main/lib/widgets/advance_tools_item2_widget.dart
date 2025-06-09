import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import '../core/constants/design_values.dart';

import '../core/utils/helper.dart';
import 'outlined_button_widget.dart';

class AdvanceToolsItem2Widget extends StatelessWidget {
  final String title;
  final String subTitle;
  final Function() onTapBtn;
  const AdvanceToolsItem2Widget({
    Key? key,
    required this.title,
    required this.subTitle,
    required this.onTapBtn,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 2,
      borderRadius: BorderRadius.circular(kBorderRadius.r),
      child: Container(
        width: 1.0.sw,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [_buildTitle(), _buildSubtitle()],
            ),
            _buildButton(),
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

  Widget _buildSubtitle() {
    return SizedBox(
      width: 0.5.sw,
      child: Text(
        translate('current_amount') + subTitle,
        maxLines: 3,
        style: styleGenerator(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          fontColor: Colors.grey,
        ),
      ),
    );
  }

  Widget _buildButton() {
    return OutlinedButtonWidget(
      btnText: translate('edit'),
      height: 35.h,
      width: 0.28.sw,
      onPressBtn: onTapBtn,
    );
  }
}
