import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/design_values.dart';
import '../../../core/utils/extensions.dart';
import '../../../core/utils/helper.dart';
import '../../../models/device.dart';
import '../../../providers/main_provider.dart';
import '../../../providers/zones_provider.dart';
import '../../../widgets/custom_text_field_widget.dart';
import '../../../widgets/elevated_button_widget.dart';
import '../../../widgets/outlined_button_widget.dart';

class ZonesViewMobile extends HookWidget {
  late Device _device;
  late MainProvider _mainProvider;
  late ZonesProvider _zonesProvider;
  late List<String> _zonesDropDownList;
  late List<TextEditingController> _zonesNameTECList;
  late TextEditingController _inquiryDialogTEC;

  ZonesViewMobile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _mainProvider = context.watch<MainProvider>();
    _zonesProvider = context.read<ZonesProvider>();
    _device = _mainProvider.selectedDevice;
    _zonesNameTECList = [
      useTextEditingController(text: _device.zone1Name),
      useTextEditingController(text: _device.zone2Name),
      useTextEditingController(text: _device.zone3Name),
      useTextEditingController(text: _device.zone4Name),
      useTextEditingController(text: _device.zone5Name),
    ];
    _inquiryDialogTEC = useTextEditingController();
    _zonesDropDownList = _zonesProvider.zonesConditions;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      width: 1.0.sw,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildZoneItem(0),
          _buildZoneItem(1),
          _buildZoneItem(2),
          _buildZoneItem(3),
          _buildZoneItem(4),
          SizedBox(height: 50.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildSubmitButton(context),
              _buildInquiryButton(),
            ],
          ),
          SizedBox(height: 40.h),
        ],
      ),
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return ElevatedButtonWidget(
      btnText: translate('save_zones'),
      btnIcon: Icons.save,
      onPressBtn: _onTapSubmit,
    );
  }

  Widget _buildInquiryButton() {
    return OutlinedButtonWidget(
      btnText: translate('inquiry_zones'),
      btnIcon: Icons.info,
      onPressBtn: () async =>
          _zonesProvider.getZonesFromDevice(_inquiryDialogTEC),
    );
  }

  //TODO: Move this method to a separate Widget
  Widget _buildZoneItem(int zoneIndex) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Material(
        color: Colors.white,
        elevation: 2,
        borderRadius: BorderRadius.circular(kBorderRadius.r),
        child: Container(
          width: 1.0.sw,
          height: 140.h,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: 0.5.sw,
                child: CustomTextFieldWidget(
                  controller: _zonesNameTECList[zoneIndex],
                  hintStyle: styleGenerator(fontSize: 14),
                  inputStyle: styleGenerator(fontSize: 14),
                  hintText: translate('zone_name'),
                  floatingText: translate('zone_name'),
                  maxLength: 40,
                  textAlign: TextAlign.start,
                  hasFloatingPlaceholder: true,
                  inputBorder: UnderlineInputBorder(
                    borderSide: BorderSide(width: 1.w),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(width: 2.w),
                  ),
                  keyboardType: TextInputType.name,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 0.5.sw,
                    child: DropdownButton<String>(
                      value: _zonesDropDownList[zoneIndex],
                      icon: Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.grey.shade500,
                      ),
                      iconSize: 22.w,
                      isExpanded: true,
                      underline: Container(height: 1, color: Colors.black),
                      onChanged: (String? newValue) async =>
                          _zonesProvider.updateZoneCondition(
                        zoneIndex,
                        newValue,
                      ),
                      items: ZoneConditionExt.getZoneConditionsAsList()
                          .map<DropdownMenuItem<String>>(
                        (String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: styleGenerator(fontSize: 13),
                            ),
                          );
                        },
                      ).toList(),
                    ),
                  ),
                  ElevatedButtonWidget(
                    width: 90.w,
                    height: 30.h,
                    btnText: translate('remove_zone'),
                    onPressBtn: () async => _zonesProvider.removeZoneFromDevice(
                      zoneIndex,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onTapSubmit() {
    dialogGenerator(
      translate('save_zones'),
      translate('zone_save_desc'),
      onPressAccept: () async => _zonesProvider.updateZoneNames(
        _zonesNameTECList,
      ),
    );
  }
}
