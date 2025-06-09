import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';

import '../../../../core/utils/enums.dart';
import '../../../../core/utils/helper.dart';
import '../../../../models/device.dart';
import '../../../../providers/app_settings_provider.dart';
import '../../../../providers/main_provider.dart';
import '../../../../widgets/setting_item_widget.dart';

class CustomizeHomeViewMobile extends StatelessWidget {
  late Device _device;
  late AppSettingsProvider _appSettingsProvider;

  CustomizeHomeViewMobile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _device = context.select<MainProvider, Device>(
      (MainProvider m) => m.selectedDevice,
    );
    _appSettingsProvider = context.read<AppSettingsProvider>();
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            translate('customize_relay_section'),
            style: styleGenerator(fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 20.h),
          SettingItemWidget(
            settingType: SettingItemType.toggle,
            itemTitle: translate('show_relay1_section'),
            switchOpen: _device.relay1SectionVisibility,
            onSwitchChange: (v) async => _appSettingsProvider.updateHomeItems(
              _device.copyWith(
                relay1SectionVisibility: v,
              ),
            ),
          ),
          SizedBox(height: 8.h),
          SettingItemWidget(
            settingType: SettingItemType.toggle,
            itemTitle: translate('show_relay1_active_btn'),
            switchOpen: _device.relay1ActiveBtnVisibility,
            onSwitchChange: (v) async => _appSettingsProvider.updateHomeItems(
              _device.copyWith(
                relay1ActiveBtnVisibility: v,
              ),
            ),
          ),
          SizedBox(height: 8.h),
          SettingItemWidget(
            settingType: SettingItemType.toggle,
            itemTitle: translate('show_relay1_trigger_btn'),
            switchOpen: _device.relay1TriggerBtnVisibility,
            onSwitchChange: (v) async => _appSettingsProvider.updateHomeItems(
              _device.copyWith(
                relay1TriggerBtnVisibility: v,
              ),
            ),
          ),
          Divider(height: 40.h, thickness: 1, color: Colors.black38),
          SettingItemWidget(
            settingType: SettingItemType.toggle,
            itemTitle: translate('show_relay2_section'),
            switchOpen: _device.relay2SectionVisibility,
            onSwitchChange: (v) async => _appSettingsProvider.updateHomeItems(
              _device.copyWith(
                relay2SectionVisibility: v,
              ),
            ),
          ),
          SizedBox(height: 8.h),
          SettingItemWidget(
            settingType: SettingItemType.toggle,
            itemTitle: translate('show_relay2_active_btn'),
            switchOpen: _device.relay2ActiveBtnVisibility,
            onSwitchChange: (v) async => _appSettingsProvider.updateHomeItems(
              _device.copyWith(
                relay2ActiveBtnVisibility: v,
              ),
            ),
          ),
          SizedBox(height: 8.h),
          SettingItemWidget(
            settingType: SettingItemType.toggle,
            itemTitle: translate('show_relay2_trigger_btn'),
            switchOpen: _device.relay2TriggerBtnVisibility,
            onSwitchChange: (v) async => _appSettingsProvider.updateHomeItems(
              _device.copyWith(
                relay2TriggerBtnVisibility: v,
              ),
            ),
          ),
          SizedBox(height: 20.h),
          Text(
            translate('customize_home_buttons'),
            style: styleGenerator(fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 20.h),
          SettingItemWidget(
            settingType: SettingItemType.toggle,
            itemTitle: translate('show_semi_active'),
            switchOpen: _device.semiActiveVisibility,
            onSwitchChange: (v) async => _appSettingsProvider.updateHomeItems(
              _device.copyWith(
                semiActiveVisibility: v,
              ),
            ),
          ),
          SizedBox(height: 8.h),
          SettingItemWidget(
            settingType: SettingItemType.toggle,
            itemTitle: translate('show_silent'),
            switchOpen: _device.silentVisibility,
            onSwitchChange: (v) async => _appSettingsProvider.updateHomeItems(
              _device.copyWith(
                silentVisibility: v,
              ),
            ),
          ),
          SizedBox(height: 8.h),
          SettingItemWidget(
            settingType: SettingItemType.toggle,
            itemTitle: translate('show_spy'),
            switchOpen: _device.spyVisibility,
            onSwitchChange: (v) async => _appSettingsProvider.updateHomeItems(
              _device.copyWith(
                spyVisibility: v,
              ),
            ),
          ),
          SizedBox(height: 20.h),
          Text(
            translate('customize_information_section'),
            style: styleGenerator(fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 20.h),
          SettingItemWidget(
            settingType: SettingItemType.toggle,
            itemTitle: translate('show_netword_state'),
            switchOpen: _device.networkStateVisibility,
            onSwitchChange: (v) async => _appSettingsProvider.updateHomeItems(
              _device.copyWith(
                networkStateVisibility: v,
              ),
            ),
          ),
          SizedBox(height: 8.h),
          SettingItemWidget(
            settingType: SettingItemType.toggle,
            itemTitle: translate('show_antenna_state'),
            switchOpen: _device.antennaAmountVisibility,
            onSwitchChange: (v) async => _appSettingsProvider.updateHomeItems(
              _device.copyWith(
                antennaAmountVisibility: v,
              ),
            ),
          ),
          SizedBox(height: 8.h),
          SettingItemWidget(
            settingType: SettingItemType.toggle,
            itemTitle: translate('show_battery_shape'),
            switchOpen: _device.batteryShapeVisibility,
            onSwitchChange: (v) async => _appSettingsProvider.updateHomeItems(
              _device.copyWith(
                batteryShapeVisibility: v,
              ),
            ),
          ),
          SizedBox(height: 8.h),
          SettingItemWidget(
            settingType: SettingItemType.toggle,
            itemTitle: translate('show_telephone'),
            switchOpen: _device.gsmStateVisibility,
            onSwitchChange: (v) async => _appSettingsProvider.updateHomeItems(
              _device.copyWith(
                gsmStateVisibility: v,
              ),
            ),
          ),
          SizedBox(height: 8.h),
          SettingItemWidget(
            settingType: SettingItemType.toggle,
            itemTitle: translate('show_remote_count'),
            switchOpen: _device.remoteAmountVisibility,
            onSwitchChange: (v) async => _appSettingsProvider.updateHomeItems(
              _device.copyWith(
                remoteAmountVisibility: v,
              ),
            ),
          ),
          SizedBox(height: 8.h),
          SettingItemWidget(
            settingType: SettingItemType.toggle,
            itemTitle: translate('show_contacts_count'),
            switchOpen: _device.contactsAmountVisibility,
            onSwitchChange: (v) async => _appSettingsProvider.updateHomeItems(
              _device.copyWith(
                contactsAmountVisibility: v,
              ),
            ),
          ),
          SizedBox(height: 8.h),
          SettingItemWidget(
            settingType: SettingItemType.toggle,
            itemTitle: "${translate('show_zone_state')} ۱",
            switchOpen: _device.zone1Visibility,
            onSwitchChange: (v) async => _appSettingsProvider.updateHomeItems(
              _device.copyWith(
                zone1Visibility: v,
              ),
            ),
          ),
          SizedBox(height: 8.h),
          SettingItemWidget(
            settingType: SettingItemType.toggle,
            itemTitle: "${translate('show_zone_state')} ۲",
            switchOpen: _device.zone2Visibility,
            onSwitchChange: (v) async => _appSettingsProvider.updateHomeItems(
              _device.copyWith(
                zone2Visibility: v,
              ),
            ),
          ),
          SizedBox(height: 8.h),
          SettingItemWidget(
            settingType: SettingItemType.toggle,
            itemTitle: "${translate('show_zone_state')} ۳",
            switchOpen: _device.zone3Visibility,
            onSwitchChange: (v) async => _appSettingsProvider.updateHomeItems(
              _device.copyWith(
                zone3Visibility: v,
              ),
            ),
          ),
          SizedBox(height: 8.h),
          SettingItemWidget(
            settingType: SettingItemType.toggle,
            itemTitle: "${translate('show_zone_state')} ۴",
            switchOpen: _device.zone4Visibility,
            onSwitchChange: (v) async => _appSettingsProvider.updateHomeItems(
              _device.copyWith(
                zone4Visibility: v,
              ),
            ),
          ),
          SizedBox(height: 8.h),
          SettingItemWidget(
            settingType: SettingItemType.toggle,
            itemTitle: "${translate('show_zone_state')} ۵",
            switchOpen: _device.zone5Visibility,
            onSwitchChange: (v) async => _appSettingsProvider.updateHomeItems(
              _device.copyWith(
                zone5Visibility: v,
              ),
            ),
          ),
          SizedBox(height: 8.h),
          SettingItemWidget(
            settingType: SettingItemType.toggle,
            itemTitle: translate('show_relay1_state'),
            switchOpen: _device.relay1Visibility,
            onSwitchChange: (v) async => _appSettingsProvider.updateHomeItems(
              _device.copyWith(
                relay1Visibility: v,
              ),
            ),
          ),
          SizedBox(height: 8.h),
          SettingItemWidget(
            settingType: SettingItemType.toggle,
            itemTitle: translate('show_relay2_state'),
            switchOpen: _device.relay2Visibility,
            onSwitchChange: (v) async => _appSettingsProvider.updateHomeItems(
              _device.copyWith(
                relay2Visibility: v,
              ),
            ),
          ),
          SizedBox(height: 30.h),
        ],
      ),
    );
  }
}
