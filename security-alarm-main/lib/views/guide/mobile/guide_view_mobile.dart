import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:supercharged/supercharged.dart';

import '../../../core/constants/design_values.dart';
import '../../../core/utils/helper.dart';

class GuideViewMobile extends StatelessWidget {
  final int scrollToIndex;
  GuideViewMobile({Key? key, required this.scrollToIndex}) : super(key: key);

  final List<String> _titlesList = [
    translate('main_page'),
    translate('add_device'),
    translate('charge_device'),
    translate('device_setting'),
    translate('advance_tools'),
    translate('contacts'),
    translate('zones'),
    translate('android_app_settings'),
  ];
  final List<String> _descriptionsList = [
    translate('guide1'),
    translate('guide2'),
    translate('guide3'),
    translate('guide4'),
    translate('guide5'),
    translate('guide6'),
    translate('guide7'),
    translate('guide8'),
  ];

  final List<IconData> _iconsList = [
    Icons.home,
    Icons.add_circle,
    Icons.attach_money,
    Icons.settings,
    Icons.settings_input_component_rounded,
    Icons.phone,
    Icons.control_camera,
    Icons.settings_cell_rounded,
  ];

  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (scrollToIndex != 0) {
        itemScrollController.scrollTo(
          index: scrollToIndex,
          duration: 900.milliseconds,
          curve: Curves.easeInOutCubic,
        );
      }
    });
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: ScrollablePositionedList.builder(
        itemCount: _titlesList.length,
        itemScrollController: itemScrollController,
        itemPositionsListener: itemPositionsListener,
        itemBuilder: (context, index) {
          return _buildSingleGuide(
            _titlesList[index],
            _descriptionsList[index],
            _iconsList[index],
            index,
          );
        },
      ),
    );
  }

  //TODO: Move this method to separate Widget
  Widget _buildSingleGuide(
    String title,
    String content,
    IconData iconData,
    int index,
  ) {
    return Column(
      children: [
        Material(
          color: Colors.white,
          elevation: 2,
          borderRadius: BorderRadius.circular(kBorderRadius.r),
          child: Container(
            width: 1.0.sw,
            alignment: Alignment.centerRight,
            height: 50.h,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: styleGenerator(
                    fontWeight: FontWeight.bold,
                    fontColor: Colors.black87,
                  ),
                ),
                Icon(iconData, color: Colors.black38),
              ],
            ),
          ),
        ),
        SizedBox(height: 15.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Text(
            content,
            textAlign: TextAlign.start,
            style: styleGenerator(fontSize: 14, fontColor: Colors.black54),
          ),
        ),
        SizedBox(height: 15.h),
      ],
    );
  }
}
