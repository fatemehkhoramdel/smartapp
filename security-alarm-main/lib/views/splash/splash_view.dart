import 'package:flutter/material.dart';
import 'package:tokenizer/tokenizer.dart';

import 'mobile/splash_view_mobile.dart';

class SplashView extends StatelessWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MyBaseWidget(
      backgroundColor: Theme.of(context).colorScheme.primary,
      mobileChild: SplashViewMobile(),
      hasScrollView: false,
    );
  }
}
