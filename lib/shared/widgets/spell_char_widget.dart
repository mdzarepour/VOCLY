import 'package:flutter/material.dart';
import 'package:vocly/shared/constants/const_colors.dart';
import 'package:vocly/shared/theme/app_text_theme.dart';
import 'package:vocly/shared/widgets/card_widget.dart';

class SpellCharWidget extends StatelessWidget {
  final void Function()? onTap;
  final bool? accuracy;
  final String char;

  const SpellCharWidget({
    super.key,
    required this.char,
    required this.onTap,
    this.accuracy,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: CardWidget(
        selectedBorderColor: _getSpellCharColor(accuracy: accuracy),
        isHavePadding: false,
        height: 45,
        width: 45,
        child: Center(child: Text(char, style: AppTextTheme.titleMedium)),
      ),
    );
  }

  Color _getSpellCharColor({required final bool? accuracy}) {
    switch (accuracy) {
      case false:
        {
          return ConstUiColors.errorColor;
        }
      case true:
        {
          return ConstUiColors.positiveColor;
        }
      default:
        {
          return ConstUiColors.thirdColor;
        }
    }
  }
}
