import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';
import 'package:security_alarm/core/constants/global_keys.dart';
import '../../../core/utils/helper.dart';
import '../../../providers/main_provider.dart';
import '../../../models/device_status_report.dart';
import '../../../injector.dart';
import '../../../repository/sms_repository.dart';

class DeviceStatusViewMobile extends StatefulWidget {
  final int deviceId;

  const DeviceStatusViewMobile({Key? key, required this.deviceId}) : super(key: key);

  @override
  State<DeviceStatusViewMobile> createState() => _DeviceStatusViewMobileState();
}

class _DeviceStatusViewMobileState extends State<DeviceStatusViewMobile> {
  DeviceStatusReport? _statusReport;
  bool _isLoading = false;
  bool _hasData = false;
  late MainProvider _mainProvider;
  
  @override
  void initState() {
    super.initState();
    _mainProvider = Provider.of<MainProvider>(context, listen: false);
  }
  
  // Consultar el estado del dispositivo
  Future<void> _queryDeviceStatus() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      // Get the device phone number
      final phoneNumber = _mainProvider.selectedDevice.devicePhone;
      
      // Create the SMS message
      final message = "stat";
      
      // Send the SMS
      final result = await injector<SMSRepository>().doSendSMS(
        message: message,
        phoneNumber: phoneNumber,
        smsCoolDownFinished: _mainProvider.smsCooldownFinished,
        isManager: _mainProvider.selectedDevice.isManager,
        showConfirmDialog: false,
      );
      
      result.fold(
        (failure) {
          // Handle error
          setState(() {
            _isLoading = false;
          });
          toastGenerator(failure);
        },
        (_) async {
          // Start SMS cooldown
          _mainProvider.startSMSCooldown();
          
          // Show success message
          // toastGenerator(translate('استعلام وضعیت ارسال شد'));
          
          // In a real implementation, you would wait for SMS response
          // For now, we simulate with a delay
          await Future.delayed(const Duration(seconds: 2));
          
          if (mounted) {
            setState(() {
              _isLoading = false;
              _hasData = true;
              
              // In a real implementation, this data would come from the SMS response
              _statusReport = DeviceStatusReport(
                deviceId: widget.deviceId,
                reports: [
                  StatusReportItem(
                    title: 'گزارش شماره یک این متن برای توسعه دهنده نوشته شده است. متن می تواند بیش از یک خط باشد',
                    timestamp: DateTime.now().subtract(const Duration(days: 1)),
                  ),
                  StatusReportItem(
                    title: 'گزارش شماره دو این متن برای توسعه دهنده نوشته شده است. متن می تواند بیش از یک خط باشد',
                    timestamp: DateTime.now().subtract(const Duration(hours: 2)),
                  ),
                ],
              );
            });
          }
        },
      );
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        toastGenerator('خطا در استعلام وضعیت دستگاه: $e');
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    // Obtener el nombre del dispositivo seleccionado
    final selectedDevice = _mainProvider.selectedDevice;
    final deviceName = selectedDevice.deviceName ?? translate('دستگاه');
    
    return Scaffold(
      backgroundColor: const Color(0xFF09162E), // Dark blue background
      appBar: AppBar(
        backgroundColor: const Color(0xFF09162E),
        elevation: 0,
        title: Text(
          translate('وضعیت دستگاه'),
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
              getDrawerKey('DeviceStatusView').currentState!.toggle();
            },
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título de la sección
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            child: Text(
              translate('وضعیت دستگاه'),
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.start,
            ),
          ),
          
          // Contenido principal
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : !_hasData
                    ? _buildEmptyView()
                    : _buildStatusReport(),
          ),
          
          // Botón de consulta
          Center(
            child: Padding(
              padding: EdgeInsets.all(16.h),
              child: ElevatedButton(
                onPressed: _queryDeviceStatus,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  minimumSize: Size(200.w, 50.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.r),
                  ),
                ),
                child: Text(
                  translate('استعلام'),
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  // Vista cuando no hay datos
  Widget _buildEmptyView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icono de documento con signo de exclamación
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
          
          // Texto de no hay reportes
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                translate('گزارشی وجود ندارد'),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.sp,
                ),
              ),
              SizedBox(width: 8.w),
              Icon(
                Icons.info_outline,
                color: Colors.white,
                size: 24.sp,
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  // Vista con datos de reporte
  Widget _buildStatusReport() {
    if (_statusReport == null) return Container();
    
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      itemCount: _statusReport!.reports.length,
      itemBuilder: (context, index) {
        final report = _statusReport!.reports[index];
        return _buildReportItem(report);
      },
    );
  }
  
  // Elemento de reporte individual
  Widget _buildReportItem(StatusReportItem report) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: const Color(0xFF142850), // Fondo azul oscuro
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Contenido del reporte
          Text(
            report.title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14.sp,
            ),
          ),
          SizedBox(height: 8.h),
          
          // Icono
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Icon(
                Icons.info_outline,
                color: Colors.white.withOpacity(0.7),
                size: 18.sp,
              ),
            ],
          ),
        ],
      ),
    );
  }
} 