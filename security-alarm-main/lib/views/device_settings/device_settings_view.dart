import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tokenizer/tokenizer.dart';

import '../../core/utils/enums.dart';
import '../../widgets/custom_appbar_widget.dart';
import 'mobile/device_settings_view_mobile.dart';

class DeviceSettingsView extends StatelessWidget {
  const DeviceSettingsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MyBaseWidget(
      platformAppBar: const CustomAppbarWidget(menu: MenuItems.deviceSettings)
          .build(context),
      mobileChild: DeviceSettingsViewMobile(),
    );
  }
}
