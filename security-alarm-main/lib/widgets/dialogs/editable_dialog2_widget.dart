import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/utils/helper.dart';

import '../custom_text_field_widget.dart';

class EditableDialog2Widget extends StatelessWidget {
  final List<TextEditingController> controllerList;
  final List<String> hintTextList;
  final List<Widget>? iconList;
  final int maxLength;
  final bool isObsecure;
  const EditableDialog2Widget({
    Key? key,
    required this.controllerList,
    required this.hintTextList,
    this.iconList,
    required this.maxLength,
    this.isObsecure = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 20.h,),
          CustomTextFieldWidget(
            controller: controllerList[0],
            hintStyle: styleGenerator(fontSize: 14, fontColor: Theme.of(context).colorScheme.onSurface),
            inputStyle: styleGenerator(fontSize: 14, fontColor: Theme.of(context).colorScheme.onSurface),
            onSubmit: (_) {},
            hintText: hintTextList[0],
            floatingText: hintTextList[0],
            maxLength: maxLength,
            hasFloatingPlaceholder: true,
            inputBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1.w, color: Theme.of(context).colorScheme.primary)),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1.w, color: Theme.of(context).colorScheme.primary)),
            obscureText: isObsecure,
            icon: iconList?[0],
          ),
          CustomTextFieldWidget(
            controller: controllerList[1],
            hintStyle: styleGenerator(fontSize: 14, fontColor: Theme.of(context).colorScheme.onSurface),
            inputStyle: styleGenerator(fontSize: 14, fontColor: Theme.of(context).colorScheme.onSurface),
            onSubmit: (_) {},
            hintText: hintTextList[1],
            floatingText: hintTextList[1],
            maxLength: maxLength,
            hasFloatingPlaceholder: true,
            inputBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 1.w, color: Theme.of(context).colorScheme.primary)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 1.w, color: Theme.of(context).colorScheme.primary)),
            obscureText: isObsecure,
            icon: iconList?[1],
          ),
          if(controllerList.length > 2)
          CustomTextFieldWidget(
            controller: controllerList[2],
            hintStyle: styleGenerator(fontSize: 14, fontColor: Theme.of(context).colorScheme.onSurface),
            inputStyle: styleGenerator(fontSize: 14, fontColor: Theme.of(context).colorScheme.onSurface),
            onSubmit: (_) {},
            hintText: hintTextList[2],
            floatingText: hintTextList[2],
            maxLength: maxLength,
            hasFloatingPlaceholder: true,
            inputBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 1.w, color: Theme.of(context).colorScheme.primary)),
            focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 1.w, color: Theme.of(context).colorScheme.primary)),
            obscureText: isObsecure,
            icon: iconList?[2],
          ),
        ],
      ),
    );
  }
}
