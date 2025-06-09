import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';

import '../../../core/utils/helper.dart';
import '../../../models/device.dart';
import '../../../models/scheduling.dart';
import '../../../providers/main_provider.dart';
import '../../../providers/scheduling_provider.dart';
import '../../../widgets/elevated_button_widget.dart';
import '../../../widgets/outlined_button_widget.dart';

class SchedulingViewMobile extends StatefulWidget {
  const SchedulingViewMobile({Key? key}) : super(key: key);

  @override
  State<SchedulingViewMobile> createState() => _SchedulingViewMobileState();
}

class _SchedulingViewMobileState extends State<SchedulingViewMobile> {
  late Device _device;
  late MainProvider _mainProvider;
  late SchedulingProvider _schedulingProvider;
  
  String? selectedRelay;
  bool isActivating = true; // true = activation, false = deactivation
  ScheduleMode selectedMode = ScheduleMode.allTimes;
  
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
  Widget build(BuildContext context) {
    _mainProvider = Provider.of<MainProvider>(context);
    _device = _mainProvider.selectedDevice;
    
    return Container(
      color: const Color(0xFF09162E),
      child: ListView(
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
          Container(
            width: double.infinity,
            height: 50.h,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.purple, Colors.purple],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(8.r),
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
              child: Text(
                'ذخیره',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: ElevatedButtonWidget(
                  btnText: 'ذخیره',
                  onPressBtn: () {},
                ),
              ),
              SizedBox(width: 20.w),
              Expanded(
                child: OutlinedButtonWidget(
                  btnText: 'استعلام',
                  onPressBtn: () {},
                ),
              ),
            ],
          ),
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
          true, // Default for now
          () => setState(() {}),
        ),
        _buildTypeSelectionOption(
          'یکبار', 
          false,
          () => setState(() {}),
        ),
        _buildTypeSelectionOption(
          'هفتگی', 
          false,
          () => setState(() {}),
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
  
  // Time selection widget based on current type
  Widget _buildScheduleTimeSelection() {
    // Common time selection widget
    final timeSelectionWidget = _buildTimeSelectionWidget();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
    // Show message to select time if not selected
    return GestureDetector(
      onTap: () => _showTimePickerDialog(),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Text(
          'ابتدا یک زمان انتخاب و سپس تغییرات را ذخیره کنید.',
          style: TextStyle(
            color: Colors.red,
            fontSize: 14.sp,
          ),
        ),
      ),
    );
  }
  
  // Schedules list
  Widget _buildSchedulesList() {
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
  
  // Show time picker dialog
  void _showTimePickerDialog() async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            primaryColor: Colors.purple,
            colorScheme: const ColorScheme.dark(
              primary: Colors.purple,
              onSurface: Colors.white,
            ),
            dialogBackgroundColor: const Color(0xFF121212),
          ),
          child: child!,
        );
      },
    );
    
    if (pickedTime != null) {
      setState(() {});
    }
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
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.r),
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
              items: items.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
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
  
  // Save schedule
  void _saveSchedule() {
    if (selectedRelay == null) {
      toastGenerator('لطفا رله را انتخاب کنید');
      return;
    }
    
    toastGenerator('زمانبندی با موفقیت ذخیره شد');
  }
} 