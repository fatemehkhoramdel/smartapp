import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';

import '../../../config/routes/app_routes.dart';
import '../../../core/utils/helper.dart';
import '../../../providers/smart_control_provider.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:security_alarm/core/constants/global_keys.dart';
import 'package:security_alarm/views/home/drawer_menu_widget.dart';
import 'package:tokenizer/tokenizer.dart';

// Control Panel Type Constant
const String kControlPanelType = 'کنترل پنل';

class ControlPanelView extends StatefulWidget {
  final String? customControlType;
  
  const ControlPanelView({
    Key? key, 
    this.customControlType,
  }) : super(key: key);

  @override
  State<ControlPanelView> createState() => _ControlPanelViewState();
}

class _ControlPanelViewState extends State<ControlPanelView> {
  late SmartControlProvider _provider;
  
  bool speakerEnabled = false;
  bool remoteCodeEnabled = false;
  bool remoteEnabled = false;
  bool relay1Enabled = false;
  bool relay2Enabled = false;
  bool relay3Enabled = false;
  bool scenarioEnabled = false;
  
  // Status options
  final List<String> _statusOptions = [
    'فعال',
    'غیر فعال',
    'نیمه فعال',
    'بی‌صدا فعال',
    'بی‌صدا نیمه فعال'
  ];
  
  String _selectedStatus = 'فعال';
  
  @override
  void initState() {
    super.initState();
    _provider = Provider.of<SmartControlProvider>(context, listen: false);
    
    // Load saved settings when the view is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadSettings();
    });
  }
  
  void _loadSettings() {
    // If we're editing a custom control, load its settings
    final controlType = widget.customControlType;
    
    if (controlType != null) {
      // Load custom control settings using the selectControlType method
      _provider.selectControlType(controlType).then((_) {
        if (_provider.currentControl != null) {
          setState(() {
            speakerEnabled = _provider.currentControl!.speakerEnabled;
            remoteCodeEnabled = _provider.currentControl!.remoteCodeEnabled;
            remoteEnabled = _provider.currentControl!.remoteEnabled;
            relay1Enabled = _provider.currentControl!.relay1Enabled;
            relay2Enabled = _provider.currentControl!.relay2Enabled;
            relay3Enabled = _provider.currentControl!.relay3Enabled;
            scenarioEnabled = _provider.currentControl!.scenarioEnabled;
            
            // Set selected status based on the active mode
            _setSelectedStatusFromMode(_provider.currentControl!.activeMode);
          });
        }
      });
    } else {
      // Load main control panel settings using the selectControlType method
      _provider.selectControlType(kControlPanelType).then((_) {
        if (_provider.currentControl != null) {
          setState(() {
            speakerEnabled = _provider.currentControl!.speakerEnabled;
            remoteCodeEnabled = _provider.currentControl!.remoteCodeEnabled;
            remoteEnabled = _provider.currentControl!.remoteEnabled;
            relay1Enabled = _provider.currentControl!.relay1Enabled;
            relay2Enabled = _provider.currentControl!.relay2Enabled;
            relay3Enabled = _provider.currentControl!.relay3Enabled;
            scenarioEnabled = _provider.currentControl!.scenarioEnabled;
            
            // Set selected status based on the active mode
            _setSelectedStatusFromMode(_provider.currentControl!.activeMode);
          });
        } else {
          // Use default values if no control is available
          setState(() {
            speakerEnabled = true;
            remoteCodeEnabled = false;
            remoteEnabled = false;
            relay1Enabled = false;
            relay2Enabled = false;
            relay3Enabled = false;
            scenarioEnabled = false;
          });
        }
      });
    }
  }
  
  void _setSelectedStatusFromMode(String mode) {
    switch (mode) {
      case SmartControlProvider.activeMode:
        _selectedStatus = 'فعال';
        break;
      case SmartControlProvider.inactiveMode:
        _selectedStatus = 'غیر فعال';
        break;
      case SmartControlProvider.semiActiveMode:
        _selectedStatus = 'نیمه فعال';
        break;
      case SmartControlProvider.silentActiveMode:
        _selectedStatus = 'بی‌صدا فعال';
        break;
      case SmartControlProvider.silentSemiActiveMode:
        _selectedStatus = 'بی‌صدا نیمه فعال';
        break;
      default:
        _selectedStatus = 'فعال';
    }
  }

  @override
  Widget build(BuildContext context) {
    // Determinar el título según si es un control personalizado o el panel de control principal
    final title = widget.customControlType != null ? widget.customControlType! : 'کنترل';
    
    return MyBaseWidget(
      hasScrollView: false,
      mobileChild: SliderDrawer(
        slideDirection: SlideDirection.RIGHT_TO_LEFT,
        isDraggable: false,
        appBar: null,
        key: getDrawerKey('ControlPanelView'),
        sliderOpenSize: 0.78.sw,
        slider: DrawerMenuWidget(drawerKey: getDrawerKey('ControlPanelView')),
        child: Scaffold(
          // backgroundColor: const Color(0xFF011742), // Dark blue background
          backgroundColor: const Color(0xFF09162E), // Dark blue background
          appBar: AppBar(
            backgroundColor: const Color(0xFF09162E),
            elevation: 0,
            title: Text(
              title,
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
                onPressed: () => getDrawerKey('ControlPanelView').currentState!.toggle(),
              ),
            ),
          ),
          body: Material(
            color: Colors.transparent, // غیرفعال کردن اثر سایه
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      // Add control button - Solo mostrar cuando no sea un control personalizado
                      if (widget.customControlType == null)
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                          padding: EdgeInsets.symmetric(vertical: 4.h),
                          decoration: BoxDecoration(
                            // color: Colors.blue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(color: Colors.blue, width: 1),
                          ),
                          child: TextButton(
                            onPressed: () {
                              // Add a new custom control
                              final provider = Provider.of<SmartControlProvider>(context, listen: false);
                              provider.addNewCustomControl();

                              // Go back to the main screen to see the new control
                              Navigator.of(context).pop();
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.add, color: Colors.blue, size: 24.sp),
                                SizedBox(width: 8.w),
                                Text(
                                  'افزودن کنترل',
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                      // Status dropdown
                      _buildStatusDropdown(),

                      // Toggle switches
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              _buildToggleItem(
                                title: 'شنود',
                                value: speakerEnabled,
                                onChanged: (value) {
                                  setState(() {
                                    speakerEnabled = value;
                                  });
                                },
                              ),
                              _buildToggleItem(
                                title: 'ریموت کد',
                                value: remoteCodeEnabled,
                                onChanged: (value) {
                                  setState(() {
                                    remoteCodeEnabled = value;
                                  });
                                },
                              ),
                              _buildToggleItem(
                                title: 'ریموت',
                                value: remoteEnabled,
                                onChanged: (value) {
                                  setState(() {
                                    remoteEnabled = value;
                                  });
                                },
                              ),
                              _buildToggleItem(
                                title: 'رله 1',
                                value: relay1Enabled,
                                onChanged: (value) {
                                  setState(() {
                                    relay1Enabled = value;
                                  });
                                },
                              ),
                              _buildToggleItem(
                                title: 'رله 2',
                                value: relay2Enabled,
                                onChanged: (value) {
                                  setState(() {
                                    relay2Enabled = value;
                                  });
                                },
                              ),
                              _buildToggleItem(
                                title: 'رله 3',
                                value: relay3Enabled,
                                onChanged: (value) {
                                  setState(() {
                                    relay3Enabled = value;
                                  });
                                },
                              ),
                              _buildToggleItem(
                                title: 'سناریو',
                                value: scenarioEnabled,
                                onChanged: (value) {
                                  setState(() {
                                    scenarioEnabled = value;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Conditional text message
                      if (scenarioEnabled)
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                          child: Text(
                            'در صورت نیاز می توانید سناریوی جدیدی ایجاد کنید',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 14.sp,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),

                      // Define scenario button
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: _buildNavigationItem(
                          icon: Icons.chat,
                          title: 'تعریف سناریو',
                          onTap: _navigateToScenario,
                        ),
                      ),
                    ],
                  ),
                ),

                // Save button
                Container(
                  width: double.infinity,
                  height: 56.h,
                  margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFF9600FF), // Purple color
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                  child: TextButton(
                    onPressed: _saveSettings,
                    child: Consumer<SmartControlProvider>(
                      builder: (context, provider, _) {
                        if (provider.isLoading) {
                          return const CircularProgressIndicator(color: Colors.white);
                        }
                        return Text(
                          'ذخیره',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusDropdown() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      // decoration: BoxDecoration(
      //   color: const Color(0xFF0D1F3D),
      //   borderRadius: BorderRadius.circular(8.r),
      //   border: Border.all(color: Colors.blue.withOpacity(0.3)),
      // ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'وضعیت',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            decoration: BoxDecoration(
              color: Colors.transparent,
              // borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: Colors.white24, width: 1),
            ),
            child: DropdownButton<String>(
              value: _selectedStatus,
              isExpanded: true,
              dropdownColor: const Color(0xFF1E2030),
              underline: const SizedBox(),
              icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
              ),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedStatus = value;
                  });
                }
              },
              items: _statusOptions.map((String status) {
                return DropdownMenuItem<String>(
                  value: status,
                  child: Text(status),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleItem({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      height: 56.h,
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.white24,
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.blue,
            inactiveThumbColor: Colors.white,
            trackColor: MaterialStateProperty.resolveWith((states) {
              return states.contains(MaterialState.selected)
                  ? const Color(0xFF2E70E6)
                  : Colors.grey.withOpacity(0.5);
            }),
            thumbColor: MaterialStateProperty.all(Colors.white),
          ),
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.sp,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildNavigationItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(16.h),
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(
                color: Colors.white24,
                width: 0.5,
              ),
              bottom: BorderSide(
                color: Colors.white24,
                width: 0.5,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
                size: 16.sp,
              ),
              Row(
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Container(
                    width: 40.w,
                    height: 40.h,
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Icon(
                        icon,
                        color: Colors.white,
                        size: 24.sp,
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

  void _saveSettings() {
    // Update the provider with the current active mode
    String mode;
    switch (_selectedStatus) {
      case 'فعال':
        mode = SmartControlProvider.activeMode;
        break;
      case 'غیر فعال':
        mode = SmartControlProvider.inactiveMode;
        break;
      case 'نیمه فعال':
        mode = SmartControlProvider.semiActiveMode;
        break;
      case 'بی‌صدا فعال':
        mode = SmartControlProvider.silentActiveMode;
        break;
      case 'بی‌صدا نیمه فعال':
        mode = SmartControlProvider.silentSemiActiveMode;
        break;
      default:
        mode = SmartControlProvider.activeMode;
    }
    
    // If we're editing a custom control, save with that type
    final controlType = widget.customControlType;
    
    if (controlType != null) {
      // Save custom control settings
      _provider.saveCustomControlSettings(
        controlType: controlType,
        speakerEnabled: speakerEnabled,
        remoteCodeEnabled: remoteCodeEnabled,
        remoteEnabled: remoteEnabled,
        relay1Enabled: relay1Enabled,
        relay2Enabled: relay2Enabled,
        relay3Enabled: relay3Enabled,
        scenarioEnabled: scenarioEnabled,
      );
      
      // Update the active mode using setActiveMode
      _provider.setActiveMode(mode);
    } else {
      // Save main control panel settings
      _provider.saveControlPanelSettings(
        speakerEnabled: speakerEnabled,
        remoteCodeEnabled: remoteCodeEnabled,
        remoteEnabled: remoteEnabled,
        relay1Enabled: relay1Enabled,
        relay2Enabled: relay2Enabled,
        relay3Enabled: relay3Enabled,
        scenarioEnabled: scenarioEnabled,
      );
      
      // Update the active mode using setActiveMode
      _provider.setActiveMode(mode);
    }
    
    toastGenerator('تنظیمات با موفقیت ذخیره شد');
  }
  
  void _navigateToScenario() {
    // Navigate to scenario page
    Navigator.pushNamed(context, AppRoutes.scenarioRoute);
  }
} 