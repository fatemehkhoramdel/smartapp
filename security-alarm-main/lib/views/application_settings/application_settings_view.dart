import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:security_alarm/core/constants/global_keys.dart';
import 'package:security_alarm/views/home/drawer_menu_widget.dart';
import 'package:tokenizer/tokenizer.dart';

import '../../core/utils/enums.dart';
import '../../widgets/custom_appbar_widget.dart';
import 'mobile/application_settings_view_mobile.dart';

class ApplicationSettingsView extends StatelessWidget {
  const ApplicationSettingsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MyBaseWidget(
      hasScrollView: false,
      mobileChild: SliderDrawer(
        slideDirection: SlideDirection.RIGHT_TO_LEFT,
        isDraggable: false,
        appBar: null,
        key: getDrawerKey('ApplicationSettingsView'),
        sliderOpenSize: 0.78.sw,
        slider: DrawerMenuWidget(drawerKey: getDrawerKey('ApplicationSettingsView')),
        child: const ApplicationSettingsViewMobile(),
      ),
    );
  }
}
