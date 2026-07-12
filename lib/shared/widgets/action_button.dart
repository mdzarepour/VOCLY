import 'package:flutter/material.dart';
import 'package:vocly/shared/constants/const_colors.dart';
import 'package:vocly/shared/widgets/card_widget.dart';
import 'package:vocly/shared/widgets/loading_widget.dart';

class ActionButton extends StatelessWidget {
  final void Function()? onTap;
  final Color? borderColor;
  final bool? isLoading;
  final List<Widget> children;

  const ActionButton({
    super.key,
    this.borderColor,
    this.isLoading,
    required this.onTap,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: CardWidget(
        height: 70,
        selectedBorderColor: borderColor ?? ConstUiColors.backgroundColor2,
        child: _getChildWidget(),
      ),
    );
  }

  Widget _getChildWidget() {
    if (isLoading == null || isLoading == false) {
      return Row(
        spacing: 5,
        mainAxisAlignment: MainAxisAlignment.center,
        children: children,
      );
    } else {
      return LoadingWidget();
    }
  }
}
