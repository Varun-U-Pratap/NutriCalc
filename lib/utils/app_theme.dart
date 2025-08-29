import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color _primaryColor = Color(0xFF6AF2A8);
  static const Color _lightText = Color(0xFF1A2E28);
  static const Color _darkText = Color(0xFFE0F5E9);
  static const Color _darkBackground = Color(0xFF121212);
  static const Color _darkSurface = Color(0xFF1E1E1E);

  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    textTheme: GoogleFonts.interTextTheme(ThemeData.light().textTheme).apply(bodyColor: _lightText, displayColor: _lightText),
    scaffoldBackgroundColor: const Color(0xFFF5F5F7),
    colorScheme: ColorScheme.fromSeed(
      seedColor: _primaryColor,
      brightness: Brightness.light,
      primary: _primaryColor,
      onPrimary: _lightText,
      background: const Color(0xFFF5F5F7),
      onBackground: _lightText,
      surface: Colors.white,
      onSurface: _lightText,
    ),
    cardTheme: CardThemeData(
      elevation: 1,
      color: Colors.white,
      shadowColor: Colors.black.withOpacity(0.05),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFFF5F5F7),
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: _lightText),
      titleTextStyle: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 20, color: _lightText),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: _primaryColor,
      foregroundColor: _lightText,
    ),
    useMaterial3: true,
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme).apply(bodyColor: _darkText, displayColor: _darkText),
    scaffoldBackgroundColor: _darkBackground,
    colorScheme: ColorScheme.fromSeed(
      seedColor: _primaryColor,
      brightness: Brightness.dark,
      primary: _primaryColor,
      onPrimary: _lightText,
      background: _darkBackground,
      onBackground: _darkText,
      surface: _darkSurface,
      onSurface: _darkText,
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      color: _darkSurface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: _darkBackground,
      elevation: 0,
      centerTitle: true,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: _primaryColor,
      foregroundColor: _lightText,
    ),
    useMaterial3: true,
  );
}