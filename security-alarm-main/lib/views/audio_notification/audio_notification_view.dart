import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:security_alarm/core/constants/global_keys.dart';
import 'package:security_alarm/views/home/drawer_menu_widget.dart';
import 'package:tokenizer/tokenizer.dart';

import '../../core/utils/enums.dart';
import '../../widgets/custom_appbar_widget.dart';
import 'mobile/audio_notification_view_mobile.dart';

class AudioNotificationView extends StatelessWidget {
  const AudioNotificationView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MyBaseWidget(
      hasScrollView: false,
      mobileChild: SliderDrawer(
          slideDirection: SlideDirection.RIGHT_TO_LEFT,
          isDraggable: false,
          appBar: null,
          key: getDrawerKey('AudioNotificationView'),
          sliderOpenSize: 0.78.sw,
          slider: DrawerMenuWidget(drawerKey: getDrawerKey('AudioNotificationView')),
          child: const AudioNotificationViewMobile()),
    );
  }
} 