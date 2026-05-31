import 'package:flutter/material.dart';
import 'package:vocly/common/widgets/card_widget.dart';
import 'package:vocly/core/constants/const_colors.dart';
import 'package:vocly/common/theme/app_text_theme.dart';

class FilterWidget extends StatelessWidget {
  final void Function() onTap;
  final String title;
  const FilterWidget({super.key, required this.onTap, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: InkWell(
        onTap: onTap,
        child: CardWidget(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(style: AppTextTheme.headlineSmall, title),
              SizedBox(width: 15),
              Icon(Icons.arrow_drop_down, color: ConstUiColors.thirdColor),
            ],
          ),
        ),
      ),
    );
  }
}
