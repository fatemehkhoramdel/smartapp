import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../core/utils/helper.dart';

class TextButtonWidget extends StatelessWidget {
  final double? width;
  final double? height;
  final String btnText;
  final IconData? btnIcon;
  final Function()? onPressBtn;
  final Color? borderColor;
  final Color? textColor;
  final Color? iconColor;
  final bool isDisabled;

  const TextButtonWidget({
    Key? key,
    required this.btnText,
    this.width,
    this.height,
    this.onPressBtn,
    this.btnIcon,
    this.borderColor,
    this.textColor,
    this.iconColor,
    this.isDisabled = false, // Default to false
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final effectiveBorderColor = borderColor ?? Theme.of(context).colorScheme.primary;
    final effectiveTextColor = textColor ?? Theme.of(context).colorScheme.primary;
    final effectiveIconColor = iconColor ?? Theme.of(context).colorScheme.primary;
    final disabledColor = Colors.grey.withOpacity(0.5);

    return SizedBox(
      width: width ?? 0.25.sw,
      height: height ?? 32.h,
      child: TextButton(
        // Disable onPressed if isDisabled is true
        onPressed: isDisabled ? null : onPressBtn,
        // style: TextButton.styleFrom(
        //   side: BorderSide(
        //     // Use disabled color for border if disabled
        //     color: isDisabled ? disabledColor : effectiveBorderColor,
        //     width: 1.5.w, // Slightly thicker border
        //   ),
        //   shape: RoundedRectangleBorder(
        //     borderRadius: BorderRadius.circular((height ?? 40.h) / 2), // Rounded corners
        //   ),
        //   padding: EdgeInsets.symmetric(horizontal: 16.w), // Add some padding
        //    // Remove default background color
        //   backgroundColor: Colors.transparent,
        // ),
        child: FittedBox(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (btnIcon != null) ...[
                Icon(
                  btnIcon,
                  // Use disabled color for icon if disabled
                  color: isDisabled ? disabledColor : effectiveIconColor,
                  size: 18.w,
                ),
                SizedBox(width: 6.w),
              ],
              Text(
                btnText,
                style: styleGenerator(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  // Use disabled color for text if disabled
                  fontColor: isDisabled ? disabledColor : effectiveTextColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
