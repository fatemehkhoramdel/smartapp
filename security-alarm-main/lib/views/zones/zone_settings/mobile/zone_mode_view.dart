import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/design_values.dart';
import '../../../../core/utils/enums.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/utils/helper.dart';
import '../../../../models/device.dart';
import '../../../../providers/main_provider.dart';
import '../../../../providers/zones_provider.dart';
import '../../../../widgets/elevated_button_widget.dart';
import '../../../../widgets/outlined_button_widget.dart';

class ZoneModeView extends StatefulWidget {
  const ZoneModeView({Key? key}) : super(key: key);

  @override
  State<ZoneModeView> createState() => _ZoneModeViewState();
}

class _ZoneModeViewState extends State<ZoneModeView> {
  Map<int, ZoneMode> _zoneModes = {};
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initZoneModes();
    });
  }

  void _initZoneModes() {
    final device = Provider.of<MainProvider>(context, listen: false).selectedDevice;
    
    // Initialize zone modes from device data
    _zoneModes = {
      1: _getZoneModeFromCondition(device.zone1Condition, device.zone1SemiActive),
      2: _getZoneModeFromCondition(device.zone2Condition, device.zone2SemiActive),
      3: _getZoneModeFromCondition(device.zone3Condition, device.zone3SemiActive),
      4: _getZoneModeFromCondition(device.zone4Condition, device.zone4SemiActive),
      5: _getZoneModeFromCondition(device.zone5Condition, device.zone5SemiActive),
    };
  }

  ZoneMode _getZoneModeFromCondition(String condition, bool isSemiActive) {
    if (condition == ZoneCondition.fullHour.value) {
      return ZoneMode.fullHour;
    } else if (condition == ZoneCondition.inactive.value) {
      return ZoneMode.inactive;
    } else if (isSemiActive) {
      return ZoneMode.semiActive;
    } else {
      return ZoneMode.normal;
    }
  }

  String _getConditionFromMode(ZoneMode mode) {
    switch (mode) {
      case ZoneMode.fullHour:
        return ZoneCondition.fullHour.value;
      case ZoneMode.inactive:
        return ZoneCondition.inactive.value;
      case ZoneMode.normal:
      case ZoneMode.semiActive:
        return ZoneCondition.normalyClose.value;
    }
  }
  
  void _updateZoneMode(int zoneNumber, ZoneMode newMode) {
    setState(() {
      _zoneModes[zoneNumber] = newMode;
      _hasChanges = true;
    });
  }
  
  Future<void> _saveChanges(ZonesProvider zonesProvider) async {
    final device = Provider.of<MainProvider>(context, listen: false).selectedDevice;
    
    // Apply changes to each zone
    for (int i = 1; i <= 5; i++) {
      final zoneMode = _zoneModes[i];
      if (zoneMode != null) {
        // Update zone condition if needed
        final condition = _getConditionFromMode(zoneMode);
        
        // Get current condition based on zone number
        String currentCondition;
        switch (i) {
          case 1: currentCondition = device.zone1Condition; break;
          case 2: currentCondition = device.zone2Condition; break;
          case 3: currentCondition = device.zone3Condition; break;
          case 4: currentCondition = device.zone4Condition; break;
          case 5: currentCondition = device.zone5Condition; break;
          default: currentCondition = ""; break;
        }
        
        if (condition != currentCondition) {
          await zonesProvider.updateZoneConditionDirect(i, condition);
        }
        
        // Update semi-active status
        final shouldBeSemiActive = zoneMode == ZoneMode.semiActive;
        await zonesProvider.updateSemiActiveZone(i, shouldBeSemiActive);
      }
    }
    
    // Save all changes to the database
    await zonesProvider.saveSemiActiveZoneChanges();
    
    setState(() {
      _hasChanges = false;
    });
    
    toastGenerator(translate('changes_saved_successfully'));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<MainProvider, ZonesProvider>(
      builder: (context, mainProvider, zonesProvider, child) {
        final selectedDevice = mainProvider.selectedDevice;
        
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          color: const Color(0xFF09162E),
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    _buildZoneModeItem(1, selectedDevice, zonesProvider),
                    _buildZoneModeItem(2, selectedDevice, zonesProvider),
                    _buildZoneModeItem(3, selectedDevice, zonesProvider),
                    _buildZoneModeItem(4, selectedDevice, zonesProvider),
                    _buildZoneModeItem(5, selectedDevice, zonesProvider),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (_hasChanges)
                    ElevatedButtonWidget(
                      btnText: translate('apply_changes'),
                      btnIcon: Icons.save,
                      onPressBtn: () => _saveChanges(zonesProvider),
                    ),
                  OutlinedButtonWidget(
                    btnText: translate('inquiry_zones'),
                    btnIcon: Icons.info_outline,
                    onPressBtn: () async {
                      final controller = TextEditingController();
                      await zonesProvider.getZonesFromDevice(controller);
                      _initZoneModes();
                    },
                  ),
                ],
              ),
              SizedBox(height: 20.h),
            ],
          ),
        );
      },
    );
  }

  Widget _buildZoneModeItem(int zoneNumber, Device device, ZonesProvider zonesProvider) {
    String zoneName;
    
    // Get the zone name based on zone number
    switch (zoneNumber) {
      case 1:
        zoneName = device.zone1Name;
        break;
      case 2:
        zoneName = device.zone2Name;
        break;
      case 3:
        zoneName = device.zone3Name;
        break;
      case 4:
        zoneName = device.zone4Name;
        break;
      case 5:
        zoneName = device.zone5Name;
        break;
      default:
        zoneName = "";
    }
    
    // Get the current zone mode
    final currentMode = _zoneModes[zoneNumber] ?? ZoneMode.normal;
    
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Material(
        color: Colors.black,
        elevation: 2,
        borderRadius: BorderRadius.circular(kBorderRadius.r),
        child: Container(
          width: 1.0.sw,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${translate('زون')} $zoneNumber: $zoneName",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.sp,
                ),
              ),
              SizedBox(height: 12.h),
              Column(
                children: ZoneModeExt.getZoneModesList().map((mode) {
                  return RadioListTile<ZoneMode>(
                    title: Text(mode.value),
                    value: mode,
                    groupValue: currentMode,
                    onChanged: (ZoneMode? value) {
                      if (value != null) {
                        _updateZoneMode(zoneNumber, value);
                      }
                    },
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 