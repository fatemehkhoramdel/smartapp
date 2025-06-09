import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

import '../../injector.dart';
import '../../repository/sms_repository.dart';
import '../../widgets/sms_error_dialog_widget.dart';
import '../../widgets/sms_loading_overlay_widget.dart';
import '../../widgets/sms_success_toast_widget.dart';
import '../constants/global_keys.dart';
import '../responses/no_params.dart';
import 'helper.dart';

class SmsHelper {
  /// Send SMS with UI feedback (loading, success, error states)
  static Future<Either<String, NoParams>> sendSmsWithUI({
    required String message,
    required String phoneNumber,
    required bool smsCoolDownFinished,
    required bool isManager,
    bool showConfirmDialog = true,
    bool isInquiry = false,
  }) async {
    final context = kNavigatorKey.currentContext!;
    
    // Show loading overlay
    showSmsLoadingOverlay(context);
    
    // Send SMS
    final result = await injector<SMSRepository>().doSendSMS(
      message: message,
      phoneNumber: phoneNumber,
      smsCoolDownFinished: smsCoolDownFinished,
      isManager: isManager,
      showConfirmDialog: showConfirmDialog,
      isInquiry: isInquiry,
    );
    
    // Hide loading overlay - Wrap in try-catch in case context is no longer valid
    try {
      hideSmsLoadingOverlay(context);
    } catch (e) {
      debugPrint('Error hiding SMS loading overlay: $e');
    }
    
    // Handle result
    return result.fold(
      (error) async {
        // On error, show error dialog with retry option
        if (error.isNotEmpty) {
          try {
            await showSmsErrorDialog(
              context,
              message: error,
              onRetry: () async {
                // Retry sending the SMS
                await sendSmsWithUI(
                  message: message,
                  phoneNumber: phoneNumber,
                  smsCoolDownFinished: smsCoolDownFinished,
                  isManager: isManager,
                  showConfirmDialog: false, // Don't show confirmation again
                  isInquiry: isInquiry,
                );
              },
            );
          } catch (e) {
            debugPrint('Error showing SMS error dialog: $e');
            // Fallback to simple toast
            toastGenerator(error);
          }
        }
        return Left(error);
      },
      (success) {
        // On success, show success toast
        try {
          showSmsSuccessToast(context);
        } catch (e) {
          debugPrint('Error showing SMS success toast: $e');
          // Fallback to simple toast
          toastGenerator(translate('پیامک ارسال شد و تغییرات اعمال گردید'));
        }
        return Right(success);
      },
    );
  }
} 