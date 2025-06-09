import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animations/loading_animations.dart';

import '../core/constants/global_keys.dart';

class SmsLoadingOverlayWidget extends StatelessWidget {
  const SmsLoadingOverlayWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          color: Colors.black.withOpacity(0.1),
          width: double.infinity,
          height: double.infinity,
          child: Center(
            child: LoadingBouncingGrid.circle(
              backgroundColor: Colors.blue,
              size: 50.w,
            ),
          ),
        ),
      ),
    );
  }
}

/// A method to show the loading overlay as a dialog
void showSmsLoadingOverlay(BuildContext context) {
  try {
    final navigatorContext = kNavigatorKey.currentContext!;
    
    showDialog(
      context: navigatorContext,
      barrierDismissible: false,
      barrierColor: Colors.transparent,
      builder: (context) => const SmsLoadingOverlayWidget(),
    );
  } catch (e) {
    debugPrint('Error showing SMS loading overlay: $e');
  }
}

/// A method to hide the loading overlay
void hideSmsLoadingOverlay(BuildContext context) {
  try {
    final navigatorContext = kNavigatorKey.currentContext!;
    Navigator.of(navigatorContext).pop();
  } catch (e) {
    debugPrint('Error hiding SMS loading overlay: $e');
    // Try with provided context as fallback
    try {
      Navigator.of(context).pop();
    } catch (e) {
      debugPrint('Error hiding SMS loading overlay with provided context: $e');
    }
  }
} 