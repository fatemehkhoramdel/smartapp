import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';
import 'package:security_alarm/core/constants/global_keys.dart';
import 'package:security_alarm/views/home/drawer_menu_widget.dart';
import 'package:tokenizer/tokenizer.dart';

import '../../../core/utils/enums.dart';
import '../../../providers/zones_provider.dart';
import '../../../providers/main_provider.dart';
import 'mobile/zone_mode_settings_view.dart';
import 'mobile/zone_name_view.dart';
import 'mobile/semi_active_zone_view.dart';

class ZoneSettingsView extends StatelessWidget {
  const ZoneSettingsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SliderDrawer(
        slideDirection: SlideDirection.RIGHT_TO_LEFT,
        isDraggable: false,
        appBar: null,
        key: getDrawerKey('ZoneSettingsView'),
        sliderOpenSize: 0.78.sw,
        slider: DrawerMenuWidget(drawerKey: getDrawerKey('ZoneSettingsView')),
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: const Color(0xFF09162E),
            elevation: 0,
            title: Text(
              translate('تنظیمات'),
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.sp,
              ),
            ),
            centerTitle: false,
            actions: [
              Container(
                margin: EdgeInsets.only(left: 10.w),
                decoration: BoxDecoration(
                  color: const Color(0xFF142850),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.chevron_right,
                    color: Colors.white,
                    size: 24.sp,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              )
            ],
            leading: Container(
              margin: EdgeInsets.only(right: 10.w),
              decoration: BoxDecoration(
                color: const Color(0xFF142850),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: IconButton(
                icon: Icon(
                  Icons.menu,
                  color: Colors.white,
                  size: 24.sp,
                ),
                onPressed: () {
                  getDrawerKey('ZoneSettingsView').currentState!.toggle();
                },
              ),
            ),
          ),
          body: const ZoneSettingsViewMobile(),
        ),
      ),
    );
  }
}

class ZoneSettingsViewMobile extends StatelessWidget {
  const ZoneSettingsViewMobile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF09162E),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 20.h),
            alignment: Alignment.center,
            child: Text(
              translate('تنظیمات زون'),
              style: TextStyle(
                color: Colors.white,
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                _buildSettingsItem(
                  context,
                  title: translate('تنظیمات حالت زون‌ها'),
                  icon: Icons.settings_outlined,
                  iconColor: Colors.blue,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ZoneModeSettingsView(),
                      ),
                    );
                  },
                ),
                _buildSettingsItem(
                  context,
                  title: translate('تنظیمات نام زون‌ها'),
                  icon: Icons.edit_outlined,
                  iconColor: Colors.purple,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ZoneNameView(),
                      ),
                    );
                  },
                ),
                _buildSettingsItem(
                  context,
                  title: translate('تنظیمات زون‌های نیمه فعال'),
                  icon: Icons.security_outlined,
                  iconColor: Colors.orange,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SemiActiveZoneView(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsItem(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.white.withOpacity(0.2),
              width: 1.h,
            ),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 16.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8.r),
                    decoration: BoxDecoration(
                      color: iconColor,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      icon,
                      color: Colors.white,
                      size: 24.sp,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                    ),
                  ),
                ],
              ),
              Icon(
                Icons.chevron_right,
                color: Colors.white,
                size: 24.sp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}