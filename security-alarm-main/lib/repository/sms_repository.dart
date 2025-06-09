import 'package:dartz/dartz.dart';

import '../core/responses/no_params.dart';
import '../services/remote/sms/sms_service.dart';

class SMSRepository {
  final SMSService _smsService;

  const SMSRepository(this._smsService);

  Future<Either<String, NoParams>> doSendSMS({
    required String message,
    required String phoneNumber,
    required bool smsCoolDownFinished,
    required bool isManager,
    bool showConfirmDialog = true,
    bool isInquiry = false,
  }) async {
    return await _smsService.doSendSMS(
      message: message,
      phoneNumber: phoneNumber,
      smsCoolDownFinished: smsCoolDownFinished,
      isManager: isManager,
      showConfirmDialog: showConfirmDialog,
      isInquiry: isInquiry,
    );
  }
}
