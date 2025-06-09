import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/utils/helper.dart';
import '../custom_text_field_widget.dart';

class EditableDialogWidget extends StatelessWidget {
  final TextEditingController controller;
  final String contentText;
  final String hintText;
  final int maxLength;
  final TextDirection? textDirection;
  const EditableDialogWidget({
    Key? key,
    required this.controller,
    required this.contentText,
    required this.hintText,
    this.maxLength = 30,
    this.textDirection,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          contentText,
          style: styleGenerator(fontSize: 14),
        ),
        SizedBox(height: 10.h),
        CustomTextFieldWidget(
          controller: controller,
          textDirection: textDirection,
          hintStyle: styleGenerator(
            fontSize: 14,
            fontColor: Colors.black45,
          ),
          inputStyle: styleGenerator(
            fontSize: 14,
            fontColor: Colors.black45,
          ),
          onSubmit: (_) {},
          hintText: hintText,
          floatingText: hintText,
          maxLength: maxLength,
          hasFloatingPlaceholder: true,
          inputBorder: UnderlineInputBorder(
            borderSide: BorderSide(width: 1.w, color: Colors.black45),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(width: 2.w, color: Colors.black45),
          ),
        ),
      ],
    );
  }
}
