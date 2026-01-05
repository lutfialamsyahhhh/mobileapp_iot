import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:uas_iot/theme.dart';
import 'package:uas_iot/services/api_service.dart';

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
    // 1. Cegah tombol ditekan dua kali saat sedang proses
    if (_isWatering) return;

    setState(() {
      _isWatering = true; // Ubah status tombol jadi loading
    });

    // 2. KIRIM PERINTAH "ON" KE BACKEND
    // Parameter "pompa" harus sesuai dengan yang didengar oleh ESP32 via MQTT
    bool success = await ApiService.controlDevice("pompa", "ON");

    // 3. LOGIKA JIKA SUKSES / GAGAL
    if (success) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text("Menyiram... Pompa ON 🌊"),
            backgroundColor: kPrimaryColor,
            duration: const Duration(seconds: 2),
          ),
        );
      }

      // Biarkan menyiram selama 3 detik (Simulasi Durasi)
      await Future.delayed(const Duration(seconds: 3));

      // 4. KIRIM PERINTAH "OFF" (Otomatis matikan)
      await ApiService.controlDevice("pompa", "OFF");

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Selesai. Pompa OFF."),
            backgroundColor: Colors.grey,
            duration: Duration(seconds: 1),
          ),
        );
      }
    } else {
      // Jika gagal connect ke Flask
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Gagal: Tidak dapat terhubung ke Server ❌"),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }

    // Kembalikan status tombol
    if (mounted) {
      setState(() {
        _isWatering = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPageBg,
      body: SafeArea(
        child: Column(
          children: [
            // =========================================
            // 1. AREA KAMERA (LIVE VIEW - Placeholder)
            // =========================================
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(
                        0.2,
                      ), // Gunakan withOpacity
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
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
                            "(ESP32-CAM Not Connected)",
                            style: TextStyle(fontSize: 10, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    // Badge "LIVE"
                    Positioned(
                      top: 15,
                      left: 15,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.redAccent.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.circle, size: 8, color: Colors.white),
                            SizedBox(width: 5),
                            Text(
                              "LIVE",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ],
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
              flex: 1,
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
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Kontrol Penyiraman Manual", style: kSubHeadingStyle),
                    const SizedBox(height: 15),
                    SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: ElevatedButton(
                        onPressed: _isWatering ? null : _handleWatering,
                        style: ElevatedButton.styleFrom(
                          // Warna berubah jika sedang loading
                          backgroundColor: _isWatering
                              ? Colors.grey
                              : Colors.lightBlueAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: _isWatering ? 0 : 5,
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
                                      strokeWidth: 2,
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
