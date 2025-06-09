import 'package:flutter/material.dart';
import 'package:tokenizer/tokenizer.dart';

import 'mobile/setup_view_mobile.dart';

class SetupView extends StatelessWidget {
  const SetupView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MyBaseWidget(
      mobileChild: SetupViewMobile(),
      hasScrollView: false,
    );
  }
}
