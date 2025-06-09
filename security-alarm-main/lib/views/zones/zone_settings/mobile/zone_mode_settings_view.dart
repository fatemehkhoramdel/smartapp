import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';
import 'package:security_alarm/widgets/elevated_button_widget.dart';

import '../../../../core/constants/design_values.dart';
import '../../../../core/utils/enums.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/utils/helper.dart';
import '../../../../models/device.dart';
import '../../../../providers/main_provider.dart';
import '../../../../providers/zones_provider.dart';
import '../../../../repository/sms_repository.dart';
import '../../../../injector.dart';
import '../../../../core/constants/sms_codes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';
import 'package:security_alarm/core/constants/global_keys.dart';
import 'package:security_alarm/views/home/drawer_menu_widget.dart';
import 'package:tokenizer/tokenizer.dart';

// Move the ZoneModel class definition to the top level
class ZoneModel {
  final int id;
  final String name;
  final String connectionType; // "wired" or "wireless"
  final List<String> conditions; // List of conditions for this zone
  
  ZoneModel({
    required this.id,
    required this.name,
    required this.connectionType,
    required this.conditions,
  });
}

class ZoneModeSettingsView extends StatefulWidget {
  const ZoneModeSettingsView({Key? key}) : super(key: key);

  @override
  State<ZoneModeSettingsView> createState() => _ZoneModeSettingsViewState();
}

class _ZoneModeSettingsViewState extends State<ZoneModeSettingsView> {
  bool _isAddingZone = false;
  final TextEditingController _newZoneNameController = TextEditingController();
  String _selectedZoneType = ZoneCondition.fullHour.value;
  
  // List of all zones
  List<ZoneModel> _zones = [];
  bool _hasChanges = false;

  // Zone limits - updated as requested
  static const int MAX_WIRED_ZONES = 6;
  static const int MIN_WIRED_ZONES = 1;
  static const int MAX_WIRELESS_ZONES = 4;
  static const int MIN_WIRELESS_ZONES = 1;

  // New state variable for zone connection type
  String _selectedZoneConnectionType = "wired"; // Default to wired
  
  // Get zone connection types
  List<String> _getZoneConnectionTypes() {
    return ["wired", "wireless"]; // "با سیم", "بی سیم"
  }

  // Count zones by connection type with null safety
  int _getWiredZonesCount() {
    return _zones.where((zone) => zone.connectionType == "wired").length;
  }
  
  int _getWirelessZonesCount() {
    return _zones.where((zone) => zone.connectionType == "wireless").length;
  }
  
  // Check if we can add more zones of a specific type
  bool _canAddZone(String connectionType) {
    if (connectionType == "wired") {
      return _getWiredZonesCount() < MAX_WIRED_ZONES;
    } else {
      return _getWirelessZonesCount() < MAX_WIRELESS_ZONES;
    }
  }
  
  // Check if we can remove a zone of a specific type
  bool _canRemoveZone(String connectionType) {
    if (connectionType == "wired") {
      return _getWiredZonesCount() > MIN_WIRED_ZONES;
    } else {
      return _getWirelessZonesCount() > MIN_WIRELESS_ZONES;
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initZones();
    });
    // Set default zone type to full hour (24 ساعته)
    _selectedZoneType = ZoneCondition.fullHour.value;
  }

  void _initZones() async {
    final mainProvider = Provider.of<MainProvider>(context, listen: false);
    final zonesProvider = Provider.of<ZonesProvider>(context, listen: false);
    
    // First, load zones from database
    await zonesProvider.loadZones();
    
    // Get all zones from provider
    List<ZoneModel> savedZones = zonesProvider.getAllZones();

    if (savedZones.isNotEmpty) {
      // Use zones from provider
      setState(() {
        _zones = savedZones;
      });
    } else {
      // Fall back to creating from device data (should rarely happen now)
      final device = mainProvider.selectedDevice;
      setState(() {
        _zones = [
          // Add default wired zone (from zone1)
          ZoneModel(
            id: 1,
            name: device.zone1Name,
            connectionType: "wired",
            conditions: _extractModes(device.zone1Condition),
          ),
          // Add default wireless zone (from zone2)
          ZoneModel(
            id: 2,
            name: device.zone2Name,
            connectionType: "wireless",
            conditions: _extractModes(device.zone2Condition),
          ),
        ];
        
        // Add remaining zones from device
        if (device.zone3Name.isNotEmpty) {
          _zones.add(ZoneModel(
            id: 3,
            name: device.zone3Name,
            connectionType: "wired", // Default to wired for existing zones
            conditions: _extractModes(device.zone3Condition),
          ));
        }

        if (device.zone4Name.isNotEmpty) {
          _zones.add(ZoneModel(
            id: 4,
            name: device.zone4Name,
            connectionType: "wired",
            conditions: _extractModes(device.zone4Condition),
          ));
        }

        if (device.zone5Name.isNotEmpty) {
          _zones.add(ZoneModel(
            id: 5,
            name: device.zone5Name,
            connectionType: "wired",
            conditions: _extractModes(device.zone5Condition),
          ));
        }
        
        // Save these zones to the provider for future reference
        zonesProvider.setAllZones(_zones);
      });
    }
  }

  // Helper method to extract modes from a zone condition
  List<String> _extractModes(String zoneCondition) {
    // Default to a list with the current condition
    return [zoneCondition];
  }

  @override
  void dispose() {
    _newZoneNameController.dispose();
    super.dispose();
  }

  // Method to add a new zone
  void _addZone(String name, String connectionType, String condition) {
    if (!_canAddZone(connectionType)) {
      String messageType = connectionType == "wired" ? "با سیم" : "بی سیم";
      int maxCount = connectionType == "wired" ? MAX_WIRED_ZONES : MAX_WIRELESS_ZONES;
      toastGenerator("نمی‌توان بیش از $maxCount زون $messageType اضافه کرد");
      return;
    }
    
    // Get ZonesProvider to store the zone
    final zonesProvider = Provider.of<ZonesProvider>(context, listen: false);
    
    setState(() {
      // Create unique ID (can be more sophisticated if needed)
      int newId = _zones.isEmpty ? 1 : (_zones.map((z) => z.id).reduce((a, b) => a > b ? a : b) + 1);
      
      ZoneModel newZone = ZoneModel(
        id: newId,
        name: name,
        connectionType: connectionType,
        conditions: [condition],
      );
      
      // Add to local state
      _zones.add(newZone);
      
      // Add to provider for persistence
      zonesProvider.addZone(newZone);
      
      _hasChanges = true;
    });
  }
  
  // Method to remove a zone with proper null safety
  void _removeZone(int zoneId) {
    final zoneToRemove = _zones.firstWhere((zone) => zone.id == zoneId);
    
    if (!_canRemoveZone(zoneToRemove.connectionType)) {
      String messageType = zoneToRemove.connectionType == "wired" ? "با سیم" : "بی سیم";
      toastGenerator("حداقل یک زون $messageType باید وجود داشته باشد");
      return;
    }
    
    // Get ZonesProvider to update stored zones
    final zonesProvider = Provider.of<ZonesProvider>(context, listen: false);
    
    setState(() {
      _zones.removeWhere((zone) => zone.id == zoneId);
      
      // Update provider
      zonesProvider.removeZone(zoneId);
      
      _hasChanges = true;
    });
  }

  // Method to update zone condition
  void _updateZoneCondition(int zoneId, String newCondition) {
    final zonesProvider = Provider.of<ZonesProvider>(context, listen: false);
    
    setState(() {
      final index = _zones.indexWhere((zone) => zone.id == zoneId);
      
      if (index != -1) {
        // We need to handle main modes (not ding dong) separately
        if (newCondition != ZoneCondition.dingDong.value) {
          // Get current conditions
          List<String> currentConditions = List.from(_zones[index].conditions);
          
          // Remove any existing main modes
          currentConditions.removeWhere((mode) => 
            mode != ZoneCondition.dingDong.value);
          
          // Add the new main mode
          currentConditions.add(newCondition);
          
          // If the new mode is 'inactive', remove ding dong if it exists
          if (newCondition == ZoneCondition.inactive.value) {
            currentConditions.remove(ZoneCondition.dingDong.value);
          }
          
          // Create updated zone
          ZoneModel updatedZone = ZoneModel(
            id: _zones[index].id,
            name: _zones[index].name,
            connectionType: _zones[index].connectionType,
            conditions: currentConditions,
          );
          
          // Update local state
          _zones[index] = updatedZone;
          
          // Update in provider
          zonesProvider.updateZone(updatedZone);
          
          _hasChanges = true;
        }
      }
    });
  }
  
  // Method to toggle ding dong mode for a zone
  void _toggleDingDongMode(int zoneId, bool enableDingDong) {
    final zonesProvider = Provider.of<ZonesProvider>(context, listen: false);
    
    setState(() {
      final index = _zones.indexWhere((zone) => zone.id == zoneId);
      
      if (index != -1) {
        List<String> currentConditions = List.from(_zones[index].conditions);
        
        if (enableDingDong) {
          // Only allow enabling ding dong if not in inactive mode
          if (!currentConditions.contains(ZoneCondition.inactive.value)) {
            // Add ding dong if not already present
            if (!currentConditions.contains(ZoneCondition.dingDong.value)) {
              currentConditions.add(ZoneCondition.dingDong.value);
              
              // Create updated zone
              ZoneModel updatedZone = ZoneModel(
                id: _zones[index].id,
                name: _zones[index].name,
                connectionType: _zones[index].connectionType,
                conditions: currentConditions,
              );
              
              // Update local state and provider
              _zones[index] = updatedZone;
              zonesProvider.updateZone(updatedZone);
              
              _hasChanges = true;
            }
          }
        } else {
          // Remove ding dong if present
          if (currentConditions.remove(ZoneCondition.dingDong.value)) {
            // Make sure we still have a main mode
            if (currentConditions.isEmpty) {
              // If no main mode, default to normal mode
              currentConditions.add(ZoneCondition.normalyClose.value);
            }
            
            // Create updated zone
            ZoneModel updatedZone = ZoneModel(
              id: _zones[index].id,
              name: _zones[index].name,
              connectionType: _zones[index].connectionType,
              conditions: currentConditions,
            );
            
            // Update local state and provider
            _zones[index] = updatedZone;
            zonesProvider.updateZone(updatedZone);
            
            _hasChanges = true;
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SliderDrawer(
        slideDirection: SlideDirection.RIGHT_TO_LEFT,
        isDraggable: false,
        appBar: null,
        key: getDrawerKey('ZoneModeSettings'),
        sliderOpenSize: 0.78.sw,
        slider: DrawerMenuWidget(drawerKey: getDrawerKey('ZoneModeSettings')),
        child: Scaffold(
          backgroundColor: const Color(0xFF09162E), // Dark blue background
          appBar: AppBar(
            backgroundColor: const Color(0xFF09162E),
            elevation: 0,
            title: Text(
              translate('تنظیمات'),
              style: TextStyle(color: Colors.white, fontSize: 18.sp),
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
                  icon: Icon(Icons.chevron_right, color: Colors.white, size: 24.sp),
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
                icon: Icon(Icons.menu, color: Colors.white, size: 24.sp),
                onPressed: () {
                  getDrawerKey('ZoneModeSettings').currentState!.toggle();
                },
              ),
            ),
          ),
          body: Consumer2<MainProvider, ZonesProvider>(
            builder: (context, mainProvider, zonesProvider, child) {
              final selectedDevice = mainProvider.selectedDevice;

              return Container(
                color: const Color(0xFF09162E),
                child: Stack(
                  children: [
                    Column(
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 20.h),
                          alignment: Alignment.center,
                          child: Text(
                            translate('تنظیمات حالت زون ها'),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        
                        // Zone type counts and add button row
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                _isAddingZone = true;
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 6.h),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.r),
                                border: Border.all(color: const Color(0xFF2E70E6), width: 1.w),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.add, color: const Color(0xFF2E70E6), size: 18.sp),
                                  SizedBox(width: 8.w),
                                  Text(
                                    translate('افزودن زون جدید'),
                                    style: TextStyle(
                                      color: const Color(0xFF2E70E6),
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        
                        // Debugging info - show zone counts
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "با سیم: ${_getWiredZonesCount()}/${MAX_WIRED_ZONES}",
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14.sp,
                                ),
                              ),
                              Text(
                                "بی سیم: ${_getWirelessZonesCount()}/${MAX_WIRELESS_ZONES}",
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14.sp,
                                ),
                              ),
                              Text(
                                "کل: ${_zones.length}",
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        // Zone List
                        Expanded(
                          child: ListView.builder(
                            itemCount: _zones.length,
                            itemBuilder: (context, index) {
                              final zone = _zones[index];
                              return _buildZoneItem(context, zone, zonesProvider);
                            },
                          ),
                        ),

                        // Bottom Buttons
                        Padding(
                          padding: EdgeInsets.all(16.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: ElevatedButtonWidget(
                                  onPressBtn: () async {
                                    final controller = TextEditingController();
                                    await zonesProvider.getZonesFromDevice(controller);
                                  },
                                  btnText: translate('استعلام'),
                                  btnColor: Colors.blue,
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: ElevatedButtonWidget(
                                  onPressBtn: () {
                                    // Save all zone settings and send SMS
                                    _saveAllZones(zonesProvider, mainProvider);
                                  },
                                  btnText: translate('ذخیره'),
                                  btnColor: Colors.purple,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 8.h,)
                      ],
                    ),

                    // Add Zone Dialog
                    if (_isAddingZone)
                      _buildAddZoneDialog(context, zonesProvider),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildZoneItem(BuildContext context, ZoneModel zone, ZonesProvider zonesProvider) {
    // Determine which states are active
    List<String> zoneModes = zone.conditions;
    
    bool isNormalActive = zoneModes.contains(ZoneCondition.normalyClose.value) ||
        zoneModes.contains(ZoneCondition.normalyOpen.value);
    bool is24HourActive = zoneModes.contains(ZoneCondition.fullHour.value);
    bool isHiddenSMSActive = zoneModes.contains(ZoneCondition.hiddenSMS.value);
    bool isHiddenCallActive = zoneModes.contains(ZoneCondition.hiddenCall.value);
    bool isInactiveActive = zoneModes.contains(ZoneCondition.inactive.value);
    bool isDingDongActive = zoneModes.contains(ZoneCondition.dingDong.value);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        children: [
          // Zone Header
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: zone.connectionType == "wired" 
                  ? Colors.blue.withOpacity(0.1)
                  : Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8.r),
                topRight: Radius.circular(8.r),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Zone name and type
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${zone.name} ${zone.id.toString()}",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      translate(zone.connectionType == "wired" ? "با سیم" : "بی سیم"),
                      style: TextStyle(
                        color: zone.connectionType == "wired" ? Colors.blue : Colors.green,
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
                
                // Delete button
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () async {
                    // Confirm before removing
                    final shouldRemove = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text(translate('remove_zone')),
                        content: Text(translate('are_you_sure')),
                        backgroundColor: const Color(0XFF09162E),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: Text(translate('cancel')),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: Text(translate('remove')),
                          ),
                        ],
                      ),
                    );

                    if (shouldRemove == true) {
                      _removeZone(zone.id);
                      // Also call the API to remove from device
                      await zonesProvider.removeZoneFromDevice(zone.id);
                    }
                  },
                ),
              ],
            ),
          ),

          // Zone Type Switches
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: Column(
              children: [
                _buildSwitchItem(
                  context: context,
                  title: translate('انتخاب حالت فوری'),
                  value: isNormalActive,
                  onChanged: (value) {
                    if (value) {
                      _updateZoneCondition(zone.id, ZoneCondition.normalyClose.value);
                    }
                  },
                ),
                _buildSwitchItem(
                  context: context,
                  title: translate('انتخاب حالت 24 ساعته'),
                  value: is24HourActive,
                  onChanged: (value) {
                    if (value) {
                      _updateZoneCondition(zone.id, ZoneCondition.fullHour.value);
                    }
                  },
                ),
                _buildSwitchItem(
                  context: context,
                  title: translate('انتخاب حالت مخفی پیامک'),
                  value: isHiddenSMSActive,
                  onChanged: (value) {
                    if (value) {
                      _updateZoneCondition(zone.id, ZoneCondition.hiddenSMS.value);
                    }
                  },
                ),
                _buildSwitchItem(
                  context: context,
                  title: translate('انتخاب حالت مخفی تماس'),
                  value: isHiddenCallActive,
                  onChanged: (value) {
                    if (value) {
                      _updateZoneCondition(zone.id, ZoneCondition.hiddenCall.value);
                    }
                  },
                ),
                _buildSwitchItem(
                  context: context,
                  title: translate('انتخاب حالت غیر فعال'),
                  value: isInactiveActive,
                  onChanged: (value) {
                    if (value) {
                      _updateZoneCondition(zone.id, ZoneCondition.inactive.value);
                    }
                  },
                ),
                _buildSwitchItem(
                  context: context,
                  title: translate('دینگ دانگ'),
                  value: isDingDongActive,
                  onChanged: isInactiveActive
                      ? (_) => toastGenerator('وقتی زون غیرفعال است، حالت دینگ دانگ قابل انتخاب نیست') // Disable if zone is inactive
                      : (value) {
                          _toggleDingDongMode(zone.id, value);
                        },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _saveAllZones(ZonesProvider zonesProvider, MainProvider mainProvider) async {
    try {
      // Sort zones by ID for consistent order
      List<ZoneModel> sortedZones = List.from(_zones)..sort((a, b) => a.id.compareTo(b.id));
      
      // Ensure provider has all zones
      zonesProvider.setAllZones(_zones);
      
      // Create a device copy with updated zone information (for first 5 zones)
      Device device = mainProvider.selectedDevice;
      Device updatedDevice = device;
      
      // Update up to 5 zones (for compatibility with current device model)
      if (sortedZones.isNotEmpty) {
        updatedDevice = updatedDevice.copyWith(
          zone1Name: sortedZones[0].name,
          zone1Condition: _getMainMode(sortedZones[0].conditions),
        );
      }
      
      if (sortedZones.length > 1) {
        updatedDevice = updatedDevice.copyWith(
          zone2Name: sortedZones[1].name,
          zone2Condition: _getMainMode(sortedZones[1].conditions),
        );
      }
      
      if (sortedZones.length > 2) {
        updatedDevice = updatedDevice.copyWith(
          zone3Name: sortedZones[2].name,
          zone3Condition: _getMainMode(sortedZones[2].conditions),
        );
      }
      
      if (sortedZones.length > 3) {
        updatedDevice = updatedDevice.copyWith(
          zone4Name: sortedZones[3].name,
          zone4Condition: _getMainMode(sortedZones[3].conditions),
        );
      }
      
      if (sortedZones.length > 4) {
        updatedDevice = updatedDevice.copyWith(
          zone5Name: sortedZones[4].name,
          zone5Condition: _getMainMode(sortedZones[4].conditions),
        );
      }
      
      // Update in zonesProvider (this will also handle formatting and sending the SMS)
      await zonesProvider.updateZoneConditionBatch(updatedDevice);
      
      setState(() {
        _hasChanges = false;
      });
      
      toastGenerator(translate('changes_saved_successfully'));
    } catch (e) {
      log('Error in _saveAllZones: $e');
      toastGenerator(translate('error_saving_changes'));
    }
  }

  // Helper method to get the main mode from a list of modes
  String _getMainMode(List<String> modes) {
    // Filter out ding dong mode to get the main mode
    List<String> mainModes = modes.where(
      (mode) => mode != ZoneCondition.dingDong.value
    ).toList();
    
    // Return the first main mode or default to normal mode if none found
    return mainModes.isNotEmpty ? mainModes.first : ZoneCondition.normalyClose.value;
  }

  Widget _buildSwitchItem({
    required BuildContext context,
    required String title,
    required bool value,
    required ValueChanged<bool>? onChanged,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.sp,
            ),
          ),
          Directionality(
            textDirection: TextDirection.ltr,
            child: Switch(
              value: value,
              onChanged: onChanged,
              activeColor: Colors.white,
              activeTrackColor: Colors.blue,
              inactiveTrackColor: Colors.transparent,
              inactiveThumbColor: Colors.white,
              trackOutlineColor: WidgetStateProperty.resolveWith<Color?>(
                      (Set<WidgetState> states) {
                    if (states.contains(WidgetState.selected)) {
                      return Colors.transparent;
                    }
                    return Colors.white; // Use the default width.
                  }),
              trackOutlineWidth: WidgetStateProperty.resolveWith<double?>(
                  (Set<WidgetState> states) {
                if (states.contains(WidgetState.selected)) {
                  return 1;
                }
                return 0.0; // Use the default width.
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddZoneDialog(BuildContext context, ZonesProvider zonesProvider) {
    return GestureDetector(
      onTap: () {
        // Close dialog when tapping outside
        setState(() {
          _isAddingZone = false;
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
                    translate('افزودن زون جدید'),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  TextField(
                    controller: _newZoneNameController,
                    decoration: InputDecoration(
                      labelText: translate('نام زون جدید'),
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
                  SizedBox(height: 16.h),
                  // First dropdown for connection type (wired/wireless)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white30),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        dropdownColor: const Color(0xFF09162E),
                        icon: const Icon(Icons.arrow_drop_down,
                            color: Colors.white),
                        value: _selectedZoneConnectionType,
                        items: _getZoneConnectionTypes()
                            .map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value == "wired" ? translate('با سیم') : translate('بی سیم'),
                              style: const TextStyle(color: Colors.white),
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setState(() {
                              _selectedZoneConnectionType = newValue;
                            });
                          }
                        },
                        hint: Text(
                          translate('انتخاب نوع اتصال زون'),
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  // Second dropdown for zone condition
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white30),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        dropdownColor: const Color(0xFF09162E),
                        icon: const Icon(Icons.arrow_drop_down,
                            color: Colors.white),
                        value: _selectedZoneType,
                        items: ZoneConditionExt.getZoneConditionsAsList()
                            .map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: const TextStyle(color: Colors.white),
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setState(() {
                              _selectedZoneType = newValue;
                            });
                          }
                        },
                        hint: Text(
                          translate('انتخاب نوع زون'),
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 24.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _isAddingZone = false;
                            _newZoneNameController.clear();
                          });
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                        ),
                        child: Text(translate('انصراف')),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Add new zone logic here
                          if (_newZoneNameController.text.isNotEmpty) {
                            // Store the zone with name, type and default condition
                            String zoneName = _newZoneNameController.text;
                            
                            // Check if we can add a zone of this type
                            if (_canAddZone(_selectedZoneConnectionType)) {
                              // Add the zone
                              _addZone(zoneName, _selectedZoneConnectionType, _selectedZoneType);
                              
                              toastGenerator(translate('zone_saved_successfully'));
                              setState(() {
                                _isAddingZone = false;
                                _newZoneNameController.clear();
                                // Reset to defaults for next time
                                _selectedZoneConnectionType = "wired";
                                _selectedZoneType = ZoneCondition.fullHour.value;
                              });
                            } else {
                              // Show error if max zones reached
                              String type = _selectedZoneConnectionType == "wired" ? "با سیم" : "بی سیم";
                              int maxCount = _selectedZoneConnectionType == "wired" ? MAX_WIRED_ZONES : MAX_WIRELESS_ZONES;
                              toastGenerator("نمی‌توان بیش از $maxCount زون $type اضافه کرد");
                            }
                          } else {
                            toastGenerator(translate('لطفا نام زون را وارد کنید'));
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

  /// Helper method to convert zone condition to the required single letter code
  String _getZoneModeCode(String zoneCondition) {
    if (zoneCondition == ZoneCondition.normalyClose.value || 
        zoneCondition == ZoneCondition.normalyOpen.value) {
      return "A"; // Immediate (فوری)
    } else if (zoneCondition == ZoneCondition.fullHour.value) {
      return "B"; // 24 hours (24 ساعته)
    } else if (zoneCondition == ZoneCondition.hiddenSMS.value) {
      return "C"; // Hidden SMS (مخفی پیامک)
    } else if (zoneCondition == ZoneCondition.hiddenCall.value) {
      return "D"; // Hidden call (مخفی تماس)
    } else if (zoneCondition == ZoneCondition.inactive.value) {
      return "Z"; // Disabled (غیرفعال)
    } else {
      return "A"; // Default to immediate mode
    }
  }
}
