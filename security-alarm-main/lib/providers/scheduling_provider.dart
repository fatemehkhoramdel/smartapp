import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/utils/helper.dart';
import '../models/device.dart';
import '../models/scheduling.dart';
import '../repository/scheduling_repository.dart';

class SchedulingProvider extends ChangeNotifier {
  final SchedulingRepository _repository;
  final Device _device;
  
  List<ScheduleItem> _schedules = [];
  List<ScheduleItem> get schedules => _schedules;
  
  ScheduleType _currentType = ScheduleType.daily;
  ScheduleType get currentType => _currentType;
  
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  
  String? _errorMessage;
  String? get errorMessage => _errorMessage;
  
  TimeOfDay? _selectedTime;
  TimeOfDay? get selectedTime => _selectedTime;
  
  DateTime? _selectedDate;
  DateTime? get selectedDate => _selectedDate;
  
  int? _selectedWeekday;
  int? get selectedWeekday => _selectedWeekday;
  
  SchedulingProvider({
    required SchedulingRepository repository,
    required Device device,
  }) : _repository = repository,
      _device = device {
    _loadSchedules();
  }
  
  void setScheduleType(ScheduleType type) {
    _currentType = type;
    
    // Reset any type-specific selections when changing type
    if (type != ScheduleType.once) {
      _selectedDate = null;
    }
    
    if (type != ScheduleType.weekly) {
      _selectedWeekday = null;
    }
    
    notifyListeners();
  }
  
  void setSelectedTime(TimeOfDay time) {
    _selectedTime = time;
    notifyListeners();
  }
  
  void setSelectedDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }
  
  void setSelectedWeekday(int weekday) {
    _selectedWeekday = weekday;
    notifyListeners();
  }
  
  void resetTimeSelection() {
    _selectedTime = null;
    notifyListeners();
  }
  
  Future<void> _loadSchedules() async {
    try {
      _isLoading = true;
      notifyListeners();
      
      _schedules = await _repository.getSchedulesForDevice(_device.id.toString());
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }
  
  Future<void> saveSchedule({
    required String relayName,
    required bool isActivating,
    required ScheduleMode mode,
  }) async {
    if (_selectedTime == null) {
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
    
    try {
      _isLoading = true;
      notifyListeners();
      
      await _repository.saveSchedule(
        _device.id.toString(), 
        relayName, 
        isActivating, 
        mode, 
        _currentType, 
        _selectedTime!,
        date: _currentType == ScheduleType.once ? _selectedDate : null,
        weekday: _currentType == ScheduleType.weekly ? _selectedWeekday : null,
      );
      
      // Refresh the schedules
      await _loadSchedules();
      
      // Reset selections after saving
      _selectedTime = null;
      
      toastGenerator('زمانبندی با موفقیت ذخیره شد');
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      toastGenerator('خطا در ذخیره زمانبندی');
    }
  }
  
  Future<void> deleteSchedule(String scheduleId) async {
    try {
      _isLoading = true;
      notifyListeners();
      
      await _repository.deleteSchedule(_device.id.toString(), scheduleId);
      
      // Refresh the schedules
      await _loadSchedules();
      
      toastGenerator('زمانبندی با موفقیت حذف شد');
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      toastGenerator('خطا در حذف زمانبندی');
    }
  }
  
  Future<void> querySchedulesFromDevice() async {
    try {
      _isLoading = true;
      notifyListeners();
      
      // Implement device query logic here
      // For now, just a mock implementation
      await Future.delayed(const Duration(seconds: 1));
      
      toastGenerator('استعلام زمانبندی ها با موفقیت انجام شد');
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      toastGenerator('خطا در استعلام زمانبندی ها');
    }
  }
  
  Future<void> sendSchedulesToDevice() async {
    try {
      _isLoading = true;
      notifyListeners();
      
      // Implement device communication logic here
      // For now, just a mock implementation
      await Future.delayed(const Duration(seconds: 1));
      
      toastGenerator('ارسال زمانبندی ها با موفقیت انجام شد');
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      toastGenerator('خطا در ارسال زمانبندی ها');
    }
  }
} 