import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dashboard_tab.dart';
import 'analytics_tab.dart';
import 'cctv_tab.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  // Daftar Halaman
  final List<Widget> _tabs = [
    const DashboardTab(),
    const AnalyticsTab(),
    const CctvTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF111827), // Warna Sidebar Web (Dark)
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const FaIcon(FontAwesomeIcons.leaf, color: Colors.green, size: 20),
            const SizedBox(width: 10),
            Text(
              'TECH GREEN HOUSE',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      // IndexedStack menjaga halaman tetap hidup saat pindah tab
      body: IndexedStack(
        index: _currentIndex,
        children: _tabs,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: FaIcon(FontAwesomeIcons.house),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: FaIcon(FontAwesomeIcons.chartLine),
            label: 'Grafik',
          ),
          NavigationDestination(
            icon: FaIcon(FontAwesomeIcons.video),
            label: 'CCTV',
          ),
        ],
      ),
    );
  }
}