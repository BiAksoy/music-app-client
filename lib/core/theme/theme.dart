import 'package:client/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static _border([Color color = AppColors.borderColor]) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: color,
          width: 3,
        ),
      );
  static final darkThemeMode = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: AppColors.backgroundColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.backgroundColor,
    ),
    chipTheme: ChipThemeData(
      color: WidgetStateProperty.all(AppColors.backgroundColor),
      side: BorderSide.none,
    ),
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.all(27),
      border: _border(),
      enabledBorder: _border(),
      focusedBorder: _border(AppColors.gradient2),
      errorBorder: _border(AppColors.errorColor),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.backgroundColor,
    ),
  );
}
