import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Konfigurasi Tema Aplikasi
final ThemeData appTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
  textTheme: GoogleFonts.poppinsTextTheme(), // Menggunakan Font Poppins
  scaffoldBackgroundColor: Colors.grey[100],
  appBarTheme: const AppBarTheme(
    iconTheme: IconThemeData(color: Colors.white),
  ),
);