import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class AppTheme {
  static final lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.black),
      titleTextStyle: TextStyle(
        color: Colors.black,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    cardColor: Colors.white,
  );

  static final darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: Colors.black,
    scaffoldBackgroundColor: Color(0xFF121212),
    appBarTheme: AppBarTheme(
      backgroundColor: Color(0xFF121212),
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    cardColor: Colors.black,
    textTheme: TextTheme(
      bodyLarge: TextStyle(
        color: Colors.white,
      ),
      bodyMedium: TextStyle(
        color: Colors.white,
      ),
      bodySmall: TextStyle(
        color: Colors.white,
      ),
      titleLarge: TextStyle(
        color: Colors.white,
      ),
      titleMedium: TextStyle(
        color: Colors.white,
      ),
      titleSmall: TextStyle(
        color: Colors.white,
      ),
      displayLarge: TextStyle(
        color: Colors.white,
      ),
      displayMedium: TextStyle(
        color: Colors.white,
      ),
      displaySmall: TextStyle(
        color: Colors.white,
      ),
      headlineLarge: TextStyle(
        color: Colors.white,
      ),
      headlineMedium: TextStyle(
        color: Colors.white,
      ),
      headlineSmall: TextStyle(
        color: Colors.white,
      ),
    ),  
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: Colors.white,
        ),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(AppColors.primary),
      ),
    ),  
    
  );
}
