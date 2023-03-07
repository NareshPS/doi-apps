import 'package:flutter/material.dart';

ColorScheme lightColorScheme = ColorScheme.fromSeed(
  seedColor: Colors.teal,
  brightness: Brightness.light,
  secondary: Colors.amber,
  tertiary: Colors.brown
);

ColorScheme darkColorScheme = ColorScheme.fromSeed(
  seedColor: Colors.teal,
  brightness: Brightness.dark,
  secondary: Colors.amber,
  tertiary: Colors.brown
);

class Themes {
  static ThemeData get lightTheme => ThemeData.from(
    colorScheme: lightColorScheme,

    textTheme: TextTheme(
      headlineSmall: TextStyle(
        color: lightColorScheme.secondary
      ),
      labelLarge: TextStyle(
        color: Colors.grey[700],
        letterSpacing: .75,
      ),
      labelMedium: TextStyle(
        color: lightColorScheme.primary,
        fontWeight: FontWeight.bold,
        letterSpacing: .5,
      ),
    )
  );

  static ThemeData get darkTheme => ThemeData.from(
    colorScheme: darkColorScheme,

    textTheme: TextTheme(
      headlineSmall: TextStyle(
        color: lightColorScheme.secondary
      ),
      labelLarge: const TextStyle(
        color: Colors.grey,
        letterSpacing: .75,
      ),
      labelMedium: TextStyle(
        color: darkColorScheme.primary,
        fontWeight: FontWeight.bold,
        letterSpacing: .5,
      ),
    )
  );
}