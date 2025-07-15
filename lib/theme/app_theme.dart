import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final ThemeData moneyMapDarkTheme = ThemeData(
  brightness: Brightness.dark,
  primarySwatch: Colors.teal,
  appBarTheme: AppBarTheme(
    backgroundColor: Color(0xFF121212),
    elevation: 0,
    centerTitle: true,
    iconTheme: IconThemeData(color: Colors.white),
    surfaceTintColor: Colors.teal.withValues(alpha: 0.1),
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.w600,
    ),
  ),
  scaffoldBackgroundColor: const Color(0xFF121212),
  colorScheme: ColorScheme.dark(
    primary: const Color(0XFF58DEAC),
    secondary: Colors.tealAccent,
    surface: const Color(0xFF1E1E1E),
    onPrimary: Colors.white,
    onSecondary: Colors.black,
  ),
  textTheme: TextTheme(
    displayLarge: GoogleFonts.poppins(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    headlineMedium: GoogleFonts.inter(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      color: Colors.white70,
    ),
    titleMedium: GoogleFonts.inter(
      fontSize: 18,
      fontWeight: FontWeight.w500,
      color: Colors.white70,
    ),
    bodyLarge: GoogleFonts.openSans(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: Colors.white70,
    ),
    bodyMedium: GoogleFonts.openSans(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: Colors.white54,
    ),
    labelLarge: GoogleFonts.manrope(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: Colors.tealAccent,
    ),
    labelMedium: GoogleFonts.manrope(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: Colors.grey[400],
    ),
  ),
);
