import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';

import '../../../../core/utils/enums.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../providers/main_provider.dart';
import '../../../../providers/zones_provider.dart';
import 'zone_name_view.dart';
import 'semi_active_zone_view.dart';
import 'zone_mode_view.dart';

class ZoneSettingsViewMobile extends StatefulWidget {
  const ZoneSettingsViewMobile({Key? key}) : super(key: key);

  @override
  State<ZoneSettingsViewMobile> createState() => _ZoneSettingsViewMobileState();
}

class _ZoneSettingsViewMobileState extends State<ZoneSettingsViewMobile> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<MainProvider, ZonesProvider>(
      builder: (context, mainProvider, zonesProvider, child) {
        final selectedDevice = mainProvider.selectedDevice;
        
        return Container(
          color: const Color(0xFF09162E),
          child: Column(
            children: [
              // Device name header
              Container(
                padding: EdgeInsets.symmetric(vertical: 16.h),
                alignment: Alignment.center,
                child: Text(
                  "${translate('تنظیمات زون')} ${selectedDevice.deviceName}",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              
              // Tab bar
              Container(
                decoration: BoxDecoration(
                  color: Colors.blue.shade900,
                ),
                child: TabBar(
                  controller: _tabController,
                  indicatorColor: Colors.white,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white70,
                  tabs: [
                    Tab(text: translate('تنظیمات حالت زون‌ها')),
                    Tab(text: translate('تنظیمات نام زون‌ها')),
                    Tab(text: translate('تنظیمات زون‌های نیمه فعال')),
                  ],
                ),
              ),
              
              // Tab content - Wrap in try-catch to prevent crashes
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildSafeTabView(() => ZoneModeView()),
                    _buildSafeTabView(() => const ZoneNameView()),
                    _buildSafeTabView(() => const SemiActiveZoneView()),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
  
  // Utility method to wrap each tab view in error handling
  Widget _buildSafeTabView(Widget Function() builder) {
    try {
      return builder();
    } catch (e) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, color: Colors.red, size: 48.w),
              SizedBox(height: 16.h),
              Text(
                translate('خطا در بارگذاری این بخش'),
                style: TextStyle(color: Colors.white, fontSize: 16.sp),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }
  }
} 