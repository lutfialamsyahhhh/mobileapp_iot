import 'dart:async';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'main_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Pindah ke MainScreen setelah 3 detik
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
      backgroundColor: Colors.green.shade50,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(FontAwesomeIcons.leaf, size: 80, color: Colors.green),
            const SizedBox(height: 20),
            Text(
              "TECH GREEN HOUSE",
              style: GoogleFonts.poppins(
                fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green[800]
              ),
            ),
            const SizedBox(height: 10),
            const CircularProgressIndicator(color: Colors.green),
          ],
        ),
      ),
    );
  }
}