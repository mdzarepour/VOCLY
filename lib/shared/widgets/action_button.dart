import 'package:flutter/material.dart';
import 'package:vocly/shared/widgets/card_widget.dart';

class ActionButton extends StatelessWidget {
  final void Function()? onTap;
  final List<Widget> children;
  final Color borderColor;
  const ActionButton({
    super.key,
    required this.borderColor,
    required this.onTap,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: CardWidget(
          selectedBorderColor: borderColor,
          height: 70,
          child: Row(
            spacing: 10,
            mainAxisAlignment: MainAxisAlignment.center,
            children: children,
          ),
        ),
      ),
    );
  }
}
