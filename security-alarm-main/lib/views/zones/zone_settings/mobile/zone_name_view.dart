import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/design_values.dart';
import '../../../../models/device.dart';
import '../../../../providers/main_provider.dart';
import '../../../../providers/zones_provider.dart';
import '../../../../widgets/elevated_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:security_alarm/core/constants/global_keys.dart';
import 'package:security_alarm/views/home/drawer_menu_widget.dart';
import 'package:tokenizer/tokenizer.dart';
import 'zone_mode_settings_view.dart'; // Import to access ZoneModel

class ZoneNameView extends StatefulWidget {
  const ZoneNameView({Key? key}) : super(key: key);

  @override
  State<ZoneNameView> createState() => _ZoneNameViewState();
}

class _ZoneNameViewState extends State<ZoneNameView> {
  // Use a Map to store controllers by zone ID
  final Map<int, TextEditingController> _controllers = {};
  // List to store zone models
  List<ZoneModel> _zones = [];
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initZones();
    });
  }

  @override
  void dispose() {
    // Dispose all controllers
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  // Initialize zones from shared provider or device data
  void _initZones() async {
    final mainProvider = Provider.of<MainProvider>(context, listen: false);
    final zonesProvider = Provider.of<ZonesProvider>(context, listen: false);
    
    // First load zones from database
    await zonesProvider.loadZones();
    
    // Then get the loaded zones
    List<ZoneModel> savedZones = zonesProvider.getAllZones();
    
    if (savedZones.isNotEmpty) {
      // Use zones from provider
      setState(() {
        _zones = savedZones;
        
        // Reset controllers
        for (var controller in _controllers.values) {
          controller.dispose();
        }
        _controllers.clear();
        
        // Create controllers for each zone
        for (var zone in _zones) {
          _controllers[zone.id] = TextEditingController(text: zone.name);
        }
      });
    } else {
      // Fall back to creating from device data
      final device = mainProvider.selectedDevice;
      setState(() {
        _zones = [
          // First zone (zone1) - wired
          ZoneModel(
            id: 1,
            name: device.zone1Name,
            connectionType: "wired",
            conditions: [device.zone1Condition],
          ),
          // Second zone (zone2) - wireless
          ZoneModel(
            id: 2,
            name: device.zone2Name,
            connectionType: "wireless",
            conditions: [device.zone2Condition],
          ),
        ];
        
        // Add remaining zones if they exist
        if (device.zone3Name.isNotEmpty) {
          _zones.add(ZoneModel(
            id: 3,
            name: device.zone3Name,
            connectionType: "wired",
            conditions: [device.zone3Condition],
          ));
        }
        
        if (device.zone4Name.isNotEmpty) {
          _zones.add(ZoneModel(
            id: 4,
            name: device.zone4Name,
            connectionType: "wired",
            conditions: [device.zone4Condition],
          ));
        }
        
        if (device.zone5Name.isNotEmpty) {
          _zones.add(ZoneModel(
            id: 5,
            name: device.zone5Name,
            connectionType: "wired",
            conditions: [device.zone5Condition],
          ));
        }

        // Reset controllers
        for (var controller in _controllers.values) {
          controller.dispose();
        }
        _controllers.clear();
        
        // Create controllers for each zone
        for (var zone in _zones) {
          _controllers[zone.id] = TextEditingController(text: zone.name);
        }
        
        // Save these zones to the provider for future reference
        zonesProvider.setAllZones(_zones);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MyBaseWidget(
      hasScrollView: false,
      mobileChild: SliderDrawer(
        slideDirection: SlideDirection.RIGHT_TO_LEFT,
        isDraggable: false,
        appBar: null,
        key: getDrawerKey('ZoneNameView'),
        sliderOpenSize: 0.78.sw,
        slider: DrawerMenuWidget(drawerKey: getDrawerKey('ZoneNameView')),
        child: Scaffold(
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
                  onPressed: () =>
                      Navigator.pop(kNavigatorKey.currentContext!, true)
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
                  getDrawerKey('ZoneNameView').currentState!.toggle();
                },
              ),
            ),
          ),
          body: Consumer2<MainProvider, ZonesProvider>(
            builder: (context, mainProvider, zonesProvider, child) {
              final selectedDevice = mainProvider.selectedDevice;

              return Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                color: const Color(0xFF09162E),
                child: Column(
                  children: [
                    SizedBox(height: 20.h),
                    Center(
                      child: Text(
                        translate('تنظیمات نام زون‌ها'),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    // SizedBox(height: 16.h),
                    // Display current zone counts
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     Text(
                    //       "تعداد زون‌ها: ${_zones.length}",
                    //       style: TextStyle(
                    //         color: Colors.white70,
                    //         fontSize: 14.sp,
                    //       ),
                    //     ),
                    //     // Refresh button
                    //     IconButton(
                    //       icon: Icon(Icons.refresh, color: Colors.white),
                    //       onPressed: () {
                    //         _initZones(); // This will load zones from database
                    //       },
                    //       tooltip: "بارگذاری مجدد زون‌ها",
                    //     ),
                    //   ],
                    // ),
                    Expanded(
                      child: _zones.isEmpty
                          ? Center(
                              child: Text(
                                translate('هیچ زونی تعریف نشده است'),
                                style: TextStyle(color: Colors.white70, fontSize: 16.sp),
                              ),
                            )
                          : ListView.builder(
                              itemCount: _zones.length,
                              itemBuilder: (context, index) {
                                final zone = _zones[index];
                                return _buildZoneNameItem(zone, selectedDevice, zonesProvider);
                              },
                            ),
                    ),
                    SizedBox(height: 20.h),
                    ElevatedButtonWidget(
                      btnText: translate('save'),
                      btnColor: Colors.purple,
                      onPressBtn: () {
                        _saveZoneNames(zonesProvider, selectedDevice);
                      },
                    ),
                    SizedBox(height: 20.h),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  // Save all zone names
  void _saveZoneNames(ZonesProvider zonesProvider, Device device) {
    // Update zone names in our local model
    List<ZoneModel> updatedZones = [];
    
    for (var zone in _zones) {
      final controller = _controllers[zone.id];
      if (controller != null) {
        updatedZones.add(ZoneModel(
          id: zone.id,
          name: controller.text,
          connectionType: zone.connectionType,
          conditions: zone.conditions,
        ));
      } else {
        updatedZones.add(zone);
      }
    }
    
    // Update local state
    setState(() {
      _zones = updatedZones;
      _hasChanges = false;
    });
    
    // Save updated zones to provider for persistence (this will save to database)
    zonesProvider.setAllZones(updatedZones);

    // Sort zones by ID for consistency
    List<ZoneModel> sortedZones = List.from(_zones)..sort((a, b) => a.id.compareTo(b.id));

    // Create a device copy with updated zone names
    Device updatedDevice = device;
    
    // Update up to 5 zones (for compatibility with current device model)
    // But use name from the correct zone based on ID
    if (sortedZones.isNotEmpty && sortedZones.length > 0) {
      updatedDevice = updatedDevice.copyWith(
        zone1Name: _controllers[sortedZones[0].id]?.text ?? device.zone1Name
      );
    }
    
    if (sortedZones.length > 1) {
      updatedDevice = updatedDevice.copyWith(
        zone2Name: _controllers[sortedZones[1].id]?.text ?? device.zone2Name
      );
    }
    
    if (sortedZones.length > 2) {
      updatedDevice = updatedDevice.copyWith(
        zone3Name: _controllers[sortedZones[2].id]?.text ?? device.zone3Name
      );
    }
    
    if (sortedZones.length > 3) {
      updatedDevice = updatedDevice.copyWith(
        zone4Name: _controllers[sortedZones[3].id]?.text ?? device.zone4Name
      );
    }
    
    if (sortedZones.length > 4) {
      updatedDevice = updatedDevice.copyWith(
        zone5Name: _controllers[sortedZones[4].id]?.text ?? device.zone5Name
      );
    }
    
    // Create controllers list for zone names
    List<TextEditingController> zoneNameControllers = [];
    for (int i = 0; i < 5; i++) {
      int zoneIndex = i;
      // Find the zone with this index if it exists
      int zoneId = (zoneIndex < sortedZones.length) ? sortedZones[zoneIndex].id : (i + 1);
      TextEditingController controller = _controllers[zoneId] ?? 
                                         TextEditingController(text: "");
      zoneNameControllers.add(controller);
    }
    
    // Call the provider to update zone names
    zonesProvider.updateZoneNames(zoneNameControllers);
  }

  Widget _buildZoneNameItem(ZoneModel zone, Device device, ZonesProvider zonesProvider) {
    // Use the controller for this zone
    final controller = _controllers[zone.id] ?? TextEditingController();
    if (!_controllers.containsKey(zone.id)) {
      _controllers[zone.id] = controller;
      controller.text = zone.name;
    }
    
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Material(
        color: Colors.transparent,
        elevation: 0,
        child: Container(
          width: 1.0.sw,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(
              color: zone.connectionType == "wired" ? Colors.blue.withOpacity(0.3) : Colors.green.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${translate('zone')} ${zone.id}",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
                    ),
                  ),
                  // Display zone type badge
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: zone.connectionType == "wired" ? Colors.blue.withOpacity(0.2) : Colors.green.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Text(
                      translate(zone.connectionType == "wired" ? "با سیم" : "بی سیم"),
                      style: TextStyle(
                        color: zone.connectionType == "wired" ? Colors.blue : Colors.green,
                        fontSize: 12.sp,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              TextField(
                controller: controller,
                decoration: InputDecoration(
                  labelText: translate('zone_name'),
                  labelStyle: TextStyle(color: Colors.white70),
                  hintText: translate('enter_zone_name'),
                  hintStyle: TextStyle(color: Colors.white30),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: BorderSide(
                      color: zone.connectionType == "wired" ? Colors.blue.withOpacity(0.5) : Colors.green.withOpacity(0.5),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: BorderSide(
                      color: zone.connectionType == "wired" ? Colors.blue : Colors.green,
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.black.withOpacity(0.2),
                ),
                style: TextStyle(color: Colors.white),
                onChanged: (value) {
                  setState(() {
                    _hasChanges = true;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
} 