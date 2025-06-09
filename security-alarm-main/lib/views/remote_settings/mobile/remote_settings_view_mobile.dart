import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:security_alarm/core/constants/global_keys.dart';

import '../../../config/routes/app_routes.dart';

class RemoteSettingsViewMobile extends StatelessWidget {
  const RemoteSettingsViewMobile({Key? key}) : super(key: key);

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
              getDrawerKey('RemoteSettingsView').currentState!.toggle();
            },
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Title
            Center(
              child: Text(
                translate('remote_settings'),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 40),
            // Options List
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildOptionItem(
                      context,
                      'inactive_remotes_inquiry',
                      Icons.question_mark,
                      Colors.purple,
                      () {
                        // Handle inquiry for inactive remotes
                        _showSendSMSDialog(context, 'inactive_remotes_inquiry');
                      },
                    ),
                    const SizedBox(height: 20),
                    _buildOptionItem(
                      context,
                      'select_remote_operation_mode',
                      Icons.settings_applications,
                      Colors.red,
                      () {
                        Navigator.pushNamed(context, AppRoutes.remoteOperationModeRoute);
                      },
                    ),
                    const SizedBox(height: 20),
                    _buildOptionItem(
                      context,
                      'manage_remote_names',
                      Icons.edit,
                      Colors.orange,
                      () {
                        Navigator.pushNamed(context, AppRoutes.remoteNameManagementRoute);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionItem(
    BuildContext context, 
    String titleKey, 
    IconData icon, 
    Color iconColor, 
    VoidCallback onTap
  ) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 15.h,),
        // decoration: BoxDecoration(
        //   color: Colors.black.withOpacity(0.3),
        //   borderRadius: BorderRadius.circular(10.r),
        //   border: Border.all(color: Colors.blue.withOpacity(0.3)),
        // ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(10.w),
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
                  const SizedBox(width: 15),
                  Text(
                    translate(titleKey),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.arrow_forward_ios, color: Colors.white),
              onPressed: onTap,
            ),
          ],
        ),
      ),
    );
  }

  void _showSendSMSDialog(BuildContext context, String operationType) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF09162E),
        title: Text(
          translate('send_sms_confirmation'),
          style: const TextStyle(color: Colors.white),
        ),
        content: Text(
          translate('confirm_send_sms_for_operation'),
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              translate('cancel'),
              style: const TextStyle(color: Colors.white),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // TODO: Implement SMS sending logic
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(translate('sms_sent_successfully'))),
              );
            },
            child: Text(
              translate('send'),
              style: const TextStyle(color: Colors.green),
            ),
          ),
        ],
      ),
    );
  }
} 