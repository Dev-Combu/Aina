import 'package:flutter/material.dart';

class AppTheme {
  // Primary color used across the app (e.g., for date picker accent)
  static const Color primary = Colors.indigo;

  static final ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: const Color(0xFFF9F6F0), // Warm beige
    useMaterial3: true,
    fontFamily: 'Pretendard', // Assuming a clean font, can be omitted if not imported
    colorScheme: ColorScheme.light(
      primary: primary,
      onPrimary: Colors.white,
    ),
  );
}
