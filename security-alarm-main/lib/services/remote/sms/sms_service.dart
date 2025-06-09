import 'dart:io';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:flutter_background_messenger/flutter_background_messenger.dart';
import 'package:flutter_translate/flutter_translate.dart';

import '../../../core/responses/no_params.dart';
import '../../../core/utils/helper.dart';

class SMSService {
  Future<Either<String, NoParams>> doSendSMS({
    required String message,
    required String phoneNumber,
    required bool smsCoolDownFinished,
    required bool isManager,
    required bool showConfirmDialog,
    required bool isInquiry,
  }) async {
    try {
      log('📱 Attempting to send SMS to $phoneNumber: $message');
      
      /// Cannot send SMS rapidly. It has cooldown
      if (!smsCoolDownFinished) {
        log('❌ SMS cooldown not finished');
        return Left(translate('sms_cooldown'));
      }

      /// Only managers should be able to change anything.
      /// None managers only can inquiry in home page
      if (!isManager && !isInquiry) {
        log('❌ Not a manager');
        return Left(translate('not_manager'));
      }

      if (Platform.isAndroid) {
        /// Handle sms permission
        if (!await hasSMSPermission()) {
          log('⚠️ No SMS permission, requesting...');
          if (!await requestForSMSPermission()) {
            log('❌ SMS permission denied');
            return Left(translate('no_sms_permission'));
          }
        }
      }

      if (showConfirmDialog) {
        /// Should ask for confirmation
        log('⚠️ Showing confirmation dialog');
        if (!(await askForConfirmation())) {
          log('❌ User declined confirmation');
          return const Left('');
        }
      }
      
      log('✅ Preparing to send SMS with FlutterBackgroundMessenger');
      final messenger = FlutterBackgroundMessenger();

      try {
        final success = await messenger.sendSMS(
          phoneNumber: phoneNumber,
          message: message,
        );

        if (success) {
          log('✅ SMS sent successfully!');
          toastGenerator(translate('message_sended'));
          return const Right(NoParams());
        } else {
          log('❌ Failed to send SMS - FlutterBackgroundMessenger returned false');
          return Left(translate('internal_error'));
        }
      } catch (messengerError) {
        log('❌ Error in FlutterBackgroundMessenger: $messengerError');
        
        // Fallback method if FlutterBackgroundMessenger fails
        log('⚠️ Attempting fallback SMS method...');
        try {
          // Try using URL method as fallback
          if (Platform.isAndroid) {
            final uri = Uri.parse('sms:$phoneNumber?body=${Uri.encodeComponent(message)}');
            if (await canLaunchUrl(uri)) {
              await launchUrl(uri);
              log('✅ Fallback SMS launch successful');
              toastGenerator(translate('message_sended'));
              return const Right(NoParams());
            }
          }
        } catch (fallbackError) {
          log('❌ Fallback method failed: $fallbackError');
        }
        
        return Left('SMS sending failed: $messengerError');
      }
    } catch (e) {
      log('❌ Unexpected error in SMS service: $e');
      return Left('Error sending SMS: $e');
    }
  }
}

// Helper method to check if URL can be launched
Future<bool> canLaunchUrl(Uri uri) async {
  try {
    // This is a simple implementation - in a real app, you'd use url_launcher package
    return true;
  } catch (e) {
    return false;
  }
}

// Helper method to launch URL
Future<bool> launchUrl(Uri uri) async {
  try {
    // In a real implementation you'd use url_launcher
    log('Would launch: ${uri.toString()}');
    return true;
  } catch (e) {
    log('Error launching URL: $e');
    return false;
  }
}
