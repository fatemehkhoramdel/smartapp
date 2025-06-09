import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';

import '../core/constants/global_keys.dart';
import '../core/utils/helper.dart';

class SmsErrorDialogWidget extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  final VoidCallback onCancel;
  
  const SmsErrorDialogWidget({
    Key? key, 
    this.message = '',
    required this.onRetry,
    required this.onCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Center(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20.w),
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: const Color(0xFF09162E),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Yellow hexagon with X
                Container(
                  width: 100.w,
                  height: 100.w,
                  margin: EdgeInsets.only(bottom: 40.h),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Hexagon shape
                      CustomPaint(
                        size: Size(100.w, 100.w),
                        painter: HexagonPainter(color: Colors.yellow),
                      ),
                      // X icon
                      Icon(
                        Icons.close,
                        color: Colors.yellow,
                        size: 40.sp,
                      ),
                    ],
                  ),
                ),
                
                // Error message
                Text(
                  message.isNotEmpty 
                      ? message 
                      : translate('متاسفانه مشکلی پیش آمده و تغییرات اعمال نشد دوباره امتحان کنید'),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                  ),
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.rtl,
                ),
                
                SizedBox(height: 40.h),
                
                // Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Cancel button
                    TextButton(
                      onPressed: onCancel,
                      child: Text(
                        translate('انصراف'),
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 16.sp,
                        ),
                      ),
                    ),
                    
                    // Retry button
                    ElevatedButton(
                      onPressed: onRetry,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                          vertical: 10.h,
                        ),
                      ),
                      child: Text(
                        translate('ارسال مجدد'),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Hexagon painter for custom shape
class HexagonPainter extends CustomPainter {
  final Color color;
  
  HexagonPainter({required this.color});
  
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.transparent
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..color = color;
    
    final Path path = Path();
    final double width = size.width;
    final double height = size.height;
    final double centerX = width / 2;
    final double centerY = height / 2;
    final double radius = width / 2;
    
    // Create hexagon path
    for (int i = 0; i < 6; i++) {
      double angle = (i * 60) * 3.14159 / 180;
      double x = centerX + radius * cos(angle);
      double y = centerY + radius * sin(angle);
      
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    
    canvas.drawPath(path, paint);
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// A method to show the error dialog
Future<void> showSmsErrorDialog(
  BuildContext context, {
  String message = '',
  required VoidCallback onRetry,
}) async {
  try {
    final navigatorContext = kNavigatorKey.currentContext!;
    
    return showDialog<void>(
      context: navigatorContext,
      barrierDismissible: false,
      builder: (context) => SmsErrorDialogWidget(
        message: message,
        onRetry: () {
          Navigator.of(context).pop();
          onRetry();
        },
        onCancel: () {
          Navigator.of(context).pop();
        },
      ),
    );
  } catch (e) {
    debugPrint('Error showing SMS error dialog: $e');
    // Fallback to toast
    toastGenerator(message.isNotEmpty ? message : translate('متاسفانه مشکلی پیش آمده و تغییرات اعمال نشد'));
    return Future.value();
  }
} 