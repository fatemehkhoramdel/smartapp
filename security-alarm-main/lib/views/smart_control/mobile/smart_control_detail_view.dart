import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';

import '../../../core/utils/helper.dart';
import '../../../providers/smart_control_provider.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:security_alarm/core/constants/global_keys.dart';
import 'package:security_alarm/views/home/drawer_menu_widget.dart';
import 'package:tokenizer/tokenizer.dart';

class SmartControlDetailView extends StatefulWidget {
  final String controlType;
  
  const SmartControlDetailView({
    Key? key,
    required this.controlType,
  }) : super(key: key);

  @override
  State<SmartControlDetailView> createState() => _SmartControlDetailViewState();
}

class _SmartControlDetailViewState extends State<SmartControlDetailView> {
  late SmartControlProvider _provider;
  String _selectedMode = SmartControlProvider.activeMode;
  bool _isStatusExpanded = false;
  final ExpansionTileController _expansionTileController = ExpansionTileController();

  final List<String> _statusOptions = [
    'فعال',
    'غیر فعال',
    'نیمه فعال',
    'بی‌صدا فعال',
    'بی‌صدا نیمه فعال',
  ];

  @override
  void initState() {
    super.initState();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _provider = Provider.of<SmartControlProvider>(context, listen: false);
      
      if (_provider.currentControl != null) {
        setState(() {
          _selectedMode = _provider.currentControl!.activeMode;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MyBaseWidget(
      hasScrollView: false,
      mobileChild: SliderDrawer(
        slideDirection: SlideDirection.RIGHT_TO_LEFT,
        isDraggable: false,
        appBar: null,
        key: getDrawerKey('SmartControlDetailView'),
        sliderOpenSize: 0.78.sw,
        slider: DrawerMenuWidget(drawerKey: getDrawerKey('SmartControlDetailView')),
        child: Scaffold(
          backgroundColor: const Color(0xFF09162E), // Dark blue background
          appBar: AppBar(
            backgroundColor: const Color(0xFF09162E),
            elevation: 0,
            title: Text(
              translate(widget.controlType),
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
          body: Consumer<SmartControlProvider>(
            builder: (context, provider, _) {
              _provider = provider;

              if (provider.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (provider.currentControl == null) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'خطا در بارگذاری تنظیمات',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 16.sp,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 16.h),
                      ElevatedButton(
                        onPressed: () => provider.selectControlType(widget.controlType),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                        ),
                        child: Text(
                          'تلاش مجدد',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }

              return Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          // Status dropdown section
                          _buildStatusDropdown(),
                          
                          // Toggle switches
                          _buildToggleItem(
                            title: 'شنود',
                            value: provider.currentControl!.speakerEnabled,
                            onChanged: (value) => provider.toggleSpeaker(value),
                          ),
                          _buildToggleItem(
                            title: 'ریموت کد',
                            value: provider.currentControl!.remoteCodeEnabled,
                            onChanged: (value) => provider.toggleRemoteCode(value),
                          ),
                          _buildToggleItem(
                            title: 'ریموت',
                            value: provider.currentControl!.remoteEnabled,
                            onChanged: (value) => provider.toggleRemote(value),
                          ),
                          _buildToggleItem(
                            title: 'رله 1',
                            value: provider.currentControl!.relay1Enabled,
                            onChanged: (value) => provider.toggleRelay1(value),
                          ),
                          _buildToggleItem(
                            title: 'رله 2',
                            value: provider.currentControl!.relay2Enabled,
                            onChanged: (value) => provider.toggleRelay2(value),
                          ),
                          _buildToggleItem(
                            title: 'رله 3',
                            value: provider.currentControl!.relay3Enabled,
                            onChanged: (value) => provider.toggleRelay3(value),
                          ),
                          _buildToggleItem(
                            title: 'سناریو',
                            value: provider.currentControl!.scenarioEnabled,
                            onChanged: (value) => provider.toggleScenario(value),
                          ),
                        ],
                      ),
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
                      child: provider.isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(
                              'ذخیره',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildStatusDropdown() {
    return Container(
      margin: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.blue.withOpacity(0.3)),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
        ),
        child: ExpansionTile(
          controller: _expansionTileController,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _provider.currentControl?.activeMode ?? 'وضعیت',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          trailing: Icon(
            _isStatusExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
            color: Colors.white,
          ),
          onExpansionChanged: (expanded) {
            setState(() {
              _isStatusExpanded = expanded;
            });
          },
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _statusOptions.length,
              itemBuilder: (context, index) {
                final option = _statusOptions[index];
                return ListTile(
                  title: Text(
                    option,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      setState(() {
                        _expansionTileController.collapse();
                        // _isExpanded = false;
                      });
                      _selectedMode = option;
                      _isStatusExpanded = false;
                      
                      // Update the mode in provider
                      switch (index) {
                        case 0:
                          _provider.setActiveMode(SmartControlProvider.activeMode);
                          break;
                        case 1:
                          _provider.setActiveMode(SmartControlProvider.inactiveMode);
                          break;
                        case 2:
                          _provider.setActiveMode(SmartControlProvider.semiActiveMode);
                          break;
                        case 3:
                          _provider.setActiveMode(SmartControlProvider.silentActiveMode);
                          break;
                        case 4:
                          _provider.setActiveMode(SmartControlProvider.silentSemiActiveMode);
                          break;
                      }
                    });
                  },
                );
              },
            ),
          ],
        ),
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
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.sp,
            ),
          ),
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
        ],
      ),
    );
  }

  void _saveSettings() async {
    await _provider.saveCurrentControl();
    
    if (!mounted) return;
    
    toastGenerator('تنظیمات با موفقیت ذخیره شد');
  }
} 