import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tokenizer/tokenizer.dart';

import '../../core/utils/enums.dart';
import '../../widgets/custom_appbar_widget.dart';
import 'mobile/advance_tools_view_mobile.dart';

class AdvanceToolsView extends StatelessWidget {
  const AdvanceToolsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MyBaseWidget(
      platformAppBar:
          const CustomAppbarWidget(menu: MenuItems.advanceTools).build(context),
      mobileChild: AdvanceToolsViewMobile(),
    );
  }
}
