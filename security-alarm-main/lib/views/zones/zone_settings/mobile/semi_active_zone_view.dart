import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/design_values.dart';
import '../../../../models/device.dart';
import '../../../../providers/main_provider.dart';
import '../../../../providers/zones_provider.dart';
import '../../../../widgets/elevated_button_widget.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:security_alarm/core/constants/global_keys.dart';
import 'package:security_alarm/views/home/drawer_menu_widget.dart';
import 'package:tokenizer/tokenizer.dart';
import 'zone_mode_settings_view.dart'; // Import to access ZoneModel

class SemiActiveZoneView extends StatefulWidget {
  const SemiActiveZoneView({Key? key}) : super(key: key);

  @override
  State<SemiActiveZoneView> createState() => _SemiActiveZoneViewState();
}

class _SemiActiveZoneViewState extends State<SemiActiveZoneView> {
  bool _hasChanges = false;
  // List to store zone models
  List<ZoneModel> _zones = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initZones();
    });
  }

  // Initialize zones from database
  void _initZones() async {
    final zonesProvider = Provider.of<ZonesProvider>(context, listen: false);
    
    // First load zones from database
    await zonesProvider.loadZones();
    
    // Then get the loaded zones
    List<ZoneModel> savedZones = zonesProvider.getAllZones();
    
    if (savedZones.isNotEmpty) {
      setState(() {
        _zones = savedZones;
      });
    } else {
      // If no zones in database, fall back to default zones
      final mainProvider = Provider.of<MainProvider>(context, listen: false);
      final device = mainProvider.selectedDevice;
      
      // Initialize with default zones from device
      setState(() {
        _zones = [
          ZoneModel(
            id: 1,
            name: device.zone1Name,
            connectionType: "wired",
            conditions: [device.zone1Condition],
          ),
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
        key: getDrawerKey('SemiActiveZoneView'),
        sliderOpenSize: 0.78.sw,
        slider: DrawerMenuWidget(drawerKey: getDrawerKey('SemiActiveZoneView')),
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
                      Navigator.pop(kNavigatorKey.currentContext!, true),
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
                  getDrawerKey('SemiActiveZoneView').currentState!.toggle();
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
                        translate('تنظیمات زون ها برای حالت نیمه فعال'),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    // Display current zone counts and refresh button
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
                    // SizedBox(height: 20.h),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            // Filter and display wired zones
                            Text(
                              translate('زون‌های باسیم'),
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 16.h),
                            // Get wired zones and display them in rows of 2
                            ..._buildZoneRows(
                              _zones.where((z) => z.connectionType == "wired").toList(),
                              selectedDevice,
                              zonesProvider,
                              isWireless: false
                            ),
                            
                            SizedBox(height: 40.h),
                            
                            // Filter and display wireless zones
                            Text(
                              translate('زون‌های بی‌سیم'),
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 16.h),
                            // Get wireless zones and display them in rows of 2
                            ..._buildZoneRows(
                              _zones.where((z) => z.connectionType == "wireless").toList(),
                              selectedDevice,
                              zonesProvider,
                              isWireless: true
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    // Buttons Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: 150.w,
                          height: 50.h,
                          decoration: BoxDecoration(
                            color: const Color(0xFF2E70E6), // Blue color
                            borderRadius: BorderRadius.circular(25.r),
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              // Inquiry functionality
                              zonesProvider.getZonesFromDevice(TextEditingController());
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent, 
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25.r),
                              ),
                            ),
                            child: Text(
                              translate('استعلام'),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: 150.w,
                          height: 50.h,
                          decoration: BoxDecoration(
                            color: const Color(0xFF9932CC), // Purple color
                            borderRadius: BorderRadius.circular(25.r),
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              zonesProvider.saveSemiActiveZoneChanges();
                              setState(() {
                                _hasChanges = false;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25.r),
                              ),
                            ),
                            child: Text(
                              translate('ذخیره'),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
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

  // Helper to build rows of zones (2 zones per row)
  List<Widget> _buildZoneRows(List<ZoneModel> filteredZones, Device device, ZonesProvider zonesProvider, {required bool isWireless}) {
    List<Widget> rows = [];
    
    for (int i = 0; i < filteredZones.length; i += 2) {
      // Create a row with 2 zones (or 1 if it's the last odd item)
      rows.add(
        Padding(
          padding: EdgeInsets.only(bottom: 12.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // First zone in the row
              isWireless 
                ? _buildWirelessZone(filteredZones[i].id, device, zonesProvider, filteredZones[i])
                : _buildCheckboxZone(filteredZones[i].id, device, zonesProvider, filteredZones[i]),
              
              SizedBox(width: 30.w),
              
              // Second zone in the row (if it exists)
              if (i + 1 < filteredZones.length)
                isWireless
                  ? _buildWirelessZone(filteredZones[i + 1].id, device, zonesProvider, filteredZones[i + 1])
                  : _buildCheckboxZone(filteredZones[i + 1].id, device, zonesProvider, filteredZones[i + 1]),
              
              // Empty space if there's no second zone
              if (i + 1 >= filteredZones.length)
                SizedBox(width: 120.w),
            ],
          ),
        )
      );
    }
    
    return rows;
  }

  Widget _buildCheckboxZone(int zoneId, Device device, ZonesProvider zonesProvider, ZoneModel zone) {
    bool isSemiActive = false;
    
    // Get the zone semi-active state based on index
    switch (zoneId) {
      case 1:
        isSemiActive = device.zone1SemiActive;
        break;
      case 2:
        isSemiActive = device.zone2SemiActive;
        break;
      case 3:
        isSemiActive = device.zone3SemiActive;
        break;
      case 4:
        isSemiActive = device.zone4SemiActive;
        break;
      case 5:
        isSemiActive = device.zone5SemiActive;
        break;
      default:
        isSemiActive = false; // Default value for new zones
        break;
    }
    
    return Row(
      children: [
        // White checkbox
        Container(
          width: 28.w,
          height: 28.w,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4.r),
          ),
          child: Checkbox(
            value: isSemiActive,
            onChanged: (value) {
              if (value != null && zoneId <= 5) {
                zonesProvider.updateSemiActiveZone(zoneId, value);
                setState(() {
                  _hasChanges = true;
                });
              }
            },
            activeColor: Colors.transparent,
            checkColor: Colors.black,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            side: BorderSide.none,
          ),
        ),
        SizedBox(width: 8.w),
        // Zone number and name
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${translate('زون')} $zoneId",
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.sp,
              ),
            ),
            Text(
              zone.name,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 12.sp,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildWirelessZone(int zoneId, Device device, ZonesProvider zonesProvider, ZoneModel zone) {
    // For wireless zones, use the semi-active state from ZoneModel
    bool isActive = false;
    
    // Check if this is one of the special zones that have semi-active state in Device model
    if (zoneId <= 5) {
      switch (zoneId) {
        case 1:
          isActive = device.zone1SemiActive;
          break;
        case 2:
          isActive = device.zone2SemiActive;
          break;
        case 3:
          isActive = device.zone3SemiActive;
          break;
        case 4:
          isActive = device.zone4SemiActive;
          break;
        case 5:
          isActive = device.zone5SemiActive;
          break;
      }
    } else {
      // For zones beyond the device's native support, we could use custom logic
      // For now, let's just default to false
      isActive = false;
    }
    
    return Row(
      children: [
        // White checkbox for wireless zone
        Container(
          width: 28.w,
          height: 28.w,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4.r),
          ),
          child: Checkbox(
            value: isActive,
            onChanged: (value) {
              if (value != null && zoneId <= 5) {
                zonesProvider.updateSemiActiveZone(zoneId, value);
                setState(() {
                  _hasChanges = true;
                });
              } else if (value != null) {
                // For zones beyond the device's native support, implement custom logic
                // For now, just set state to reflect the change visually
                setState(() {
                  // We would need to store this state somewhere for persistence
                  _hasChanges = true;
                });
              }
            },
            activeColor: Colors.transparent,
            checkColor: Colors.black,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            side: BorderSide.none,
          ),
        ),
        SizedBox(width: 8.w),
        // Zone number and name
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${translate('زون')} $zoneId",
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.sp,
              ),
            ),
            Text(
              zone.name,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 12.sp,
              ),
            ),
          ],
        ),
      ],
    );
  }
} 