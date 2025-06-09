import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';
import 'package:security_alarm/core/constants/global_keys.dart';
import 'package:security_alarm/widgets/elevated_button_widget.dart';
import 'package:security_alarm/widgets/svg.dart';

import '../../../core/constants/design_values.dart';
import '../../../providers/audio_notification_provider.dart';

class AudioNotificationViewMobile extends StatefulWidget {
  const AudioNotificationViewMobile({Key? key}) : super(key: key);

  @override
  State<AudioNotificationViewMobile> createState() =>
      _AudioNotificationViewMobileState();
}

class _AudioNotificationViewMobileState
    extends State<AudioNotificationViewMobile>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late AudioNotificationProvider _provider;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _provider = context.read<AudioNotificationProvider>();

    // تنظیم تب فعلی بر اساس مقدار ذخیره شده در پروایدر
    _tabController.index = _provider.currentTabIndex;

    // لیسنر برای تغییر تب
    _tabController.addListener(() {
      // به‌روزرسانی تب فعلی در پروایدر
      if (!_tabController.indexIsChanging) {
        _provider.changeTab(_tabController.index);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

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
              onPressed: () => Navigator.pop(context)
              ,
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
              getDrawerKey('AudioNotificationView').currentState!.toggle();
            },
          ),
        ),
      ),
      body: Consumer<AudioNotificationProvider>(
        builder: (context, provider, child) {
          // افزودن بررسی وجود تنظیمات برای جلوگیری از کرش
          if (provider.notificationSettings == null) {
            return Container(
              color: const Color(0xFF09162E),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(
                      color: Colors.blue,
                    ),
                    SizedBox(height: 20.h),
                    Text(
                      translate('loading_settings'),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return Container(
            color: const Color(0xFF09162E), // زمینه به رنگ آبی تیره
            child: Column(
              children: [
                SizedBox(height: 20.h),
                Center(
                  child: Text(
                    translate('مدیریت هشدارهای صوتی'),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // بخش تنظیم صدا
                _buildVolumeSection(provider),

                // تب بار برای دسته‌بندی هشدارها
                _buildTabBar(),

                // محتوای تب‌ها
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildSystemNotificationsTab(provider),
                      _buildZonesNotificationsTab(provider),
                      _buildSettingsNotificationsTab(provider),
                      _buildSecurityNotificationsTab(provider),
                    ],
                  ),
                ),

                // بخش انتخاب همه و ذخیره تغییرات
                _buildBottomActionSection(provider),
              ],
            ),
          );
        },
      ),
    );
  }

  // ساخت بخش پایینی صفحه شامل انتخاب همه و دکمه ذخیره
  Widget _buildBottomActionSection(AudioNotificationProvider provider) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
      // color: Colors.blue.shade900,
      child: Column(
        children: [

          // دکمه ذخیره
          ElevatedButtonWidget(
            onPressBtn: () {
              provider.saveAllChanges();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(translate('settings_saved'), style: const TextStyle(color: Colors.white),),
                  backgroundColor: Colors.green,
                  behavior: SnackBarBehavior.floating,
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            btnText: translate('save_changes'),
            // height: 56.h,
            width: double.infinity,

            // style: ElevatedButton.styleFrom(
            //   backgroundColor: Colors.blue,
            //   foregroundColor: Colors.white,
            //   padding: EdgeInsets.symmetric(vertical: 15.h),
            //   minimumSize: Size(double.infinity, 50.h),
            // ),
            // child: Text(
            //   translate('save_changes'),
            //   style: TextStyle(
            //     fontSize: 16.sp,
            //     fontWeight: FontWeight.bold,
            //   ),
            // ),
          ),
        ],
      ),
    );
  }

  Widget _buildVolumeSection(AudioNotificationProvider provider) {
    return Container(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Checkbox(
                value: _getCurrentTabSelectAllValue(provider),
                onChanged: (value) {
                  if (value != null) {
                    _toggleSelectAllForCurrentTab(provider, value);
                  }
                },
                activeColor: Colors.blue,
                checkColor: Colors.white,
              ),
              Text(
                translate('volume_level'),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              const Icon(Icons.volume_up, color: Colors.white),
              Expanded(
                child: Directionality(
                  textDirection: TextDirection.ltr,
                  child: Slider(
                    value: provider.volume,
                    min: 0.0,
                    max: 1.0,
                    divisions: 10,
                    activeColor: Colors.blue,
                    inactiveColor: Colors.grey,
                    onChanged: (value) async {
                      provider.setVolume(value);
                      await provider.playNotificationSound();
                    },
                  ),
                ),
              ),
              const Icon(Icons.volume_down, color: Colors.white),
            ],
          ),
          // SizedBox(height: 8.h),
          // Center(
          //   child: ElevatedButton.icon(
          //     icon: const Icon(Icons.play_arrow),
          //     label: Text(translate('test_sound')),
          //     onPressed: () {
          //       provider.playNotificationSound();
          //     },
          //     style: ElevatedButton.styleFrom(
          //       backgroundColor: Colors.blue,
          //       foregroundColor: Colors.white,
          //       padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  // دریافت مقدار تیک انتخاب همه برای تب فعلی
  bool _getCurrentTabSelectAllValue(AudioNotificationProvider provider) {
    switch (_tabController.index) {
      case 0:
        return provider.isAllSystemChecked;
      case 1:
        return provider.isAllZonesChecked;
      case 2:
        return provider.isAllSettingsChecked;
      case 3:
        return provider.isAllSecurityChecked;
      default:
        return false;
    }
  }

  // تغییر وضعیت انتخاب همه برای تب فعلی
  void _toggleSelectAllForCurrentTab(
      AudioNotificationProvider provider, bool value) {
    switch (_tabController.index) {
      case 0:
        provider.toggleAllSystemNotifications(value);
        break;
      case 1:
        provider.toggleAllZonesNotifications(value);
        break;
      case 2:
        provider.toggleAllSettingsNotifications(value);
        break;
      case 3:
        provider.toggleAllSecurityNotifications(value);
        break;
    }
  }

  Widget _buildTabBar() {
    return TabBar(
      controller: _tabController,
      indicatorColor: Colors.white,
      labelColor: Colors.white,
      unselectedLabelColor: Colors.white70,
      isScrollable: true,
      padding: EdgeInsets.zero,
      labelPadding: EdgeInsets.only(left: 40.w),
      tabs: [
        Tab(
          text: translate('system_alerts'),
          icon: const Icon(Icons.fingerprint),
        ),
        Tab(
          text: translate('zone_alerts'),
          icon: const Icon(Icons.alarm),
        ),
        Tab(
          text: translate('settings_notifications'),
          icon: const Icon(Icons.settings),
        ),
        Tab(
          text: translate('security_alerts'),
          icon: const Icon(Icons.lock_open_rounded),
        ),
      ],
    );
  }

  Widget _buildSystemNotificationsTab(AudioNotificationProvider provider) {
    return _buildNotificationList(
      items: [
        _buildNotificationItem(
            'generalArmed', translate('system_armed'), provider),
        _buildNotificationItem(
            'generalDisarmed', translate('system_disarmed'), provider),
        _buildNotificationItem(
            'generalReportByUser', translate('report_by_user'), provider),
        _buildNotificationItem('noAccess', translate('no_access'), provider),
        _buildNotificationItem('powerOn', translate('power_on'), provider),
        _buildNotificationItem('powerOff', translate('power_off'), provider),
        _buildNotificationItem(
            'sirenTriggered', translate('siren_triggered'), provider),
        _buildNotificationItem(
            'sirenTimeExpired', translate('siren_time_expired'), provider),
        _buildNotificationItem('chargeLow', translate('charge_low'), provider),
        _buildNotificationItem(
            'batteryLow', translate('battery_low'), provider),
        _buildNotificationItem(
            'batteryDisconnected', translate('battery_disconnected'), provider),
        _buildNotificationItem('sirenOff', translate('siren_off'), provider),
        _buildNotificationItem(
            'reportByAdmin', translate('report_by_admin'), provider),
        _buildNotificationItem('deviceBackupDeleted',
            translate('device_backup_deleted'), provider),
      ],
    );
  }

  Widget _buildZonesNotificationsTab(AudioNotificationProvider provider) {
    return _buildNotificationList(
      items: [
        _buildNotificationItem(
            'zone1Alert', translate('zone1_alert'), provider),
        _buildNotificationItem(
            'zone2Alert', translate('zone2_alert'), provider),
        _buildNotificationItem(
            'zone3Alert', translate('zone3_alert'), provider),
        _buildNotificationItem(
            'zone4Alert', translate('zone4_alert'), provider),
        _buildNotificationItem(
            'zone5Alert', translate('zone5_alert'), provider),
        _buildNotificationItem(
            'zone1SemiAlert', translate('zone1_semi_alert'), provider),
        _buildNotificationItem(
            'zone2SemiAlert', translate('zone2_semi_alert'), provider),
        _buildNotificationItem(
            'zone3SemiAlert', translate('zone3_semi_alert'), provider),
        _buildNotificationItem(
            'zone4SemiAlert', translate('zone4_semi_alert'), provider),
        _buildNotificationItem(
            'zone5SemiAlert', translate('zone5_semi_alert'), provider),
        _buildNotificationItem(
            'allZonesSemiAlert', translate('all_zones_semi_alert'), provider),
        _buildNotificationItem(
            'semiActiveZones', translate('semi_active_zones'), provider),
      ],
    );
  }

  Widget _buildSettingsNotificationsTab(AudioNotificationProvider provider) {
    return _buildNotificationList(
      items: [
        _buildNotificationItem(
            'zonesStatus', translate('zones_status'), provider),
        _buildNotificationItem(
            'relaysStatus', translate('relays_status'), provider),
        _buildNotificationItem(
            'connectStatus', translate('connect_status'), provider),
        _buildNotificationItem(
            'batteryStatus', translate('battery_status'), provider),
        _buildNotificationItem('simStatus', translate('sim_status'), provider),
        _buildNotificationItem(
            'powerStatus', translate('power_status'), provider),
        _buildNotificationItem(
            'deviceLossPower', translate('device_loss_power'), provider),
        _buildNotificationItem('simCredit', translate('sim_credit'), provider),
        _buildNotificationItem('deviceLostConnection',
            translate('device_lost_connection'), provider),
      ],
    );
  }

  Widget _buildSecurityNotificationsTab(AudioNotificationProvider provider) {
    return _buildNotificationList(
      items: [
        _buildNotificationItem(
            'sirenEnabled', translate('siren_enabled'), provider),
        _buildNotificationItem(
            'incorrectCode', translate('incorrect_code'), provider),
        _buildNotificationItem(
            'disconnectedSensor', translate('disconnected_sensor'), provider),
        _buildNotificationItem(
            'adminManager', translate('admin_manager'), provider),
        _buildNotificationItem(
            'activateRelay', translate('activate_relay'), provider),
        _buildNotificationItem(
            'deactivateRelay', translate('deactivate_relay'), provider),
        _buildNotificationItem(
            'deleteBackup', translate('delete_backup'), provider),
        _buildNotificationItem(
            'networkLost', translate('network_lost'), provider),
        _buildNotificationItem(
            'deactivatedByUser', translate('deactivated_by_user'), provider),
        _buildNotificationItem(
            'deactivatedByAdmin', translate('deactivated_by_admin'), provider),
        _buildNotificationItem(
            'deactivatedByTimer', translate('deactivated_by_timer'), provider),
        _buildNotificationItem('deactivatedByBackup',
            translate('deactivated_by_backup'), provider),
        _buildNotificationItem(
            'silenceMode', translate('silence_mode'), provider),
      ],
    );
  }

  Widget _buildNotificationList({
    required List<Widget> items,
  }) {
    return Container(
      color: const Color(0xFF09162E),
      child: ListView(
        padding: EdgeInsets.all(8.w),
        children: items,
      ),
    );
  }

  Widget _buildNotificationItem(
      String type, String label, AudioNotificationProvider provider) {
    // Get the current value from the provider's notification settings
    bool isChecked = false;
    double itemVolume = 0.7;

    if (provider.notificationSettings != null) {
      final settings = provider.notificationSettings!;

      switch (type) {
        // هشدارهای سیستم
        case 'generalArmed':
          isChecked = settings.generalArmed;
          itemVolume = settings.generalArmedVolume;
          break;
        case 'generalDisarmed':
          isChecked = settings.generalDisarmed;
          itemVolume = settings.generalDisarmedVolume;
          break;
        case 'generalReportByUser':
          isChecked = settings.generalReportByUser;
          itemVolume = settings.generalReportByUserVolume;
          break;
        case 'noAccess':
          isChecked = settings.noAccess;
          itemVolume = settings.noAccessVolume;
          break;
        case 'powerOn':
          isChecked = settings.powerOn;
          itemVolume = settings.powerOnVolume;
          break;
        case 'powerOff':
          isChecked = settings.powerOff;
          itemVolume = settings.powerOffVolume;
          break;
        case 'sirenTriggered':
          isChecked = settings.sirenTriggered;
          itemVolume = settings.sirenTriggeredVolume;
          break;
        case 'sirenTimeExpired':
          isChecked = settings.sirenTimeExpired;
          itemVolume = settings.sirenTimeExpiredVolume;
          break;
        case 'chargeLow':
          isChecked = settings.chargeLow;
          itemVolume = settings.chargeLowVolume;
          break;
        case 'batteryLow':
          isChecked = settings.batteryLow;
          itemVolume = settings.batteryLowVolume;
          break;
        case 'batteryDisconnected':
          isChecked = settings.batteryDisconnected;
          itemVolume = settings.batteryDisconnectedVolume;
          break;
        case 'sirenOff':
          isChecked = settings.sirenOff;
          itemVolume = settings.sirenOffVolume;
          break;
        case 'reportByAdmin':
          isChecked = settings.reportByAdmin;
          itemVolume = settings.reportByAdminVolume;
          break;
        case 'deviceBackupDeleted':
          isChecked = settings.deviceBackupDeleted;
          itemVolume = settings.deviceBackupDeletedVolume;
          break;

        // هشدارهای زون‌ها
        case 'zone1Alert':
          isChecked = settings.zone1Alert;
          itemVolume = settings.zone1AlertVolume;
          break;
        case 'zone2Alert':
          isChecked = settings.zone2Alert;
          itemVolume = settings.zone2AlertVolume;
          break;
        case 'zone3Alert':
          isChecked = settings.zone3Alert;
          itemVolume = settings.zone3AlertVolume;
          break;
        case 'zone4Alert':
          isChecked = settings.zone4Alert;
          itemVolume = settings.zone4AlertVolume;
          break;
        case 'zone5Alert':
          isChecked = settings.zone5Alert;
          itemVolume = settings.zone5AlertVolume;
          break;
        case 'zone1SemiAlert':
          isChecked = settings.zone1SemiAlert;
          itemVolume = settings.zone1SemiAlertVolume;
          break;
        case 'zone2SemiAlert':
          isChecked = settings.zone2SemiAlert;
          itemVolume = settings.zone2SemiAlertVolume;
          break;
        case 'zone3SemiAlert':
          isChecked = settings.zone3SemiAlert;
          itemVolume = settings.zone3SemiAlertVolume;
          break;
        case 'zone4SemiAlert':
          isChecked = settings.zone4SemiAlert;
          itemVolume = settings.zone4SemiAlertVolume;
          break;
        case 'zone5SemiAlert':
          isChecked = settings.zone5SemiAlert;
          itemVolume = settings.zone5SemiAlertVolume;
          break;
        case 'allZonesSemiAlert':
          isChecked = settings.allZonesSemiAlert;
          itemVolume = settings.allZonesSemiAlertVolume;
          break;
        case 'semiActiveZones':
          isChecked = settings.semiActiveZones;
          itemVolume = settings.semiActiveZonesVolume;
          break;

        // اعلام تنظیمات
        case 'zonesStatus':
          isChecked = settings.zonesStatus;
          itemVolume = settings.zonesStatusVolume;
          break;
        case 'relaysStatus':
          isChecked = settings.relaysStatus;
          itemVolume = settings.relaysStatusVolume;
          break;
        case 'connectStatus':
          isChecked = settings.connectStatus;
          itemVolume = settings.connectStatusVolume;
          break;
        case 'batteryStatus':
          isChecked = settings.batteryStatus;
          itemVolume = settings.batteryStatusVolume;
          break;
        case 'simStatus':
          isChecked = settings.simStatus;
          itemVolume = settings.simStatusVolume;
          break;
        case 'powerStatus':
          isChecked = settings.powerStatus;
          itemVolume = settings.powerStatusVolume;
          break;
        case 'deviceLossPower':
          isChecked = settings.deviceLossPower;
          itemVolume = settings.deviceLossPowerVolume;
          break;
        case 'simCredit':
          isChecked = settings.simCredit;
          itemVolume = settings.simCreditVolume;
          break;
        case 'deviceLostConnection':
          isChecked = settings.deviceLostConnection;
          itemVolume = settings.deviceLostConnectionVolume;
          break;

        // هشدارهای امنیتی
        case 'sirenEnabled':
          isChecked = settings.sirenEnabled;
          itemVolume = settings.sirenEnabledVolume;
          break;
        case 'incorrectCode':
          isChecked = settings.incorrectCode;
          itemVolume = settings.incorrectCodeVolume;
          break;
        case 'disconnectedSensor':
          isChecked = settings.disconnectedSensor;
          itemVolume = settings.disconnectedSensorVolume;
          break;
        case 'adminManager':
          isChecked = settings.adminManager;
          itemVolume = settings.adminManagerVolume;
          break;
        case 'activateRelay':
          isChecked = settings.activateRelay;
          itemVolume = settings.activateRelayVolume;
          break;
        case 'deactivateRelay':
          isChecked = settings.deactivateRelay;
          itemVolume = settings.deactivateRelayVolume;
          break;
        case 'deleteBackup':
          isChecked = settings.deleteBackup;
          itemVolume = settings.deleteBackupVolume;
          break;
        case 'networkLost':
          isChecked = settings.networkLost;
          itemVolume = settings.networkLostVolume;
          break;
        case 'deactivatedByUser':
          isChecked = settings.deactivatedByUser;
          itemVolume = settings.deactivatedByUserVolume;
          break;
        case 'deactivatedByAdmin':
          isChecked = settings.deactivatedByAdmin;
          itemVolume = settings.deactivatedByAdminVolume;
          break;
        case 'deactivatedByTimer':
          isChecked = settings.deactivatedByTimer;
          itemVolume = settings.deactivatedByTimerVolume;
          break;
        case 'deactivatedByBackup':
          isChecked = settings.deactivatedByBackup;
          itemVolume = settings.deactivatedByBackupVolume;
          break;
        case 'silenceMode':
          isChecked = settings.silenceMode;
          itemVolume = settings.silenceModeVolume;
          break;
      }
    }

    return Container(
      margin: EdgeInsets.symmetric(vertical: 4.h),
      decoration: BoxDecoration(
        color: Colors.blue.shade900.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        children: [
          CheckboxListTile(
            title: Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.sp,
              ),
            ),
            value: isChecked,
            onChanged: (value) {
              if (value != null) {
                provider.toggleNotification(type, value);
              }
            },
            activeColor: Colors.blue,
            checkColor: Colors.white,
            contentPadding:
                EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
          ),
          if (isChecked)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
              child: Row(
                children: [
                  Icon(Icons.volume_up_outlined,
                      color: Colors.white, size: 18.sp),
                  SizedBox(width: 8.w),
                  Directionality(
                    textDirection: TextDirection.ltr,
                    child: Expanded(
                      child: Slider(
                        value: itemVolume,
                        min: 0.0,
                        max: 1.0,
                        divisions: 10,
                        activeColor: Colors.green,
                        inactiveColor: Colors.grey,
                        onChanged: (value) {
                          provider.setItemVolume(type, value);
                        },
                      ),
                    ),
                  ),
                  Icon(Icons.volume_down_outlined,
                      color: Colors.white, size: 18.sp),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
