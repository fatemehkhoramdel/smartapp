import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:tokenizer/tokenizer.dart';

import '../../core/constants/global_keys.dart';
import 'drawer_menu_widget.dart';
import 'mobile/home_view_mobile.dart';

class RootView extends StatelessWidget {
  const RootView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MyBaseWidget(
      hasSafeArea: false,
      hasScrollView: false,
      mobileChild: SliderDrawer(
        slideDirection: SlideDirection.RIGHT_TO_LEFT,
        isDraggable: false,
        appBar: null,
        key: getDrawerKey('RootView'),
        sliderOpenSize: 0.78.sw,
        slider: DrawerMenuWidget(drawerKey: getDrawerKey('RootView')),
        child: const HomeViewMobile(),
      ),
    );
  }
}
