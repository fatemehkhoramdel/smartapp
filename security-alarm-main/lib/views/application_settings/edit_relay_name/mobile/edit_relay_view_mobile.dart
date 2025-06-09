import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../../core/utils/enums.dart';
import '../../../../core/utils/helper.dart';
import '../../../../models/relay.dart';
import '../../../../providers/app_settings_provider.dart';
import '../../../../providers/main_provider.dart';
import '../../../../core/utils/extensions.dart';

// Add RelayMode enum
enum RelayMode {
  toggle,
  momentary,
}

class EditRelayViewMobile extends StatefulWidget {
  EditRelayViewMobile({Key? key}) : super(key: key);

  @override
  State<EditRelayViewMobile> createState() => _EditRelayViewMobileState();
}

class _EditRelayViewMobileState extends State<EditRelayViewMobile> {
  bool _isAddingRelay = false;
  final TextEditingController _newRelayNameController = TextEditingController();
  
  // Mode selection
  Map<int, bool> _isMomentaryMode = {};
  Map<int, bool> _isToggleMode = {};
  
  // Duration slider values
  Map<int, double> _momentaryDurations = {};
  
  late MainProvider _mainProvider;
  late AppSettingsProvider _appSettingsProvider;

  @override
  void initState() {
    super.initState();
    
    // Initialize after the build is complete
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeRelaySettings();
    });
  }
  
  void _initializeRelaySettings() {
    final relays = _mainProvider.relays;
    
    // Initialize mode and duration maps for each relay
    for (int i = 0; i < relays.length; i++) {
      final relay = relays[i];
      final momentaryDurationSeconds = _getTriggerTimeInSeconds(relay.relayTriggerTime);
      
      // Default modes (if relayTriggerTime is not empty, relay is in momentary mode)
      _isMomentaryMode[i] = relay.relayTriggerTime.isNotEmpty;
      _isToggleMode[i] = !_isMomentaryMode[i]!;
      
      // Set duration (default to 5 seconds if not set)
      _momentaryDurations[i] = momentaryDurationSeconds.toDouble();
    }
    
    setState(() {});
  }
  
  // Convert trigger time string (HHMMSS format) to seconds
  int _getTriggerTimeInSeconds(String triggerTime) {
    if (triggerTime.isEmpty || triggerTime.length != 6) return 5;
    
    try {
      final hours = int.parse(triggerTime.substring(0, 2));
      final minutes = int.parse(triggerTime.substring(2, 4));
      final seconds = int.parse(triggerTime.substring(4, 6));
      
      return hours * 3600 + minutes * 60 + seconds;
    } catch (e) {
      return 5;
    }
  }
  
  // Convert seconds to trigger time string (HHMMSS format)
  String _getFormattedTriggerTime(int totalSeconds) {
    final hours = (totalSeconds ~/ 3600).toString().padLeft(2, '0');
    final minutes = ((totalSeconds % 3600) ~/ 60).toString().padLeft(2, '0');
    final seconds = (totalSeconds % 60).toString().padLeft(2, '0');
    
    return '$hours$minutes$seconds';
  }

  @override
  void dispose() {
    _newRelayNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _mainProvider = Provider.of<MainProvider>(context);
    _appSettingsProvider = Provider.of<AppSettingsProvider>(context);
    
    return Container(
      color: const Color(0xFF09162E),
      child: Stack(
        children: [
          Column(
            children: [
              // Add Relay Button
              Padding(
                padding: EdgeInsets.all(16.w),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _isAddingRelay = true;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add, color: Colors.white),
                        SizedBox(width: 8.w),
                        Text(
                          translate('افزودن رله جدید'),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              
              // Relay List
              Expanded(
                child: _mainProvider.relays.isEmpty
                    ? Center(
                        child: Text(
                          translate('هیچ رله‌ای وجود ندارد'),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.sp,
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: _mainProvider.relays.length,
                        itemBuilder: (context, index) {
                          return _buildRelayItem(index);
                        },
                      ),
              ),
            ],
          ),
          
          // Add Relay Dialog
          if (_isAddingRelay)
            _buildAddRelayDialog(),
        ],
      ),
    );
  }

  Widget _buildRelayItem(int index) {
    final relay = _mainProvider.relays[index];
    final durationValue = _momentaryDurations[index] ?? 5.0;
    
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.blue.withOpacity(0.5), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      translate('نام رله'),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8.h),
                  ],
                ),
              ),
              // Delete Relay Button
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
                        translate('حذف رله'),
                        style: TextStyle(color: Colors.white),
                      ),
                      content: Text(
                        translate('آیا از حذف این رله اطمینان دارید؟'),
                        style: TextStyle(color: Colors.white70),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text(
                            translate('انصراف'),
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            _deleteRelay(index);
                          },
                          child: Text(
                            translate('حذف'),
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
          TextField(
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white30),
                borderRadius: BorderRadius.circular(8.r),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue),
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            style: TextStyle(color: Colors.white),
            controller: TextEditingController(text: relay.relayName),
            onSubmitted: (value) {
              if (value.isNotEmpty) {
                _updateRelayName(index, value);
              }
            },
          ),
          SizedBox(height: 20.h),
          
          // Mode Selector
          Text(
            translate('حالت'),
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              _buildModeOption(
                index,
                RelayMode.toggle,
                translate('روشن/خاموش'),
              ),
              SizedBox(width: 16.w),
              _buildModeOption(
                index,
                RelayMode.momentary,
                translate('لحظه‌ای'),
              ),
            ],
          ),
          
          // Show duration slider only for momentary mode
          if (_isMomentaryMode[index] == true) ...[
            SizedBox(height: 16.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${translate('مدت زمان')}: ${durationValue.toInt()} ${translate('ثانیه')}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                  ),
                ),
              ],
            ),
          SizedBox(height: 8.h),
            Slider(
              value: durationValue,
              min: 5,
              max: 120,
              divisions: 23, // To allow increments of 5
              label: '${durationValue.toInt()}',
              onChanged: (value) {
                setState(() {
                  _momentaryDurations[index] = value;
                });
              },
              onChangeEnd: (value) {
                _updateRelayTriggerTime(index, value.toInt());
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAddRelayDialog() {
    return GestureDetector(
      onTap: () {
        // Close dialog when tapping outside
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
                    translate('افزودن رله جدید'),
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
                      labelText: translate('نام رله'),
                      labelStyle: TextStyle(color: Colors.white70),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white30),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(height: 24.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _isAddingRelay = false;
                            _newRelayNameController.clear();
                          });
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                        ),
                        child: Text(translate('انصراف')),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (_newRelayNameController.text.isNotEmpty) {
                            _addNewRelay(_newRelayNameController.text);
                            setState(() {
                              _isAddingRelay = false;
                              _newRelayNameController.clear();
                            });
                          } else {
                            toastGenerator(translate('لطفا نام رله را وارد کنید'));
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                        ),
                        child: Text(translate('افزودن')),
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

  // Update relay name
  Future<void> _updateRelayName(int index, String newName) async {
    final relay = _mainProvider.relays[index];
    final updatedRelay = relay.copyWith(relayName: newName);
    await _mainProvider.updateRelay(updatedRelay);
    toastGenerator(translate('تغییرات با موفقیت ذخیره شد'));
  }
  
  // Update relay mode (momentary or toggle)
  Future<void> _updateRelayMode(int index, bool isMomentary) async {
    final relay = _mainProvider.relays[index];
    
    if (isMomentary) {
      // Convert to momentary with current duration
      final seconds = _momentaryDurations[index]?.toInt() ?? 5;
      final triggerTime = _getFormattedTriggerTime(seconds);
      final updatedRelay = relay.copyWith(relayTriggerTime: triggerTime);
      await _mainProvider.updateRelay(updatedRelay);
    } else {
      // Convert to toggle mode (empty trigger time)
      final updatedRelay = relay.copyWith(relayTriggerTime: '');
      await _mainProvider.updateRelay(updatedRelay);
    }
    
    toastGenerator(translate('تغییرات با موفقیت ذخیره شد'));
  }
  
  // Update relay trigger time (for momentary mode)
  Future<void> _updateRelayTriggerTime(int index, int seconds) async {
    final relay = _mainProvider.relays[index];
    final triggerTime = _getFormattedTriggerTime(seconds);
    final updatedRelay = relay.copyWith(relayTriggerTime: triggerTime);
    await _mainProvider.updateRelay(updatedRelay);
    toastGenerator(translate('تغییرات با موفقیت ذخیره شد'));
  }
  
  // Add new relay
  Future<void> _addNewRelay(String name) async {
    final deviceId = _mainProvider.selectedDevice.id;
    if (deviceId == null) {
      toastGenerator(translate('خطا در افزودن رله'));
      return;
    }
    
    final newRelay = Relay(
      deviceId: deviceId,
      relayName: name,
      relayTriggerTime: '',
      relayState: false,
    );
    
    await _mainProvider.insertRelay(newRelay);
    await _mainProvider.getAllRelays();
    
    // Initialize settings for the new relay
    _initializeRelaySettings();
    
    toastGenerator(translate('رله جدید با موفقیت اضافه شد'));
  }
  
  // Delete relay
  Future<void> _deleteRelay(int index) async {
    final relay = _mainProvider.relays[index];
    final result = await _mainProvider.deleteRelay(relay);
    
    if (result.isSuccess) {
      // Remove from local state
      setState(() {
        _momentaryDurations.remove(index);
        _isMomentaryMode.remove(index);
        _isToggleMode.remove(index);
      });
      
      // Update the provider state with fresh data
      await _mainProvider.getAllRelays();
      
      // Show success message
      if (mounted) {
        toastGenerator(translate('رله با موفقیت حذف شد'));
      }
    } else {
      // Show error message
      if (mounted) {
        toastGenerator(translate('خطا در حذف رله'));
      }
    }
  }

  Widget _buildModeOption(int index, RelayMode mode, String label) {
    bool isSelected = false;
    
    if (mode == RelayMode.toggle) {
      isSelected = _isToggleMode[index] ?? false;
    } else if (mode == RelayMode.momentary) {
      isSelected = _isMomentaryMode[index] ?? false;
    }
    
    return InkWell(
      onTap: () {
        if (mode == RelayMode.toggle) {
          setState(() {
            _isToggleMode[index] = true;
            _isMomentaryMode[index] = false;
          });
          _updateRelayMode(index, false); // false means toggle mode
        } else {
          setState(() {
            _isToggleMode[index] = false;
            _isMomentaryMode[index] = true;
          });
          _updateRelayMode(index, true); // true means momentary mode
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.withOpacity(0.3) : Colors.black.withOpacity(0.5),
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.white30,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.white70,
            fontSize: 14.sp,
          ),
        ),
      ),
    );
  }
}
