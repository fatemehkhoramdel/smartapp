import 'package:flutter/material.dart';
import 'package:tokenizer/tokenizer.dart';

import 'mobile/about_us_view_mobile.dart';

class AboutUsView extends StatelessWidget {
  const AboutUsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MyBaseWidget(
      backgroundColor: Theme.of(context).colorScheme.primary,
      mobileChild: const AboutUsViewMobile(),
    );
  }
}
