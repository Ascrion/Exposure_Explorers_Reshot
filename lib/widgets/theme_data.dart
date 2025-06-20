import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

// Custom Theme: Custom colors and text
final ThemeData customTheme = ThemeData(

  colorScheme: ColorScheme(
    primary: Color(0xFF0C0C0C),
    onPrimary: Colors.white70, // content such as text sitting on top of the primary color
    brightness: Brightness.dark,
    secondary: Color(0xFFFF7A00),
    secondaryFixed: Color.fromARGB(255, 123, 60, 0),
    secondaryFixedDim: Color.fromARGB(255, 65, 34, 6),
    onSecondary: Colors.white,
    tertiary: Color(0xFF2E2E2E), // Subtle surface circle
    onTertiary: Colors.white,
    surface: Color.fromARGB(235, 29, 29, 29), //  Background of cards and menus that sit on top of app background
    onSurface: Color.fromARGB(255, 22, 22, 22),
    surfaceContainerHighest: Color(0xFF1A1A1A), //	Highest-level surface layer (used in Material 3 elevations).
    onSurfaceVariant: Color(0xFFB0B0B0), //Variant for nested or less prominent surfaces (dividers)
    error: Colors.red,
    onError: Colors.white,
    outline: Colors.orangeAccent,
  ),

textTheme: TextTheme(
  headlineLarge: GoogleFonts.playfairDisplay().copyWith(
    fontSize: 50,
    fontWeight: FontWeight.w700,
    letterSpacing: 1.5,
    fontFamilyFallback: ['NotoSans'], // fallback
  ),
  labelLarge: GoogleFonts.lora().copyWith(
    fontSize: 25,
    fontWeight: FontWeight.w400,
    height: 1.5,
    fontFamilyFallback: ['NotoSans'],
  ),
  labelMedium: GoogleFonts.lora().copyWith(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    height: 1.5,
    fontFamilyFallback: ['NotoSans'],
  ),
  bodyMedium: GoogleFonts.lora().copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
    fontFamilyFallback: ['NotoSans'],
  ),
),


);
