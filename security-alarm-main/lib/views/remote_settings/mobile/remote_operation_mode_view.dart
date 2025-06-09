import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:provider/provider.dart';
import 'package:security_alarm/core/constants/global_keys.dart';
import 'package:security_alarm/views/home/drawer_menu_widget.dart';
import 'package:security_alarm/core/utils/helper.dart';
import 'package:tokenizer/tokenizer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../repository/sms_repository.dart';
import '../../../injector.dart';
import '../../../providers/main_provider.dart';

class RemoteOperationModeView extends StatefulWidget {
  const RemoteOperationModeView({Key? key}) : super(key: key);

  @override
  State<RemoteOperationModeView> createState() =>
      _RemoteOperationModeViewState();
}

class _RemoteOperationModeViewState extends State<RemoteOperationModeView> {
  bool _isBurglarModeActive = false;
  bool _isRelayModeActive = false;
  bool _isLoading = false;
  late MainProvider _mainProvider;
  static const String _prefKeyBurglarMode = 'burglar_mode_enabled';
  static const String _prefKeyRelayMode = 'relay_mode_enabled';

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _mainProvider = Provider.of<MainProvider>(context, listen: false);
  }

  // Load saved settings from preferences
  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      setState(() {
        _isBurglarModeActive = prefs.getBool(_prefKeyBurglarMode) ?? false;
        _isRelayModeActive = prefs.getBool(_prefKeyRelayMode) ?? false;
      });
    } catch (e) {
      debugPrint('Error loading remote operation mode settings: $e');
    }
  }

  // Save settings to preferences
  Future<void> _saveSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      await prefs.setBool(_prefKeyBurglarMode, _isBurglarModeActive);
      await prefs.setBool(_prefKeyRelayMode, _isRelayModeActive);
    } catch (e) {
      debugPrint('Error saving remote operation mode settings: $e');
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
        key: getDrawerKey('RemoteOperationModeView'),
        sliderOpenSize: 0.78.sw,
        slider: DrawerMenuWidget(drawerKey: getDrawerKey('RemoteOperationModeView')),
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
                  getDrawerKey('RemoteOperationModeView').currentState!.toggle();
                },
              ),
            ),
          ),
          body: _isLoading 
            ? const Center(child: CircularProgressIndicator()) 
            : Column(
              children: [
                const SizedBox(height: 20),
                // Title
                Center(
                  child: Text(
                    translate('select_remote_operation_mode'),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 60),
                // Mode switches
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    children: [
                      _buildModeSwitch(
                        'burglar_mode',
                        _isBurglarModeActive,
                        (value) => _toggleBurglarMode(value),
                      ),
                      const Divider(
                        height: 1,
                        thickness: 1,
                        color: Colors.white12,
                      ),
                      _buildModeSwitch(
                        'relay_mode',
                        _isRelayModeActive,
                        (value) => _toggleRelayMode(value),
                      ),
                    ],
                  ),
                ),
              ],
            ),
        ),
      ),
    );
  }

  Widget _buildModeSwitch(
      String titleKey, bool isActive, ValueChanged<bool> onChanged) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            translate(titleKey),
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.sp,
            ),
            textAlign: TextAlign.right,
          ),
          Switch(
            value: isActive,
            onChanged: onChanged,
            activeColor: Colors.blue,
            activeTrackColor: Colors.blue.withOpacity(0.5),
            inactiveThumbColor: Colors.grey,
            inactiveTrackColor: Colors.grey.withOpacity(0.5),
          ),
        ],
      ),
    );
  }

  void _toggleBurglarMode(bool value) {
    setState(() {
      _isBurglarModeActive = value;
      // We're no longer making the switches mutually exclusive
    });

    _showSendSMSDialog(
        context, value ? 'remote1=1' : 'remote1=0', 'burglar_mode');
  }

  void _toggleRelayMode(bool value) {
    setState(() {
      _isRelayModeActive = value;
      // We're no longer making the switches mutually exclusive
    });

    _showSendSMSDialog(context, value ? 'ghofl=0' : 'ghofl=1', 'relay_mode');
  }

  void _showSendSMSDialog(BuildContext context, String smsCommand, String operationType) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF09162E),
        title: Text(
          translate('send_sms_confirmation'),
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          translate('confirm_send_sms_for_operation'),
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Revert the switch state since the operation was cancelled
              setState(() {
                if (operationType == 'burglar_mode') {
                  _isBurglarModeActive = !_isBurglarModeActive;
                } else if (operationType == 'relay_mode') {
                  _isRelayModeActive = !_isRelayModeActive;
                }
              });
            },
            child: Text(
              translate('cancel'),
              style: TextStyle(color: Colors.white),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _sendSms(smsCommand, operationType);
            },
            child: Text(
              translate('send'),
              style: TextStyle(color: Colors.green),
            ),
          ),
        ],
      ),
    );
  }

  void _sendSms(String command, String operationType) async {
    if (_mainProvider.selectedDevice == null) {
      toastGenerator(translate('please_select_device_first'));
      // Revert the switch state
      setState(() {
        if (operationType == 'burglar_mode') {
          _isBurglarModeActive = !_isBurglarModeActive;
        } else if (operationType == 'relay_mode') {
          _isRelayModeActive = !_isRelayModeActive;
        }
      });
      return;
    }

    try {
      setState(() {
        _isLoading = true;
      });
      
      final phoneNumber = _mainProvider.selectedDevice!.devicePhone;
      
      // Send the SMS
      final result = await injector<SMSRepository>().doSendSMS(
        message: command,
        phoneNumber: phoneNumber,
        smsCoolDownFinished: _mainProvider.smsCooldownFinished,
        isManager: _mainProvider.selectedDevice!.isManager,
        showConfirmDialog: false,
      );
      
      result.fold(
        (failure) {
          // Error handling
          toastGenerator(failure);
          // Revert the switch state since SMS failed
          setState(() {
            if (operationType == 'burglar_mode') {
              _isBurglarModeActive = !_isBurglarModeActive;
            } else if (operationType == 'relay_mode') {
              _isRelayModeActive = !_isRelayModeActive;
            }
          });
        },
        (_) async {
          // Success handling
          // toastGenerator(translate('sms_sent_successfully'));
          _mainProvider.startSMSCooldown();

          // Save the settings after successful SMS
          await _saveSettings();
        },
      );
    } catch (e) {
      toastGenerator('${translate('error_sending_sms')}: $e');
      // Revert the switch state on error
      setState(() {
        if (operationType == 'burglar_mode') {
          _isBurglarModeActive = !_isBurglarModeActive;
        } else if (operationType == 'relay_mode') {
          _isRelayModeActive = !_isRelayModeActive;
        }
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
