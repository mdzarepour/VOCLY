import 'package:flutter/material.dart';
import 'package:vocly/shared/theme/app_text_theme.dart';
import 'package:vocly/shared/widgets/card_widget.dart';

class FilterButton extends StatelessWidget {
  final String title;
  final void Function() onTap;
  const FilterButton({super.key, required this.onTap, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: InkWell(
        onTap: onTap,
        child: CardWidget(
          child: Row(
            children: [
              Text(style: AppTextTheme.bodySmall, title),
              Icon(Icons.arrow_drop_down),
            ],
          ),
        ),
      ),
    );
  }
}
