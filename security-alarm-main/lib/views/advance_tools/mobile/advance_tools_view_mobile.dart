import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';

import '../../../core/utils/enums.dart';
import '../../../core/utils/extensions.dart';
import '../../../core/utils/helper.dart';
import '../../../models/device.dart';
import '../../../providers/advance_tools_provider.dart';
import '../../../providers/main_provider.dart';
import '../../../widgets/advance_tools_item2_widget.dart';
import '../../../widgets/advance_tools_item_widget.dart';
import '../../../widgets/dialogs/call_order_dialog_widget.dart';
import '../../../widgets/dialogs/editable_dialog_widget.dart';
import '../../../widgets/dialogs/spy_dialog_widget.dart';

class AdvanceToolsViewMobile extends HookWidget {
  late TextEditingController _chargePeriodTEC;
  late TextEditingController _batteryPeriodTEC;
  late TextEditingController _spyTEC;
  late TextEditingController _alarmTimeTEC;
  late AdvanceToolsProvider _advanceToolsProvider;
  late Device _device;
  final List<String> _callOrderTitles = [
    translate('sms_call_line'),
    translate('call_sms_line'),
    translate('call_line_sms'),
    translate('line_call_sms'),
  ];

  AdvanceToolsViewMobile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _advanceToolsProvider = context.read<AdvanceToolsProvider>();
    _device = context.select<MainProvider, Device>(
      (MainProvider m) => m.selectedDevice,
    );
    _chargePeriodTEC = useTextEditingController();
    _batteryPeriodTEC = useTextEditingController();
    _spyTEC = useTextEditingController();
    _alarmTimeTEC = useTextEditingController();
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildChooseOperator(),
          SizedBox(height: 10.h),
          _buildDeviceLanguage(),
          SizedBox(height: 10.h),
          _buildSimCardLanguage(),
          SizedBox(height: 10.h),
          _buildSilentOnSiren(),
          SizedBox(height: 10.h),
          _buildRelayOnDingDong(),
          SizedBox(height: 10.h),
          _buildCallOnPowerLost(),
          SizedBox(height: 10.h),
          _buildManageByContacts(),
          SizedBox(height: 10.h),
          _buildAlertTime(),
          SizedBox(height: 10.h),
          _buildSpy(),
          SizedBox(height: 10.h),
          _buildChargePeriodictReport(),
          SizedBox(height: 10.h),
          _buildBatteryPeriodictReport(),
          SizedBox(height: 10.h),
          _buildCallOrder(),
          SizedBox(height: 30.h),
        ],
      ),
    );
  }

  Widget _buildChooseOperator() {
    return AdvanceToolsItemWidget(
      title: translate('choose_operator'),
      buttonTextList: [
        translate('mci'),
        translate('irancell'),
        translate('rightel'),
      ],
      onTapBtnList: [
        _advanceToolsProvider.selectMCIOperator,
        _advanceToolsProvider.selectIrancellOperator,
        _advanceToolsProvider.selectRightelOperator,
      ],
      selectedButtonIndex: _device.operator ==
              Operators.mci.value
          ? 0
          : _device.operator == Operators.irancell.value
              ? 1
              : _device.operator == Operators.rightel.value
                  ? 2
                  : -1,
    );
  }

  Widget _buildDeviceLanguage() {
    return AdvanceToolsItemWidget(
      title: translate('device_language'),
      buttonTextList: [
        translate('english'),
        translate('persian'),
      ],
      onTapBtnList: [
        _advanceToolsProvider.selectEnglishAsDeviceLang,
        _advanceToolsProvider.selectPresianAsDeviceLang,
      ],
      selectedButtonIndex:
          _device.deviceLang == translate('english')
              ? 0
              : _device.deviceLang == translate('persian')
                  ? 1
                  : -1,
    );
  }

  Widget _buildSimCardLanguage() {
    return AdvanceToolsItemWidget(
      title: translate('device_sim_language'),
      buttonTextList: [
        translate('english'),
        translate('persian'),
      ],
      onTapBtnList: [
        _advanceToolsProvider.selectEnglishAsSimCardLang,
        _advanceToolsProvider.selectPersianAsSimCardLang,
      ],
      selectedButtonIndex:
          _device.deviceSimLang == translate('english')
              ? 0
              : _device.deviceSimLang == translate('persian')
                  ? 1
                  : -1,
    );
  }

  Widget _buildSilentOnSiren() {
    return AdvanceToolsItemWidget(
      title: translate('silent_on_siren'),
      buttonTextList: [
        translate('active'),
        translate('deactive'),
      ],
      onTapBtnList: [
        _advanceToolsProvider.activeSilentOnSiren,
        _advanceToolsProvider.deactiveSilentOnSiren,
      ],
      selectedButtonIndex: _device.silentOnSiren
          ? 0
          : !_device.silentOnSiren
              ? 1
              : -1,
    );
  }

  Widget _buildRelayOnDingDong() {
    return AdvanceToolsItemWidget(
      title: translate('relay_on_ding_dong'),
      buttonTextList: [
        translate('active'),
        translate('deactive'),
      ],
      onTapBtnList: [
        _advanceToolsProvider.activeRelayOnDingDong,
        _advanceToolsProvider.deactiveRelayOnDingDong,
      ],
      selectedButtonIndex: _device.relayOnDingDong
          ? 0
          : !_device.relayOnDingDong
              ? 1
              : -1,
    );
  }

  Widget _buildCallOnPowerLost() {
    return AdvanceToolsItemWidget(
      title: translate('call_on_power_loss'),
      buttonTextList: [
        translate('active'),
        translate('deactive'),
      ],
      onTapBtnList: [
        _advanceToolsProvider.activeCallOnPowerLost,
        _advanceToolsProvider.deactiveCallOnPowerLost,
      ],
      selectedButtonIndex: _device.callOnPowerLoss
          ? 0
          : !_device.callOnPowerLoss
              ? 1
              : -1,
    );
  }

  Widget _buildManageByContacts() {
    return AdvanceToolsItemWidget(
      title: translate('manage_by_contacts'),
      buttonTextList: [
        translate('active'),
        translate('deactive'),
      ],
      onTapBtnList: [
        _advanceToolsProvider.activeManageByContacts,
        _advanceToolsProvider.deactiveManageByContacts,
      ],
      selectedButtonIndex: _device.manageWithContacts
          ? 0
          : !_device.manageWithContacts
              ? 1
              : -1,
    );
  }

  Widget _buildAlertTime() {
    return AdvanceToolsItem2Widget(
      title: translate('alarm_time'),
      subTitle: "${_device.alarmTime} ${translate('minute')} ",
      onTapBtn: _onTapEditAlertTime,
    );
  }

  Widget _buildSpy() {
    return AdvanceToolsItem2Widget(
      title: translate('spy'),
      subTitle: _device.spyAmount.toString(),
      onTapBtn: _onTapEditSpy,
    );
  }

  Widget _buildChargePeriodictReport() {
    return AdvanceToolsItem2Widget(
      title: translate('charge_periodic_report'),
      subTitle: "${_device.chargePeriodictReport} ${translate('sms')} ",
      onTapBtn: _onTapEditChargeReportPeriod,
    );
  }

  Widget _buildBatteryPeriodictReport() {
    return AdvanceToolsItem2Widget(
      title: translate('battery_periodic_report'),
      subTitle: "${_device.batteryPeriodictReport} ${translate('minute')} ",
      onTapBtn: _onTapEditBatteryReportPeriod,
    );
  }

  Widget _buildCallOrder() {
    return AdvanceToolsItem2Widget(
      title: translate('call_order'),
      subTitle: '\n${_callOrderTitles[_device.callOrder - 1]}',
      onTapBtn: _dialogCallOrder,
    );
  }

  void _onTapEditAlertTime() {
    _alarmTimeTEC.clear();
    dialogGenerator(
      translate('change_alarm_time'),
      '',
      contentWidget: EditableDialogWidget(
        controller: _alarmTimeTEC,
        contentText: translate('change_alarm_time_desc'),
        hintText: translate('alarm_time_in_minute'),
        maxLength: 3,
      ),
      onPressAccept: () async => _advanceToolsProvider.updateAlertTime(
        _alarmTimeTEC.text,
      ),
    );
  }

  void _onTapEditSpy() {
    _spyTEC.clear();
    dialogGenerator(
      translate('spy'),
      '',
      contentWidget: SpyDialogWidget(
        controller: _spyTEC,
        devicePhone: _device.devicePhone,
      ),
      onPressAccept: () async => _advanceToolsProvider.updateSpyVolume(
        _spyTEC.text,
      ),
    );
  }

  void _onTapEditChargeReportPeriod() {
    _chargePeriodTEC.clear();
    dialogGenerator(
      translate('charge_periodic_report'),
      '',
      contentWidget: EditableDialogWidget(
        controller: _chargePeriodTEC,
        contentText: translate('charge_periodic_report_desc'),
        hintText: translate('sms_count'),
        maxLength: 2,
      ),
      onPressAccept: () async => _advanceToolsProvider.updateChargeReportPeriod(
        _chargePeriodTEC.text,
      ),
    );
  }

  void _onTapEditBatteryReportPeriod() {
    _batteryPeriodTEC.clear();
    dialogGenerator(
      translate('battery_periodic_report'),
      '',
      contentWidget: EditableDialogWidget(
        controller: _batteryPeriodTEC,
        contentText: translate('battery_periodic_report_desc'),
        hintText: translate('minute'),
        maxLength: 2,
      ),
      onPressAccept: () async =>
          _advanceToolsProvider.updateBatteryReportPeriod(
        _batteryPeriodTEC.text,
      ),
    );
  }

  void _dialogCallOrder() {
    dialogGenerator(
      translate('call_order'),
      '',
      contentWidget: CallOrderDialogWidget(
        selectedItemIndex: _device.callOrder - 1,
        onTapButtonList: [
          _advanceToolsProvider.selectFirstCallOrder,
          _advanceToolsProvider.selectSecondCallOrder,
          _advanceToolsProvider.selectThirdCallOrder,
          _advanceToolsProvider.selectFourthCallOrder,
        ],
      ),
      showAccept: false,
    );
  }
}
