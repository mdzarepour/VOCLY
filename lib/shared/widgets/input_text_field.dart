import 'package:flutter/material.dart';
import 'package:vocly/shared/constants/const_colors.dart';
import 'package:vocly/shared/constants/const_strings.dart';
import 'package:vocly/shared/theme/app_text_theme.dart';

class InputTextField extends StatelessWidget {
  final String hint;
  final IconData icon;
  final TextEditingController controller;

  const InputTextField({
    super.key,
    required this.hint,
    required this.controller,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      cursorColor: ConstUiColors.thirdColor,
      style: AppTextTheme.titleMedium,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return "${UIStrings.pleaseEnter} $hint";
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        filled: true,
        fillColor: ConstUiColors.forthColor,
        hintText: hint,
        suffixIcon: Icon(icon, color: ConstUiColors.thirdColor),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          borderSide: BorderSide(
            color: ConstUiColors.backgroundColor2,
            width: 1,
          ),
        ),
        errorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          borderSide: BorderSide(color: ConstUiColors.errorColor, width: 1),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: ConstUiColors.thirdColor, width: 1),
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: ConstUiColors.thirdColor, width: 1),
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
      ),
    );
  }
}
