import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';
import 'package:security_alarm/core/constants/global_keys.dart';

import '../../../config/routes/app_routes.dart';
import '../../../core/utils/helper.dart';
import '../../../providers/main_provider.dart';
import '../../../models/device.dart';

class ApplicationSettingsViewMobile extends StatefulWidget {
  const ApplicationSettingsViewMobile({Key? key}) : super(key: key);

  @override
  State<ApplicationSettingsViewMobile> createState() =>
      _ApplicationSettingsViewMobileState();
}

class _ApplicationSettingsViewMobileState
    extends State<ApplicationSettingsViewMobile> {
  // کلید برای کنترل وضعیت ExpansionTile
  final GlobalKey _expansionTileKey = GlobalKey();
  final ExpansionTileController _expansionTileController = ExpansionTileController();

  // وضعیت باز یا بسته بودن منوی کشویی
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF09162E), // Dark blue background
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
        // actions: [
        //   IconButton(
        //     icon: Icon(
        //       Icons.notifications_none_outlined,
        //       color: Colors.white,
        //       size: 24.sp,
        //     ),
        //     onPressed: () {
        //       // Bell icon functionality
        //     },
        //   ),
        // ],
        leading: Container(
          // width: 20.w,
          // height: 20.w,
          margin: EdgeInsets.only(right: 10.w),
          // padding: EdgeInsets.all(4.w),
          // alignment: Alignment.center,
          decoration: BoxDecoration(
            color: const Color(0xFF142850),
            borderRadius: BorderRadius.circular(8.r),
            // image: const DecorationImage(image: AssetImage(kLogoAsset))
          ),
          child: IconButton(
            icon: Icon(
              Icons.menu,
              color: Colors.white,
              size: 24.sp,
            ),
            onPressed: () {
              getDrawerKey('ApplicationSettingsView').currentState!.toggle();
            },
          ),
        ),
      ),
      body: Consumer<MainProvider>(
        builder: (context, mainProvider, child) {
          // دریافت لیست دستگاه‌ها از MainProvider
          final devices = mainProvider.devices;
          // دریافت دستگاه انتخاب شده فعلی
          final selectedDevice = mainProvider.selectedDevice;

    return Container(
            color: const Color(0xFF09162E),
      child: Column(
              children: [
                // بخش انتخاب دستگاه
                _buildDeviceSelector(
                    context, mainProvider, devices, selectedDevice),

                // محتوای اصلی صفحه
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    child: ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
        children: <Widget>[
                        _buildSettingsListItem(
                          title: translate('مدیریت شماره ها'),
                          icon: Icons.phone_outlined,
                          iconBackgroundColor: Colors.blue.shade700,
                          onTap: () {
                            Navigator.pushNamed(
                                context, AppRoutes.contactsRoute);
                          },
                        ),
                        _buildSettingsListItem(
                          title: translate('مدیریت هشدار های صوتی'),
                          icon: Icons.warning_amber_rounded,
                          iconBackgroundColor: Colors.red.shade400,
                          onTap: () {
                            Navigator.pushNamed(
                                context, AppRoutes.audioNotificationRoute);
                          },
                        ),
                        _buildSettingsListItem(
                          title: translate('تنظیمات زون'),
                          icon: Icons.security_outlined,
                          iconBackgroundColor: Colors.purple.shade400,
                          onTap: () {
                            Navigator.pushNamed(
                                context, AppRoutes.zoneSettingsRoute);
                          },
                        ),
                        _buildSettingsListItem(
                          title: translate('تنظیمات رله'),
                          icon: Icons.settings_remote_outlined,
                          iconBackgroundColor: Colors.blue.shade700,
                          onTap: () {
                            Navigator.pushNamed(
                                context, AppRoutes.relaySettingsRoute);
                          },
                        ),
                        _buildSettingsListItem(
                          title: translate('تنظیمات ریموت RMS'),
                          icon: Icons.shield_outlined,
                          iconBackgroundColor: Colors.purple.shade400,
                          onTap: () {
                            Navigator.pushNamed(
                                context, AppRoutes.remoteSettingsRoute);
                          },
                        ),
                        _buildSettingsListItem(
                          title: translate('تنظیمات جانبی'),
                          icon: Icons.settings_outlined,
                          iconBackgroundColor: Colors.orange.shade400,
                          onTap: () {
                            Navigator.pushNamed(
                                context, AppRoutes.generalSettingsRoute);
                          },
                        ),
                        _buildSettingsListItem(
                          title: translate('ویرایش دستگاه'),
                          icon: Icons.edit_outlined,
                          iconBackgroundColor: Colors.green.shade400,
                          onTap: () {
                            try {
                              // Verify selected device is valid before navigating
                              if (mainProvider.devices.isEmpty) {
                                toastGenerator(
                                    translate('no_device_available'));
                                return;
                              }
                              Navigator.pushNamed(
                                  context, AppRoutes.editDeviceRoute);
                            } catch (e) {
                              debugPrint('Error navigating to edit device: $e');
                              toastGenerator(
                                  translate('error_opening_edit_device'));
                            }
                          },
                        ),
                        _buildSettingsListItem(
                          title: translate('تعریف رمز'),
                          icon: Icons.lock_outline,
                          iconBackgroundColor: Colors.lightBlue.shade400,
                          onTap: () {
                            try {
                              Navigator.pushNamed(
                                  context, AppRoutes.patternLockRoute);
                            } catch (e) {
                              debugPrint(
                                  'Error navigating to pattern lock: $e');
                              toastGenerator(
                                  translate('error_opening_pattern_lock'));
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
        ],
      ),
    );
        },
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      height: 50.h,
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      decoration: BoxDecoration(
          // color: const Color(0xFF0E1F40),
          borderRadius: BorderRadius.circular(60.r),
          border: Border.all(color: Theme.of(context).colorScheme.primary)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavBarItem(Icons.settings, translate('تنظیمات'), () {},
              isSelected: true),
          _buildNavBarItem(Icons.home, translate('خانه'), () {
            Navigator.pushNamedAndRemoveUntil(
        context,
              AppRoutes.homeRoute,
                  (route) => false, // Eliminar todas las rutas anteriores
            );
            // Navigator.pushNamed(context, AppRoutes.homeRoute);
          }),
          _buildNavBarItem(Icons.people_alt_outlined, translate('کاربران'), () {
            Navigator.pushNamed(context, AppRoutes.contactsRoute);
          }),
        ],
      ),
    );
  }

  Widget _buildNavBarItem(IconData icon, String text, VoidCallback onTap,
      {bool isSelected = false}) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isSelected
                ? const Color(0xFF2E70E6)
                : Colors.white.withOpacity(0.7),
            size: 24.sp,
          ),
          SizedBox(height: 4.h),
          Text(
            text,
            style: TextStyle(
              color: isSelected
                  ? const Color(0xFF2E70E6)
                  : Colors.white.withOpacity(0.7),
              fontSize: 12.sp,
            ),
          ),
        ],
      ),
    );
  }

  // ساخت بخش انتخاب دستگاه در بالای صفحه
  Widget _buildDeviceSelector(BuildContext context, MainProvider mainProvider,
      List<Device?> devices, Device? selectedDevice) {
    // Handle case when selectedDevice is null
    if (selectedDevice == null || devices.isEmpty) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: const Color(0xFF09162E),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            SizedBox(height: 8.h),
            Text(
              translate('no_device_selected'),
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.h),
          ],
      ),
    );
  }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: const Color(0xFF09162E),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          SizedBox(height: 8.h),
          Text(
            "${translate('تنظیمات دستگاه')} ${selectedDevice.devicePhone}",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 40.h),
          Container(
            decoration: BoxDecoration(
              // borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: const Color(0XFF122950)),
            ),
            child: ExpansionTile(
              key: _expansionTileKey,
              controller: _expansionTileController,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    translate('تغییر دستگاه'),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                    ),
                  ),
                ],
              ),
              iconColor: Colors.white,
              collapsedIconColor: Colors.white,
              backgroundColor: const Color(0xFF09162E),
              collapsedBackgroundColor: const Color(0xFF09162E),
              // onExpansionChanged: (expanded) {
              //   setState(() {
              //     _isExpanded = expanded;
              //   });
              // },
              initiallyExpanded: _isExpanded,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF09162E),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(8.r),
                      bottomRight: Radius.circular(8.r),
                    ),
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: devices.length,
                    itemBuilder: (context, index) {
                      final device = devices[index];
                      if (device == null) return const SizedBox.shrink();

                      final isSelected = device.id == selectedDevice.id;
                      return InkWell(
                        onTap: () async {
                          try {
                            setState(() {
                              _expansionTileController.collapse();
                              // _isExpanded = false;
                            });
                            // تغییر دستگاه انتخاب شده
                            await mainProvider.selectDevice(device);

                            // بستن منوی کشویی بعد از انتخاب دستگاه

                          } catch (e) {
                            debugPrint('Error changing device: $e');
                          }
                        },
                        child: Container(

                          decoration: BoxDecoration(
                            color: isSelected ? Colors.blue.shade700 : null,
                            border: Border(
                              bottom: BorderSide(
                                color: index == devices.length - 1 ? Colors.transparent : Colors.white.withOpacity(0.2),
                              ),
                            ),
                          ),
                          padding: EdgeInsets.symmetric(
                              vertical: 16.h, horizontal: 16.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                device.devicePhone,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.sp,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsListItem({
    required String title,
    required IconData icon,
    required Color iconBackgroundColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[

                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.all(8.w),
                        decoration: BoxDecoration(
                          color: iconBackgroundColor,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          icon,
                          color: Colors.white,
                          size: 24.sp,
                        ),
                      ),
                      SizedBox(width: 16.w),

                      Text(
                        title,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: Colors.white.withOpacity(0.7),
                  size: 24.sp,
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Divider(
              color: Colors.white.withOpacity(0.2),
              height: 1.h,
            ),
          ],
        ),
      ),
    );
  }
}
