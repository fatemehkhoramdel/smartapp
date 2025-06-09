// import 'package:ava/common/values/imports.dart';
//
// export 'package:ava/core/models/label_model.dart';

import 'package:security_alarm/models/labelModel.dart';
import 'package:security_alarm/widgets/svg.dart';
import 'package:flutter/material.dart';

class CustomLabel extends StatelessWidget {
  const CustomLabel({
    super.key,
    required this.label,
    this.style,
    this.color,
    this.margin,
    this.onShowAll,
    this.trailing,
  });

  final LabelModel label;
  final TextStyle? style;
  final Color? color;
  final double? margin;
  final VoidCallback? onShowAll;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    if (onShowAll != null || trailing != null) {
      return Padding(
        padding: EdgeInsets.symmetric(
          horizontal: margin ?? 0,
        ),
        child: Row(
          children: [
            Expanded(
              child: _Text(
                // icon: label.icon,
                label: label.title ?? '',
                style: style ?? const TextStyle(fontSize: 20, color: Colors.black),
                iconColor: color,
              ),
            ),
            if (onShowAll != null)
              GestureDetector(
                onTap: onShowAll,
                child: const Text(
                  'مشاهده همه',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                  ),
                ),
              ),
            if (trailing != null) trailing!,
          ],
        ),
      );
    }
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: margin ?? 0,
      ),
      child: _Text(
        // icon: label.icon,
        label: label.title ?? '',
        style: style?? const TextStyle(fontSize: 20, color: Colors.black),
        iconColor: color,
      ),
    );
  }
}

class _Text extends StatelessWidget {
  const _Text({
    // this.icon,
    required this.label,
    this.style,
    this.iconColor,
  });

  // final String? icon;
  final String label;
  final TextStyle? style;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return RichText(
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        style: style ??
            TextStyle(
              color: iconColor ?? const Color(0xFF87B8FF),
            ),
        children: [
          // if (icon != null)
          //   WidgetSpan(
          //     alignment: PlaceholderAlignment.middle,
          //     child: Padding(
          //       padding: const EdgeInsets.only(left: 5),
          //       child: CustomSvg(
          //         icon!,
          //         color: iconColor ?? const Color(0xFF87B8FF),
          //       ),
          //     ),
          //   ),
          TextSpan(
            text: label,
          ),
        ],
      ),
    );
  }
}
