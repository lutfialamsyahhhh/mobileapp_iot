import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../services/api_service.dart';

// --- DEFINISI KONSTANTA WARNA & FONT ---
const Color kPrimaryColor = Colors.blue;      // Warna utama biru (air)
const Color kPageBg = Color(0xFFF3F4F6);      // Background abu terang
const Color kCardBg = Colors.white;

final TextStyle kHeadingStyle = GoogleFonts.poppins(
  fontSize: 24,
  fontWeight: FontWeight.bold,
  color: Colors.black87,
);

final TextStyle kSubHeadingStyle = GoogleFonts.poppins(
  fontSize: 16,
  fontWeight: FontWeight.w600,
  color: Colors.black87,
);

final TextStyle kBodyStyle = GoogleFonts.poppins(
  fontSize: 14,
  color: Colors.grey[600],
);
// ------------------------------------------

class WateringScreen extends StatefulWidget {
  const WateringScreen({super.key});

  @override
  State<WateringScreen> createState() => _WateringScreenState();
}

class _WateringScreenState extends State<WateringScreen> {
  String pumpStatus = "OFF";
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchStatus();
  }

  // Ambil status awal
  Future<void> _fetchStatus() async {
    final data = await ApiService.fetchSensors();
    if (mounted && data.isNotEmpty) {
      setState(() {
        pumpStatus = (data['status_pompa'] ?? "OFF").toUpperCase();
      });
    }
  }

  // Fungsi Tombol Pompa
  Future<void> _togglePump() async {
    setState(() => isLoading = true);
    
    String action = (pumpStatus == "ON") ? "OFF" : "ON";
    bool success = await ApiService.controlDevice("pompa", action);
    
    if (success) {
      setState(() {
        pumpStatus = action;
      });
      if(mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Berhasil mengubah pompa ke $action")),
        );
      }
    } else {
      if(mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Gagal menghubungi server")),
        );
      }
    }
    
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    bool isPumpOn = pumpStatus == "ON";

    return Scaffold(
      backgroundColor: kPageBg,
      appBar: AppBar(
        title: Text("Kontrol Penyiraman", style: kSubHeadingStyle.copyWith(color: Colors.white)),
        backgroundColor: Colors.blue.shade800,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Card Utama
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: isPumpOn ? Colors.blue.shade600 : Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withValues(alpha: 0.2), 
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  )
                ],
              ),
              child: Column(
                children: [
                  FaIcon(
                    isPumpOn ? FontAwesomeIcons.faucetDrip : FontAwesomeIcons.faucet,
                    size: 50,
                    color: isPumpOn ? Colors.white : Colors.blue.shade300,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    isPumpOn ? "POMPA MENYALA" : "POMPA MATI",
                    style: kHeadingStyle.copyWith(
                      color: isPumpOn ? Colors.white : Colors.grey[800]
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isPumpOn ? "Sedang menyiram tanaman..." : "Sistem dalam mode siaga",
                    style: kBodyStyle.copyWith(
                      color: isPumpOn ? Colors.white70 : Colors.grey[500]
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Tombol Aksi Besar
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton.icon(
                onPressed: isLoading ? null : _togglePump,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isPumpOn ? Colors.red : Colors.blue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 5,
                ),
                icon: isLoading 
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : Icon(isPumpOn ? Icons.stop_circle_outlined : Icons.power_settings_new),
                label: Text(
                  isLoading ? "MEMPROSES..." : (isPumpOn ? "MATIKAN SEKARANG" : "NYALAKAN SEKARANG"),
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Info Jadwal (Statis/Dummy dulu)
            Text("Jadwal Otomatis", style: kSubHeadingStyle),
            const SizedBox(height: 12),
            _buildScheduleItem("Pagi", "07:00 WIB", true),
            _buildScheduleItem("Sore", "16:00 WIB", true),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleItem(String label, String time, bool isActive) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: kCardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.access_time_filled, color: Colors.blue.shade300),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: kSubHeadingStyle),
                  Text(time, style: kBodyStyle),
                ],
              ),
            ],
          ),
          Switch(
            value: isActive,
            activeTrackColor: Colors.blue, // FIX: Mengganti activeColor jadi activeTrackColor
            onChanged: (val) {}, 
          )
        ],
      ),
    );
  }
}