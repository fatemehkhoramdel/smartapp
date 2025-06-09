import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';
import 'package:security_alarm/core/constants/global_keys.dart';
import 'package:security_alarm/injector.dart';
import 'package:security_alarm/repository/sms_repository.dart';

import '../../../core/utils/helper.dart';
import '../../../providers/general_settings_provider.dart';
import '../../../providers/main_provider.dart';
import '../../../providers/sms_provider.dart';

class GeneralSettingsViewMobile extends StatefulWidget {
  const GeneralSettingsViewMobile({Key? key}) : super(key: key);

  @override
  State<GeneralSettingsViewMobile> createState() => _GeneralSettingsViewMobileState();
}

class _GeneralSettingsViewMobileState extends State<GeneralSettingsViewMobile> {
  late GeneralSettingsProvider _provider;
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      final mainProvider = Provider.of<MainProvider>(context);
      _provider = GeneralSettingsProvider(mainProvider.selectedDevice);
      _isInitialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _provider,
      child: Scaffold(
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
                getDrawerKey('GeneralSettingsView').currentState!.toggle();
              },
            ),
          ),
        ),
        body: Consumer<GeneralSettingsProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return Center(child: CircularProgressIndicator());
            }
            
            return SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20.h),
                      // Title
                      Center(
                        child: Text(
                          translate('general_settings'),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 40.h),
                      
                      // Alarm Duration Slider
                      _buildDurationSlider(
                        title: translate('alarm_duration'),
                        value: provider.alarmDuration,
                        min: 10,
                        max: 300,
                        onChanged: provider.setAlarmDuration,
                      ),
                      SizedBox(height: 30.h),
                      
                      // Call Duration Slider
                      _buildDurationSlider(
                        title: translate('call_duration'),
                        value: provider.callDuration,
                        min: 5,
                        max: 60,
                        onChanged: provider.setCallDuration,
                      ),
                      SizedBox(height: 20.h),
                      
                      // Other Settings Section
                      Text(
                        translate('other_settings'),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20.h),
                      
                      // Control Relays With Remote
                      _buildToggleSwitch(
                        title: translate('control_relays_with_remote'),
                        value: provider.controlRelaysWithRemote,
                        onChanged: provider.setControlRelaysWithRemote,
                      ),
                      Divider(color: Colors.white30),
                      // Monitoring
                      _buildToggleSwitch(
                        title: translate('monitoring'),
                        value: provider.monitoring,
                        onChanged: provider.setMonitoring,
                      ),
                      Divider(color: Colors.white30),
                      // Remote Reporting
                      _buildToggleSwitch(
                        title: translate('remote_reporting'),
                        value: provider.remoteReporting,
                        onChanged: provider.setRemoteReporting,
                      ),
                      Divider(color: Colors.white30),
                      // Scenario/Schedule Reporting
                      _buildToggleSwitch(
                        title: translate('scenario_schedule_reporting'),
                        value: provider.scenarioScheduleReporting,
                        onChanged: provider.setScenarioScheduleReporting,
                      ),
                      
                      // SizedBox(height: 10.h),
                      Divider(color: Colors.white30),
                      // SizedBox(height: 10.h),
                      
                      // Alert Priority Section
                      Row(
                        children: [
                          Text(
                            translate('change_alert_priority'),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12.sp,
                            ),
                          ),
                          SizedBox(width: 20.w),

                          // Call Priority
                          _buildCheckbox(
                            title: translate('call'),
                            value: provider.callPriority,
                            onChanged: provider.setCallPriority,
                          ),

                          // SMS Priority
                          _buildCheckbox(
                            title: translate('sms'),
                            value: provider.smsPriority,
                            onChanged: provider.setSmsPriority,
                          ),
                        ],
                      ),
                      // Divider(color: Colors.white30),
                      SizedBox(height: 40.h),
                      
                      // Save Button
                      Center(
                        child: ElevatedButton(
                          onPressed: provider.isSaving ? null : _saveSettings,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purple,
                            minimumSize: Size(200.w, 50.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25.r),
                            ),
                          ),
                          child: provider.isSaving
                              ? CircularProgressIndicator(color: Colors.white)
                              : Text(
                                  translate('send'),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18.sp,
                                  ),
                                ),
                        ),
                      ),
                      SizedBox(height: 20.h),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildDurationSlider({
    required String title,
    required double value,
    required double min,
    required double max,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
              ),
            ),
            Text(
              '${value.toInt()}',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        SizedBox(height: 10.h),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: Colors.blue,
            inactiveTrackColor: Colors.blue.withOpacity(0.3),
            thumbColor: Colors.white,
            overlayColor: Colors.blue.withOpacity(0.3),
            valueIndicatorColor: Colors.blue,
            valueIndicatorTextStyle: TextStyle(color: Colors.white),
          ),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Slider(
              value: value,
              min: min,
              max: max,
              divisions: ((max - min) / 5).round(),
              label: '${value.toInt()}',
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildToggleSwitch({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.sp,
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.blue,
            activeTrackColor: Colors.blue.withOpacity(0.5),
            inactiveThumbColor: Colors.grey,
            inactiveTrackColor: Colors.grey.withOpacity(0.5),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckbox({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.sp,
            ),
          ),
          Checkbox(
            value: value,
            onChanged: (newValue) {
              if (newValue != null) {
                onChanged(newValue);
              }
            },
            activeColor: Colors.blue,
            checkColor: Colors.white,
          ),
        ],
      ),
    );
  }

  Future<void> _saveSettings() async {
    log('111111111111111');
    final success = await _provider.saveSettings(context);
    
    if (success) {
      _showSendSMSDialog(context);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(translate('error_saving_changes'))),
        );
      }
    }
  }

  void _showSendSMSDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF09162E),
        title: Text(
          translate('send_sms_confirmation'),
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          translate('confirm_send_sms_for_operation'),
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              translate('cancel'),
              style: TextStyle(color: Colors.white),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _sendSettingsSms();
            },
            child: Text(
              translate('send'),
              style: TextStyle(color: Colors.green),
            ),
          ),
        ],
      ),
    );
  }
  
  void _sendSettingsSms() {
    final mainProvider = Provider.of<MainProvider>(context, listen: false);
    if (mainProvider.selectedDevice == null || mainProvider.selectedDevice.devicePhone == null) {
      toastGenerator(translate('no_device_selected'));
      return;
    }
    
    final phoneNumber = mainProvider.selectedDevice.devicePhone;
    final List<String> commands = [];
    
    // Monitoring
    if (_provider.monitoring) {
      commands.add('mic=1');
    } else {
      commands.add('mic=0');
    }
    
    // Control relays with remote
    if (_provider.controlRelaysWithRemote) {
      commands.add('hnde');
    } else {
      commands.add('hndd');
    }
    
    // Remote reporting
    if (_provider.remoteReporting) {
      commands.add('rep1');
    } else {
      commands.add('rep0');
    }
    
    // Scenario/Schedule reporting
    if (_provider.scenarioScheduleReporting) {
      commands.add('repst1');
    } else {
      commands.add('repst0');
    }
    
    // Create message with all commands
    final message = commands.join('\n');
    
    // Send SMS
    _sendSms(phoneNumber, message);
  }
  
  Future<void> _sendSms(String phoneNumber, String message) async {
    try {
      // Get the SMS service from provider
      // final smsProvider = Provider.of<SmsProvider>(context, listen: false);
      // Use main provider's doSendSMS method
      // final mainProvider = Provider.of<MainProvider>(context, listen: false);

      await injector<SMSRepository>().doSendSMS(
        message: message,
        phoneNumber: phoneNumber,
        smsCoolDownFinished: true,
        isManager: true,
        showConfirmDialog: false,
      ).then((result) {
        result.fold(
          (failure) => toastGenerator(failure),
          // (_) => toastGenerator(translate('sms_sent_successfully')),
          (_) => Navigator.pop(context),
        );
      });
    } catch (e) {
      toastGenerator('${translate('error_sending_sms')}: $e');
    }
  }
} 