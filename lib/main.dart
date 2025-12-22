import 'package:flutter/material.dart';
import 'package:uas_iot/screens/splash_screen.dart';
import 'package:uas_iot/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner:
          false, // Menghilangkan pita 'Debug' di pojok kanan
      title: 'Smart Greenhouse',
      theme: ThemeData(
        // Mengatur warna utama aplikasi secara global
        primaryColor: kPrimaryColor,
        scaffoldBackgroundColor: kPageBg, // Background default abu-abu terang
        useMaterial3: true,
      ),
      // Arahkan home ke MainScreen yang baru kita buat
      home: const SplashScreen(),
    );
  }
}
