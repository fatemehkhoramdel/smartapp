import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:supercharged/supercharged.dart';

import '../../../core/utils/enums.dart';
import '../../../core/utils/helper.dart';
import '../../../models/device.dart';
import '../../../providers/charge_device_provider.dart';
import '../../../providers/main_provider.dart';
import '../../../widgets/elevated_button_widget.dart';
import '../../../widgets/setting_item_widget.dart';

class ChargeDeviceViewMobile extends HookWidget {
  late TextEditingController _chargeCodeTEC;
  late TextEditingController _inquiryDialogTEC;
  late ChargeDeviceProvider _chargeDeviceProvider;
  late String _operator;
  late Device _device;

  ChargeDeviceViewMobile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _chargeDeviceProvider = context.read<ChargeDeviceProvider>();
    _device = context.select<MainProvider, Device>(
      (MainProvider m) => m.selectedDevice,
    );
    _operator = _device.operator;
    _chargeCodeTEC = useTextEditingController();
    _inquiryDialogTEC = useTextEditingController();
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Column(
        children: [
          _buildGetChargeCode(),
          SizedBox(height: 25.h),
          _buildDoChargeButton(context),
          Divider(height: 60.h, thickness: 1, color: Colors.grey.shade400),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                translate('last_charge_colon'),
                style: styleGenerator(fontSize: 14),
              ),
              _buildChargeAmount(),
            ],
          ),
          SizedBox(height: 35.h),
          _buildInquiryChargeButton(context),
        ],
      ),
    );
  }

  Widget _buildGetChargeCode() {
    return SettingItemWidget(
      textFieldController: _chargeCodeTEC,
      settingType: SettingItemType.edit,
      textFieldTextDirection: TextDirection.ltr,
      descriptionText: _operator == translate('irancell')
          ? translate('irancell')
          : _operator == translate('mci')
              ? translate('mci')
              : _operator == translate('rightel')
                  ? translate('rightel')
                  : '',
      itemHeight: 80.h,
      hintText: translate('charge_code'),
      maxLength: 35,
      hasFloatingHint: true,
      keyboardType: TextInputType.phone,
    );
  }

  Widget _buildDoChargeButton(BuildContext context) {
    return ElevatedButtonWidget(
      btnText: translate('do_charge'),
      btnIcon: Icons.attach_money,
      onPressBtn: () async => _chargeDeviceProvider.performChargeDevice(
        _chargeCodeTEC.text,
      ),
    );
  }

  Widget _buildChargeAmount() {
    return Shimmer.fromColors(
      baseColor: Colors.teal,
      highlightColor: Colors.tealAccent,
      period: 1500.milliseconds,
      child: Text(
        "${_device.simChargeAmount} ${translate('toman')} ",
        style: styleGenerator(
          fontWeight: FontWeight.bold,
          fontColor: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildInquiryChargeButton(BuildContext context) {
    return ElevatedButtonWidget(
      btnText: translate('inquiry_charge'),
      btnIcon: Icons.info,
      onPressBtn: () async =>
          _chargeDeviceProvider.getChargeAmountFromDevice(_inquiryDialogTEC),
    );
  }
}
