import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';
import 'package:security_alarm/core/constants/global_keys.dart';

import '../../../../core/utils/helper.dart';
import '../../../../models/device.dart';
import '../../../../providers/device_settings_provider.dart';
import '../../../../providers/main_provider.dart';

// کلاس ویجت جدید برای دیالوگ افزودن دستگاه
class AddDeviceDialog extends StatefulWidget {
  final Function(String name, String phone) onDeviceAdded;

  const AddDeviceDialog({
    Key? key,
    required this.onDeviceAdded,
  }) : super(key: key);

  @override
  State<AddDeviceDialog> createState() => _AddDeviceDialogState();
}

class _AddDeviceDialogState extends State<AddDeviceDialog> {
  late TextEditingController _locationNameController;
  late TextEditingController _phoneNumberController;

  @override
  void initState() {
    super.initState();
    _locationNameController = TextEditingController();
    _phoneNumberController = TextEditingController();
  }

  @override
  void dispose() {
    _locationNameController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }
  
  Widget _buildInputField(String label, IconData icon, TextEditingController controller) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
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

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF09162E),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                translate('add_new_device'),
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 30.h),
              // Location name input
              _buildInputField(
                translate('device_installation_location'),
                Icons.location_on_outlined,
                _locationNameController,
              ),
              SizedBox(height: 20.h),
              // Phone number input
              _buildInputField(
                translate('sim_card_number'),
                Icons.phone_outlined,
                _phoneNumberController,
              ),
              SizedBox(height: 30.h),
              // Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Cancel button
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 100.w,
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white.withOpacity(0.7)),
                        borderRadius: BorderRadius.circular(25.r),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        translate('cancel'),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                  ),
                  // Add button
                  TextButton(
                    onPressed: () {
                      final name = _locationNameController.text;
                      final phone = _phoneNumberController.text;
                      
                      if (name.isNotEmpty && phone.isNotEmpty) {
                        Navigator.pop(context);
                        widget.onDeviceAdded(name, phone);
                      } else {
                        toastGenerator(translate('please_fill_all_fields'));
                      }
                    },
                    child: Container(
                      width: 100.w,
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(25.r),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        translate('add'),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.sp,
                        ),
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
}

class EditDeviceViewMobile extends StatefulWidget {
  const EditDeviceViewMobile({Key? key}) : super(key: key);

  @override
  State<EditDeviceViewMobile> createState() => _EditDeviceViewMobileState();
}

class _EditDeviceViewMobileState extends State<EditDeviceViewMobile> {
  final Map<int, TextEditingController> _deviceNameControllers = {};
  final Map<int, TextEditingController> _devicePhoneControllers = {};

  // Use nullable types to avoid late initialization issues
  MainProvider? _mainProvider;
  DeviceSettingsProvider? _deviceSettingsProvider;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    // Initialize providers in the next frame to ensure context is available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _mainProvider = Provider.of<MainProvider>(context, listen: false);
      _deviceSettingsProvider = Provider.of<DeviceSettingsProvider>(context, listen: false);
      _initializeControllers();
      if (mounted) setState(() {});
    });
  }

  void _initializeControllers() {
    if (_mainProvider == null) return;

    _deviceNameControllers.clear();
    _devicePhoneControllers.clear();

    final devices = _mainProvider!.devices;

    // Make sure devices list is not empty before iterating
    if (devices.isEmpty) return;

    for (int i = 0; i < devices.length; i++) {
      final device = devices[i];
      if (device != null) {
        _deviceNameControllers[i] = TextEditingController(text: device.deviceName);
        _devicePhoneControllers[i] = TextEditingController(text: device.devicePhone);
      }
    }
  }

  @override
  void dispose() {
    for (var controller in _deviceNameControllers.values) {
      controller.dispose();
    }
    for (var controller in _devicePhoneControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Update providers in build method but don't overwrite the ones from initState
    _mainProvider ??= Provider.of<MainProvider>(context);
    _deviceSettingsProvider ??= Provider.of<DeviceSettingsProvider>(context);

    // If providers are still initializing, show a loading indicator
    if (_mainProvider == null) {
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
                getDrawerKey('EditDeviceView').currentState!.toggle();
              },
            ),
          ),
        ),
        body: const Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    }

    return  Scaffold(
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
              getDrawerKey('EditDeviceView').currentState!.toggle();
            },
          ),
        ),
      ),
      body: Column(
          children: [
            SizedBox(height: 20.h),
            // Title
            Center(
              child: Text(
                translate('edit_and_add_device'),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 30.h),
            // Add Device Button
            _buildAddDeviceButton(),
            SizedBox(height: 20.h),
            // Device List - Using Expanded to give it the remaining space
            Expanded(
              child: _mainProvider!.devices.isEmpty
                  ? Center(
                child: Text(
                  translate('no_devices_found'),
                  style: TextStyle(color: Colors.white, fontSize: 16.sp),
                ),
              )
                  : ListView.separated(
                separatorBuilder: (_, __) => SizedBox(height: 20.h,),
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                itemCount: _mainProvider!.devices.length,
                itemBuilder: (context, index) => _buildDeviceItem(index),
              ),
            ),
            // Save Button
            Padding(
              padding: EdgeInsets.all(20.w),
              child: _buildSaveButton(),
            ),
          ],
        ),
      );
  }

  Widget _buildAddDeviceButton() {
    return InkWell(
      onTap: () {
        _showAddDeviceDialog();
      },
      child: Container(
        width: 0.85.sw,
        padding: EdgeInsets.symmetric(vertical: 8.h),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blue, width: 1),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add, color: Colors.blue, size: 20.sp),
            SizedBox(width: 8.w),
            Text(
              translate('add_new_device'),
              style: TextStyle(
                color: Colors.blue,
                fontSize: 16.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddDeviceDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AddDeviceDialog(
          onDeviceAdded: (String name, String phone) {
            _addNewDevice(name, phone);
          },
        );
      },
    );
  }

  Widget _buildInputField(String label, IconData icon, TextEditingController controller) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
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

  void _addNewDevice(String name, String phone) async {
    if (name.isEmpty || phone.isEmpty) {
      toastGenerator(translate('please_fill_all_fields'));
      return;
    }
    
    log('name = $name');
    log('phone = $phone');
    
    try {
      setState(() {
        _isSaving = true;
      });
      
      log('_isSaving = $_isSaving');
      
      // Create new device
      final newDevice = Device(
        id: DateTime.now().millisecondsSinceEpoch, // Generate a unique ID
        deviceName: name,
        devicePhone: phone,
      );
      
      log('newDevice = $newDevice');
      
      // Add the device to the provider
      await _mainProvider?.insertDevice(newDevice);
      
      log('1');
      
      // Re-initialize controllers to include the new device
      _initializeControllers();
      
      log('2');
      
      // If this is the first device, set it as selected
      if (_mainProvider != null && _mainProvider!.devices.length == 1) {
        log('3');
        await _mainProvider!.updateAppSettings(
          _mainProvider!.appSettings.copyWith(selectedDeviceIndex: 0),
        );
        log('4');
        _mainProvider!.setSelectedDevice();
      }
      
      log('5');
      
      // Show success message
      toastGenerator(translate('device_added_successfully'));
      
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
      
      log('6');
    } catch (e) {
      log('Error: $e');
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
      log('8');
      toastGenerator(translate('error_adding_device'));
    }
    
    log('10');
  }
  
  Widget _buildDeviceItem(int index) {
    if (_mainProvider == null || index >= _mainProvider!.devices.length) {
      return const SizedBox.shrink();
    }

    final device = _mainProvider!.devices[index];
    if (device == null) {
      return const SizedBox.shrink();
    }

    // Ensure controllers exist for this index
    if (_deviceNameControllers[index] == null) {
      _deviceNameControllers[index] = TextEditingController(text: device.deviceName);
    }

    if (_devicePhoneControllers[index] == null) {
      _devicePhoneControllers[index] = TextEditingController(text: device.devicePhone);
    }

    return Container(
      margin: EdgeInsets.only(bottom: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Device header with delete button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                translate('دستگاه شماره ${(index + 1)}'),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.delete_forever,
                  color: Colors.red,
                  size: 28.r,
                ),
                onPressed: () => _confirmDeleteDevice(index),
              ),
            ],
          ),
          SizedBox(height: 16.h),

          // Device Name Field
          Text(
            translate('device_installation_location'),
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14.sp,
            ),
            textAlign: TextAlign.right,
          ),
          SizedBox(height: 8.h),
          TextField(
            controller: _deviceNameControllers[index],
            decoration: InputDecoration(
              filled: false,
              fillColor: Colors.white,
              contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: BorderSide(color: Theme.of(context).primaryColor)
              ),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: BorderSide(color: Theme.of(context).primaryColor)
              ),
            ),
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.sp,
            ),
          ),
          SizedBox(height: 16.h),

          // SIM Card Number Field
          Text(
            translate('sim_card_number'),
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14.sp,
            ),
            textAlign: TextAlign.right,
          ),
          SizedBox(height: 8.h),
          TextField(
            controller: _devicePhoneControllers[index],
            decoration: InputDecoration(
              filled: false,
              fillColor: Colors.white,
              contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: BorderSide(color: Theme.of(context).primaryColor)
              ),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: BorderSide(color: Theme.of(context).primaryColor)
              ),
            ),
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.sp,
            ),
            keyboardType: TextInputType.phone,
            textAlign: TextAlign.left,
            textDirection: TextDirection.ltr,
            ),
          ],
        ),
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: 140.w,
      height: 30.h,
      child: ElevatedButton(
        onPressed: _mainProvider == null || _isSaving ? null : _saveChanges,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.purple,
          padding: EdgeInsets.symmetric(vertical: 4.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.r),
          ),
        ),
        child: _isSaving
            ? SizedBox(
                height: 20.h,
                width: 20.h,
                child: CircularProgressIndicator(
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                  strokeWidth: 2.w,
                ),
              )
            : Text(
                translate('save'),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }

  Future<void> _saveChanges() async {
    if (_mainProvider == null) return;

    setState(() {
      _isSaving = true;
    });

    try {
      // Save each device
      for (int i = 0; i < _mainProvider!.devices.length; i++) {
        final device = _mainProvider!.devices[i];

        if (
        _deviceNameControllers[i] != null && _devicePhoneControllers[i] != null &&
        _deviceNameControllers[i]?.text != device.deviceName && _devicePhoneControllers[i]?.text != device.devicePhone

        ) {
          final updatedDevice = device.copyWith(
            deviceName: _deviceNameControllers[i]!.text,
            devicePhone: _devicePhoneControllers[i]!.text,
          );

          await _mainProvider!.updateDevice(updatedDevice);
        }
      }

      toastGenerator(translate('changes_saved_successfully'));
      Navigator.pop(context);
    } catch (e) {
      toastGenerator(translate('error_saving_changes'));
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  void _confirmDeleteDevice(int index) {
    if (_mainProvider == null) return;

    if (_mainProvider!.devices.length <= 1) {
      toastGenerator(translate('cannot_remove_last_device'));
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF09162E),
        title: Text(
          translate('delete_device'),
          style: const TextStyle(color: Colors.white),
        ),
        content: Text(
          translate('confirm_delete_device'),
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
              _deleteDevice(index);
            },
            child: Text(
              translate('delete'),
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteDevice(int index) async {
    if (_mainProvider == null) return;

    try {
      await _mainProvider!.removeDevice(index);

      // Re-initialize controllers after device removal
      _initializeControllers();

      setState(() {});

      toastGenerator(translate('device_removed_successfully'));
    } catch (e) {
      toastGenerator(translate('error_removing_device'));
    }
  }
}
