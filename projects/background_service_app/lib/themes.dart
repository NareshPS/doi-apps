import 'package:flutter/material.dart';

class CustomTheme {
  static ThemeData get lightTheme => ThemeData.from(
    colorScheme: const ColorScheme.light(
      primary: Colors.teal,
      secondary: Colors.lightGreen,
      background: Colors.white,
    ),

    textTheme: const TextTheme(
      titleLarge: TextStyle(color: Colors.black),
      displayLarge: TextStyle(color: Colors.black),
      displayMedium: TextStyle(color: Colors.black),
      displaySmall: TextStyle(color: Colors.black),
      bodyLarge: TextStyle(color: Colors.black),
      bodyMedium: TextStyle(color: Colors.black),
      bodySmall: TextStyle(color: Colors.black),
    )
  );

  static ThemeData get darkTheme => ThemeData.from(
    colorScheme: const ColorScheme.light(
      // secondary: Colors.redAccent,
      background: Colors.grey
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(color: Colors.white),
      displayMedium: TextStyle(color: Colors.white),
      displaySmall: TextStyle(color: Colors.white),
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white),
      bodySmall: TextStyle(color: Colors.white),
    )
  );
}