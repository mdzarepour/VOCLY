import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vocly/common/constants/const_colors.dart';

class AppTextTheme {
  AppTextTheme._();

  static TextStyle _base({
    required double fontSize,
    required FontWeight fontWeight,
    required Color color,
    double height = 1.2,
    double letterSpacing = 0.0,
  }) {
    return GoogleFonts.roboto(
      textStyle: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        height: height,
        letterSpacing: letterSpacing,
        color: color,
      ),
    );
  }

  static TextStyle displayLarge = _base(
    fontSize: 32,
    fontWeight: FontWeight.w400,
    color: ConstUiColors.thirdColor,
    height: 1.0,
    letterSpacing: 0.5,
  );

  static TextStyle displayMedium = _base(
    fontSize: 25,
    fontWeight: FontWeight.w400,
    color: ConstUiColors.thirdColor,
    height: 1.0,
  );

  static TextStyle displaySmall = _base(
    fontSize: 20,
    fontWeight: FontWeight.w400,
    color: ConstUiColors.thirdColor,
    height: 1.1,
  );

  static TextStyle headlineSmall = _base(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: ConstUiColors.thirdColor,
    height: 1.2,
  );

  static TextStyle titleLarge = _base(
    fontSize: 22,
    fontWeight: FontWeight.w400,
    color: ConstUiColors.thirdColor,
    height: 1.2,
  );

  static TextStyle titleMedium = _base(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    color: ConstUiColors.thirdColor,
    height: 1.3,
    letterSpacing: 0.15,
  );

  static TextStyle titleSmall = _base(
    fontSize: 13,
    fontWeight: FontWeight.w300,
    color: ConstUiColors.thirdColor,
    height: 1.4,
    letterSpacing: 0.1,
  );


  static TextStyle bodyLarge = _base(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: ConstUiColors.thirdColor,
    height: 1.5,
    letterSpacing: 0.5,
  );

  static TextStyle bodyMedium = _base(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: ConstUiColors.thirdColor,
    height: 1.4,
    letterSpacing: 0.25,
  );

  static TextStyle bodySmall = _base(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: ConstUiColors.thirdColor,
    height: 1.3,
    letterSpacing: 0.4,
  );


  static TextStyle labelLarge = _base(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: ConstUiColors.forthColor,
    height: 1.2,
    letterSpacing: 0.1,
  );

  static TextStyle labelMedium = _base(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: ConstUiColors.forthColor,
    height: 1.2,
    letterSpacing: 0.5,
  );

  static TextStyle labelSmall = _base(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: ConstUiColors.forthColor,
    height: 1.2,
    letterSpacing: 0.5,
  );
}
