import 'dart:io';

import 'package:flutter/material.dart';

import 'mobile/relay_settings_view_mobile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:security_alarm/core/constants/global_keys.dart';
import 'package:security_alarm/views/home/drawer_menu_widget.dart';
import 'package:tokenizer/tokenizer.dart';

class RelaySettingsView extends StatelessWidget {
  const RelaySettingsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return MyBaseWidget(
      // platformAppBar:
      //     const CustomAppbarWidget(menu: MenuItems.audioNotification)
      //         .build(context),
      mobileChild: SliderDrawer(
          slideDirection: SlideDirection.RIGHT_TO_LEFT,
          isDraggable: false,
          appBar: null,
          key: getDrawerKey('RelaySettingsView'),
          sliderOpenSize: 0.78.sw,
          slider: DrawerMenuWidget(drawerKey: getDrawerKey('RelaySettingsView')),
          child: const RelaySettingsViewMobile()),
      // hasSafeArea: true,
      hasScrollView: false,
    );
  }
} 