import 'package:flutter/material.dart';
import 'dart:async'; // Library untuk Timer (waktu tunggu)
import 'package:uas_iot/theme.dart';
import 'package:uas_iot/screens/main_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Setting Timer: Setelah 3 detik, pindah ke MainScreen
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPageBg, // Bisa diganti kDarkBg jika ingin tema gelap
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // =========================================
            // 1. LOGO APLIKASI
            // =========================================
            // Menggunakan logo gambar saja (Container icon dihapus)
            Image.asset(
              'assets/images/logo.jpg', // Pastikan nama file sesuai (jpg/png)
              width: 150, // Ukuran logo
              height: 150,
            ),

            const SizedBox(height: 20),

            // =========================================
            // 2. JUDUL APLIKASI
            // =========================================
            Text(
              "Smart Greenhouse",
              style: kHeadingStyle.copyWith(
                fontSize: 24,
                color: kDarkBg,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Text("Monitoring & Control System", style: kBodyStyle),

            const SizedBox(height: 50),

            // =========================================
            // 3. LOADING INDICATOR
            // =========================================
            CircularProgressIndicator(color: kPrimaryColor),
          ],
        ),
      ),
    );
  }
}
