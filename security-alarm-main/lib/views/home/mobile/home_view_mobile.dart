import 'dart:ui';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';
import 'package:security_alarm/core/constants/asset_constants.dart';
import 'package:security_alarm/core/constants/global_keys.dart';
import 'package:security_alarm/core/utils/helper.dart';
import 'package:security_alarm/models/device.dart';
import 'package:security_alarm/providers/home_provider.dart';
import 'package:security_alarm/providers/main_provider.dart';
import 'package:security_alarm/widgets/elevated_button_widget.dart';
import 'package:security_alarm/widgets/outlined_button_widget.dart';
import 'package:security_alarm/config/routes/app_routes.dart';
import 'package:security_alarm/widgets/sync_slider/src/slider.dart';
import 'package:security_alarm/widgets/sync_slider/src/slider_shapes.dart';
import 'package:security_alarm/widgets/sync_core/src/theme/slider_theme.dart';
import 'package:security_alarm/widgets/text_button_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../views/device_status/device_status_view.dart';
import '../../../views/sms_report/sms_report_view.dart';
// import 'package:security_alarm/constants/constants.dart';
// import 'package:security_alarm/models/device_model.dart';
// import 'package:security_alarm/providers/bluetooth_provider.dart';
// import 'package:security_alarm/providers/device_provider.dart';
// import 'package:security_alarm/providers/setting_provider.dart';
// import 'package:security_alarm/providers/user_provider.dart';
// import 'package:security_alarm/services/notification_manager.dart';
// import 'package:security_alarm/utils/helpers.dart';
// import 'package:security_alarm/views/common/no_device_widget.dart';
// import 'package:security_alarm/views/devices/mobile/add_device_view.dart';
// import 'package:security_alarm/views/devices/mobile/devices_detail_view.dart';
// import 'package:security_alarm/views/home/mobile/device_status_widget.dart';
// import 'package:security_alarm/views/home/mobile/tab_bar_widget.dart';
// import 'package:security_alarm/views/settings/mobile/settings_view_mobile.dart';
// import 'package:security_alarm/widgets/circular_progress_widget.dart';
// import 'package:security_alarm/widgets/custom_app_bar_widget.dart';
// import 'package:security_alarm/widgets/drawer_item_widget.dart';
// import 'package:security_alarm/widgets/icon_widget.dart';
// import 'package:security_alarm/widgets/slider_drawer/slider_drawer.dart';

class HomeViewMobile extends StatefulWidget {
  const HomeViewMobile({Key? key}) : super(key: key);

  @override
  HomeViewMobileState createState() => HomeViewMobileState();
}

class HomeViewMobileState extends State<HomeViewMobile>
    with AutomaticKeepAliveClientMixin {
  late MainProvider _mainProvider;
  late HomeProvider _homeProvider;
  late List<Device> _devices;
  late Device _selectedDevice;
  final TextEditingController _locationNameTEC = TextEditingController();
  final TextEditingController _phoneNumberTEC = TextEditingController();
  final TextEditingController _inquiryDialogTEC = TextEditingController();

  @override
  void dispose() {
    _locationNameTEC.dispose();
    _phoneNumberTEC.dispose();
    _inquiryDialogTEC.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    _mainProvider = context.read<MainProvider>();
    _homeProvider = context.read<HomeProvider>();
    _devices = context.select<MainProvider, List<Device>>(
      (MainProvider m) => m.devices,
    );
    _selectedDevice = context.select<MainProvider, Device>(
      (MainProvider m) => m.selectedDevice,
    );

    return Scaffold(
      backgroundColor: const Color(0xFF09162E), // Dark blue background
      appBar: AppBar(
        backgroundColor: const Color(0xFF09162E),
        elevation: 0,
        title: Text(
          translate('صفحه اصلی'),
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.sp,
          ),
        ),
        centerTitle: false,
        // actions: [
        //   IconButton(
        //     icon: Icon(
        //       Icons.notifications_none_outlined,
        //       color: Colors.white,
        //       size: 24.sp,
        //     ),
        //     onPressed: () {
        //       // Bell icon functionality
        //     },
        //   ),
        // ],
        leading: Container(
          // width: 20.w,
          // height: 20.w,
          margin: EdgeInsets.only(right: 10.w),
          // padding: EdgeInsets.all(4.w),
          // alignment: Alignment.center,
          decoration: BoxDecoration(
            color: const Color(0xFF142850),
            borderRadius: BorderRadius.circular(8.r),
            // image: const DecorationImage(image: AssetImage(kLogoAsset))
          ),
          child: IconButton(
            icon: Icon(
              Icons.menu,
              color: Colors.white,
              size: 24.sp,
            ),
            onPressed: () {
              getDrawerKey('RootView').currentState!.toggle();
            },
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            children: [
              SizedBox(height: 32.h),
              // Add new device button
              _buildAddDeviceButton(),
              SizedBox(height: 32.h),
              // Shield icon
              _buildShieldIcon(),
              SizedBox(height: 20.h),
              // Function buttons
              _buildFunctionButtons(),
              SizedBox(height: 20.h),
              // Devices accordion list
              _buildDevicesList(),
              SizedBox(height: 32.h),
          ],
        ),
      ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildAddDeviceButton() {
    return InkWell(
      onTap: () => _showAddDeviceDialog(),
      child: Container(
        width: double.infinity,
        height: 36.h,
        margin: EdgeInsets.symmetric(horizontal: 12.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: const Color(0xFF2E70E6), width: 1.w),
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
              translate('افزودن دستگاه جدید'),
              style: TextStyle(
                color: const Color(0xFF2E70E6),
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShieldIcon() {
    bool isActive =
        _devices.isNotEmpty && _selectedDevice.deviceState == 'active';
    bool isSemiActive =
        _devices.isNotEmpty && _selectedDevice.deviceState == 'semi_active';
    // bool isDeactive = _devices.isNotEmpty && _selectedDevice.deviceState == 'deactive';
    // Color shieldColor = isActive
    //     ? Colors.green.shade400
    //     : isSemiActive
    //         ? Colors.yellow.shade400
    //         : Colors.red.shade400;
    String kShieldAsset = isActive
        ? kActiveShieldAsset
        : isSemiActive
            ? kSemiActiveShieldAsset
            : kDeactiveShieldAsset;

    return Column(
      children: [
        SizedBox(
          // width: 180.w,
          height: 180.w,
          child: Center(
            child: Image.asset(
              kShieldAsset,
              height: 150.w,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFunctionButtons() {
    return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
        // Botón derecho - Ver estado del dispositivo
        _buildFunctionButton(Icons.info_outline, () {
          if (_selectedDevice.id != null) {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      DeviceStatusView(deviceId: _selectedDevice.id!),
                ));
          } else {
            toastGenerator(translate('لطفا ابتدا یک دستگاه انتخاب کنید'));
          }
        }),

        // Botón central - Llamada telefónica
        _buildFunctionButton(Icons.call_outlined, () {
          if (_selectedDevice.devicePhone.isNotEmpty) {
            // Lanzar la llamada telefónica
            _makePhoneCall(_selectedDevice.devicePhone);
          } else {
            toastGenerator(translate('شماره تلفن دستگاه نامعتبر است'));
          }
        }),

        // Botón izquierdo - Ver mensajes SMS
        _buildFunctionButton(Icons.message_outlined, () {
          if (_selectedDevice.id != null) {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      SmsReportView(deviceId: _selectedDevice.id!),
                ));
          } else {
            toastGenerator(translate('لطفا ابتدا یک دستگاه انتخاب کنید'));
          }
        }),
      ],
    );
  }

  Widget _buildFunctionButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        width: 50.w,
        height: 50.w,
        child: Icon(
          icon,
          color: Colors.white,
          size: 24.sp,
        ),
      ),
    );
  }

  Widget _buildDevicesList() {
    if (_devices.isEmpty) {
      return Center(
        child: Text(
          translate('لطفا یک دستگاه اضافه کنید'),
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.sp,
                ),
              ),
            );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _devices.length,
      itemBuilder: (context, index) {
        final device = _devices[index];
        final isSelected = _mainProvider.selectedDevice.id == device.id;
        return InkWell(
          onTap: () async {
            await _mainProvider.selectDevice(device);
            setState(() {});
          },
          child: DeviceItemWidget(
            device: device,
            index: index,
            isSelected: isSelected,
            homeProvider: _homeProvider,
            mainProvider: _mainProvider,
            changeDeviceStateCallback: _changeDeviceState,
            showSmsConfirmDialogCallback: _showSendSMSConfirmDialog,
          ),
        );
      },
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      height: 50.h,
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      decoration: BoxDecoration(
          // color: const Color(0xFF0E1F40),
          borderRadius: BorderRadius.circular(60.r),
          border: Border.all(color: Theme.of(context).colorScheme.primary)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavBarItem(Icons.settings, translate('تنظیمات'), () {
            Navigator.pushNamed(context, AppRoutes.applicationSettingsRoute);
          }),
          _buildNavBarItem(Icons.home, translate('خانه'), () {
            // Home is current page
          }, isSelected: true),
          _buildNavBarItem(Icons.people_alt_outlined, translate('کاربران'), () {
            Navigator.pushNamed(context, AppRoutes.contactsRoute);
          }),
        ],
      ),
    );
  }

  Widget _buildNavBarItem(IconData icon, String text, VoidCallback onTap,
      {bool isSelected = false}) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
      children: [
          Icon(
            icon,
            color: isSelected
                ? const Color(0xFF2E70E6)
                : Colors.white.withOpacity(0.7),
            size: 24.sp,
          ),
          SizedBox(height: 4.h),
        Text(
            text,
            style: TextStyle(
              color: isSelected
                  ? const Color(0xFF2E70E6)
                  : Colors.white.withOpacity(0.7),
              fontSize: 12.sp,
          ),
        ),
      ],
      ),
    );
  }

  void _showAddDeviceDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Dialog(
            backgroundColor: const Color(0xFF09162E),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.r),
            ),
                child: Container(
              padding: EdgeInsets.all(20.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    translate('دستگاه جدید'),
                    style: TextStyle(
                      color: const Color(0xFF2E70E6),
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 30.h),
                  // Location name input
                  _buildInputField(
                    translate('نام محل نصب'),
                    Icons.location_on_outlined,
                    _locationNameTEC,
                  ),
                  SizedBox(height: 8.h),
                  // Phone number input
                  _buildInputField(
                    translate('شماره سیمکارت'),
                    Icons.phone_outlined,
                    _phoneNumberTEC,
                  ),
                  SizedBox(height: 40.h),
                  // Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButtonWidget(
                        btnText: translate('افزودن'),
                        // width: 120.w,
                        // height: 45.h,
                        onPressBtn: () {
                          Navigator.pop(context);
                          _addNewDevice();
                        },
                      ),
                      SizedBox(
                        width: 12.w,
                      ),
                      TextButtonWidget(
                        btnText: translate('انصراف'),
                        // width: 120.w,
                        // height: 45.h,
                        onPressBtn: () {
                          Navigator.pop(context);
                          _locationNameTEC.clear();
                          _phoneNumberTEC.clear();
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildInputField(
      String label, IconData icon, TextEditingController controller) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: Colors.blue,
          width: 1.w,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 24.sp,
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: TextField(
              controller: controller,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
              ),
              decoration: InputDecoration(
                hintText: label,
                hintStyle: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: 16.sp,
                ),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
        ),
    );
  }

  void _showSendSMSConfirmDialog(Function() onConfirm) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Dialog(
            backgroundColor: const Color(0xFF09162E),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.r),
            ),
                child: Container(
              padding: EdgeInsets.all(20.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    translate('ارسال پیامک'),
                    style: TextStyle(
                      color: const Color(0xFF2E70E6),
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    translate('آیا از ارسال پیامک مطمئن هستید؟'),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  SizedBox(height: 10.h),
        Text(
                    translate(
                        '"با ارسال پیامک تغییرات در دزدگیر اعمال می‌شود."'),
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 14.sp,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  SizedBox(height: 30.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
                      OutlinedButtonWidget(
                        btnText: translate('انصراف'),
                        width: 120.w,
                        height: 45.h,
                        onPressBtn: () {
                          Navigator.pop(context);
                        },
                      ),
                      ElevatedButtonWidget(
                        btnText: translate('ارسال'),
                        width: 120.w,
                        height: 45.h,
                        onPressBtn: () {
                          Navigator.pop(context);
                          onConfirm();
                        },
                      ),
                    ],
                  ),
                ],
            ),
          ),
        ),
        );
      },
    );
  }

  Future<void> _addNewDevice() async {
    if (_locationNameTEC.text.isEmpty || _phoneNumberTEC.text.isEmpty) {
      toastGenerator(translate('لطفا تمام فیلدها را پر کنید'));
      return;
    }

    // _showSendSMSConfirmDialog(() async {
    final device = Device(
      deviceName: _locationNameTEC.text,
      devicePhone: _phoneNumberTEC.text,
      deviceState: 'deactive',
    );

    await _mainProvider.insertDevice(device);

    if (_devices.length == 1) {
      await _mainProvider.updateAppSettings(
        _mainProvider.appSettings.copyWith(selectedDeviceIndex: 0),
      );
      _mainProvider.setSelectedDevice();
    }

    _locationNameTEC.clear();
    _phoneNumberTEC.clear();

    setState(() {});
    // });
  }

  void _changeDeviceState(int index, String newState) {
    _showSendSMSConfirmDialog(() async {
      // First select the device we want to modify
      await _mainProvider.updateAppSettings(
        _mainProvider.appSettings.copyWith(selectedDeviceIndex: index),
      );
      _mainProvider.setSelectedDevice();

      // Update device based on state
      switch (newState) {
        case 'active':
          await _homeProvider.activateDevice();
          break;
        case 'deactive':
          await _homeProvider.deactiveDevice();
          break;
        case 'semi_active':
          await _homeProvider.semiActiveDevice();
          break;
        case 'silent':
          await _homeProvider.silentDevice();
          break;
      }

      // Update UI
      setState(() {});
    });
  }

  // Método para realizar llamada telefónica
  void _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    try {
      // Lanzar la aplicación de llamadas con el número
      await _launchUrl(launchUri);
    } catch (e) {
      toastGenerator('خطا در برقراری تماس: $e');
    }
  }

  // Método para lanzar URL
  Future<void> _launchUrl(Uri url) async {
    try {
      // Tratar de lanzar la URL
      bool launched = await canLaunchUrl(url);
      if (launched) {
        await launchUrl(url);
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      toastGenerator('خطا: $e');
    }
  }
}

class DeviceItemWidget extends StatefulWidget {
  final Device device;
  final int index;
  final bool isSelected;
  final HomeProvider homeProvider;
  final MainProvider mainProvider;
  final Function(int, String) changeDeviceStateCallback;
  final Function(Function()) showSmsConfirmDialogCallback;

  const DeviceItemWidget({
    Key? key,
    required this.device,
    required this.index,
    required this.isSelected,
    required this.homeProvider,
    required this.mainProvider,
    required this.changeDeviceStateCallback,
    required this.showSmsConfirmDialogCallback,
  }) : super(key: key);

  @override
  _DeviceItemWidgetState createState() => _DeviceItemWidgetState();
}

class _DeviceItemWidgetState extends State<DeviceItemWidget> {
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.device.deviceState == 'semi_active';
  }

  // void _selectDevice() async {
  //   if (!widget.isSelected) {
  //     await widget.mainProvider.selectDevice(widget.device);
  //     // Use setState here to refresh the widget if needed
  //     if (mounted) {
  //       setState(() {
  //         // Refresh the UI
  //       });
  //     }
  //   }
  // }

  Color getStatusColor() {
    switch (widget.device.deviceState) {
      case 'active':
        return const Color(0xFF00C853); // Green
      case 'semi_active':
        return const Color(0xFFFFD700); // Yellow
      case 'deactive': // Changed from 'inactive'
        return const Color(0xFFFF4D4D); // Red
      default:
        return Colors.grey;
    }
  }

  String getStatusText() {
    switch (widget.device.deviceState) {
      case 'active':
        return translate('فعال');
      case 'semi_active':
        return translate('نیمه فعال');
      case 'deactive': // Changed from 'inactive'
        return translate('غیر فعال');
      default:
        return translate('نامشخص');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: widget.isSelected ? const Color(0XFF122950) : Colors.transparent,
      // Color from provided code
      margin: EdgeInsets.only(bottom: 4.h),
      shape: RoundedRectangleBorder(
        side: BorderSide(color: const Color(0XFF122950), width: 1.w),
      ),
      elevation: widget.isSelected ? 4 : 1,
      child: ExpansionTile(
        initiallyExpanded: _isExpanded,
        onExpansionChanged: (expanded) {
          setState(() {
            _isExpanded = expanded;
          });
        },
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
        // To prevent border issue
        collapsedShape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
        // To prevent border issue
        iconColor: Colors.white,
        collapsedIconColor: Colors.white,
        title: GestureDetector(
          // onTap: () => _selectDevice(),
          behavior: HitTestBehavior.translucent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
                widget.device.deviceName,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight:
                      widget.isSelected ? FontWeight.bold : FontWeight.normal,
                ),
                overflow: TextOverflow.ellipsis,
                ),
                  Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                    decoration: BoxDecoration(
                  // color: getStatusColor().withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Text(
                  getStatusText(),
                  style: TextStyle(
                      color: getStatusColor(),
                      fontWeight: FontWeight.bold,
                      fontSize: 14.sp),
                ),
              ),
              const SizedBox()
            ],
          ),
        ),
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h), // Adjust padding
            child: DeviceSliderWidget(
              device: widget.device,
              onStatusChanged: (newStatus) {
                // widget.showSmsConfirmDialogCallback(() {
                widget.changeDeviceStateCallback(widget.index, newStatus);
                // });
              },
            ),
          ),
        ],
      ),
    );
  }
}

class DeviceSliderWidget extends StatefulWidget {
  final Device device;
  final Function(String) onStatusChanged;

  const DeviceSliderWidget({
    Key? key,
    required this.device,
    required this.onStatusChanged,
  }) : super(key: key);

  @override
  _DeviceSliderWidgetState createState() => _DeviceSliderWidgetState();
}

class _DeviceSliderWidgetState extends State<DeviceSliderWidget> {
  late double _currentValue;

  @override
  void initState() {
    super.initState();
    _currentValue = _getInitialValue();
  }

  @override
  void didUpdateWidget(covariant DeviceSliderWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.device.deviceState != oldWidget.device.deviceState) {
      setState(() {
        _currentValue = _getInitialValue();
      });
    }
  }

  double _getInitialValue() {
    switch (widget.device.deviceState) {
      case 'active':
        return 0;
      case 'semi_active':
        return 1;
      case 'deactive': // Changed from 'inactive'
        return 2;
      default:
        return 1; // Default to semi-active if unknown
    }
  }

  String _getStatusFromValue(double value) {
    if (value == 0) return 'active';
    if (value == 1) return 'semi_active';
    return 'deactive'; // Changed from 'inactive'
  }

  // double _value = 40.0;

  @override
  Widget build(BuildContext context) {
    return SfSlider(
      min: 0,
      max: 2,
      value: _currentValue,
      interval: 1,
      showDividers: true,
      enableTooltip: false,
      showLabels: false,
      showTicks: false,
      minorTicksPerInterval: 0,
      stepSize: 1,
      activeColor: const Color(0xFF2E70E6), // Color azul para el track activo
      inactiveColor: const Color(0xFF2E70E6), // Color azul para el track inactivo
      thumbIcon: _getThumbIcon(),
      trackShape: CustomTrackShape(),
      dividerShape: CustomDividerShape(),
      thumbShape: CustomThumbShape(),
      onChanged: (dynamic value) {
        setState(() {
          _currentValue = value;
        });
      },
      onChangeEnd: (dynamic endValue) {
        final newStatus = _getStatusFromValue(endValue);
        if (newStatus != widget.device.deviceState) {
          widget.onStatusChanged(newStatus);
        } else {
          setState(() {
            _currentValue = _getInitialValue();
          });
        }
      },
    );
  }

  Widget _getThumbIcon() {
    String assetPath;
    switch (_getStatusFromValue(_currentValue)) {
      case 'active':
        assetPath = kActiveHandleAsset;
        break;
      case 'semi_active':
        assetPath = kSemiActiveHandleAsset;
        break;
      case 'deactive':
        assetPath = kDeactiveHandleAsset;
        break;
      default:
        assetPath = kSemiActiveHandleAsset;
    }

    // Simplemente usamos una imagen sin ningún fondo adicional
    return Image.asset(
      assetPath,
      width: 60.w,
      height: 33.w,
      fit: BoxFit.contain,
    );
  }
}

/// Custom thumb shape class that extends SfThumbShape to provide a larger thumb radius
class CustomThumbShape extends SfThumbShape {
  @override
  Size getPreferredSize(SfSliderThemeData themeData) {
    // Increase the thumb radius from default 10.0 to 30.0
    return Size.fromRadius(30.0);
  }
  
  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required RenderBox parentBox,
    required RenderBox? child,
    required SfSliderThemeData themeData,
    dynamic currentValues,
    dynamic currentValue,
    required Paint? paint,
    required Animation<double> enableAnimation,
    required TextDirection textDirection,
    required dynamic thumb,
  }) {
    // Solo dibujamos el icono del thumb sin fondo azul
    if (child != null) {
      context.paintChild(
        child,
        Offset(
          center.dx - (child.size.width) / 2,
          center.dy - (child.size.height) / 2,
        ),
      );
    }
  }
}

/// Custom track shape class that creates a dotted line track
class CustomTrackShape extends SfTrackShape {
  @override
  void paint(
    PaintingContext context,
    Offset offset,
    Offset? thumbCenter,
    Offset? startThumbCenter,
    Offset? endThumbCenter, {
    required RenderBox parentBox,
    required SfSliderThemeData themeData,
    dynamic currentValues,
    dynamic currentValue,
    required Animation<double> enableAnimation,
    required Paint? inactivePaint,
    required Paint? activePaint,
    required TextDirection textDirection,
  }) {
    final Rect trackRect = getPreferredRect(
      parentBox,
      themeData,
      offset,
    );
    
    final Paint dashPaint = Paint()
      ..color = const Color(0xFF2E70E6) // Color azul para la línea punteada
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5; // Línea más fina
    
    // Dibujar línea punteada
    _drawDashedPath(
      context.canvas,
      dashPaint,
      Offset(trackRect.left, trackRect.center.dy),
      Offset(trackRect.right, trackRect.center.dy),
    );
  }

  void _drawDashedPath(Canvas canvas, Paint paint, Offset start, Offset end) {
    // Longitud de cada segmento y espacio (ajustado para que sea más como la imagen)
    const dashLength = 4.0;
    const dashSpace = 4.0;
    
    final dx = end.dx - start.dx;
    // Calcular distancia entre dos puntos
    final distance = math.sqrt(math.pow(end.dx - start.dx, 2) + math.pow(end.dy - start.dy, 2));
    final count = (distance / (dashLength + dashSpace)).floor();
    
    final startPoint = start;
    final unitVector = Offset(dx, 0) / distance;
    
    for (var i = 0; i < count; i++) {
      final dashStart = startPoint + unitVector * (i * (dashLength + dashSpace));
      final dashEnd = dashStart + unitVector * dashLength;
      canvas.drawLine(dashStart, dashEnd, paint);
    }
  }
}

/// Custom divider shape class that uses the same images as thumb
class CustomDividerShape extends SfDividerShape {
  @override
  void paint(PaintingContext context, Offset center, Offset? thumbCenter,
      Offset? startThumbCenter, Offset? endThumbCenter,
      {required RenderBox parentBox,
      required SfSliderThemeData themeData,
      dynamic currentValues,
      dynamic currentValue,
      required Paint? paint,
      required Animation<double> enableAnimation,
      required TextDirection textDirection}) {
        
    // Determine if the divider is active based on its position relative to the thumb
    final bool isActive = thumbCenter != null && center.dx <= thumbCenter.dx;
    
    // Create a paint object with the appropriate color
    final Paint dividerPaint = Paint()
      ..color = isActive
          ? themeData.activeTrackColor!
          : themeData.inactiveTrackColor!
      ..style = PaintingStyle.fill;
    
    // Use a smaller scale factor for the dividers compared to thumbs
    final double scale = 0.7;  
    
    // Calculate the scaled radius
    final double radius = themeData.thumbRadius != null
        ? themeData.thumbRadius! * scale
        : 10.0 * scale;
    
    // Draw a circle for the divider
    context.canvas.drawCircle(center, radius, dividerPaint);
  }
}
