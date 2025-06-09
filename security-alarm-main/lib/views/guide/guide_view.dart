import 'package:flutter/material.dart';
import 'package:tokenizer/tokenizer.dart';

import '../../core/utils/enums.dart';
import '../../widgets/custom_appbar_widget.dart';
import 'mobile/guide_view_mobile.dart';

class GuideView extends StatelessWidget {
  final int scrollToIndex;

  const GuideView({Key? key, required this.scrollToIndex}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MyBaseWidget(
      platformAppBar: const CustomAppbarWidget(
        menu: MenuItems.guide,
        hasHelper: false,
      ).build(context),
      hasScrollView: false,
      mobileChild: GuideViewMobile(scrollToIndex: scrollToIndex),
    );
  }
}
