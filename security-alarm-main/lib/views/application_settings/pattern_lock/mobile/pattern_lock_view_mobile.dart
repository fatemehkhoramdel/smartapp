import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:pattern_lock/pattern_lock.dart';
import 'package:provider/provider.dart';
import 'package:security_alarm/core/constants/global_keys.dart';

import '../../../../core/utils/helper.dart';
import '../../../../injector.dart';
import '../../../../models/app_settings.dart';
import '../../../../providers/main_provider.dart';
import '../../../../repository/cache_repository.dart';

class PatternLockViewMobile extends StatefulWidget {
  const PatternLockViewMobile({Key? key}) : super(key: key);

  @override
  State<PatternLockViewMobile> createState() => _PatternLockViewMobileState();
}

class _PatternLockViewMobileState extends State<PatternLockViewMobile> {
  final List<int> _firstPattern = [];
  final List<int> _confirmPattern = [];
  
  bool _isConfirmationMode = false;
  bool _showVerificationPage = false;
  bool _patternCorrect = false;
  bool _patternWrong = false;
  bool _showSaveButton = false;
  bool _isSaving = false;
  
  String _statusMessage = '';
  
  late MainProvider _mainProvider;
  
  @override
  void initState() {
    super.initState();
    _mainProvider = Provider.of<MainProvider>(context, listen: false);
    _checkExistingPassword();
  }
  
  void _checkExistingPassword() {
    final hasPassword = _mainProvider.appSettings.appPassword != '000000';
    setState(() {
      _showVerificationPage = hasPassword;
      _statusMessage = hasPassword 
          ? translate('enter_previous_pattern') 
          : translate('draw_new_pattern');
    });
  }

  @override
  Widget build(BuildContext context) {
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
              getDrawerKey('PatternLockView').currentState!.toggle();
            },
          ),
        ),
      ),
      body:Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            children: [
              SizedBox(height: 20.h),
              // Title
              Text(
                translate('define_password'),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 30.h),
              // Lock Icon
              Container(
                width: 120.w,
                height: 120.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: _getStatusColor(),
                    width: 3.w,
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.lock_outline,
                    color: _getStatusColor(),
                    size: 60.w,
                  ),
                ),
              ),
              SizedBox(height: 40.h),
              // Status message
              Text(
                _statusMessage,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10.h),
              // Pattern lock
              SizedBox(
                height: 300,
                child: PatternLock(
                  // Dimension of the pattern lock
                  dimension: 3,
                  // Color of the selected dots and connecting lines
                  selectedColor: _getStatusColor(),
                  // Size of the dots
                  pointRadius: 10,
                  // Width of the connecting lines
                  // selectThickness: 3,

                  // fill color of the not-selected dots
                  fillPoints: true,
                  notSelectedColor: const Color(0XFF2E70E6),
                  // Size of the hitslop for the dots
                  // pointSize: 30.w,
                  // Callback when pattern is complete
                  onInputComplete: (List<int> input) {
                    if (input.length < 3) {
                      setState(() {
                        _statusMessage = translate('pattern_too_short');
                        _patternWrong = true;
                        Future.delayed(const Duration(milliseconds: 1500), () {
                          setState(() {
                            _patternWrong = false;
                            _statusMessage = _showVerificationPage
                                ? translate('enter_previous_pattern')
                                : _isConfirmationMode
                                    ? translate('confirm_pattern')
                                    : translate('draw_new_pattern');
                          });
                        });
                      });
                      return;
                    }

                    if (_showVerificationPage) {
                      _verifyExistingPattern(input);
                    } else if (_isConfirmationMode) {
                      _confirmNewPattern(input);
                    } else {
                      _saveFirstPattern(input);
                    }
                  },
                ),
              ),
              SizedBox(height: 10.h),
              // Save button (shown only after successful confirmation)
              if (_showSaveButton)
                ElevatedButton(
                  onPressed: _isSaving ? null : _savePattern,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.symmetric(horizontal: 50.w, vertical: 12.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                  ),
                  child: _isSaving
                      ? SizedBox(
                          height: 20.h,
                          width: 20.h,
                          child: CircularProgressIndicator(
                            valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                            strokeWidth: 2.w,
                          ),
                        )
                      : Text(
                          translate('save'),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
            ],
          ),
        ),
      );
  }
  
  Color _getStatusColor() {
    if (_patternWrong) return Colors.red;
    if (_patternCorrect) return Colors.green;
    return Colors.blue;
  }
  
  void _verifyExistingPattern(List<int> input) {
    // Convert pattern to string for comparison
    final inputStr = input.join('');
    final savedPassword = _mainProvider.appSettings.appPassword;
    
    if (inputStr == savedPassword) {
      setState(() {
        _patternCorrect = true;
        _statusMessage = translate('pattern_correct');
      });
      
      // Navigate to create new pattern after successful verification
      Future.delayed(const Duration(milliseconds: 1500), () {
        setState(() {
          _patternCorrect = false;
          _showVerificationPage = false;
          _statusMessage = translate('draw_new_pattern');
        });
      });
    } else {
      setState(() {
        _patternWrong = true;
        _statusMessage = translate('pattern_wrong');
      });
      
      Future.delayed(const Duration(milliseconds: 1500), () {
        setState(() {
          _patternWrong = false;
          _statusMessage = translate('enter_previous_pattern');
        });
      });
    }
  }
  
  void _saveFirstPattern(List<int> input) {
    _firstPattern.clear();
    _firstPattern.addAll(input);
    
    setState(() {
      _isConfirmationMode = true;
      _statusMessage = translate('confirm_pattern');
    });
  }
  
  void _confirmNewPattern(List<int> input) {
    _confirmPattern.clear();
    _confirmPattern.addAll(input);
    
    if (_listEquals(_firstPattern, _confirmPattern)) {
      setState(() {
        _patternCorrect = true;
        _statusMessage = translate('pattern_confirmed');
        _showSaveButton = true;
      });
      
      Future.delayed(const Duration(milliseconds: 1500), () {
        setState(() {
          _patternCorrect = false;
        });
      });
    } else {
      setState(() {
        _patternWrong = true;
        _statusMessage = translate('patterns_dont_match');
      });
      
      Future.delayed(const Duration(milliseconds: 1500), () {
        setState(() {
          _patternWrong = false;
          _isConfirmationMode = false;
          _statusMessage = translate('draw_new_pattern');
        });
      });
    }
  }
  
  bool _listEquals<T>(List<T> list1, List<T> list2) {
    if (list1.length != list2.length) return false;
    for (int i = 0; i < list1.length; i++) {
      if (list1[i] != list2[i]) return false;
    }
    return true;
  }
  
  Future<void> _savePattern() async {
    setState(() {
      _isSaving = true;
    });
    
    try {
      // Convert pattern to string for storage
      final patternStr = _firstPattern.join('');
      
      // Update app settings
      final updatedSettings = _mainProvider.appSettings.copyWith(
        appPassword: patternStr,
        showPassPage: true, // Enable password protection
      );
      
      // Save to database
      await _mainProvider.updateAppSettings(updatedSettings);
      
      setState(() {
        _isSaving = false;
      });
      
      toastGenerator(translate('password_saved_successfully'));
      Navigator.pop(context);
    } catch (e) {
      setState(() {
        _isSaving = false;
      });
      
      toastGenerator(translate('error_saving_password'));
    }
  }
} 