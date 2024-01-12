import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/app_export.dart';

String _appTheme = "primary";

/// Helper class for managing themes and colors.
class ThemeHelper {
  // A map of custom color themes supported by the app
  Map<String, PrimaryColors> _supportedCustomColor = {
    'primary': PrimaryColors()
  };

// A map of color schemes supported by the app
  Map<String, ColorScheme> _supportedColorScheme = {
    'primary': ColorSchemes.primaryColorScheme
  };

  /// Changes the app theme to [_newTheme].
  void changeTheme(String _newTheme) {
    _appTheme = _newTheme;
  }

  /// Returns the primary colors for the current theme.
  PrimaryColors _getThemeColors() {
    //throw exception to notify given theme is not found or not generated by the generator
    if (!_supportedCustomColor.containsKey(_appTheme)) {
      throw Exception(
          "$_appTheme is not found.Make sure you have added this theme class in JSON Try running flutter pub run build_runner");
    }
    //return theme from map

    return _supportedCustomColor[_appTheme] ?? PrimaryColors();
  }

  /// Returns the current theme data.
  ThemeData _getThemeData() {
    //throw exception to notify given theme is not found or not generated by the generator
    if (!_supportedColorScheme.containsKey(_appTheme)) {
      throw Exception(
          "$_appTheme is not found.Make sure you have added this theme class in JSON Try running flutter pub run build_runner");
    }
    //return theme from map

    var colorScheme =
        _supportedColorScheme[_appTheme] ?? ColorSchemes.primaryColorScheme;
    return ThemeData(
      visualDensity: VisualDensity.standard,
      colorScheme: colorScheme,
      textTheme: TextThemes.textTheme(colorScheme),
      scaffoldBackgroundColor: colorScheme.onError.withOpacity(1),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.h),
          ),
          visualDensity: const VisualDensity(
            vertical: -4,
            horizontal: -4,
          ),
          padding: EdgeInsets.zero,
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateColor.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return colorScheme.primary;
          }
          return colorScheme.onSurface;
        }),
        side: BorderSide(
          width: 1,
        ),
        visualDensity: const VisualDensity(
          vertical: -4,
          horizontal: -4,
        ),
      ),
      dividerTheme: DividerThemeData(
        thickness: 2,
        space: 2,
        color: appTheme.gray70001,
      ),
    );
  }

  /// Returns the primary colors for the current theme.
  PrimaryColors themeColor() => _getThemeColors();

  /// Returns the current theme data.
  ThemeData themeData() => _getThemeData();
}

/// Class containing the supported text theme styles.
class TextThemes {
  static TextTheme textTheme(ColorScheme colorScheme) => TextTheme(
        bodyMedium: TextStyle(
          color: Color(0XFF524E4E),
          fontSize: 13.fSize,
          fontFamily: 'Outfit',
          fontWeight: FontWeight.w400,
        ),
        bodySmall: TextStyle(
          color: appTheme.black900,
          fontSize: 10.fSize,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w400,
        ),
        displayMedium: TextStyle(
          color: Color(0XFFDE7933),
          fontSize: 40.fSize,
          fontFamily: 'Outfit',
          fontWeight: FontWeight.w600,
        ),
        displaySmall: TextStyle(
          color: Color(0XFF5A7756),
          fontSize: 36.fSize,
          fontFamily: 'Outfit',
          fontWeight: FontWeight.w600,
        ),
        headlineLarge: TextStyle(
          color: appTheme.black900,
          fontSize: 32.fSize,
          fontFamily: 'Outfit',
          fontWeight: FontWeight.w700,
        ),
        headlineMedium: TextStyle(
          color: appTheme.gray700,
          fontSize: 28.fSize,
          fontFamily: 'Outfit',
          fontWeight: FontWeight.w700,
        ),
        headlineSmall: TextStyle(
          color: appTheme.gray700,
          fontSize: 24.fSize,
          fontFamily: 'Outfit',
          fontWeight: FontWeight.w500,
        ),
        labelLarge: TextStyle(
          color: appTheme.black900,
          fontSize: 12.fSize,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w600,
        ),
        titleLarge: TextStyle(
          color: appTheme.black900,
          fontSize: 20.fSize,
          fontFamily: 'Outfit',
          fontWeight: FontWeight.w700,
        ),
        titleMedium: TextStyle(
          color: appTheme.black900,
          fontSize: 16.fSize,
          fontFamily: 'Sora',
          fontWeight: FontWeight.w600,
        ),
        titleSmall: TextStyle(
          color: appTheme.black900,
          fontSize: 14.fSize,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w500,
        ),
      );
}

/// Class containing the supported color schemes.
class ColorSchemes {
  static final primaryColorScheme = ColorScheme.light(
    // Primary colors
    primary: Color(0XFFF6E9DB),
    primaryContainer: Color(0X14374151),
    secondaryContainer: Color(0XFFFFCD41),

    // Error colors
    errorContainer: Color(0XFFEDBA8E),
    onError: Color(0X7FFFFFFF),

    // On colors(text colors)
    onPrimary: Color(0XFF33363F),
    onPrimaryContainer: Color(0XFF080909),
    onSecondaryContainer: Color(0XFF222222),
  );
}

/// Class containing custom colors for a primary theme.
class PrimaryColors {
  // Black
  Color get black900 => Color(0XFF000000);

  // BlueGray
  Color get blueGray400 => Color(0XFF8792A2);
  Color get blueGray500 => Color(0XFF697386);

  // DeepOrange
  Color get deepOrange100 => Color(0XFFF8C5A1);

  // Gray
  Color get gray600 => Color(0XFF7C7A7A);
  Color get gray60001 => Color(0XFF808080);
  Color get gray60002 => Color(0XFF6C6C6C);
  Color get gray700 => Color(0XFF5A7756);
  Color get gray70001 => Color(0XFF636363);
  Color get gray800 => Color(0XFF524E4E);
  Color get gray900 => Color(0XFF231F20);

  // Indigo
  Color get indigo50 => Color(0XFFE3E8EE);

  // Purple
  Color get purple50 => Color(0XFFF8E5FF);

  // Red
  Color get red200 => Color(0XFFF8A0A0);

  // Yellow
  Color get yellow50 => Color(0XFFFFF6EB);
  Color get yellow5001 => Color(0XFFFFF5EB);
  Color get yellow900 => Color(0XFFDE7933);

  //Green
  Color get green_primary => Color(0xFF5A7756);
  Color get yellow_primary => Color(0xFFEDBA8E);
  Color get orange_primary => Color(0xFFDE7933);
  Color get yellow_secondary => Color(0xFFF6E9DB);
}

PrimaryColors get appTheme => ThemeHelper().themeColor();
ThemeData get theme => ThemeHelper().themeData();
