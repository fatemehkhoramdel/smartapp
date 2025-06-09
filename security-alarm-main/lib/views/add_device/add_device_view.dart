import 'package:flutter/material.dart';
import 'package:tokenizer/tokenizer.dart';

import '../../core/utils/enums.dart';
import '../../widgets/custom_appbar_widget.dart';
import 'mobile/add_device_view_mobile.dart';

class AddDeviceView extends StatelessWidget {
  const AddDeviceView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MyBaseWidget(
      platformAppBar:
          const CustomAppbarWidget(menu: MenuItems.addDevice).build(context),
      mobileChild: AddDeviceViewMobile(),
    );
  }
}
