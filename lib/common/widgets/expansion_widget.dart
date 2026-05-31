import 'package:flutter/material.dart';
import 'package:vocly/common/theme/app_text_theme.dart';
import 'package:vocly/common/widgets/card_widget.dart';

class ExpansionWidget extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final void Function(bool)? onExpansionChanged;

  const ExpansionWidget({
    super.key,
    this.onExpansionChanged,
    required this.children,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return CardWidget(
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          onExpansionChanged: onExpansionChanged,
          dense: true,
          minTileHeight: 50,
          showTrailingIcon: false,
          splashColor: Colors.transparent,
          childrenPadding: EdgeInsets.only(bottom: 30),
          title: Center(child: Text(title, style: AppTextTheme.titleMedium)),
          children: children,
        ),
      ),
    );
  }
}
