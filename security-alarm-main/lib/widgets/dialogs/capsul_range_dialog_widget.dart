import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';

import '../../core/utils/helper.dart';
import '../custom_text_field_widget.dart';

class CapsulRangeDialogWidget extends StatelessWidget {
  final List<TextEditingController> controllerList;
  final List<String> hintTextList;
  const CapsulRangeDialogWidget({
    Key? key,
    required this.controllerList,
    required this.hintTextList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            translate('capsul_range_desc'),
            style: styleGenerator(fontSize: 14),
          ),
          SizedBox(height: 20.h),
          CustomTextFieldWidget(
            controller: controllerList[0],
            hintStyle: styleGenerator(fontSize: 14, fontColor: Colors.black45),
            inputStyle: styleGenerator(fontSize: 14, fontColor: Colors.black45),
            onSubmit: (_) {},
            hintText: hintTextList[0],
            floatingText: hintTextList[0],
            maxLength: 6,
            hasFloatingPlaceholder: true,
            inputBorder: UnderlineInputBorder(
              borderSide: BorderSide(width: 1.w, color: Colors.black45),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(width: 2.w, color: Colors.black45),
            ),
          ),
          CustomTextFieldWidget(
            controller: controllerList[1],
            hintStyle: styleGenerator(fontSize: 14, fontColor: Colors.black45),
            inputStyle: styleGenerator(fontSize: 14, fontColor: Colors.black45),
            onSubmit: (_) {},
            hintText: hintTextList[1],
            floatingText: hintTextList[1],
            maxLength: 6,
            hasFloatingPlaceholder: true,
            inputBorder: UnderlineInputBorder(
              borderSide: BorderSide(width: 1.w, color: Colors.black45),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(width: 2.w, color: Colors.black45),
            ),
          ),
        ],
      ),
    );
  }
}
