import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tokenizer/tokenizer.dart';

import '../core/utils/enums.dart';
import '../core/utils/extensions.dart';
import '../core/utils/helper.dart';
import '../views/guide/guide_view.dart';

class CustomAppbarWidget extends StatelessWidget {
  final MenuItems menu;
  final bool hasHelper;
  final Function()? onTapBack;
  const CustomAppbarWidget({
    Key? key,
    required this.menu,
    this.hasHelper = true,
    this.onTapBack,
  }) : super(key: key);

  @override
  PlatformAppBar build(BuildContext context) {
    return PlatformAppBar(
      toolbarHeight: 0.08.sh,
      centerTitle: true,
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      elevation: Theme.of(context).appBarTheme.elevation,
      title: Text(
        menu.value,
        style: styleGenerator(
          fontWeight: FontWeight.bold,
          fontColor: Theme.of(context).colorScheme.primary,
        ),
      ),
      leading: GestureDetector(
        onTap: onTapBack ?? () => Navigator.pop(context),
        child: Icon(
          Icons.arrow_back_ios,
          color: Theme.of(context).colorScheme.primary,
          size: 23.w,
        ),
      ),
      actions: [
        if (hasHelper) _buildHelpIcon(context),
      ],
    );
  }

  Widget _buildHelpIcon(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: GestureDetector(
        child: Icon(
          Icons.description_outlined,
          color: Theme.of(context).colorScheme.primary,
        ),
        onTap: () => _onTapHelp(context),
      ),
    );
  }

  void _onTapHelp(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => GuideView(scrollToIndex: menu.indexInGuidePage),
      ),
    );
  }
}
