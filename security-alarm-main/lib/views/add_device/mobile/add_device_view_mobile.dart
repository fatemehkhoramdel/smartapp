import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';

import '../../../core/utils/enums.dart';
import '../../../core/utils/extensions.dart';
import '../../../core/utils/helper.dart';
import '../../../providers/add_device_provider.dart';
import '../../../widgets/custom_text_field_widget.dart';
import '../../../widgets/elevated_button_widget.dart';
import '../../../widgets/operator_container_widget.dart';

// ignore: must_be_immutable
class AddDeviceViewMobile extends HookWidget {
  late AddDeviceProvider _addDeviceProvider;
  late TextEditingController _deviceNameTEC;
  late TextEditingController _devicePhoneTEC;
  late FocusNode _deviceNameFN;
  late FocusNode _devicePhoneFN;

  AddDeviceViewMobile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _addDeviceProvider = context.read<AddDeviceProvider>();
    _deviceNameTEC = useTextEditingController();
    _devicePhoneTEC = useTextEditingController();
    _deviceNameFN = useFocusNode();
    _devicePhoneFN = useFocusNode();
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      width: 1.0.sw,
      child: Column(
        children: [
          // Text(
          //   translate('device_model'),
          //   style: styleGenerator(
          //     fontWeight: FontWeight.w500,
          //     fontColor: Theme.of(context).colorScheme.secondary,
          //   ),
          // ),
          // SizedBox(height: 8.h),
          // SizedBox(
          //   width: 0.7.sw,
          //   child: DropdownButton<String>(
          //     value: context.select<AddDeviceProvider, String>(
          //       (AddDeviceProvider a) => a.deviceModelDropDownValue,
          //     ),
          //     icon: Icon(
          //       Icons.keyboard_arrow_down,
          //       color: Colors.grey.shade500,
          //     ),
          //     iconSize: 22.w,
          //     isExpanded: true,
          //     underline: Container(height: 1, color: Colors.black),
          //     onChanged: (String? newValue) async =>
          //         _addDeviceProvider.deviceModelDropDownValue = newValue!,
          //     items: DeviceModelsExt.getDeviceModelsList()
          //         .map<DropdownMenuItem<String>>(
          //       (String value) {
          //         return DropdownMenuItem<String>(
          //           value: value,
          //           child: Text(
          //             value,
          //             style: styleGenerator(fontSize: 13),
          //           ),
          //         );
          //       },
          //     ).toList(),
          //   ),
          // ),
          // Divider(height: 30.h, thickness: 1, color: Colors.black12),
          Text(
            translate('device_phone'),
            style: styleGenerator(
              fontWeight: FontWeight.w500,
              fontColor: Theme.of(context).colorScheme.secondary,
            ),
          ),
          SizedBox(height: 8.h),
          SizedBox(
            width: 0.7.sw,
            child: CustomTextFieldWidget(
              controller: _devicePhoneTEC,
              focusNode: _devicePhoneFN,
              hintStyle: styleGenerator(
                fontSize: 13,
                fontColor: Colors.black45,
              ),
              inputStyle: styleGenerator(
                fontSize: 14,
                fontColor: Colors.black54,
              ),
              textDirection: TextDirection.ltr,
              hintText: translate('device_sim_number'),
              floatingText: translate('device_sim_number'),
              maxLength: 11,
              inputBorder: UnderlineInputBorder(
                borderSide: BorderSide(width: 1.w, color: Colors.black45),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(width: 1.w, color: Colors.black54),
              ),
              keyboardType: TextInputType.number,
              onChange: (String newText) {
                _addDeviceProvider.autoDetectOperator(newText);
                _devicePhoneFN.requestFocus();
              },
            ),
          ),
          Divider(height: 30.h, thickness: 1, color: Colors.black12),
          Text(
            translate('device_name'),
            style: styleGenerator(
              fontWeight: FontWeight.w500,
              fontColor: Theme.of(context).colorScheme.secondary,
            ),
          ),
          SizedBox(
            width: 0.7.sw,
            child: CustomTextFieldWidget(
              controller: _deviceNameTEC,
              focusNode: _deviceNameFN,
              hintStyle: styleGenerator(
                fontSize: 13,
                fontColor: Colors.black45,
              ),
              inputStyle: styleGenerator(
                fontSize: 14,
                fontColor: Colors.black54,
              ),
              textDirection: TextDirection.ltr,
              hintText: translate('device_name'),
              floatingText: translate('device_name'),
              inputBorder: UnderlineInputBorder(
                borderSide: BorderSide(width: 1.w, color: Colors.black45),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(width: 1.w, color: Colors.black54),
              ),
              keyboardType: TextInputType.text,
            ),
          ),
          Divider(height: 30.h, thickness: 1, color: Colors.black12),
          Text(
            translate('device_operator'),
            style: styleGenerator(
              fontWeight: FontWeight.w500,
              fontColor: Theme.of(context).colorScheme.secondary,
            ),
          ),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              OperatorContainerWidget(
                operator: Operators.mci,
                onTapOperator: () =>
                    _addDeviceProvider.selectedOperator = Operators.mci,
                width: 70.w,
                selectedOperator:
                    context.watch<AddDeviceProvider>().selectedOperator,
              ),
              OperatorContainerWidget(
                operator: Operators.irancell,
                onTapOperator: () =>
                    _addDeviceProvider.selectedOperator = Operators.irancell,
                width: 70.w,
                selectedOperator:
                    context.watch<AddDeviceProvider>().selectedOperator,
              ),
              OperatorContainerWidget(
                operator: Operators.rightel,
                onTapOperator: () =>
                    _addDeviceProvider.selectedOperator = Operators.rightel,
                width: 70.w,
                selectedOperator:
                    context.watch<AddDeviceProvider>().selectedOperator,
              ),
            ],
          ),
          SizedBox(height: 50.h),
          ElevatedButtonWidget(
            width: 0.45.sw,
            btnText: translate('add_device'),
            btnIcon: Icons.add,
            onPressBtn: () async => _addDeviceProvider.addNewDevice(
              _deviceNameTEC.text,
              _devicePhoneTEC.text,
              DeviceModels.series300.value,
            ),
          ),
        ],
      ),
    );
  }
}
