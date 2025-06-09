import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/utils/helper.dart';
import '../custom_text_field_widget.dart';
import '../elevated_button_widget.dart';

class SpyDialogWidget extends StatelessWidget {
  final TextEditingController controller;
  final String devicePhone;
  const SpyDialogWidget({
    Key? key,
    required this.controller,
    required this.devicePhone,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          translate('spy_dialog_desc'),
          style: styleGenerator(fontSize: 14),
        ),
        SizedBox(height: 10.h),
        _buildTextField(),
        ElevatedButtonWidget(
          btnText: translate('instant_spy'),
          onPressBtn: () async => _onTapInstantSpy(context),
        ),
        SizedBox(height: 10.h),
      ],
    );
  }

  Widget _buildTextField() {
    return CustomTextFieldWidget(
      controller: controller,
      hintStyle: styleGenerator(
        fontSize: 14,
        fontColor: Colors.black45,
      ),
      inputStyle: styleGenerator(
        fontSize: 14,
        fontColor: Colors.black45,
      ),
      onSubmit: (_) {},
      hintText: translate('spy_volume'),
      floatingText: translate('spy_volume'),
      maxLength: 2,
      hasFloatingPlaceholder: true,
      inputBorder: UnderlineInputBorder(
        borderSide: BorderSide(width: 1.w, color: Colors.black45),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(width: 2.w, color: Colors.black45),
      ),
      keyboardType: TextInputType.number,
    );
  }

  Future _onTapInstantSpy(BuildContext context) async {
    Navigator.pop(context);
    try {
      await launchUrl(Uri.parse('tel:$devicePhone'));
    } on Exception {
      toastGenerator(translate('not_possible_desc'));
    }
  }
}
