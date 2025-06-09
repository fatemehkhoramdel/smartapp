import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../core/utils/enums.dart';
import '../core/utils/extensions.dart';

class OperatorContainerWidget extends StatelessWidget {
  final Operators operator;
  final Function()? onTapOperator;
  final double? width;
  final Operators selectedOperator;

  const OperatorContainerWidget({
    Key? key,
    required this.operator,
    required this.onTapOperator,
    this.width,
    required this.selectedOperator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapOperator,
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.w),
          side: BorderSide(
            width: 3,
            color: selectedOperator == operator
                ? operator.color
                : Operators.none.color,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10.w),
          child: ColorFiltered(
            colorFilter: selectedOperator == operator
                ? const ColorFilter.mode(Colors.transparent, BlendMode.hue)
                : ColorFilter.mode(Colors.grey.shade100, BlendMode.hue),
            child: _buildImage(),
          ),
        ),
      ),
    );
  }

  Widget _buildImage() {
    return Container(
      width: width ?? 75.w,
      height: width ?? 75.w,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(operator.imageAddress),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
