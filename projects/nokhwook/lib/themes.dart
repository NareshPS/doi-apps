import 'package:flutter/material.dart';

ColorScheme lightColorScheme = ColorScheme.fromSeed(
  seedColor: Colors.red[400]!,
  primary: Colors.red[400]!,
  brightness: Brightness.light,
);

ColorScheme darkColorScheme = ColorScheme.fromSeed(
  seedColor: Colors.red[400]!,
  primary: Colors.red[400]!,
  brightness: Brightness.dark,
);

class Themes {
  static ThemeData get lightTheme => ThemeData.from(
      colorScheme: lightColorScheme,
      textTheme: Typography.blackMountainView.copyWith(
          titleSmall: TextStyle(
            color: Colors.grey[500],
            fontWeight: FontWeight.bold,
          ),
          titleMedium: TextStyle(color: Colors.grey[600]),
          titleLarge: TextStyle(color: lightColorScheme.secondary),
          headlineSmall: TextStyle(
            color: lightColorScheme.secondary,
          ),
          headlineMedium: TextStyle(color: lightColorScheme.primary),
          labelLarge: TextStyle(
            color: lightColorScheme.secondary.withValues(alpha: 0.85),
            fontWeight: FontWeight.bold,
          ),
          labelMedium: TextStyle(
            color: lightColorScheme.secondary.withValues(alpha: 0.85),
            fontWeight: FontWeight.bold,
          ),
          bodyMedium: TextStyle(
            color: lightColorScheme.secondary,
          ),
          bodyLarge: TextStyle(
            color: lightColorScheme.secondary,
          )));

  static ThemeData get darkTheme => ThemeData.from(
      colorScheme: darkColorScheme,
      textTheme: Typography.blackMountainView.copyWith(
          titleSmall: TextStyle(
            color: Colors.grey[500],
            fontWeight: FontWeight.bold,
          ),
          titleMedium: TextStyle(color: Colors.grey[600]),
          titleLarge: TextStyle(color: darkColorScheme.secondary),
          headlineSmall: TextStyle(
            color: darkColorScheme.secondary,
          ),
          headlineMedium: TextStyle(color: darkColorScheme.primary),
          labelLarge: TextStyle(
            color: darkColorScheme.secondary.withValues(alpha: 0.85),
            fontWeight: FontWeight.bold,
          ),
          labelMedium: TextStyle(
            color: darkColorScheme.secondary.withValues(alpha: 0.85),
            fontWeight: FontWeight.bold,
          ),
          bodyMedium: TextStyle(
            color: darkColorScheme.secondary,
          ),
          bodyLarge: TextStyle(
            color: darkColorScheme.secondary,
          )));
}
