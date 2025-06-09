import 'dart:io';

import 'package:flutter/material.dart';

import 'mobile/general_settings_view_mobile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:security_alarm/core/constants/global_keys.dart';
import 'package:security_alarm/views/home/drawer_menu_widget.dart';
import 'package:tokenizer/tokenizer.dart';

class GeneralSettingsView extends StatelessWidget {
  const GeneralSettingsView({Key? key}) : super(key: key);

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
          key: getDrawerKey('GeneralSettingsView'),
          sliderOpenSize: 0.78.sw,
          slider: DrawerMenuWidget(drawerKey: getDrawerKey('GeneralSettingsView')),
          child: const GeneralSettingsViewMobile()),
      // hasSafeArea: true,
      hasScrollView: false,
    );

    // if (Platform.isAndroid || Platform.isIOS) {
    //   return const GeneralSettingsViewMobile();
    // } else {
    //   // Fallback to mobile view for now
    //   return const GeneralSettingsViewMobile();
    // }
  }
} 