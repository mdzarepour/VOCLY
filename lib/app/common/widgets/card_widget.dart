import 'package:flutter/material.dart';
import 'package:vocly/app/common/constants/const_colors.dart';

class CardWidget extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final bool? isHavePadding;
  final Color? selectedBorderColor;

  const CardWidget({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.isHavePadding,
    this.selectedBorderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      padding: EdgeInsets.symmetric(
        horizontal: isHavePadding == false ? 0 : 20,
      ),
      decoration: BoxDecoration(
        color: ConstUiColors.forthColor,
        border: Border.all(
          color: selectedBorderColor ?? ConstUiColors.backgroundColor2,
          width: 1,
        ),
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      child: child,
    );
  }
}
