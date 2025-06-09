import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../core/utils/helper.dart';

class ElevatedButtonWidget extends StatelessWidget {
  final double? width;
  final double? height;
  final String btnText;
  final IconData? btnIcon;
  final Function()? onPressBtn;
  final Color? btnColor;

  const ElevatedButtonWidget({
    Key? key,
    required this.btnText,
    this.width,
    this.height,
    this.onPressBtn,
    this.btnIcon,
    this.btnColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? 0.25.sw,
      height: height ?? 32.h,
      child: ElevatedButton(
        onPressed: onPressBtn,
       style: ButtonStyle(
         backgroundColor: WidgetStatePropertyAll(btnColor ?? Theme.of(context).colorScheme.primary),

         // backgroundColor: WidgetStatePropertyAll(Colors.white)
       ),
        child: FittedBox(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (btnIcon != null) ...[
                Icon(
                  btnIcon,
                  color: Colors.white,
                  size: 18.w,
                ),
                SizedBox(width: 6.w),
              ],
              Text(
                btnText,
                style: styleGenerator(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  fontColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
