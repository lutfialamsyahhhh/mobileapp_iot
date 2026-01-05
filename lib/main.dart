import 'package:flutter/material.dart';
import 'theme.dart'; // Import file theme.dart kamu
import 'screens/main_screen.dart'; // Import MainScreen

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tech Green House',
      theme: appTheme, // Panggil tema dari theme.dart
      home: const MainScreen(), // Masuk ke MainScreen
    );
  }
}