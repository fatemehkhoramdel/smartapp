import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';
import 'package:security_alarm/core/constants/asset_constants.dart';
import 'package:security_alarm/widgets/dialogs/editable_dialog2_widget.dart';

import '../../../core/utils/helper.dart';
import '../../../providers/setup_provider.dart';

class SetupViewMobile extends HookWidget {
  late SetupProvider _setupProvider;
  late TextEditingController _devicePhoneTEC;
  late TextEditingController _deviceNameTEC;
  late FocusNode _devicePhoneFN;

  SetupViewMobile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _setupProvider = context.read<SetupProvider>();
    _devicePhoneTEC = useTextEditingController();
    _deviceNameTEC = useTextEditingController();
    _devicePhoneFN = useFocusNode();

    final privacyAccepted = useState(false);

    return Scaffold(
      backgroundColor: const Color(0xFF09162E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF09162E),
        elevation: 0,
        leading:
          Container(
              width: 44.w,
              height: 44.w,
            margin: EdgeInsets.only(right: 10.w),
            padding: EdgeInsets.all(4.w),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0xFF142850),
                borderRadius: BorderRadius.circular(8.r),
              // image: const DecorationImage(image: AssetImage(kLogoAsset))
            ),
            child: Container(
              decoration: BoxDecoration(
                  color: const Color(0xFF142850),
                  borderRadius: BorderRadius.circular(8.r),
                  image: const DecorationImage(image: AssetImage(kLogoAsset))
              ),
            ),
            // child: Text(
            //   "LO\nGO",
            //   textAlign: TextAlign.center,
            //   style: TextStyle(
            //     color: Colors.white,
            //     fontSize: 14.sp,
            //     fontWeight: FontWeight.bold,
            //   ),
            // ),
          ),
        title: Text(
          "ورود",
                style: TextStyle(
                  color: Colors.white,
            fontSize: 16.sp,
              ),
            ),
        centerTitle: false,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 40.h),
            
            // Device name title
            Text(
              "نام محل نصب دستگاه",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.right,
            ),
            
            SizedBox(height: 16.h),
            
            // Installation location field
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(color: Colors.white30, width: 1.w),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Row(
                  textDirection: TextDirection.rtl,
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      color: Colors.white,
                      size: 24.sp,
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: TextField(
                        controller: _deviceNameTEC,
                        textAlign: TextAlign.right,
                        textDirection: TextDirection.rtl,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                        ),
                        decoration: InputDecoration(
                          hintText: "نام محل نصب",
                          hintStyle: TextStyle(
                            color: Colors.white54,
                            fontSize: 16.sp,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            SizedBox(height: 40.h),
            
            // SIM card number title
            Text(
              "شماره سیمکارت",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.right,
            ),
            
            SizedBox(height: 16.h),
            
            // SIM card number field
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(color: Colors.white30, width: 1.w),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Row(
                  textDirection: TextDirection.rtl,
                  children: [
                    Icon(
                      Icons.phone,
                      color: Colors.white,
                      size: 24.sp,
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: TextField(
                        controller: _devicePhoneTEC,
                        textAlign: TextAlign.right,
                        textDirection: TextDirection.rtl,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                        ),
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          hintText: "شماره سیمکارت",
                          hintStyle: TextStyle(
                            color: Colors.white54,
                            fontSize: 16.sp,
                          ),
                          border: InputBorder.none,
                        ),
                        onChanged: (text) {
                          if (text.length >= 3) {
                            _setupProvider.autoDetectOperator(text);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 40.h),
            // Privacy policy checkbox
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    privacyAccepted.value = !privacyAccepted.value;
                  },
                  child: Container(
                    width: 24.w,
                    height: 24.w,
                    decoration: BoxDecoration(
                      color: privacyAccepted.value ? const Color(0xFF2E70E6) : Colors.transparent,
                      borderRadius: BorderRadius.circular(4.r),
                      border: Border.all(
                        color: privacyAccepted.value ? const Color(0xFF2E70E6) : Colors.white,
                        width: 1.w,
                      ),
                    ),
                    child: privacyAccepted.value
                        ? Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 18.sp,
                          )
                        : null,
                  ),
                ),
                SizedBox(width: 8.w),
                GestureDetector(
                  onTap: () => _onTapPrivacyPolicy(context),
                  child: Text(
                    "سیاست های حریم خصوصی",
                    style: TextStyle(
                      color: const Color(0xFF2E70E6),
                      fontSize: 14.sp,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
            
            SizedBox(height: 100.h),
            
            // Login button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  if (_deviceNameTEC.text.isEmpty || _devicePhoneTEC.text.isEmpty) {
                    toastGenerator(translate('لطفا تمام فیلدها را پر کنید'));
                    return;
                  }
                  
                  if (!privacyAccepted.value) {
                    toastGenerator(translate('لطفا سیاست حریم خصوصی را قبول کنید'));
                    return;
                  }
                  
                  _setupProvider.updateDeviceAfterSetup(
                    _deviceNameTEC.text,
                    _devicePhoneTEC.text,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E70E6),
                  minimumSize: Size(200.w, 50.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.r),
                  ),
                ),
                child: Text(
                  "ورود",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            
            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }

  void _onTapPrivacyPolicy(BuildContext context) {
    dialogGenerator(
      translate('privacy_policy'),
      translate('privacy_policy_desc'),
      showCancel: false,
    );
  }
}
