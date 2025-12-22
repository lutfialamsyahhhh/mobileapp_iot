import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// --- PALET WARNA (TETAP) ---
const Color kPrimaryColor = Color(0xFF4CAF50);
const Color kAccentColor = Color(0xFF76FF03);
const Color kDarkBg = Color(0xFF212121);
const Color kPageBg = Color(0xFFFAFAFA); // Putih yang lebih bersih
const Color kCardBg = Colors.white; // Card sebaiknya putih bersih di atas abu
const Color kTextBlack = Color(0xFF1A1A1A);
const Color kTextGrey = Color(0xFF9E9E9E);

// --- STYLE TAMBAHAN (UNTUK UI LEBIH MODERN) ---
// Bayangan halus ala iOS/Modern Android
final BoxShadow kSoftShadow = BoxShadow(
  color: Colors.black.withValues(alpha: 0.05), // Sangat transparan
  blurRadius: 15,
  offset: const Offset(0, 5),
);

// Style Border Radius yang konsisten
final BorderRadius kRadius = BorderRadius.circular(16);

// --- TEXT STYLES (Diperbarui Spacing-nya) ---
TextStyle kHeadingStyle = GoogleFonts.poppins(
  fontSize: 22, // Sedikit diperkecil agar elegan
  fontWeight: FontWeight.bold,
  color: kTextBlack,
  height: 1.2,
);

TextStyle kSubHeadingStyle = GoogleFonts.poppins(
  fontSize: 16,
  fontWeight: FontWeight.w600,
  color: kDarkBg,
);

TextStyle kSensorValueStyle = GoogleFonts.poppins(
  fontSize: 26, // Lebih besar sedikit
  fontWeight: FontWeight.bold,
  color: kTextBlack,
);

TextStyle kBodyStyle = GoogleFonts.poppins(
  fontSize: 12,
  fontWeight: FontWeight.w500,
  color: kTextGrey,
);
