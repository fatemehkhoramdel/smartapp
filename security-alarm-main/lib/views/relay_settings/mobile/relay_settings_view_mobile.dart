import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';
import 'package:security_alarm/core/constants/global_keys.dart';
import 'package:security_alarm/widgets/elevated_button_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/utils/helper.dart';
import '../../../models/relay.dart';
import '../../../providers/main_provider.dart';
import '../../../repository/sms_repository.dart';
import '../../../injector.dart';

// Relay operating modes
enum RelayMode {
  toggle,
  momentary,
}

class RelaySettingsViewMobile extends StatefulWidget {
  const RelaySettingsViewMobile({Key? key}) : super(key: key);

  @override
  State<RelaySettingsViewMobile> createState() => _RelaySettingsViewMobileState();
}

class _RelaySettingsViewMobileState extends State<RelaySettingsViewMobile> {
  // Alarm duration slider
  double _alarmDuration = 5.0; // Default duration in seconds
  double _initialAlarmDuration = 5.0; // To track changes
  
  // Add relay dialog
  bool _isAddingRelay = false;
  final TextEditingController _newRelayNameController = TextEditingController();
  
  // Loading state
  bool _isLoading = false;
  
  // Relay lists and states
  List<Relay> _relays = [];
  final List<TextEditingController> _relayNameControllers = [];
  final List<String> _initialRelayNames = [];
  final List<bool> _isMomentaryActive = [];
  final List<bool> _initialMomentaryActive = [];
  final List<bool> _isOnOffActive = [];
  final List<bool> _initialOnOffActive = [];
  
  late MainProvider _mainProvider;
  
  // Preference keys
  static const String _prefKeyAlarmDuration = 'relay_alarm_duration';
  static const String _prefKeyRelayNamePrefix = 'relay_name_';
  static const String _prefKeyMomentaryPrefix = 'relay_momentary_';
  static const String _prefKeyOnOffPrefix = 'relay_on_off_';

  @override
  void initState() {
    super.initState();
    // Initialize after the build is complete
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadSettings();
    });
  }
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _mainProvider = Provider.of<MainProvider>(context, listen: false);
  }

  @override
  void dispose() {
    _newRelayNameController.dispose();
    for (var controller in _relayNameControllers) {
      controller.dispose();
    }
    super.dispose();
  }
  
  // Load settings from SharedPreferences and initialize the relay lists
  Future<void> _loadSettings() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      // Get current relays from the provider
      _relays = List.from(_mainProvider.relays);
      
      // Intialize controllers and state lists
      _relayNameControllers.clear();
      _initialRelayNames.clear();
      _isMomentaryActive.clear();
      _initialMomentaryActive.clear();
      _isOnOffActive.clear();
      _initialOnOffActive.clear();
      
      // Initialize controllers for each relay
      for (var relay in _relays) {
        final controller = TextEditingController(text: relay.relayName);
        _relayNameControllers.add(controller);
        _initialRelayNames.add(relay.relayName);
      }
      
      // Load saved preferences
      final prefs = await SharedPreferences.getInstance();
      _alarmDuration = prefs.getDouble(_prefKeyAlarmDuration) ?? 5.0;
      _initialAlarmDuration = _alarmDuration;
      
      // Load relay states for each relay
      for (int i = 0; i < _relays.length; i++) {
        // Momentary mode is active by default
        bool isMomentary = prefs.getBool('$_prefKeyMomentaryPrefix$i') ?? true;
        bool isOnOff = prefs.getBool('$_prefKeyOnOffPrefix$i') ?? false;
        
        // Ensure only one mode is active
        if (isMomentary && isOnOff) {
          isOnOff = false;
        } else if (!isMomentary && !isOnOff) {
          isMomentary = true; // Default to momentary if none are active
        }
        
        _isMomentaryActive.add(isMomentary);
        _initialMomentaryActive.add(isMomentary);
        _isOnOffActive.add(isOnOff);
        _initialOnOffActive.add(isOnOff);
      }
    } catch (e) {
      debugPrint('Error loading relay settings: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
  
  // Save all settings and send SMS commands for changes
  Future<void> _saveSettings() async {
    if (_mainProvider.selectedDevice == null) {
      toastGenerator(translate('please_select_device_first'));
      return;
    }
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Save alarm duration and send SMS if changed
      await prefs.setDouble(_prefKeyAlarmDuration, _alarmDuration);
      if (_alarmDuration != _initialAlarmDuration) {
        final command = 'Trels=${_alarmDuration.toInt()}&&';
        await _sendSms(command, 'duration');
        _initialAlarmDuration = _alarmDuration;
      }
      
      // Process each relay's changes
      for (int i = 0; i < _relays.length; i++) {
        // Skip if index is out of range
        if (i >= _relayNameControllers.length) continue;
        
        final newName = _relayNameControllers[i].text;
        final relay = _relays[i];
        
        // Save relay name to preferences
        await prefs.setString('$_prefKeyRelayNamePrefix$i', newName);
        
        // Save relay states to preferences
        await prefs.setBool('$_prefKeyMomentaryPrefix$i', _isMomentaryActive[i]);
        await prefs.setBool('$_prefKeyOnOffPrefix$i', _isOnOffActive[i]);
        
        // Check if states changed and send appropriate SMS commands
        final hasMomentaryModeChanged = _isMomentaryActive[i] != _initialMomentaryActive[i];
        final hasOnOffModeChanged = _isOnOffActive[i] != _initialOnOffActive[i];
        
        if (hasMomentaryModeChanged || hasOnOffModeChanged) {
          if (_isMomentaryActive[i]) {
            // If momentary mode is now active, send momentary activation SMS
            String command = '';
            if (i == 0) command = 'r1pu';
            else if (i == 1) command = 'r2pu';
            else if (i == 2) command = 'r3pu';
            else if (i == 3) command = 'r4pu';
            
            if (command.isNotEmpty) {
              await _sendSms(command, 'momentary_$i');
            }
          } else if (_isOnOffActive[i]) {
            // If on/off mode is now active, send on activation SMS
            String command = '';
            if (i == 0) command = 'r1en';
            else if (i == 1) command = 'r2en';
            else if (i == 2) command = 'r3en';
            else if (i == 3) command = 'r4en';
            
            if (command.isNotEmpty) {
              await _sendSms(command, 'on_$i');
            }
          } else {
            // If on/off mode is now inactive, send off deactivation SMS
            String command = '';
            if (i == 0) command = 'r1ds';
            else if (i == 1) command = 'r2ds';
            else if (i == 2) command = 'r3ds';
            else if (i == 3) command = 'r4ds';
            
            if (command.isNotEmpty) {
              await _sendSms(command, 'off_$i');
            }
          }
          
          // Update initial states to current states
          _initialMomentaryActive[i] = _isMomentaryActive[i];
          _initialOnOffActive[i] = _isOnOffActive[i];
        }
        
        // Update relay in database if name changed
        if (newName != _initialRelayNames[i] && newName.isNotEmpty) {
          final updatedRelay = relay.copyWith(relayName: newName);
          await _mainProvider.updateRelay(updatedRelay);
          _initialRelayNames[i] = newName;
        }
      }
      
      toastGenerator(translate('changes_saved_successfully'));
    } catch (e) {
      debugPrint('Error saving relay settings: $e');
      toastGenerator(translate('error_saving_settings'));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
  
  // Send SMS command
  Future<void> _sendSms(String command, String operationType) async {
    if (_mainProvider.selectedDevice == null) {
      toastGenerator(translate('please_select_device_first'));
      return;
    }
    
    try {
      final phoneNumber = _mainProvider.selectedDevice!.devicePhone;
      
      // Send the SMS
      final result = await injector<SMSRepository>().doSendSMS(
        message: command,
        phoneNumber: phoneNumber,
        smsCoolDownFinished: _mainProvider.smsCooldownFinished,
        isManager: _mainProvider.selectedDevice!.isManager,
        showConfirmDialog: false,
      );
      
      result.fold(
        (failure) {
          // Error handling
          toastGenerator(failure);
        },
        (_) {
          // Success handling
          toastGenerator(translate('sms_sent_successfully'));
          _mainProvider.startSMSCooldown();
        },
      );
    } catch (e) {
      toastGenerator('${translate('error_sending_sms')}: $e');
    }
  }
  
  // Add new relay
  Future<void> _addNewRelay(String name) async {
    try {
      final deviceId = _mainProvider.selectedDevice?.id;
      if (deviceId == null) {
        toastGenerator(translate('error_adding_relay'));
        return;
      }
      
      final newRelay = Relay(
        deviceId: deviceId,
        relayName: name,
        relayTriggerTime: '', // Start with toggle mode
        relayState: false,
      );
      
      // Add relay to database
      await _mainProvider.insertRelay(newRelay);
      await _mainProvider.getAllRelays();
      
      // Reload the page with the new relay
      await _loadSettings();
      
      // Save default settings for the new relay (momentary mode active by default)
      final newIndex = _relays.length - 1;
      if (newIndex >= 0) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('$_prefKeyRelayNamePrefix$newIndex', name);
        await prefs.setBool('$_prefKeyMomentaryPrefix$newIndex', true);
        await prefs.setBool('$_prefKeyOnOffPrefix$newIndex', false);
      }
      
      toastGenerator(translate('new_relay_added_successfully'));
    } catch (e) {
      debugPrint('Error adding new relay: $e');
      toastGenerator(translate('error_adding_relay'));
    }
  }
  
  // Delete relay
  Future<void> _deleteRelay(int index) async {
    try {
      if (index < _relays.length) {
        final relay = _relays[index];
        
        // Delete from database
        await _mainProvider.deleteRelay(relay);
        
        // Remove from preferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('$_prefKeyRelayNamePrefix$index');
        await prefs.remove('$_prefKeyMomentaryPrefix$index');
        await prefs.remove('$_prefKeyOnOffPrefix$index');
        
        // Reload the page
        await _loadSettings();
        
        toastGenerator(translate('relay_deleted_successfully'));
      }
    } catch (e) {
      debugPrint('Error deleting relay: $e');
      toastGenerator(translate('error_deleting_relay'));
    }
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
              onPressed: () => Navigator.pop(context),
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
              getDrawerKey('RelaySettingsView').currentState!.toggle();
            },
          ),
        ),
      ),
      body: Stack(
        children: [
          _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20.h),
                      // Title
                      Center(
                        child: Text(
                          translate('مدیریت عملکرد رله ها'),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 20.h),
                      
                      // Add new relay button
                      InkWell(
                        onTap: () {
                          setState(() {
                            _isAddingRelay = true;
                            _newRelayNameController.clear();
                          });
                        },
                        child: Container(
                          width: double.infinity,
                          height: 36.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.r),
                            border: Border.all(
                                color: const Color(0xFF2E70E6), width: 1.w),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add,
                                color: const Color(0xFF2E70E6),
                                size: 24.sp,
                              ),
                              SizedBox(width: 16.w),
                              Text(
                                translate('افزودن رله جدید'),
                                style: TextStyle(
                                  color: const Color(0xFF2E70E6),
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 24.h),
                      
                      // Duration slider
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${translate('مدت زمان آژیر لحظه ای (ثانیه)')}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                            ),
                          ),
                          Text(
                            '${_alarmDuration.toInt()}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      Slider(
                        value: _alarmDuration,
                        min: 5,
                        max: 120,
                        divisions: 115,
                        activeColor: Colors.blue,
                        inactiveColor: Colors.grey,
                        label: '${_alarmDuration.toInt()}',
                        onChanged: (value) {
                          setState(() {
                            _alarmDuration = value;
                          });
                        },
                      ),
                      SizedBox(height: 20.h),
                      
                      // Relay items
                      for (int i = 0; i < _relays.length; i++) 
                        if (i < _relayNameControllers.length) ...[
                          _buildRelayItem(i),
                          SizedBox(height: 24.h),
                        ],
                      
                      // Save button
                      Center(
                        child: ElevatedButtonWidget(
                          btnText: translate('ذخیره'),
                          btnColor: Colors.purple,
                          onPressBtn: _saveSettings,
                        ),
                      ),
                      SizedBox(height: 20.h),
                    ],
                  ),
                ),
              ),
          
          // Add Relay Dialog
          if (_isAddingRelay) _buildAddRelayDialog(),
        ],
      ),
    );
  }

  Widget _buildRelayItem(int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Relay header with delete button
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              translate('رله') + ' ${index + 1}',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.delete_forever,
                color: Colors.red,
                size: 28.r,
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    backgroundColor: const Color(0xFF09162E),
                    title: Text(
                      translate('delete_relay'),
                      style: const TextStyle(color: Colors.white),
                    ),
                    content: Text(
                      translate('confirm_delete_relay'),
                      style: const TextStyle(color: Colors.white70),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text(
                          translate('cancel'),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          _deleteRelay(index);
                        },
                        child: Text(
                          translate('delete'),
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
        SizedBox(height: 8.h),
        
        // Relay name field
        Text(
          translate('تغییر نام رله') + ' ${index + 1}',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 14.sp,
          ),
        ),
        SizedBox(height: 8.h),
        TextField(
          controller: _relayNameControllers[index],
          decoration: InputDecoration(
            hintText: translate('یک مقدار دلخواه وارد کن'),
            hintStyle: TextStyle(color: Colors.white30),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blue.withOpacity(0.5)),
              borderRadius: BorderRadius.circular(8.r),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.blue),
              borderRadius: BorderRadius.circular(8.r),
            ),
            fillColor: Colors.black12,
            filled: true,
          ),
          style: TextStyle(color: Colors.white),
        ),
        SizedBox(height: 16.h),
        
        // Momentary switch
        _buildSwitchRow(
          translate('انتخاب حالت لحظه ای'),
          index < _isMomentaryActive.length ? _isMomentaryActive[index] : true,
          (value) {
            setState(() {
              // If turning on momentary, turn off on/off mode
              if (value) {
                _isMomentaryActive[index] = true;
                _isOnOffActive[index] = false;
              } else {
                // Don't allow both switches to be off
                if (_isOnOffActive[index]) {
                  _isMomentaryActive[index] = false;
                } else {
                  _isMomentaryActive[index] = true;
                }
              }
            });
          },
        ),
        
        // On/Off switch
        _buildSwitchRow(
          translate('انتخاب حالت روشن / خاموش'),
          index < _isOnOffActive.length ? _isOnOffActive[index] : false,
          (value) {
            setState(() {
              // If turning on on/off mode, turn off momentary mode
              if (value) {
                _isOnOffActive[index] = true;
                _isMomentaryActive[index] = false;
              } else {
                // Don't allow both switches to be off
                if (_isMomentaryActive[index]) {
                  _isOnOffActive[index] = false;
                } else {
                  _isOnOffActive[index] = true;
                }
              }
            });
          },
        ),
      ],
    );
  }

  Widget _buildSwitchRow(String title, bool value, Function(bool) onChanged) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14.sp,
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.blue,
            activeTrackColor: Colors.blue.withOpacity(0.5),
            inactiveThumbColor: Colors.grey,
            inactiveTrackColor: Colors.grey.withOpacity(0.5),
          ),
        ],
      ),
    );
  }

  Widget _buildAddRelayDialog() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isAddingRelay = false;
        });
      },
      child: Container(
        color: Colors.black.withOpacity(0.5),
        child: Center(
          child: GestureDetector(
            onTap: () {}, // Prevent dialog from closing when tapping inside
            child: Container(
              width: 0.85.sw,
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: const Color(0xFF09162E),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: Colors.blue, width: 2),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    translate('add_new_relay'),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  TextField(
                    controller: _newRelayNameController,
                    decoration: InputDecoration(
                      labelText: translate('relay_name'),
                      labelStyle: const TextStyle(color: Colors.white70),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white30),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.blue),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                  SizedBox(height: 24.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _isAddingRelay = false;
                          });
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                        ),
                        child: Text(translate('cancel')),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          if (_newRelayNameController.text.isNotEmpty) {
                            await _addNewRelay(_newRelayNameController.text);
                            setState(() {
                              _isAddingRelay = false;
                            });
                          } else {
                            toastGenerator(translate('please_enter_relay_name'));
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                        ),
                        child: Text(translate('add')),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
} 