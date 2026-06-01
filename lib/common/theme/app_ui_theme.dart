import 'package:flutter/material.dart';
import 'package:vocly/common/constants/const_colors.dart';
import 'package:vocly/common/theme/app_text_theme.dart';

class AppUiTheme {
  AppUiTheme._();

  static ThemeData theme = ThemeData(
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    scaffoldBackgroundColor: ConstUiColors.backgroundColor,
    dividerTheme: DividerThemeData(
      radius: BorderRadius.all(Radius.circular(100)),
      color: ConstUiColors.backgroundColor2,
    ),
    appBarTheme: appbarTheme(),
    inputDecorationTheme: inputTheme(),
    iconTheme: iconTheme(),
    tabBarTheme: tabbraTheme(),
    popupMenuTheme: popupMenuTheme(),
  );

  static PopupMenuThemeData popupMenuTheme() {
    return PopupMenuThemeData(
      menuPadding: EdgeInsets.all(0),
      shadowColor: Colors.transparent,
      color: ConstUiColors.thirdColor,
    );
  }

  static TabBarThemeData tabbraTheme() {
    return TabBarThemeData(
      indicatorSize: TabBarIndicatorSize.label,
      unselectedLabelColor: ConstUiColors.thirdColor,
      splashFactory: NoSplash.splashFactory,
      labelColor: ConstUiColors.thirdColor,
      dividerColor: ConstUiColors.backgroundColor2,
      indicatorColor: ConstUiColors.thirdColor,
      tabAlignment: TabAlignment.start,
    );
  }

  static AppBarThemeData appbarTheme() {
    return AppBarThemeData(
      toolbarHeight: 70,
      scrolledUnderElevation: 0,
      centerTitle: true,
      titleSpacing: 0,
      iconTheme: IconThemeData(color: ConstUiColors.thirdColor, size: 22),
      backgroundColor: ConstUiColors.backgroundColor,
    );
  }

  static IconThemeData iconTheme() {
    return IconThemeData(size: 20, color: ConstUiColors.thirdColor);
  }

  static InputDecorationThemeData inputTheme() {
    return InputDecorationThemeData(
      hintStyle: AppTextTheme.titleMedium,
      errorStyle: AppTextTheme.bodyMedium.copyWith(
        color: ConstUiColors.thirdColor,
        fontSize: 12,
      ),
      border: OutlineInputBorder(borderSide: BorderSide.none),
      suffixIconColor: ConstUiColors.thirdColor,
    );
  }
}
