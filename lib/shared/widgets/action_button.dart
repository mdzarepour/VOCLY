import 'package:flutter/material.dart';
import 'package:vocly/shared/widgets/card_widget.dart';

class ActionButton extends StatelessWidget {
  final void Function()? onTap;
  final Widget child;
  final Color borderColor;
  const ActionButton({
    super.key,
    required this.borderColor,
    required this.onTap,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: CardWidget(
          selectedBorderColor: borderColor,
          height: 70,
          child: child,
        ),
      ),
    );
  }
}
