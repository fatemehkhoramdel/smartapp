import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';

import '../../../config/routes/app_routes.dart';
import '../../../core/utils/helper.dart';
import '../../../providers/smart_control_provider.dart';
import 'smart_control_detail_view.dart';
import 'control_panel_view.dart' show ControlPanelView, kControlPanelType;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';
import 'package:security_alarm/core/constants/global_keys.dart';
import 'package:security_alarm/widgets/elevated_button_widget.dart';
import 'package:security_alarm/widgets/svg.dart';

import '../../../core/constants/design_values.dart';
import '../../../providers/audio_notification_provider.dart';
class SmartControlViewMobile extends StatefulWidget {
  const SmartControlViewMobile({Key? key}) : super(key: key);

  @override
  State<SmartControlViewMobile> createState() => _SmartControlViewMobileState();
}

class _SmartControlViewMobileState extends State<SmartControlViewMobile> {
  late SmartControlProvider _provider;
  bool _isInit = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    if (!_isInit) {
      _provider = Provider.of<SmartControlProvider>(context);
      _isInit = true;
      
      // Usar addPostFrameCallback para retrasar la inicialización hasta después de la construcción
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _provider.initSmartControls();
        }
      });
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
              getDrawerKey('SmartControlView').currentState!.toggle();
            },
          ),
        ),
      ),
      body: Consumer<SmartControlProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (provider.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    provider.errorMessage!,
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 16.sp,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16.h),
                  ElevatedButton(
                    onPressed: () => provider.initSmartControls(),
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
          
          return ListView(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            children: [
              // Safe Entry
              _buildControlItem(
                icon: Icons.login,
                title: SmartControlProvider.safeEntry,
                iconBackgroundColor: Colors.blueAccent,
                onTap: () => _navigateToDetail(SmartControlProvider.safeEntry),
              ),
              
              // Safe Exit
              _buildControlItem(
                icon: Icons.logout,
                title: SmartControlProvider.safeExit,
                iconBackgroundColor: Colors.purpleAccent,
                onTap: () => _navigateToDetail(SmartControlProvider.safeExit),
              ),
              
              // Safe Travel
              _buildControlItem(
                icon: Icons.flight,
                title: SmartControlProvider.safeTravel,
                iconBackgroundColor: Colors.redAccent,
                onTap: () => _navigateToDetail(SmartControlProvider.safeTravel),
              ),
              
              // Safe Sleep
              _buildControlItem(
                icon: Icons.nightlight_round,
                title: SmartControlProvider.safeSleep,
                iconBackgroundColor: Colors.orangeAccent,
                onTap: () => _navigateToDetail(SmartControlProvider.safeSleep),
              ),
              
              // Custom Controls
              ..._buildCustomControls(provider),
              
              SizedBox(height: 30.h),
              
              // Control section heading
              Text(
                'کنترل هوشمند',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              
              SizedBox(height: 20.h),
              
              // Control button
              _buildControlItem(
                icon: Icons.settings_remote,
                title: 'کنترل',
                iconBackgroundColor: Colors.teal,
                onTap: () => _navigateToControlPanel(),
              ),
              
              SizedBox(height: 30.h),
              
              // Save and Query buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [

                  Expanded(
                    child: ElevatedButtonWidget(
                      btnText: translate('استعلام'),
                      onPressBtn: () => provider.querySettingsFromDevice(),
                    ),
                  ),
                  SizedBox(width: 20.w),
                  Expanded(
                    child: ElevatedButtonWidget(
                      btnText: translate('ذخیره'),
                      onPressBtn: () => provider.saveCurrentControl(),
                      btnColor: Colors.purple,
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildControlItem({
    required IconData icon,
    required String title,
    required Color iconBackgroundColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[

                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.all(8.w),
                        decoration: BoxDecoration(
                          color: iconBackgroundColor,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          icon,
                          color: Colors.white,
                          size: 24.sp,
                        ),
                      ),
                      SizedBox(width: 16.w),

                      Text(
                        title,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: Colors.white.withOpacity(0.7),
                  size: 24.sp,
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Divider(
              color: Colors.white.withOpacity(0.2),
              height: 1.h,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton({
    required String text,
    required Color backgroundColor,
    Color? borderColor,
    required VoidCallback onPressed,
  }) {
    return Container(
      height: 50.h,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8.r),
        border: borderColor != null ? Border.all(color: borderColor) : null,
      ),
      child: TextButton(
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  void _navigateToDetail(String controlType) async {
    await _provider.selectControlType(controlType);
    
    if (!mounted) return;
    
    // Si es un control personalizado, navegar a ControlPanelView
    if (controlType.startsWith(SmartControlProvider.customControlPrefix)) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ControlPanelView(customControlType: controlType),
        ),
      );
    } else {
      // Si es un control predefinido, navegar a la vista de detalle normal
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => SmartControlDetailView(controlType: controlType),
        ),
      );
    }
  }

  void _navigateToControlPanel() {
    // Navigate to control panel screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const ControlPanelView(),
      ),
    );
  }
  
  // Build custom controls dynamically
  List<Widget> _buildCustomControls(SmartControlProvider provider) {
    final customControls = provider.smartControls.where(
      (control) => control.controlType.startsWith(SmartControlProvider.customControlPrefix) && 
                  control.controlType != kControlPanelType
    ).toList();
    
    if (customControls.isEmpty) {
      return [];
    }
    
    return [
      SizedBox(height: 30.h),
      
      Text(
        'کنترل های سفارشی',
        style: TextStyle(
          color: Colors.white,
          fontSize: 18.sp,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
      
      SizedBox(height: 20.h),
      
      ...customControls.map((control) => _buildControlItem(
        icon: Icons.settings_remote,
        title: control.controlType,
        iconBackgroundColor: Colors.amber,
        onTap: () => _navigateToDetail(control.controlType),
      )).toList(),
    ];
  }
} 