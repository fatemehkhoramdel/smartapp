import 'package:flutter/material.dart';
import 'package:security_alarm/core/utils/helper.dart';

import '../../core/constants/colors.dart';
import '../../core/constants/design_values.dart';

class AppThemes {
  static ThemeData get palette1 {
    return ThemeData(
      scaffoldBackgroundColor: kPalette1Colors[3],
      highlightColor: kPalette1Colors[1].withOpacity(0.6),
      fontFamily: kDefaultFont,
      appBarTheme: AppBarTheme(
        elevation: 0.0,
        backgroundColor: kPalette1Colors[3],
      ),
      tabBarTheme: TabBarTheme(
        labelStyle: styleGenerator(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          fontColor: kPalette1Colors[0],
        ),
      ),
      colorScheme: ColorScheme.light(
        primary: kPalette1Colors[0],
        secondary: kPalette1Colors[1],
        background: kPalette1Colors[3],
        surface: kPalette1Colors[2],
        onSurface: kPalette1Colors[4],
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: OutlinedButton.styleFrom(
          backgroundColor: kPalette1Colors[2],
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(kBorderRadius),
            ),
          ),
          elevation: 0,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(kBorderRadius),
            ),
          ),
          side: BorderSide(width: 3, color: kPalette1Colors[2]),
          elevation: 0,
        ),
      ),
    );
  }

  static ThemeData get palette2 {
    return ThemeData(
      scaffoldBackgroundColor: kPalette2Colors[3],
      highlightColor: kPalette2Colors[1].withOpacity(0.6),
      fontFamily: kDefaultFont,
      appBarTheme: AppBarTheme(
        elevation: 0.0,
        backgroundColor: kPalette2Colors[3],
      ),
      colorScheme: ColorScheme.light(
        primary: kPalette2Colors[0],
        secondary: kPalette2Colors[1],
        background: kPalette2Colors[3],
        surface: kPalette2Colors[2],
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: OutlinedButton.styleFrom(
          backgroundColor: kPalette2Colors[2],
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(kBorderRadius),
            ),
          ),
          elevation: 0,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(kBorderRadius),
            ),
          ),
          side: BorderSide(width: 3, color: kPalette2Colors[2]),
          elevation: 0,
        ),
      ),
    );
  }

  static ThemeData get palette3 {
    return ThemeData(
      scaffoldBackgroundColor: kPalette3Colors[3],
      highlightColor: kPalette3Colors[1].withOpacity(0.6),
      fontFamily: kDefaultFont,
      appBarTheme: AppBarTheme(
        elevation: 0.0,
        backgroundColor: kPalette3Colors[3],
      ),
      colorScheme: ColorScheme.light(
        primary: kPalette3Colors[0],
        secondary: kPalette3Colors[1],
        background: kPalette3Colors[3],
        surface: kPalette3Colors[2],
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: OutlinedButton.styleFrom(
          backgroundColor: kPalette3Colors[2],
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(kBorderRadius),
            ),
          ),
          elevation: 0,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(kBorderRadius),
            ),
          ),
          side: BorderSide(width: 3, color: kPalette3Colors[2]),
          elevation: 0,
        ),
      ),
    );
  }
}
