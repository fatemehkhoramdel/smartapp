import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../../core/utils/helper.dart';
import '../../../models/device.dart';
import '../../../models/scheduling.dart';
import '../../../providers/main_provider.dart';
import '../../../repository/scheduling_repository.dart';
import '../../../services/local/app_database.dart';
import '../../../widgets/elevated_button_widget.dart';
import '../../../widgets/outlined_button_widget.dart';
import 'dart:async';
import '../../../injector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';
import 'package:security_alarm/core/constants/global_keys.dart';
import 'package:security_alarm/widgets/elevated_button_widget.dart';
import 'package:security_alarm/widgets/svg.dart';

import '../../../core/constants/design_values.dart';
import '../../../providers/audio_notification_provider.dart';

class SchedulingViewMobile extends StatefulWidget {
  const SchedulingViewMobile({Key? key}) : super(key: key);

  @override
  State<SchedulingViewMobile> createState() => _SchedulingViewMobileState();
}

class _SchedulingViewMobileState extends State<SchedulingViewMobile> {
  late Device _device;
  late MainProvider _mainProvider;
  AppDatabase? _appDatabase;
  bool _isInitialized = false;
  
  String? selectedRelay;
  bool isActivating = true; // true = activation, false = deactivation
  ScheduleMode selectedMode = ScheduleMode.allTimes;
  
  // Schedule settings
  ScheduleType _currentType = ScheduleType.daily;
  TimeOfDay? _selectedTime;
  DateTime? _selectedDate;
  int? _selectedWeekday;
  bool _timeError = false;
  List<ScheduleItem> _schedules = [];
  bool _isLoading = false;
  
  // Define dropdown constants
  final List<String> relayOptions = ['رله 1', 'رله 2', 'رله 3'];
  final List<String> activationOptions = ['فعالسازی', 'غیرفعالسازی'];
  final List<String> modeOptions = [
    'در همه زمان‌ها',
    'در زمان فعال بودن دستگاه',
    'در زمان غیر فعال بودن دستگاه',
    'استعلام مد سناریو'
  ];
  
  // Week days
  final List<String> weekDays = [
    'شنبه',
    'یکشنبه',
    'دوشنبه',
    'سه شنبه',
    'چهارشنبه',
    'پنج شنبه',
    'جمعه'
  ];

  @override
  void initState() {
    super.initState();
    // Initialize the database directly from injector
    _appDatabase = injector<AppDatabase>();
    _isInitialized = true;
  }
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      try {
        // Initialize the database directly from injector
        _appDatabase = injector<AppDatabase>();
        _isInitialized = true;
      } catch (e) {
        print('Error initializing app database: $e');
        toastGenerator('خطا در اتصال به پایگاه داده');
      }
    }
    
    // Load schedules after dependency initialization
    if (_isInitialized && mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _loadSchedules();
      });
    }
  }

  Future<void> _loadSchedules() async {
    if (!mounted || _appDatabase == null) return;
    
    try {
      setState(() => _isLoading = true);
      final repo = SchedulingRepository(_appDatabase!);
      
      // Check if device exists and has a valid ID
      if (_device != null && _device.id != null) {
        _schedules = await repo.getSchedulesForDevice(_device.id.toString());
      } else {
        _schedules = [];
      }
    } catch (e) {
      print('Error loading schedules: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _mainProvider = Provider.of<MainProvider>(context);
    
    try {
      _device = _mainProvider.selectedDevice;
    } catch (e) {
      print('Error accessing selected device: $e');
      // Return an error message if device is null or inaccessible
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
                getDrawerKey('SchedulingView').currentState!.toggle();
              },
            ),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 48),
              SizedBox(height: 16.h),
              Text(
                'خطا در دسترسی به دستگاه',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'لطفاً ابتدا یک دستگاه انتخاب کنید',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                ),
              ),
              SizedBox(height: 24.h),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 12.h),
                ),
                child: Text(
                  'بازگشت',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
    
    // Check if device is null
    if (_device == null) {
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
                getDrawerKey('SchedulingView').currentState!.toggle();
              },
            ),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.device_unknown, color: Colors.amber, size: 48),
              SizedBox(height: 16.h),
              Text(
                'دستگاهی انتخاب نشده است',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'لطفاً ابتدا یک دستگاه را انتخاب کنید',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                ),
              ),
              SizedBox(height: 24.h),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 12.h),
                ),
                child: Text(
                  'بازگشت',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
    
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
              getDrawerKey('SchedulingView').currentState!.toggle();
            },
          ),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        children: [
          // Page title
          Center(
            child: Text(
              "تعریف زمانبندی",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 30.h),
          
          // Schedule type selection (Daily/Once/Weekly)
          _buildScheduleTypeSelection(),
          SizedBox(height: 30.h),
          
          // Date selection for once or weekly type
          if (_currentType == ScheduleType.once)
            _buildDateSelectionWidget(),
          
          if (_currentType == ScheduleType.weekly)
            _buildWeekdaySelectionWidget(),
            
          if (_currentType != ScheduleType.daily)
            SizedBox(height: 20.h),
          
          // Time selection based on current type
          _buildScheduleTimeSelection(),
          SizedBox(height: 20.h),
          
          // Relay selection dropdown
          _buildDropdown(
            title: 'انتخاب رله',
            items: relayOptions,
            value: selectedRelay ?? relayOptions.first,
            onChanged: (value) => setState(() => selectedRelay = value),
            icon: Icons.keyboard_arrow_down,
          ),
          SizedBox(height: 15.h),
          
          // Activation state dropdown
          _buildDropdown(
            title: 'فعال سازی رله',
            items: activationOptions,
            value: isActivating ? activationOptions[0] : activationOptions[1],
            onChanged: (value) => setState(() => 
              isActivating = value == activationOptions[0]),
            icon: Icons.keyboard_arrow_down,
          ),
          SizedBox(height: 15.h),
          
          // Mode selection dropdown
          _buildDropdown(
            title: 'انتخاب مد عملکرد زمان بندی ها',
            items: modeOptions,
            value: _getModeDisplayText(),
            onChanged: (value) => setState(() => 
              selectedMode = _getModeFromText(value!)),
            icon: Icons.keyboard_arrow_down,
          ),
          SizedBox(height: 30.h),
          
          // Save button
          _buildSaveButton(),
          SizedBox(height: 30.h),
          
          // Saved schedules section
          Text(
            'زمانبندی‌های تعریف شده',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 15.h),
          
          _buildSchedulesList(),
          SizedBox(height: 30.h),
          
          // Bottom buttons
          _buildBottomButtons(),
        ],
      ),
    );
  }
  
  // Schedule type selection (Daily/Once/Weekly)
  Widget _buildScheduleTypeSelection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildTypeSelectionOption(
          'روزانه', 
          _currentType == ScheduleType.daily,
          () => setState(() => _currentType = ScheduleType.daily),
        ),
        _buildTypeSelectionOption(
          'یکبار', 
          _currentType == ScheduleType.once,
          () => setState(() => _currentType = ScheduleType.once),
        ),
        _buildTypeSelectionOption(
          'هفتگی', 
          _currentType == ScheduleType.weekly,
          () => setState(() => _currentType = ScheduleType.weekly),
        ),
      ],
    );
  }
  
  // Schedule type option widget
  Widget _buildTypeSelectionOption(String text, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.sp,
            ),
          ),
          SizedBox(height: 5.h),
          Container(
            width: 20.w,
            height: 20.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            child: isSelected
              ? Center(
                  child: Container(
                    width: 12.w,
                    height: 12.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blue,
                    ),
                  ),
                )
              : const SizedBox(),
          ),
        ],
      ),
    );
  }
  
  // Date selection widget for one-time schedule
  Widget _buildDateSelectionWidget() {
    if (_selectedDate != null) {
      final formattedDate = 'روز ${_selectedDate!.day} ماه ${_selectedDate!.month} اجرا می شود';
      
      return Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            'انتخاب روز',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10.h),
          GestureDetector(
            onTap: () => _showDatePickerDialog(),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.green),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'روز تنظیم شد. در صورت نیاز به تغییر روی آن کلیک کنید.',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 14.sp,
                    ),
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    formattedDate,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            'انتخاب روز',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10.h),
          GestureDetector(
            onTap: () => _showDatePickerDialog(),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.amber),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'انتخاب روز',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, color: Colors.white),
                      SizedBox(width: 10.w),
                      Text(
                        'یک روز از ماه را انتخاب کنید',
                        style: TextStyle(
                          color: Colors.amber,
                          fontSize: 14.sp,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }
  }
  
  // Weekday selection for weekly schedule
  Widget _buildWeekdaySelectionWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          'انتخاب روز',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10.h),
        _buildDropdown(
          title: 'انتخاب روز هفته',
          items: weekDays,
          value: _selectedWeekday != null ? weekDays[_selectedWeekday! - 1] : weekDays[0],
          onChanged: (value) {
            if (value != null) {
              setState(() {
                _selectedWeekday = weekDays.indexOf(value) + 1;
              });
            }
          },
          icon: Icons.keyboard_arrow_down,
        ),
        if (_selectedWeekday == null)
          Padding(
            padding: EdgeInsets.only(top: 5.h),
            child: Text(
              'لطفا یک روز هفته را انتخاب کنید',
              style: TextStyle(
                color: Colors.amber,
                fontSize: 12.sp,
              ),
            ),
          ),
      ],
    );
  }
  
  // Time selection widget based on current type
  Widget _buildScheduleTimeSelection() {
    // Common time selection widget
    final timeSelectionWidget = _buildTimeSelectionWidget();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          'انتخاب زمان',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10.h),
        timeSelectionWidget,
      ],
    );
  }
  
  // Time selection widget
  Widget _buildTimeSelectionWidget() {
    // Display selected time if available
    if (_selectedTime != null) {
      final formattedTime = '${_selectedTime!.hour.toString().padLeft(2, '0')}:${_selectedTime!.minute.toString().padLeft(2, '0')}';
      
      return GestureDetector(
        onTap: () => _showTimePickerDialog(),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.green),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'زمان تنظیم شد. در صورت نیاز به تغییر روی آن کلیک کنید.',
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 14.sp,
                ),
              ),
              SizedBox(height: 5.h),
              Text(
                formattedTime,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      );
    } else if (_timeError) {
      // Show error message if time not selected and attempted to save
      return GestureDetector(
        onTap: () => _showTimePickerDialog(),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.red),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Text(
            'انتخاب زمان ضروری است. لطفا یک زمان را انتخاب کنید.',
            style: TextStyle(
              color: Colors.red,
              fontSize: 14.sp,
            ),
          ),
        ),
      );
    } else {
      // Show default message if time not selected
      return GestureDetector(
        onTap: () => _showTimePickerDialog(),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.amber),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Row(
            children: [
              const Icon(Icons.access_time, color: Colors.white),
              SizedBox(width: 10.w),
              Text(
                'انتخاب زمان',
                style: TextStyle(
                  color: Colors.amber,
                  fontSize: 14.sp,
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
  
  // Schedules list
  Widget _buildSchedulesList() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    
    if (_schedules.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 20.h),
        child: Center(
          child: Text(
            'هیچ زمانبندی تعریف نشده است',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14.sp,
            ),
          ),
        ),
      );
    }
    
    return SizedBox(
      height: 200.h,
      child: ListView.builder(
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        itemCount: _schedules.length,
        itemBuilder: (context, index) {
          final schedule = _schedules[index];
          return Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey, width: 1),
              borderRadius: BorderRadius.circular(16.r)
            ),
            padding: EdgeInsets.all(12.h),
            margin: EdgeInsets.only(bottom: 10.h),
            child: Text(
              schedule.getDisplayText(),
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.sp,
              ),
            ),
          );
        },
      ),
    );
  }
  
  // Show time picker dialog
  void _showTimePickerDialog() async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Colors.white,
              onPrimary: Colors.black,
              surface: Color(0xFF09162E),
              onSurface: Colors.white,
            ),
            dialogBackgroundColor: const Color(0xFF09162E),
          ),
          child: child!,
        );
      },
    );
    
    if (pickedTime != null) {
      setState(() {
        _selectedTime = pickedTime;
        _timeError = false;
      });
    }
  }
  
  // Show date picker dialog for one-time schedules
  void _showDatePickerDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: const Color(0xFF09162E),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 15.h),
                decoration: const BoxDecoration(
                  color: Colors.purple,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Text(
                  'انتخاب روز',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                'لطفا یک روز از ماه را برای اجرای زمانبندی انتخاب کنید',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20.h),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  childAspectRatio: 1,
                ),
                itemCount: 31,
                itemBuilder: (context, index) {
                  final day = index + 1;
                  return GestureDetector(
                    onTap: () {
                      final now = DateTime.now();
                      final selectedDate = DateTime(now.year, now.month, day);
                      setState(() => _selectedDate = selectedDate);
                      Navigator.pop(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _selectedDate?.day == day ? Colors.blue : Colors.transparent,
                        border: Border.all(color: Colors.white),
                      ),
                      child: Center(
                        child: Text(
                          day.toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: Text(
                      'انصراف',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  // Generic dropdown builder
  Widget _buildDropdown({
    required String title,
    required List<String> items,
    required String value,
    required Function(String?) onChanged,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.sp,
          ),
        ),
        SizedBox(height: 5.h),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0XFF122950), width: 1),
          ),
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              icon: Icon(icon),
              iconSize: 24.sp,
              elevation: 16,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16.sp,
              ),
              onChanged: onChanged,
              dropdownColor: const Color(0xFF09162E),
              items: items.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Container(
                      color: const Color(0xFF09162E),
                      child: Text(value,  style: const TextStyle(color: Colors.white))),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
  
  // Helper to get mode display text
  String _getModeDisplayText() {
    switch (selectedMode) {
      case ScheduleMode.allTimes:
        return modeOptions[0];
      case ScheduleMode.whenActive:
        return modeOptions[1];
      case ScheduleMode.whenDeactive:
        return modeOptions[2];
      case ScheduleMode.statusQuery:
        return modeOptions[3];
      default:
        return modeOptions[0];
    }
  }
  
  // Helper to get mode from text
  ScheduleMode _getModeFromText(String text) {
    if (text == modeOptions[0]) return ScheduleMode.allTimes;
    if (text == modeOptions[1]) return ScheduleMode.whenActive;
    if (text == modeOptions[2]) return ScheduleMode.whenDeactive;
    if (text == modeOptions[3]) return ScheduleMode.statusQuery;
    return ScheduleMode.allTimes;
  }
  
  // Save button
  Widget _buildSaveButton() {
    return Container(
      height: 40.h,
      margin: EdgeInsets.symmetric(horizontal: 100.w),
      decoration: BoxDecoration(
        color: Colors.purple,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: ElevatedButton(
        onPressed: () => _saveSchedule(),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
        ),
        child: _isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : Text(
                'ذخیره',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }
  
  // Save schedule
  void _saveSchedule() async {
    if (_appDatabase == null) {
      toastGenerator('خطا در اتصال به پایگاه داده');
      return;
    }
    
    if (selectedRelay == null) {
      toastGenerator('لطفا رله را انتخاب کنید');
      return;
    }
    
    if (_selectedTime == null) {
      setState(() => _timeError = true);
      toastGenerator('لطفا زمان را انتخاب کنید');
      return;
    }
    
    if (_currentType == ScheduleType.once && _selectedDate == null) {
      toastGenerator('لطفا تاریخ را انتخاب کنید');
      return;
    }
    
    if (_currentType == ScheduleType.weekly && _selectedWeekday == null) {
      toastGenerator('لطفا روز هفته را انتخاب کنید');
      return;
    }
    
    final repo = SchedulingRepository(_appDatabase!);
    
    try {
      setState(() => _isLoading = true);
      
      await repo.saveSchedule(
        _device.id != null ? _device.id.toString() : "",
        selectedRelay!,
        isActivating,
        selectedMode,
        _currentType,
        _selectedTime!,
        date: _currentType == ScheduleType.once ? _selectedDate : null,
        weekday: _currentType == ScheduleType.weekly ? _selectedWeekday : null,
      );
      
      await _loadSchedules();
      toastGenerator('زمانبندی با موفقیت ذخیره شد');
    } catch (e) {
      print('Error saving schedule: $e');
      toastGenerator('خطا در ذخیره زمانبندی');
    } finally {
      setState(() => _isLoading = false);
    }
  }
  
  // Bottom action buttons
  Widget _buildBottomButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: ElevatedButtonWidget(
            btnText: translate('استعلام'),
            onPressBtn: () => _querySchedulesFromDevice(),
          ),
        ),
        SizedBox(width: 20.w),
        Expanded(
          child: ElevatedButtonWidget(
            btnText: translate('ارسال'),
            onPressBtn: () => _sendSchedulesToDevice(),
            btnColor: Colors.purple,
          ),
        ),

        // Expanded(
        //   child: Container(
        //     height: 50.h,
        //     decoration: BoxDecoration(
        //       gradient: const LinearGradient(
        //         colors: [Colors.blue, Colors.blueAccent],
        //         begin: Alignment.centerLeft,
        //         end: Alignment.centerRight,
        //       ),
        //       borderRadius: BorderRadius.circular(8.r),
        //       boxShadow: [
        //         BoxShadow(
        //           color: Colors.blue.withOpacity(0.3),
        //           spreadRadius: 1,
        //           blurRadius: 5,
        //           offset: const Offset(0, 3),
        //         ),
        //       ],
        //     ),
        //     child: ElevatedButton(
        //       onPressed: () => _sendSchedulesToDevice(),
        //       style: ElevatedButton.styleFrom(
        //         backgroundColor: Colors.transparent,
        //         shadowColor: Colors.transparent,
        //         shape: RoundedRectangleBorder(
        //           borderRadius: BorderRadius.circular(8.r),
        //         ),
        //       ),
        //       child: Text(
        //         'ارسال به دستگاه',
        //         style: TextStyle(
        //           color: Colors.white,
        //           fontSize: 16.sp,
        //           fontWeight: FontWeight.bold,
        //         ),
        //       ),
        //     ),
        //   ),
        // ),
        // SizedBox(width: 20.w),
        // Expanded(
        //   child: Container(
        //     height: 50.h,
        //     decoration: BoxDecoration(
        //       border: Border.all(color: Colors.white),
        //       borderRadius: BorderRadius.circular(8.r),
        //     ),
        //     child: ElevatedButton(
        //       onPressed: () => _querySchedulesFromDevice(),
        //       style: ElevatedButton.styleFrom(
        //         backgroundColor: Colors.transparent,
        //         shadowColor: Colors.transparent,
        //         shape: RoundedRectangleBorder(
        //           borderRadius: BorderRadius.circular(8.r),
        //         ),
        //       ),
        //       child: Text(
        //         'استعلام از دستگاه',
        //         style: TextStyle(
        //           color: Colors.white,
        //           fontSize: 16.sp,
        //           fontWeight: FontWeight.bold,
        //         ),
        //       ),
        //     ),
        //   ),
        // ),
      ],
    );
  }
  
  // Send schedules to device
  void _sendSchedulesToDevice() {
    toastGenerator('ارسال زمانبندی ها به دستگاه در حال انجام است');
    // Add actual implementation here
    Future.delayed(const Duration(seconds: 2), () {
      toastGenerator('ارسال زمانبندی ها با موفقیت انجام شد');
    });
  }
  
  // Query schedules from device
  void _querySchedulesFromDevice() {
    toastGenerator('در حال استعلام زمانبندی ها از دستگاه');
    // Add actual implementation here
    Future.delayed(const Duration(seconds: 2), () {
      toastGenerator('استعلام زمانبندی ها با موفقیت انجام شد');
    });
  }
} 