import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// --- 1. DEFINISI KONSTANTA (Tambahan biar error undefined hilang) ---
const Color kPageBg = Color(0xFFF3F4F6);      // Abu-abu terang
const Color kDarkBg = Color(0xFF111827);      // Warna gelap (mirip Sidebar)
const Color kPrimaryColor = Colors.green;     // Warna Hijau Utama

// Gaya Text
final TextStyle kSubHeadingStyle = GoogleFonts.poppins(
  fontSize: 16,
  fontWeight: FontWeight.w600,
  color: Colors.black87,
);

final TextStyle kTitleStyle = GoogleFonts.poppins(
  fontSize: 22,
  fontWeight: FontWeight.bold,
  color: kDarkBg,
);
// ------------------------------------------------------------------

class HarvestScreen extends StatelessWidget {
  const HarvestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPageBg, // Menggunakan konstanta yang sudah didefinisikan
      appBar: AppBar(
        title: Text("Riwayat Panen", style: kSubHeadingStyle.copyWith(color: Colors.white)),
        backgroundColor: kDarkBg,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Header Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [kPrimaryColor, kPrimaryColor.withValues(alpha: 0.7)], // FIX: withValues pengganti withOpacity
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: kPrimaryColor.withValues(alpha: 0.3), // FIX: withValues
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                )
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2), // FIX: withValues
                    shape: BoxShape.circle,
                  ),
                  child: const FaIcon(FontAwesomeIcons.basketShopping, color: Colors.white, size: 30),
                ),
                const SizedBox(width: 15),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Total Panen", style: TextStyle(color: Colors.white, fontSize: 14)),
                    Text("125 kg", style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
                  ],
                )
              ],
            ),
          ),

          const SizedBox(height: 25),
          Text("Daftar Panen Terakhir", style: kTitleStyle),
          const SizedBox(height: 10),

          // List Panen Dummy
          _buildHarvestItem("Sawi Hijau", "12 Jan 2026", "5.2 kg", Colors.green),
          _buildHarvestItem("Selada Air", "10 Jan 2026", "3.1 kg", Colors.teal),
          _buildHarvestItem("Pakcoy", "05 Jan 2026", "4.8 kg", Colors.lightGreen),
        ],
      ),
    );
  }

  Widget _buildHarvestItem(String name, String date, String weight, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1), // FIX: withValues
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.grass, color: color),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: kSubHeadingStyle),
                  Text(date, style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                ],
              ),
            ],
          ),
          Text(
            weight,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}