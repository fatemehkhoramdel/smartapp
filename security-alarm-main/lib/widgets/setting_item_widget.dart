import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fswitch_nullsafety/fswitch_nullsafety.dart';
import '../core/constants/design_values.dart';

import '../core/utils/enums.dart';
import '../core/utils/helper.dart';
import 'custom_text_field_widget.dart';

//TODO: Move if statements in this widget to separate widget
class SettingItemWidget extends StatelessWidget {
  final SettingItemType settingType;
  final double? itemHeight;
  final double? borderRadius;
  final double? itemPadding;
  final String itemTitle;
  final String hintText;
  final String descriptionText;
  final Icon? itemIcon;
  final bool hasFloatingHint;
  final bool switchOpen;
  final int maxLength;
  final TextInputType keyboardType;
  final TextEditingController? textFieldController;
  final FocusNode? textFieldFocusNode;
  final Function(String)? textFieldOnChange;
  final TextDirection textFieldTextDirection;
  final Function()? onItemClick;
  final Function(bool)? onSwitchChange;

  const SettingItemWidget({
    Key? key,
    required this.settingType,
    this.itemHeight,
    this.borderRadius,
    this.itemTitle = '',
    this.descriptionText = '',
    this.onSwitchChange,
    this.itemPadding,
    this.onItemClick,
    this.itemIcon,
    this.textFieldController,
    this.hintText = '',
    this.hasFloatingHint = false,
    this.switchOpen = false,
    this.keyboardType = TextInputType.name,
    this.maxLength = 20,
    this.textFieldTextDirection = TextDirection.rtl,
    this.textFieldFocusNode,
    this.textFieldOnChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 2,
      borderRadius: BorderRadius.circular(kBorderRadius.r),
      child: InkWell(
        borderRadius: BorderRadius.circular(kBorderRadius.r),
        onTap: onItemClick,
        child: Container(
          width: 1.0.sw,
          height: itemHeight ?? 50.h,
          padding: EdgeInsets.symmetric(horizontal: itemPadding?.w ?? 16.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _buildTitle(),
              if (settingType == SettingItemType.normal ||
                  settingType == SettingItemType.edit)
                _buildDescriptionText()
              else
                settingType == SettingItemType.toggle ||
                        settingType == SettingItemType.editCheck
                    ? _buildToggleSwitch()
                    : settingType == SettingItemType.icon
                        ? itemIcon ?? Container()
                        : Container(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildToggleSwitch() {
    return SizedBox(
      child: FSwitch(
        open: switchOpen,
        openColor: Colors.green,
        onChanged: onSwitchChange ?? (v) {},
        height: 20.h,
        width: 47.w,
        closeChild: const Icon(
          Icons.close,
          size: 16,
          color: Colors.white,
        ),
        openChild: const Icon(
          Icons.check,
          size: 16,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildDescriptionText() {
    return Container(
      width: 0.3.sw,
      alignment: Alignment.centerLeft,
      child: Text(
        descriptionText,
        style: styleGenerator(fontSize: 14),
      ),
    );
  }

  Widget _buildTitle() {
    return SizedBox(
      width: 0.5.sw,
      child: settingType == SettingItemType.editCheck ||
              settingType == SettingItemType.edit
          ? CustomTextFieldWidget(
              controller: textFieldController ?? TextEditingController(),
              focusNode: textFieldFocusNode ?? FocusNode(),
              hintStyle: styleGenerator(
                fontSize: 14,
                fontColor: Colors.black54,
              ),
              inputStyle: styleGenerator(
                fontSize: 14,
                fontColor: Colors.black87,
              ),
              hintText: hintText,
              floatingText: hintText,
              maxLength: maxLength,
              textDirection: textFieldTextDirection,
              hasFloatingPlaceholder: hasFloatingHint,
              inputBorder: UnderlineInputBorder(
                borderSide: BorderSide(width: 1.w, color: Colors.black45),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(width: 1.w, color: Colors.black87),
              ),
              keyboardType: keyboardType,
              onChange: textFieldOnChange,
            )
          : Text(
              itemTitle,
              style: styleGenerator(
                fontSize: 14,
                fontColor: Colors.black87,
              ),
            ),
    );
  }
}
