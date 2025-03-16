import 'package:flutter/material.dart';

class AppTheme {
  // Light Theme
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: const Color(0xFF6EBF84),
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF6EBF84),
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black),
      bodyMedium: TextStyle(fontSize: 14, color: Colors.black54),
      titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
    ),
    iconTheme: const IconThemeData(color: Colors.black87),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: Color(0xFF6EBF84),
      unselectedItemColor: Colors.black45,
    ),
  );

  // Dark Theme
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: const Color(0xFF599F6C),
    scaffoldBackgroundColor: const Color(0xFF1E1E1E),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF599F6C),
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
      bodyMedium: TextStyle(fontSize: 14, color: Colors.white70),
      titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
    ),
    iconTheme: const IconThemeData(color: Colors.white70),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF2A2A2A),
      selectedItemColor: Color(0xFF6EBF84),
      unselectedItemColor: Colors.white54,
    ),
  );
}