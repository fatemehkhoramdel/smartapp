// import 'package:circle_checkbox/redev_checkbox.dart';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// import 'package:flutter_native_contact_picker/flutter_native_contact_picker.dart';
// import 'package:flutter_native_contact_picker/model/contact.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';

// import 'package:security_alarm/views/contacts/pack/redev_checkbox.dart'; // Use standard checkbox
import 'package:provider/provider.dart';
import 'package:security_alarm/core/constants/global_keys.dart';

import '../../../core/constants/design_values.dart';
import '../../../core/utils/helper.dart';
import '../../../models/device.dart';
import '../../../providers/contacts_provider.dart';
import '../../../providers/main_provider.dart';
import '../../../widgets/elevated_button_widget.dart';
import '../../../widgets/outlined_button_widget.dart';

// Define max contacts
const int maxContacts = 10;

class ContactsViewMobile extends StatefulWidget {
  const ContactsViewMobile({Key? key}) : super(key: key);

  @override
  ContactsViewMobileState createState() => ContactsViewMobileState();
}

class ContactsViewMobileState extends State<ContactsViewMobile> {
  late Device _device;
  late ContactsProvider _contactsProvider;
  final _inquiryDialogTEC = TextEditingController();

  // Use lists sized to maxContacts
  late List<TextEditingController> _contactsPhoneTECList;
  late List<List<bool?>> _localCheckboxes;
  int _visibleContacts = 0; // Number of currently visible/added contacts

  @override
  void initState() {
    super.initState();
    _contactsProvider = context.read<ContactsProvider>();
    _device = context
        .read<MainProvider>()
        .selectedDevice;

    // Initialize controllers and checkboxes
    _contactsPhoneTECList =
        List.generate(maxContacts, (_) => TextEditingController());
    _localCheckboxes = List.generate(
        maxContacts, (_) => List.filled(3, false)); // [sms, call, manager]

    _loadInitialData();
  }

  void _loadInitialData() {
    _visibleContacts = 0;
    for (int i = 0; i < maxContacts; i++) {
      final phone = _getDeviceContactPhone(i);
      if (phone.isNotEmpty) {
        _contactsPhoneTECList[i].text = phone;
        _localCheckboxes[i][0] = _getDeviceContactSMS(i); // SMS at index 0
        _localCheckboxes[i][1] = _getDeviceContactCall(i); // Call at index 1
        _localCheckboxes[i][2] =
            _getDeviceContactManager(i); // Manager at index 2
        _visibleContacts++;
      } else {
        // Clear fields for slots beyond saved contacts
        _contactsPhoneTECList[i].clear();
        _localCheckboxes[i] = List.filled(3, false);
      }
    }
    // Ensure at least one box is visible if none are saved
    if (_visibleContacts == 0) {
      _visibleContacts = 1;
    }
    // Or show all initially if needed based on design preference
    // _visibleContacts = maxContacts; 
    setState(() {}); // Update UI after loading
  }

  // Helper methods to get device data based on index
  String _getDeviceContactPhone(int index) {
    switch (index) {
      case 0:
        return _device.contact1Phone;
      case 1:
        return _device.contact2Phone;
      case 2:
        return _device.contact3Phone;
      case 3:
        return _device.contact4Phone;
      case 4:
        return _device.contact5Phone;
      case 5:
        return _device.contact6Phone;
      case 6:
        return _device.contact7Phone;
      case 7:
        return _device.contact8Phone;
      case 8:
        return _device.contact9Phone;
      case 9:
        return _device.contact10Phone;
      default:
        return '';
    }
  }

  bool _getDeviceContactSMS(int index) {
    switch (index) {
      case 0:
        return _device.contact1SMS;
      case 1:
        return _device.contact2SMS;
      case 2:
        return _device.contact3SMS;
      case 3:
        return _device.contact4SMS;
      case 4:
        return _device.contact5SMS;
      case 5:
        return _device.contact6SMS;
      case 6:
        return _device.contact7SMS;
      case 7:
        return _device.contact8SMS;
      case 8:
        return _device.contact9SMS;
      case 9:
        return _device.contact10SMS;
      default:
        return false;
    }
  }

  bool _getDeviceContactCall(int index) {
    switch (index) {
      case 0:
        return _device.contact1Call;
      case 1:
        return _device.contact2Call;
      case 2:
        return _device.contact3Call;
      case 3:
        return _device.contact4Call;
      case 4:
        return _device.contact5Call;
      case 5:
        return _device.contact6Call;
      case 6:
        return _device.contact7Call;
      case 7:
        return _device.contact8Call;
      case 8:
        return _device.contact9Call;
      case 9:
        return _device.contact10Call;
      default:
        return false;
    }
  }

  bool _getDeviceContactManager(int index) {
    switch (index) {
      case 0:
        return _device.contact1Manager;
      case 1:
        return _device.contact2Manager;
      case 2:
        return _device.contact3Manager;
      case 3:
        return _device.contact4Manager;
      case 4:
        return _device.contact5Manager;
      case 5:
        return _device.contact6Manager;
      case 6:
        return _device.contact7Manager;
      case 7:
        return _device.contact8Manager;
      case 8:
        return _device.contact9Manager;
      case 9:
        return _device.contact10Manager;
      default:
        return false;
    }
  }

  @override
  void dispose() {
    _inquiryDialogTEC.dispose();
    for (var controller in _contactsPhoneTECList) {
      controller.dispose();
    }
    super.dispose();
  }

  // Method to add a new empty contact box
  void _addNewContactBox() {
    if (_visibleContacts < maxContacts) {
      setState(() {
        // Clear the next available slot before showing it
        _contactsPhoneTECList[_visibleContacts].clear();
        _localCheckboxes[_visibleContacts] = List.filled(3, false);
        _visibleContacts++;
      });
    }
  }

  // Method to handle saving contacts, potentially in batches
  void _saveContacts(int startIndex, int endIndex) {
    log("Saving contacts from $startIndex to $endIndex");
    
    // First save contacts to the database as before
    _contactsProvider.updateContactsBatch(
      startIndex,
      endIndex,
      _localCheckboxes,
      _contactsPhoneTECList,
    );
    
    // Then format and send the SMS message
    _sendContactsViaSMS(startIndex, endIndex);
  }
  
  // Format and send contact information via SMS
  void _sendContactsViaSMS(int startIndex, int endIndex) {
    // Check if a device is selected
    if (_device.id == null) {
      toastGenerator(translate('please_select_device_first'));
      return;
    }
    
    // Build the SMS message string
    String smsMessage = '';
    
    for (int i = startIndex; i <= endIndex; i++) {
      // Skip if we exceed the visible contacts
      // if (i >= _visibleContacts) break;
      
      // Add contact identifier (t1, t2, etc. - indices are 0-based but message uses 1-based)
      smsMessage += 't${i + 1}=';
      
      // Add phone number or 'e' if empty
      final phoneNumber = _contactsPhoneTECList[i].text.trim();
      smsMessage += phoneNumber.isEmpty ? 'e' : phoneNumber;
      
      // Add separator
      smsMessage += '&';
      
      // Add SMS status (1 or 0)
      smsMessage += _localCheckboxes[i][0] == true ? '1' : '0';
      
      // Add Call status (1 or 0)
      smsMessage += _localCheckboxes[i][1] == true ? '1' : '0';
      
      // Add Manager status (1 or 0)
      smsMessage += _localCheckboxes[i][2] == true ? '1' : '0';
      
      // Add separator for next contact
      smsMessage += '/';
    }
    
    // Send SMS if message is not empty
    if (smsMessage.isNotEmpty) {
      log("Sending SMS message: $smsMessage");
      
      // Get the SMS service from ContactsProvider
      _contactsProvider.sendContactsSMS(
        _device.devicePhone,
        smsMessage,
      );
      
      toastGenerator(translate('sending_contacts_sms'));
    }
  }

  @override
  Widget build(BuildContext context) {
    // Listen for device changes to reload data
    final currentDevice = context
        .watch<MainProvider>()
        .selectedDevice;
    if (_device.id != currentDevice.id) {
      _device = currentDevice;
      _loadInitialData();
    }

    log('_visibleContacts = $_visibleContacts');
    log('maxContacts = $maxContacts');
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
        actions: [
          Container(
            // width: 20.w,
            // height: 20.w,
            margin: EdgeInsets.only(left: 10.w),
            // padding: EdgeInsets.all(4.w),
            // alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFF142850),
              borderRadius: BorderRadius.circular(8.r),
              // image: const DecorationImage(image: AssetImage(kLogoAsset))
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
              getDrawerKey('ContactsView').currentState!.toggle();
            },
          ),
        ),
      ),
      body: Container(
        color: const Color(0xFF09162E), // Dark blue background
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        width: 1.0.sw,
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
            SizedBox(height: 20.h),
            Center(
              child: Text(
                translate('مدیریت شماره تماس‌ها'),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 20.h),
            // Add new contact button
            InkWell(
              onTap: _visibleContacts < maxContacts ? _addNewContactBox : null,
              child: Container(
                width: double.infinity,
                height: 36.h,
                margin: EdgeInsets.symmetric(horizontal: 12.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(
                      color: const Color(0xFF2E70E6), width: 1.w),
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
                      translate('افزودن شماره جدید'),
                      style: TextStyle(
                        color: const Color(0xFF2E70E6),
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // OutlinedButtonWidget(
            //   width: double.infinity,
            //   height: 36.h,
            //   btnText: translate('افزودن شماره جدید'),
            //   btnIcon: Icons.add,
            //   borderColor: Colors.blue, // Match the design
            //   textColor: Colors.blue,
            //   iconColor: Colors.blue,
            //   onPressBtn: _addNewContactBox,
            //   isDisabled: _visibleContacts >= maxContacts, // Disable if max contacts reached
            // ),
            SizedBox(height: 20.h),

            /// Contacts list
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                children: [
                    // Generate contact boxes up to _visibleContacts
                    ...List.generate(
                      _visibleContacts,
                          (index) => _buildContactContainer(index),
                    ),
                    SizedBox(height: 10.h),
                    // Save button for contacts 1-5
                    if (_visibleContacts > 0)
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.h),
                        child: ElevatedButtonWidget(
                          btnText: translate('ذخیره شماره های ۱ تا ۵'),
                          btnColor: Colors.purple, // Purple color from image
                          width: double.infinity,
                          onPressBtn: () =>
                              _saveContacts(0, 4), // Indices 0 to 4
                        ),
                      ),
                    // Save button for contacts 6-10
                    if (_visibleContacts >
                        5) // Show only if there are contacts beyond the 5th
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.h),
                        child: ElevatedButtonWidget(
                          btnText: translate('ذخیره شماره های ۶ تا ۱۰'),
                          btnColor: Colors.purple, // Purple color from image
                          width: double.infinity,
                          onPressBtn: () =>
                              _saveContacts(5, 9), // Indices 5 to 9
                    ),
                  ),
                ],
              ),
              ),
            ),
            Divider(height: 8.h,
                thickness: 1,
                color: Colors.white.withOpacity(0.2)),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              child: ElevatedButtonWidget(
                btnText: translate('استعلام'),
                btnColor: Colors.blue, // Blue color from image
                width: double.infinity,
                onPressBtn: () async {
                  // TODO: Implement Inquiry logic - adapt from old provider if needed
                  // _contactsProvider.getContactsFromDevice(_inquiryDialogTEC);
                  toastGenerator('Inquiry function not implemented yet');
                },
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildContactContainer(int index) {
    return Container(
      margin: EdgeInsets.only(bottom: 15.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2A44), // Darker blue boxes
        borderRadius: BorderRadius.circular(kBorderRadius.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Phone number input
          SizedBox(height: 20.h,),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: Colors.blue, width: 1.w),
            ),
            child: Row(
              children: [
                Icon(
                    Icons.phone_outlined, color: Colors.white.withOpacity(0.7)),
                SizedBox(width: 10.w),
                Expanded(
                  child: TextField(
                    controller: _contactsPhoneTECList[index],
                    style: styleGenerator(
                        fontSize: 15, fontColor: Colors.white),
                    decoration: InputDecoration(
                      hintText: translate('شماره سیمکارت'),
                      hintStyle: styleGenerator(fontSize: 15,
                          fontColor: Colors.white.withOpacity(0.5)),
                      border: InputBorder.none,
                      counterText: '', // Hide counter
                    ),
                    keyboardType: TextInputType.phone,
                    maxLength: 11,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                ),
                // Optional: Add contact picker icon here if needed
              ],
            ),
          ),
          SizedBox(height: 15.h),
          // Checkboxes
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _buildCheckboxItem(
                label: translate('ارسال پیامک'),
                value: _localCheckboxes[index][0] ?? false,
                onChanged: (value) {
                  setState(() {
                    _localCheckboxes[index][0] = value;
                  });
                },
              ),
              SizedBox(width: 15.h),
              _buildCheckboxItem(
                label: translate('تماس'),
                value: _localCheckboxes[index][1] ?? false,
                onChanged: (value) {
                  setState(() {
                    _localCheckboxes[index][1] = value;
                  });
                },
              ),
              SizedBox(width: 15.h),
              _buildCheckboxItem(
                label: translate('مدیر'),
                value: _localCheckboxes[index][2] ?? false,
                onChanged: (value) {
                  setState(() {
                    _localCheckboxes[index][2] = value;
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCheckboxItem(
      {required String label, required bool value, required ValueChanged<
          bool?> onChanged}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Theme(
          data: Theme.of(context).copyWith(
            unselectedWidgetColor: Colors.white.withOpacity(0.7),
          ),
          child: Checkbox(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.blue,
            // Use blue for active checkbox
            checkColor: Colors.white,
            side: BorderSide(color: Colors.white.withOpacity(0.7)),
            visualDensity: VisualDensity.compact,
            // Make checkbox smaller
            materialTapTargetSize: MaterialTapTargetSize
                .shrinkWrap, // Reduce tap area
          ),
        ),
        SizedBox(width: 4.w),
        Text(
          label,
          style: styleGenerator(fontSize: 14, fontColor: Colors.white),
        ),
      ],
    );
  }

// Removed old _onTapImportContact method as contact name is not used anymore
}
