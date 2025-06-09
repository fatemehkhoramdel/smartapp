import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';
import 'package:security_alarm/core/constants/global_keys.dart';
import 'package:security_alarm/views/home/drawer_menu_widget.dart';
import 'package:tokenizer/tokenizer.dart';

import '../../core/utils/helper.dart';
import '../../providers/main_provider.dart';
import './mobile/device_status_view_mobile.dart';

class DeviceStatusView extends StatelessWidget {
  final int deviceId;

  const DeviceStatusView({Key? key, required this.deviceId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MyBaseWidget(
        hasScrollView: false,
        mobileChild: SliderDrawer(
          slideDirection: SlideDirection.RIGHT_TO_LEFT,
          isDraggable: false,
          appBar: null,
          key: getDrawerKey('DeviceStatusView'),
          sliderOpenSize: 0.78.sw,
          slider: DrawerMenuWidget(drawerKey: getDrawerKey('DeviceStatusView')),
          child: DeviceStatusViewMobile(deviceId: deviceId),
        ));
  }
} 