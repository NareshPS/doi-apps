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
              color: Colors.grey[500], letterSpacing: 1.35, height: 1.5),
          titleMedium: TextStyle(
              color: Colors.grey[600], letterSpacing: 1.0, height: 1.5),
          headlineSmall: TextStyle(
              fontSize: 18,
              color: lightColorScheme.secondary,
              letterSpacing: 1),
          headlineMedium: TextStyle(color: lightColorScheme.primary),
          labelLarge: TextStyle(
              color: Colors.grey[500],
              fontWeight: FontWeight.bold,
              letterSpacing: 1.35,
              height: 1.5),
          labelMedium: TextStyle(
              color: Colors.grey[500],
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0,
              height: 1.5),
          bodyMedium: TextStyle(
              fontSize: 16,
              color: lightColorScheme.secondary,
              letterSpacing: .6)));

  static ThemeData get darkTheme => ThemeData.from(
      colorScheme: darkColorScheme,
      textTheme: Typography.blackMountainView.copyWith(
          titleSmall: TextStyle(
              color: Colors.grey[500], letterSpacing: 1.35, height: 1.5),
          titleMedium: TextStyle(
              color: Colors.grey[600], letterSpacing: 1.0, height: 1.5),
          headlineSmall: TextStyle(
              fontSize: 18, color: darkColorScheme.secondary, letterSpacing: 1),
          headlineMedium: TextStyle(color: darkColorScheme.primary),
          labelLarge: TextStyle(
              color: Colors.grey[500],
              fontWeight: FontWeight.bold,
              letterSpacing: 1.35,
              height: 1.5),
          labelMedium: TextStyle(
              color: Colors.grey[500],
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0,
              height: 1.5),
          bodyMedium: TextStyle(
              fontSize: 16, color: darkColorScheme.secondary, letterSpacing: .6)
          // headlineSmall: TextStyle(color: lightColorScheme.secondary),
          // labelLarge: const TextStyle(
          //   color: Colors.grey,
          //   letterSpacing: .75,
          // ),
          // labelMedium: TextStyle(
          //   color: darkColorScheme.primary,
          //   fontWeight: FontWeight.bold,
          //   letterSpacing: .5,
          // ),
          ));
}
