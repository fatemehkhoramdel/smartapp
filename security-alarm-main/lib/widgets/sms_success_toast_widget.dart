import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';

import '../core/constants/global_keys.dart';

class SmsSuccessToastWidget extends StatelessWidget {
  final String message;
  
  const SmsSuccessToastWidget({
    Key? key, 
    this.message = '',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(8.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check,
              color: Colors.white,
              size: 24.sp,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              message.isNotEmpty 
                  ? message 
                  : translate('پیامک ارسال شد و تغییرات اعمال گردید'),
              style: TextStyle(
                color: Colors.black87,
                fontSize: 14.sp,
              ),
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
            ),
          ),
        ],
      ),
    );
  }
}

/// A method to show the success toast
void showSmsSuccessToast(BuildContext context, {String message = ''}) {
  // Use the global navigator key's context to ensure we have access to the overlay
  final navigatorContext = kNavigatorKey.currentContext!;
  final overlay = Overlay.of(navigatorContext);
  
  if (overlay == null) {
    // Fallback if overlay is still null
    ScaffoldMessenger.of(navigatorContext).showSnackBar(
      SnackBar(
        content: Text(
          message.isNotEmpty 
              ? message 
              : translate('پیامک ارسال شد و تغییرات اعمال گردید'),
          textAlign: TextAlign.right,
          textDirection: TextDirection.rtl,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
    return;
  }
  
  final overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      bottom: 20.h,
      left: 16.w,
      right: 16.w,
      child: SmsSuccessToastWidget(message: message),
    ),
  );
  
  // Add the overlay and remove after 3 seconds
  overlay.insert(overlayEntry);
  Future.delayed(const Duration(seconds: 3), () {
    overlayEntry.remove();
  });
} 