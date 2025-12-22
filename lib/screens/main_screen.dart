import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:uas_iot/theme.dart';
// Import halaman-halaman
import 'package:uas_iot/screens/dashboard_screen.dart';
import 'package:uas_iot/screens/analytics_screen.dart';
import 'package:uas_iot/screens/watering_screen.dart';
import 'package:uas_iot/screens/harvest_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  // Daftar halaman yang akan ditampilkan
  final List<Widget> _pages = [
    const DashboardScreen(),
    const AnalyticsScreen(),
    const WateringScreen(),
    const HarvestScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Menampilkan halaman sesuai index yang dipilih
      body: _pages[_selectedIndex],

      // NAVIGASI BAWAH (Bottom Navigation Bar)
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: Colors.grey.shade800, width: 0.5),
          ),
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: kDarkBg, // Hitam (dari theme.dart)
          selectedItemColor: kPrimaryColor, // Hijau (dari theme.dart)
          unselectedItemColor: Colors.white54,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_rounded),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.chartLine),
              label: 'Analytics',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.water_drop),
              label: 'Watering',
            ),
            BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.wheatAwn),
              label: 'Harvest',
            ),
          ],
        ),
      ),
    );
  }
}
