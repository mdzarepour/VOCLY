import 'package:flutter/material.dart';
import 'package:vocly/core/constants/const_colors.dart';
import 'package:vocly/common/theme/app_text_theme.dart';
import 'package:vocly/common/widgets/card_widget.dart';

class InputWidget extends StatelessWidget {
  final String hint;
  final IconData icon;
  final TextEditingController controller;

  const InputWidget({
    super.key,
    required this.hint,
    required this.controller,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return CardWidget(
      height: 50,
      isHavePadding: false,
      child: TextFormField(
        controller: controller,
        cursorColor: ConstUiColors.thirdColor,
        style: AppTextTheme.titleMedium,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return "Please enter $hint";
          }
          return null;
        },
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(
          hintText: hint,
          suffixIcon: Icon(icon, color: ConstUiColors.thirdColor),
          enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
          errorBorder: OutlineInputBorder(borderSide: BorderSide.none),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: ConstUiColors.thirdColor, width: 1),
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: ConstUiColors.thirdColor, width: 1),
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
        ),
      ),
    );
  }
}
