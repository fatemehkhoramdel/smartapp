import 'package:flutter/material.dart';
import 'package:tokenizer/tokenizer.dart';

import '../../../core/utils/enums.dart';
import '../../../widgets/custom_appbar_widget.dart';
import 'mobile/customize_home_view_mobile.dart';

class CustomizeHomeView extends StatelessWidget {
  const CustomizeHomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MyBaseWidget(
      platformAppBar: const CustomAppbarWidget(
        menu: MenuItems.customizeHome,
        hasHelper: false,
      ).build(context),
      mobileChild: CustomizeHomeViewMobile(),
    );
  }
}
