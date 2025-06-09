import 'dart:developer';

import 'package:security_alarm/models/labelModel.dart';
import 'package:security_alarm/providers/scenario_provider.dart';
import 'package:security_alarm/widgets/custom_text_field_widget.dart';
import 'package:security_alarm/widgets/label.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';

import '../../../core/utils/helper.dart';
import '../../../models/device.dart';
import '../../../providers/main_provider.dart';
import '../../../widgets/elevated_button_widget.dart';
import '../../../widgets/outlined_button_widget.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';
import 'package:security_alarm/core/constants/global_keys.dart';
import 'package:security_alarm/widgets/elevated_button_widget.dart';
import 'package:security_alarm/widgets/svg.dart';

import '../../../core/constants/design_values.dart';
import '../../../providers/audio_notification_provider.dart';
import '../../../providers/zones_provider.dart';
import '../../../repository/cache_repository.dart';
import '../../../injector.dart';
import '../../../views/zones/zone_settings/mobile/zone_mode_settings_view.dart';

class ScenarioViewMobile extends StatefulWidget {
  const ScenarioViewMobile({Key? key}) : super(key: key);

  @override
  State<ScenarioViewMobile> createState() => _ScenarioViewMobileState();
}

class _ScenarioViewMobileState extends State<ScenarioViewMobile> {
  late Device _device;
  late MainProvider _mainProvider;
  late ScenarioProvider _scenarioProvider;

  String? selectedZone;
  String? selectedActivation;
  String? selectedRelay;
  String? selectedRelayState;
  String? selectedMode;
  
  // تعداد سناریوهای تعریف شده
  int _scenarioCount = 0;
  
  // لیست زون‌های بارگذاری شده از دیتابیس
  List<ZoneModel> _zones = [];

  // Define dropdown constants
  final List<String> activationOptions = ['فعال سازی', 'غیرفعال سازی'];
  final List<String> relayStateOptions = ['روشن', 'خاموش'];
  
  // گزینه‌های جدید برای مد عملکرد
  final List<String> modeOptions = [
    'در همه زمان‌ها',
    'در زمان فعال بودن دستگاه',
    'در زمان غیر فعال بودن دستگاه'
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initZones();
      _loadSavedScenarios();
    });
  }
  
  // بارگذاری زون‌ها از دیتابیس - مشابه zone_mode_settings_view.dart
  void _initZones() async {
    final mainProvider = Provider.of<MainProvider>(context, listen: false);
    final zonesProvider = Provider.of<ZonesProvider>(context, listen: false);
    
    // ابتدا زون‌ها را از دیتابیس بارگذاری می‌کنیم
    await zonesProvider.loadZones();
    
    // سپس زون‌های بارگذاری شده را دریافت می‌کنیم
    List<ZoneModel> savedZones = zonesProvider.getAllZones();
    log('savedZones = $savedZones');
    if (savedZones.isNotEmpty) {
      // استفاده از زون‌های بارگذاری شده
      setState(() {
        _zones = savedZones;
      });
    } else {
      // اگر زونی در دیتابیس نبود، از اطلاعات دستگاه استفاده می‌کنیم
      final device = mainProvider.selectedDevice;
      setState(() {
        _zones = [
          // زون پیش‌فرض با سیم (از زون 1)
          ZoneModel(
            id: 1,
            name: device.zone1Name,
            connectionType: "wired",
            conditions: [device.zone1Condition],
          ),
          // زون پیش‌فرض بی‌سیم (از زون 2)
          ZoneModel(
            id: 2,
            name: device.zone2Name,
            connectionType: "wireless",
            conditions: [device.zone2Condition],
          ),
        ];
        
        // اضافه کردن سایر زون‌ها از دستگاه
        if (device.zone3Name.isNotEmpty) {
          _zones.add(ZoneModel(
            id: 3,
            name: device.zone3Name,
            connectionType: "wired", // پیش‌فرض برای زون‌های موجود
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
        
        // ذخیره زون‌ها در provider برای استفاده‌های بعدی
        zonesProvider.setAllZones(_zones);
      });
    }
  }
  
  // Load saved scenarios from the database
  void _loadSavedScenarios() async {
    _mainProvider = Provider.of<MainProvider>(context, listen: false);
    _scenarioProvider = Provider.of<ScenarioProvider>(context, listen: false);
    _device = _mainProvider.selectedDevice;
    
    final deviceId = _device.id;
    if (deviceId == null) return;
    
    try {
      final savedScenario = await injector<CacheRepository>().getScenarioByDeviceId(deviceId);
      if (savedScenario != null) {
        log('Loading scenarios from database for device $deviceId');
        setState(() {
          // Update the UI with saved scenarios
          _scenarioProvider.clearScenariosText(); // Clear first to avoid duplicates
          
          // Add each non-empty scenario text to the UI
          List<String> textFields = [
            savedScenario.scenarioText1,
            savedScenario.scenarioText2,
            savedScenario.scenarioText3,
            savedScenario.scenarioText4,
            savedScenario.scenarioText5,
            savedScenario.scenarioText6,
            savedScenario.scenarioText7,
            savedScenario.scenarioText8,
            savedScenario.scenarioText9,
            savedScenario.scenarioText10,
          ];
          
          // Add all non-empty scenario texts to the provider
          for (var text in textFields) {
            if (text.isNotEmpty) {
              _scenarioProvider.addScenarioText(text);
              log('Added scenario text: $text');
            }
          }
          
          // Also set the SMS format and mode format
          _scenarioProvider.setSMSFormat(savedScenario.smsFormat);
          _scenarioProvider.setModeFormat(savedScenario.modeFormat);
          
          _scenarioCount = _scenarioProvider.scenariosText.length;
          log('Loaded ${_scenarioCount} scenarios from database');
        });
      } else {
        log('No saved scenarios found for device $deviceId');
      }
    } catch (e) {
      log('Error loading saved scenarios: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    _mainProvider = Provider.of<MainProvider>(context);
    _scenarioProvider = Provider.of<ScenarioProvider>(context);
    _device = _mainProvider.selectedDevice;

    // Initialize the dropdown values if not set
    _initializeValues();

    final scenariosText = _scenarioProvider.scenariosText;
    _scenarioCount = scenariosText.length;

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
              getDrawerKey('ScenarioView').currentState!.toggle();
            },
          ),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      children: [
          // Description text
          Text(
            translate(
                'با انتخاب زون و رله و فعال کردن و غیر فعال کردن آنها می‌توانید سناریو تعریف کنید'),
            style: TextStyle(
              color: const Color(0XFFF87E5F),
              fontSize: 16.sp,
            ),
            textAlign: TextAlign.start,
          ),
          SizedBox(height: 30.h),

          // "اگر" section with green text
          Text(
            "اگر",
            style: TextStyle(
              color: Colors.green,
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 15.h),

          // First dropdown (zones selection)
          _buildDropdown(
            title: 'انتخاب زون',
            items: _getZonesList(),
            value: selectedZone,
            onChanged: (value) => setState(() => selectedZone = value),
          ),
          SizedBox(height: 10.h),

          // Second dropdown (activation/deactivation)
          _buildDropdown(
            title: '',
            items: activationOptions,
            value: selectedActivation,
            onChanged: (value) => setState(() => selectedActivation = value),
          ),

          SizedBox(height: 30.h),

          // "آنگاه" section with yellow text
          Text(
            "آنگاه",
            style: TextStyle(
              color: Colors.yellow,
              fontSize: 22.sp,
            fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 15.h),

          // Third dropdown (relay selection)
          _buildDropdown(
            title: 'انتخاب رله',
            items: _getRelaysList(),
            value: selectedRelay,
            onChanged: (value) => setState(() => selectedRelay = value),
          ),
          SizedBox(height: 10.h),

          // Fourth dropdown (on/off)
          _buildDropdown(
            title: '',
            items: relayStateOptions,
            value: selectedRelayState,
            onChanged: (value) => setState(() => selectedRelayState = value),
          ),

          SizedBox(height: 30.h),

          // Fifth dropdown (operation mode)
          _buildDropdown(
            title: 'انتخاب مد عملکرد سناریوها',
            items: modeOptions,
            value: selectedMode,
            onChanged: (value) => setState(() => selectedMode = value),
          ),

          SizedBox(height: 40.h),

          // Save button
          Container(
            height: 40.h,
            margin: EdgeInsets.symmetric(horizontal: 100.w),
            decoration: BoxDecoration(
              color: Colors.purple,
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: ElevatedButton(
              onPressed: () => _saveScenario(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              child: Text(
                'ذخیره',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          SizedBox(height: 30.h),

          // Defined scenarios section
          Text(
            translate('سناریوهای تعریف شده'),
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 15.h),

          // List of defined scenarios
          if (scenariosText.isNotEmpty)
            Container(
              height: 200.h,
                        child: ListView.builder(
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                itemCount: scenariosText.length,
                          itemBuilder: (context, index) {
                  String scene = scenariosText[index] ?? '-';
                            return Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey, width: 2),
                        borderRadius: BorderRadius.circular(16.r)),
                    padding: EdgeInsets.all(12.h),
                    margin: EdgeInsets.only(bottom: 10.h),
                    child: Text(
                      scene,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                      ),
                              ),
                            );
                          },
                        ),
            )
          else
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20.h),
              child: Center(
                child: Text(
                  translate('هیچ سناریویی تعریف نشده است'),
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14.sp,
                  ),
                            ),
                          ),
                        ),

          SizedBox(height: 30.h),

          // Bottom buttons row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
              child: ElevatedButtonWidget(
                btnText: translate('استعلام'),
                onPressBtn: () => _scenarioProvider.getScenarioFromDevice(),
              ),
            ),
              SizedBox(width: 20.w),
              Expanded(
                child: ElevatedButtonWidget(
                  btnText: translate('ارسال'),
                  onPressBtn: () => _sendScenarios(),
                  btnColor: Colors.purple,
                          ),
                        ),
                      ],
                    ),

          SizedBox(height: 30.h),
                  ],
                ),
              );
  }

  void _initializeValues() {
    final List<String> zones = _getZonesList();
    final List<String> relays = _getRelaysList();

    // If the provider values exist but don't match our dropdown options, set default values
    if (selectedZone == null) {
      final providerZone = _scenarioProvider.scenario[2];
      selectedZone = zones.contains(providerZone)
          ? providerZone
          : (zones.isNotEmpty ? zones.first : null);
    }

    if (selectedActivation == null) {
      final providerActivation = _scenarioProvider.scenario[0];
      selectedActivation = activationOptions.contains(providerActivation)
          ? providerActivation
          : activationOptions.first;
    }

    if (selectedRelay == null) {
      final relayName = _getRelayName(_scenarioProvider.scenario[4]);
      selectedRelay =
          relays.contains(relayName) ? relayName : (relays.isNotEmpty ? relays.first : null);
    }

    if (selectedRelayState == null) {
      final isOn = _isRelayOn(_scenarioProvider.scenario[4]);
      selectedRelayState =
          isOn ? relayStateOptions.first : relayStateOptions.last;
    }

    if (selectedMode == null) {
      selectedMode = modeOptions.first;
    }
  }

  Widget _buildDropdown({
    required String title,
    required List<String> items,
    required String? value,
    required Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.sp,
          ),
        ),
        SizedBox(height: 5.h),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0XFF122950), width: 1),
          ),
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: items.contains(value)
                  ? value
                  : (items.isNotEmpty ? items[0] : null),
        isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down),
              iconSize: 24.sp,
              elevation: 16,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16.sp,
              ),
              onChanged: onChanged,
              dropdownColor: const Color(0xFF09162E),
              items: items.map<DropdownMenuItem<String>>((String value2) {
                return DropdownMenuItem<String>(
                  value: value2,
                  child: Container(
                    width: double.infinity,
                      color: value == value2
                          ? const Color(0xFF09162E)
                          : const Color(0xFF09162E),
                      child: Text(value2,
                          style: const TextStyle(color: Colors.white))),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  // دریافت لیست زون‌ها - به‌روزرسانی شده برای استفاده از داده‌های دیتابیس
  List<String> _getZonesList() {
    List<String> zones = [];

    // اضافه کردن زون‌های بارگذاری شده از دیتابیس
    if (_zones.isNotEmpty) {
      for (var zone in _zones) {
        if (zone.name.isNotEmpty) {
          zones.add(zone.name);
        }
      }
    } else {
      // اگر هنوز زون‌ها بارگذاری نشده‌اند، از دستگاه استفاده می‌کنیم
      if (_device.zone1Name.isNotEmpty) zones.add(_device.zone1Name);
      if (_device.zone2Name.isNotEmpty) zones.add(_device.zone2Name);
      if (_device.zone3Name.isNotEmpty) zones.add(_device.zone3Name);
      if (_device.zone4Name.isNotEmpty) zones.add(_device.zone4Name);
      if (_device.zone5Name.isNotEmpty) zones.add(_device.zone5Name);
    }
    
    log('zones = $zones');
    
    // اگر هیچ زونی یافت نشد، زون‌های پیش‌فرض را اضافه می‌کنیم
    if (zones.isEmpty) {
      for (int i = 1; i <= 5; i++) {
        zones.add('زون $i');
      }
    }

    // اضافه کردن گزینه "برق"
    zones.add('برق');

    return zones;
  }

  // دریافت لیست رله‌های واقعی
  List<String> _getRelaysList() {
    // فعلاً به صورت استاتیک پیاده‌سازی می‌کنیم
    List<String> relays = [];
    
    // رله‌های پیش‌فرض را اضافه می‌کنیم
    for (int i = 1; i <= 3; i++) {
      relays.add('رله $i');
    }

    return relays;
  }

  String _getRelayName(String? actionSelect) {
    if (actionSelect == null) return 'رله 1';

    if (actionSelect.contains('رله 1')) return 'رله 1';
    if (actionSelect.contains('رله 2')) return 'رله 2';
    if (actionSelect.contains('رله 3')) return 'رله 3';

    return 'رله 1';
  }

  bool _isRelayOn(String? actionSelect) {
    if (actionSelect == null) return true;

    return actionSelect.contains('وصل');
  }

  String _getRelayActionFromName(String relayName, {bool isOn = true}) {
    if (relayName == 'رله 1') return isOn ? 'رله 1 وصل' : 'رله 1 قطع';
    if (relayName == 'رله 2') return isOn ? 'رله 2 وصل' : 'رله 2 قطع';
    if (relayName == 'رله 3') return isOn ? 'رله 3 وصل' : 'رله 3 قطع';

    return isOn ? 'رله 1 وصل' : 'رله 1 قطع';
  }

  // تبدیل نام زون به شماره آن برای SMS
  int _getZoneNumberForSMS(String? zoneName) {
    if (zoneName == null) return 1;
    
    if (zoneName == 'برق') return 8;
    
    // برای زون‌های بیسیم
    if (zoneName.contains('بیسیم')) return 7;
    
    // جستجو در زون‌های بارگذاری شده از دیتابیس
    for (var zone in _zones) {
      if (zone.name == zoneName) {
        return zone.id;
      }
    }
    
    // برای زون های با شماره مشخص
    if (zoneName.contains('1') || zoneName.contains('۱')) return 1;
    if (zoneName.contains('2') || zoneName.contains('۲')) return 2;
    if (zoneName.contains('3') || zoneName.contains('۳')) return 3;
    if (zoneName.contains('4') || zoneName.contains('۴')) return 4;
    if (zoneName.contains('5') || zoneName.contains('۵')) return 5;
    if (zoneName.contains('6') || zoneName.contains('۶')) return 6;
    
    // پیش‌فرض
    return 1;
  }

  // تبدیل نام رله به شماره آن برای SMS
  int _getRelayNumberForSMS(String? relayName) {
    if (relayName == null) return 1;
    
    if (relayName.contains('1') || relayName.contains('۱')) return 1;
    if (relayName.contains('2') || relayName.contains('۲')) return 2;
    if (relayName.contains('3') || relayName.contains('۳')) return 3;
    
    // پیش‌فرض
    return 1;
  }

  // ایجاد متن SMS برای سناریو
  String _createSMSText() {
    // فرمت SMS: s{scenarioNumber}{zoneNumber}{activationNumber}{relayNumber}{relayStateNumber}/
    
    _scenarioCount++; // افزایش شمارنده سناریو
    
    // شماره سناریو
    String smsText = 's$_scenarioCount:';
    
    // شماره زون
    smsText += _getZoneNumberForSMS(selectedZone).toString();
    
    // فعال‌سازی یا غیرفعال‌سازی
    smsText += (selectedActivation == 'فعال سازی') ? '1' : '0';
    
    // شماره رله
    smsText += _getRelayNumberForSMS(selectedRelay).toString();
    
    // وضعیت رله
    smsText += (selectedRelayState == 'روشن') ? '1' : '0';
    
    // افزودن / در انتها
    smsText += '/';
    
    return smsText;
  }

  void _saveScenario() {
    // Validate inputs
    if (selectedActivation == null ||
        selectedMode == null ||
        selectedZone == null ||
        selectedRelay == null ||
        selectedRelayState == null) {
      toastGenerator(translate('لطفا تمامی اطلاعات را وارد کنید'));
      return;
    }

    // Set relay type
    _scenarioProvider.updateScenario('رله', 3);

    // Create scenario text
    final scenarioText =
        'سناریو ${_scenarioCount + 1}: اگر $selectedZone ${selectedActivation == 'فعال سازی' ? 'فعال' : 'غیرفعال'} شود، ${_getRelayActionFromName(selectedRelay!, isOn: selectedRelayState == 'روشن')} می شود. (${selectedMode})';

    // Save locally
    _scenarioProvider.addScenarioText(scenarioText);
    
    // Also save to the database
    if (_device.id != null) {
      // Create SMS format for this scenario
      String smsCommand = _createSMSText();
      
      // Create mode command based on selected mode
      String modeCommand = '';
      if (selectedMode == 'در همه زمان‌ها') {
        modeCommand = 'senario_en=9';
      } else if (selectedMode == 'در زمان فعال بودن دستگاه') {
        modeCommand = 'senario_en=1';
      } else if (selectedMode == 'در زمان غیر فعال بودن دستگاه') {
        modeCommand = 'senario_en=0';
      }
      
      // Save to database
      injector<CacheRepository>().saveScenarios(
        _device.id!,
        _scenarioProvider.scenariosText,
        smsCommand,
        modeCommand,
      ).then((_) {
        log('Scenario saved to database');
      }).catchError((e) {
        log('Error saving scenario to database: $e');
      });
    }

    toastGenerator(translate('سناریو با موفقیت ذخیره شد'));
  }

  // ارسال تمامی سناریوها به صورت SMS
  void _sendScenarios() async {
    if (_scenarioProvider.scenariosText.isEmpty) {
      toastGenerator(translate('هیچ سناریویی برای ارسال وجود ندارد'));
      return;
    }
    
    log('Initial scenarios count: ${_scenarioProvider.scenariosText.length}');
    
    // Make a backup of current scenarios
    List<String?> scenariosBackup = List.from(_scenarioProvider.scenariosText);
    log('Created backup of scenarios, count: ${scenariosBackup.length}');
    
    String smsCommand = '';
    
    // ارسال هر سناریو با استفاده از متد _createSMSText
    // برای هر سناریو، ابتدا مقادیر را تنظیم می‌کنیم، سپس SMS را می‌سازیم
    for (int i = 0; i < _scenarioProvider.scenariosText.length; i++) {
      // بازیابی متن سناریوی ذخیره شده
      String scenarioText = _scenarioProvider.scenariosText[i] ?? '';
      log('پردازش سناریو $i: $scenarioText');
      
      // تنظیم مقادیر انتخاب شده بر اساس متن سناریو
      selectedZone = _extractZoneFromText(scenarioText);
      selectedActivation = scenarioText.contains('فعال') ? 'فعال سازی' : 'غیرفعال سازی';
      selectedRelay = _extractRelayFromText(scenarioText);
      selectedRelayState = scenarioText.contains('وصل') ? 'روشن' : 'خاموش';
      
      log('استخراج اطلاعات: زون=$selectedZone، وضعیت=${selectedActivation}، رله=$selectedRelay، وضعیت رله=$selectedRelayState');
      
      // ساخت پیام SMS با استفاده از متد _createSMSText
      // نکته: شماره سناریو در متد _createSMSText خودکار اضافه می‌شود، اما ما اینجا بازنشانی می‌کنیم
      _scenarioCount = i; // تنظیم برای شماره سناریوی درست (i+1)
      String scenarioSMS = _createSMSText();
      log('فرمت SMS سناریو $i: $scenarioSMS');
      smsCommand += scenarioSMS;
    }
    
    log('After processing scenarios count: ${_scenarioProvider.scenariosText.length}');
    
    // افزودن بخش مد عملکرد
    String modeCommand = '';
    if (selectedMode == 'در همه زمان‌ها') {
      modeCommand = 'senario_en=9';
    } else if (selectedMode == 'در زمان فعال بودن دستگاه') {
      modeCommand = 'senario_en=1';
    } else if (selectedMode == 'در زمان غیر فعال بودن دستگاه') {
      modeCommand = 'senario_en=0';
    }
    
    // ارسال SMS
    try {
      final phoneNumber = _device.devicePhone;
      
      log('فرمان سناریوها: $smsCommand');
      log('فرمان مد عملکرد: $modeCommand');
      log('شماره تلفن دستگاه: $phoneNumber');
      
      if (phoneNumber.isEmpty) {
        toastGenerator('شماره تلفن دستگاه خالی است');
        return;
      }
      
      // تنظیم فرمت SMS و مد عملکرد برای ارسال
      _scenarioProvider.setSMSFormat(smsCommand);
      _scenarioProvider.setModeFormat(modeCommand);
      
      toastGenerator('شروع ارسال سناریوها...');
      
      log('Before registerScenario scenarios count: ${_scenarioProvider.scenariosText.length}');
      
      // ارسال با استفاده از متد registerScenario که حالا از دیتابیس و sendDirectSMS استفاده می‌کند
      await _scenarioProvider.registerScenario();
      
      log('After registerScenario scenarios count: ${_scenarioProvider.scenariosText.length}');
      
      // Check if scenariosText was cleared
      if (_scenarioProvider.scenariosText.isEmpty && scenariosBackup.isNotEmpty) {
        log('Warning: scenariosText was cleared! Restoring from backup...');
        // Restore from backup
        for (String? text in scenariosBackup) {
          if (text != null && text.isNotEmpty) {
            _scenarioProvider.addScenarioText(text);
          }
        }
        log('Restored scenarios, new count: ${_scenarioProvider.scenariosText.length}');
      }
      
      // Save scenarios to database after successful sending - with error handling
      if (_device.id != null) {
        try {
          log('_scenarioProvider.scenariosText before saveScenarios = ${_scenarioProvider.scenariosText}');
          await injector<CacheRepository>().saveScenarios(
            _device.id!,
            _scenarioProvider.scenariosText,
            smsCommand,
            modeCommand,
          );
          log('Scenarios saved to database after successful sending: ${_scenarioProvider.scenariosText.length} scenarios');
        } catch (e) {
          log('Error saving scenarios to database after sending: $e');
          // Continue without showing error to user
        }
      }
      
      // Check again if scenariosText was cleared after saving
      if (_scenarioProvider.scenariosText.isEmpty && scenariosBackup.isNotEmpty) {
        log('Warning: scenariosText was cleared after saving! Restoring from backup again...');
        // Restore from backup
        for (String? text in scenariosBackup) {
          if (text != null && text.isNotEmpty) {
            _scenarioProvider.addScenarioText(text);
          }
        }
        log('Restored scenarios again, new count: ${_scenarioProvider.scenariosText.length}');
      }
      
      // به روزرسانی UI بعد از ارسال موفقیت‌آمیز
      setState(() {
        // _scenarioCount را به‌روز می‌کنیم تا نمایش صحیحی از تعداد سناریوها داشته باشیم
        _scenarioCount = _scenarioProvider.scenariosText.length;
      });
      
      log('Final scenarios count: ${_scenarioProvider.scenariosText.length}');
      toastGenerator(translate('درخواست ارسال شد'));
    } catch (e) {
      log('Error sending SMS: $e');
      toastGenerator(translate('خطا در ارسال پیامک'));
      
      // In case of error, make sure the scenariosText is preserved
      if (_scenarioProvider.scenariosText.isEmpty && scenariosBackup.isNotEmpty) {
        log('Restoring scenarios after error...');
        // Restore from backup
        for (String? text in scenariosBackup) {
          if (text != null && text.isNotEmpty) {
            _scenarioProvider.addScenarioText(text);
          }
        }
      }
    }
  }
  
  // استخراج نام زون از متن سناریو
  String? _extractZoneFromText(String scenarioText) {
    // در متن سناریو، زون‌ها با "زون ۱" یا "زون 1" مشخص می‌شوند
    final zones = _getZonesList();
    
    for (String zone in zones) {
      if (scenarioText.contains(zone)) {
        return zone;
      }
    }
    
    // اگر زون مشخصی پیدا نشد، اولین زون را برمی‌گردانیم
    return zones.isNotEmpty ? zones.first : null;
  }
  
  // استخراج نام رله از متن سناریو
  String? _extractRelayFromText(String scenarioText) {
    // در متن سناریو، رله‌ها با "رله ۱" یا "رله 1" مشخص می‌شوند
    final relays = _getRelaysList();
    
    for (String relay in relays) {
      if (scenarioText.contains(relay)) {
        return relay;
      }
    }
    
    // اگر رله مشخصی پیدا نشد، اولین رله را برمی‌گردانیم
    return relays.isNotEmpty ? relays.first : null;
  }
}
