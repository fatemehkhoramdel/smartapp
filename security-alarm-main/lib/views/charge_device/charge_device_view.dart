import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tokenizer/tokenizer.dart';

import '../../core/utils/enums.dart';
import '../../widgets/custom_appbar_widget.dart';
import 'mobile/charge_device_view_mobile.dart';

class ChargeDeviceView extends StatelessWidget {
  const ChargeDeviceView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MyBaseWidget(
      platformAppBar:
          const CustomAppbarWidget(menu: MenuItems.chargeDevice).build(context),
      mobileChild: ChargeDeviceViewMobile(),
    );
  }
}
