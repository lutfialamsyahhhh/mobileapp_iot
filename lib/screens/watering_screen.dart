import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:uas_iot/theme.dart';

class WateringScreen extends StatefulWidget {
  const WateringScreen({super.key});

  @override
  State<WateringScreen> createState() => _WateringScreenState();
}

class _WateringScreenState extends State<WateringScreen> {
  // Variabel status: Apakah sedang menyiram atau tidak?
  bool _isWatering = false;

  // Fungsi yang dijalankan saat tombol ditekan
  void _handleWatering() async {
    setState(() {
      _isWatering = true; // Ubah status jadi 'Sedang Menyiram'
    });

    // SIMULASI KONEKSI IOT (Tunda 3 detik seolah-olah kirim data ke alat)
    await Future.delayed(const Duration(seconds: 3));

    // Jika halaman masih terbuka, kembalikan status dan beri notifikasi
    if (mounted) {
      setState(() {
        _isWatering = false; // Selesai menyiram
      });

      // Munculkan pesan sukses di bawah layar (SnackBar)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Perintah Terkirim: Pompa Air MENYALA! 🌊"),
          backgroundColor: kPrimaryColor,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPageBg,
      // SafeArea agar tidak tertutup poni HP/Status Bar
      body: SafeArea(
        child: Column(
          children: [
            // =========================================
            // 1. AREA KAMERA (LIVE VIEW)
            // =========================================
            Expanded(
              flex: 3, // Mengambil 3/4 porsi layar
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.black87, // Background hitam ala layar CCTV
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(
                        alpha: 0.2,
                      ), // Fix deprecated
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    // Placeholder Tampilan Kamera
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.videocam_off_outlined,
                            size: 60,
                            color: Colors.grey.shade700,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "Tampilan Live Tanaman",
                            style: kBodyStyle.copyWith(color: Colors.grey),
                          ),
                          const SizedBox(height: 5),
                          const Text(
                            "(Sambungkan ke ESP32-CAM)",
                            style: TextStyle(fontSize: 10, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),

                    // Label "LIVE" di pojok kiri atas
                    Positioned(
                      top: 15,
                      left: 15,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.redAccent.withValues(alpha: 0.8),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: const Text(
                          "LIVE",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // =========================================
            // 2. PANEL KONTROL (BAWAH)
            // =========================================
            Expanded(
              flex: 1, // Mengambil 1/4 porsi layar
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Judul Panel
                    Text("Kontrol Penyiraman Manual", style: kSubHeadingStyle),
                    const SizedBox(height: 15),

                    // TOMBOL WATERING BESAR
                    SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: ElevatedButton(
                        onPressed: _isWatering
                            ? null
                            : _handleWatering, // Disable jika sedang menyiram
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Colors.lightBlueAccent, // Warna biru air
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: _isWatering
                              ? 0
                              : 5, // Hilangkan bayangan saat ditekan
                        ),
                        child: _isWatering
                            ? const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    "Sedang Menyiram...",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Ikon Tetesan Air
                                  const Icon(
                                    FontAwesomeIcons.droplet,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    "WATERING NOW",
                                    style: kHeadingStyle.copyWith(
                                      color: Colors.white,
                                      fontSize: 18,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  // Hiasan tetesan air kecil sesuai desain
                                  const Icon(
                                    Icons.water_drop,
                                    size: 15,
                                    color: Colors.white70,
                                  ),
                                  const Icon(
                                    Icons.water_drop,
                                    size: 20,
                                    color: Colors.white,
                                  ),
                                  const Icon(
                                    Icons.water_drop,
                                    size: 15,
                                    color: Colors.white70,
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
