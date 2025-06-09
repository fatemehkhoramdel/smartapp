import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart' as sms;
import 'package:permission_handler/permission_handler.dart';
import '../models/sms_message.dart';
import '../providers/main_provider.dart';
import '../core/utils/helper.dart';

class SmsProvider extends ChangeNotifier {
  final MainProvider? _mainProvider;
  List<SmsMessage> _smsMessages = [];
  List<SmsMessage> _filteredMessages = [];
  bool _isLoading = false;
  String? _errorMessage;

  SmsProvider(this._mainProvider);

  // Getters
  List<SmsMessage> get smsMessages => _smsMessages;
  List<SmsMessage> get filteredMessages => _filteredMessages;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Set SMS messages and notify listeners
  void setSmsMessages(List<SmsMessage> messages) {
    _smsMessages = messages;
    _filteredMessages = messages;
    notifyListeners();
  }

  // Filter messages based on search query
  void filterMessages(String query) {
    _filteredMessages = _smsMessages
        .where((message) =>
            message.message.toLowerCase().contains(query.toLowerCase()))
        .toList();
    notifyListeners();
  }

  // Fetch SMS messages for a specific device
  Future<void> fetchSmsMessages(int deviceId) async {
    if (_mainProvider?.selectedDevice == null) {
      _errorMessage = 'هیچ دستگاهی انتخاب نشده است';
      notifyListeners();
      return;
    }

    try {
      _isLoading = true;
      notifyListeners();

      // Get device phone number - using phone field from Device model
      String? devicePhone;
      try {
        // Try to access the phone number based on available fields
        devicePhone = _mainProvider?.selectedDevice.devicePhone;
      } catch (e) {
        // If none of these fields exist, use a fallback message
        debugPrint('Error accessing device phone number: $e');
      }
      
      if (devicePhone == null || devicePhone.isEmpty) {
        _errorMessage = 'شماره تلفن دستگاه موجود نیست';
        _isLoading = false;
        notifyListeners();
        return;
      }

      // Request permissions if needed
      bool permissionGranted = await _requestSmsPermission();
      if (!permissionGranted) {
        _errorMessage = 'دسترسی به پیام‌ها رد شد';
        _isLoading = false;
        notifyListeners();
        return;
      }

      // Query SMS messages
      sms.SmsQuery query = sms.SmsQuery();
      List<sms.SmsMessage> messages = await query.querySms(
        kinds: [sms.SmsQueryKind.inbox, sms.SmsQueryKind.sent],
        address: devicePhone,
      );

      // Convert to our SmsMessage model
      List<SmsMessage> convertedMessages = messages
          .map((message) => SmsMessage(
                deviceId: deviceId,
                message: message.body ?? 'بدون متن',
                timestamp: message.date ?? DateTime.now(),
                isIncoming: message.kind == sms.SmsQueryKind.inbox,
              ))
          .toList();

      // Sort by timestamp (newest first)
      convertedMessages.sort((a, b) => b.timestamp.compareTo(a.timestamp));

      setSmsMessages(convertedMessages);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'خطا در بارگیری پیام‌ها: $e';
      notifyListeners();
      toastGenerator(_errorMessage ?? 'خطا در بارگیری پیام‌ها');
    }
  }

  // Request SMS permissions
  Future<bool> _requestSmsPermission() async {
    try {
      // Request SMS permission using permission_handler
      var status = await Permission.sms.request();
      return status.isGranted;
    } catch (e) {
      debugPrint('Error requesting SMS permission: $e');
      return false;
    }
  }
} 