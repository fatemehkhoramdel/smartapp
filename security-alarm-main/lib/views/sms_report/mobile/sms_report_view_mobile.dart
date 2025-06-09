import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';
import 'package:security_alarm/core/constants/global_keys.dart';
import '../../../core/utils/helper.dart';
import '../../../providers/main_provider.dart';
import '../../../models/sms_message.dart';
import '../../../providers/sms_provider.dart';

class SmsReportViewMobile extends StatefulWidget {
  final int deviceId;

  const SmsReportViewMobile({Key? key, required this.deviceId}) : super(key: key);

  @override
  State<SmsReportViewMobile> createState() => _SmsReportViewMobileState();
}

class _SmsReportViewMobileState extends State<SmsReportViewMobile> {
  late SmsProvider _smsProvider;
  String _searchQuery = '';
  
  @override
  void initState() {
    super.initState();
    _smsProvider = Provider.of<SmsProvider>(context, listen: false);
    _loadMessages();
  }
  
  // Método para cargar los mensajes
  Future<void> _loadMessages() async {
    await _smsProvider.fetchSmsMessages(widget.deviceId);
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF09162E), // Dark blue background
      appBar: AppBar(
        backgroundColor: const Color(0xFF09162E),
        elevation: 0,
        title: Text(
          translate('گزارش گیری'),
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
              getDrawerKey('SmsReportView').currentState!.toggle();
            },
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title and search bar
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            child: Text(
              translate('گزارشات اخیر'),
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.start,
            ),
          ),
          
          // Message list
          Expanded(
            child: Consumer<SmsProvider>(
              builder: (context, provider, child) {
                // Show loading indicator
                if (provider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                // Show error message if any
                if (provider.errorMessage != null && provider.smsMessages.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.w),
                      child: Text(
                        provider.errorMessage!,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }
                
                // Show empty view if no messages
                final messages = _searchQuery.isEmpty 
                    ? provider.smsMessages 
                    : provider.filteredMessages;
                    
                if (messages.isEmpty) {
                  return _buildEmptyView();
                }
                
                // Show messages list
                return ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    return _buildMessageItem(message);
                  },
                );
              },
            ),
          ),
          
          // Clear button - only show if there are messages
          Consumer<SmsProvider>(
            builder: (context, provider, child) {
              if (provider.smsMessages.isEmpty) {
                return const SizedBox.shrink();
              }
              
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(16.h),
                  child: ElevatedButton(
                    onPressed: _clearMessages,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      minimumSize: Size(200.w, 50.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.r),
                      ),
                    ),
                    child: Text(
                      translate('پاک کردن'),
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
  
  // Empty view
  Widget _buildEmptyView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon with exclamation
          Container(
            width: 120.w,
            height: 120.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.1),
            ),
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Icon(
                    Icons.description_outlined,
                    size: 80.sp,
                    color: Colors.blue.withOpacity(0.7),
                  ),
                  Positioned(
                    right: 15.w,
                    top: 15.h,
                    child: Container(
                      padding: EdgeInsets.all(4.r),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.red.withOpacity(0.8),
                      ),
                      child: Icon(
                        Icons.error_outline,
                        size: 24.sp,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 24.h),
          
          // No reports text
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.email_outlined,
                color: Colors.white,
                size: 24.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                translate('گزارشی وجود ندارد'),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.sp,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  // Message item
  Widget _buildMessageItem(SmsMessage message) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: const Color(0xFF142850), // Dark blue background
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Message content
          Text(
            message.message,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14.sp,
            ),
          ),
          SizedBox(height: 8.h),
          
          // Icon and date
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatDateTime(message.timestamp),
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 12.sp,
                ),
              ),
              Row(
                children: [
                  Icon(
                    message.isIncoming ? Icons.call_received : Icons.call_made,
                    color: message.isIncoming ? Colors.green : Colors.blue,
                    size: 16.sp,
                  ),
                  SizedBox(width: 4.w),
                  Icon(
                    Icons.email_outlined,
                    color: Colors.white.withOpacity(0.7),
                    size: 18.sp,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  // Format date time to a readable string
  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inDays > 0) {
      return '${difference.inDays} ${translate('روز پیش')}';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ${translate('ساعت پیش')}';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} ${translate('دقیقه پیش')}';
    } else {
      return translate('چند لحظه پیش');
    }
  }
  
  // Clear all messages
  void _clearMessages() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF142850),
        title: Text(
          translate('پاک کردن'),
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.sp,
          ),
        ),
        content: Text(
          translate('آیا مطمئن هستید که می‌خواهید همه گزارش‌ها را پاک کنید؟'),
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 14.sp,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              translate('خیر'),
              style: TextStyle(
                color: Colors.blue,
                fontSize: 14.sp,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Clear messages in provider
              _smsProvider.setSmsMessages([]);
              toastGenerator(translate('گزارش‌ها با موفقیت پاک شدند'));
            },
            child: Text(
              translate('بله'),
              style: TextStyle(
                color: Colors.red,
                fontSize: 14.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
} 