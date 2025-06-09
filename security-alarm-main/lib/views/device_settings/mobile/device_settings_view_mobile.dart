import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';

import '../../../config/routes/app_routes.dart';
import '../../../core/utils/enums.dart';
import '../../../core/utils/helper.dart';
import '../../../providers/device_settings_provider.dart';
import '../../../widgets/dialogs/editable_dialog2_widget.dart';
import '../../../widgets/dialogs/editable_dialog_widget.dart';
import '../../../widgets/setting_item_widget.dart';

class DeviceSettingsViewMobile extends HookWidget {
  late TextEditingController _oldPassTEC;
  late TextEditingController _newPassTEC;
  late TextEditingController _reNewPassTEC;
  late TextEditingController _remoteNumberTEC;
  late DeviceSettingsProvider _deviceSettingsProvider;

  DeviceSettingsViewMobile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _deviceSettingsProvider = context.read<DeviceSettingsProvider>();
    _oldPassTEC = useTextEditingController();
    _newPassTEC = useTextEditingController();
    _reNewPassTEC = useTextEditingController();
    _remoteNumberTEC = useTextEditingController();
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SettingItemWidget(
            settingType: SettingItemType.icon,
            itemTitle: translate('edit_device'),
            itemIcon: Icon(
              Icons.keyboard_arrow_left_rounded,
              color: Colors.grey.shade700,
            ),
            onItemClick: () =>
                Navigator.pushNamed(context, AppRoutes.editDeviceRoute),
          ),
          SizedBox(height: 10.h),
          SettingItemWidget(
            settingType: SettingItemType.icon,
            itemTitle: translate('change_device_pass'),
            onItemClick: _onTapChangePassword,
            itemIcon: Icon(
              Icons.keyboard_arrow_left_rounded,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: 10.h),
          SettingItemWidget(
            settingType: SettingItemType.icon,
            itemTitle: translate('remove_remote'),
            onItemClick: _onTapRemoveRemote,
            itemIcon: Icon(
              Icons.keyboard_arrow_left_rounded,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: 10.h),
          _buildResetDevice(),
          SizedBox(height: 15.h),
        ],
      ),
    );
  }

  Widget _buildResetDevice() {
    return SettingItemWidget(
      settingType: SettingItemType.icon,
      itemTitle: translate('reset_device_settings'),
      onItemClick: _onTapResetDevice,
      itemIcon: Icon(
        Icons.keyboard_arrow_left_rounded,
        color: Colors.grey[700],
      ),
    );
  }

  void _onTapChangePassword() {
    _oldPassTEC.clear();
    _newPassTEC.clear();
    _reNewPassTEC.clear();
    dialogGenerator(
      translate('change_device_pass'),
      '',
      contentWidget: EditableDialog2Widget(
        controllerList: [
          _oldPassTEC,
          _newPassTEC,
          _reNewPassTEC,
        ],
        hintTextList: [
          translate('old_pass'),
          translate('new_pass'),
          translate('re_new_pass'),
        ],
        maxLength: 6,
        isObsecure: true,
      ),
      onPressAccept: () async => _deviceSettingsProvider.updateDevicePassword(
        _oldPassTEC.text,
        _newPassTEC.text,
        _reNewPassTEC.text,
      ),
    );
  }

  void _onTapRemoveRemote() {
    _remoteNumberTEC.clear();
    dialogGenerator(
      translate('remove_remote'),
      '',
      contentWidget: EditableDialogWidget(
        controller: _remoteNumberTEC,
        contentText: translate('insert_remote_number_desc'),
        hintText: translate('remote_number'),
        maxLength: 2,
      ),
      confirmBtnText: translate('remove'),
      onPressAccept: () async => _deviceSettingsProvider.removeRemoteFromDevice(
        _remoteNumberTEC.text,
      ),
    );
  }

  void _onTapResetDevice() {
    dialogGenerator(
      translate('reset_device_settings'),
      translate('reset_device_settings_desc'),
      onPressAccept: () async => _deviceSettingsProvider.resetFactoryDevice(),
    );
  }
}
