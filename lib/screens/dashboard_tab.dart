import 'dart:async';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import '../services/api_service.dart';

class DashboardTab extends StatefulWidget {
  const DashboardTab({super.key});

  @override
  State<DashboardTab> createState() => _DashboardTabState();
}

class _DashboardTabState extends State<DashboardTab> {
  Timer? _timer;
  String _currentTime = "";
  
  // Data Sensor Default
  String suhu = "0";
  String hum = "0";
  String light = "0";
  String soil = "0";
  String pumpStatus = "OFF";
  bool isOnline = false;
  bool isLoadingAction = false;

  @override
  void initState() {
    super.initState();
    _updateTime();
    _fetchData();
    // Polling data setiap 3 detik
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      _fetchData();
      _updateTime();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _updateTime() {
    if (!mounted) return;
    final now = DateTime.now();
    setState(() {
      _currentTime = DateFormat('dd/MM/yyyy HH:mm').format(now);
    });
  }

  Future<void> _fetchData() async {
    final data = await ApiService.fetchSensors();
    if (mounted) {
      setState(() {
        if (data.isNotEmpty) {
          suhu = data['suhu'].toString();
          hum = data['kelembapan_udara'].toString();
          light = data['cahaya'].toString();
          soil = data['kelembapan_tanah'].toString();
          pumpStatus = (data['status_pompa'] ?? "OFF").toUpperCase();
          isOnline = true;
        } else {
          isOnline = false;
        }
      });
    }
  }

  Future<void> _togglePump() async {
    setState(() => isLoadingAction = true);
    
    String action = (pumpStatus == "ON") ? "OFF" : "ON";
    bool success = await ApiService.controlDevice("pompa", action);
    
    // [FIX 1] Cek apakah widget masih ada di layar sebelum pakai context
    if (!mounted) return;

    if (success) {
      // Optimistic update agar UI terasa cepat
      setState(() {
        pumpStatus = action;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Berhasil mengubah pompa ke $action")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Gagal menghubungi server")),
      );
    }
    
    setState(() => isLoadingAction = false);
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Status Bar & Date
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(_currentTime, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              Row(
                children: [
                  Icon(Icons.circle, size: 10, color: isOnline ? Colors.green : Colors.red),
                  const SizedBox(width: 5),
                  Text(isOnline ? "ONLINE" : "OFFLINE", 
                    style: TextStyle(
                      color: isOnline ? Colors.green : Colors.red, 
                      fontWeight: FontWeight.bold, fontSize: 12
                    )
                  ),
                ],
              )
            ],
          ),
        ),
        
        const SizedBox(height: 20),
        
        // Header Dashboard
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Monitor Green House", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Text("Data Realtime ESP32", style: TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300)
              ),
              child: Column(
                children: [
                  const Text("POMPA", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey)),
                  Text(pumpStatus, 
                    style: TextStyle(
                      fontSize: 14, 
                      fontWeight: FontWeight.bold, 
                      color: pumpStatus == "ON" ? Colors.green : Colors.grey
                    )
                  ),
                ],
              ),
            )
          ],
        ),

        const SizedBox(height: 20),

        // Grid Sensor Cards
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.4,
          children: [
            _buildSensorCard("Suhu Udara", suhu, "°C", Colors.blue, FontAwesomeIcons.temperatureHalf),
            _buildSensorCard("Kelembapan", hum, "%", Colors.teal, FontAwesomeIcons.droplet),
            _buildSensorCard("Cahaya", light, "Lux", Colors.orange, FontAwesomeIcons.sun),
            _buildSensorCard("Tanah", soil, "", Colors.brown, FontAwesomeIcons.seedling),
          ],
        ),

        const SizedBox(height: 20),

        // Tombol Kontrol Pompa Besar
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: pumpStatus == "ON" 
                  ? [Colors.red.shade400, Colors.red.shade700] // Merah jika ON
                  : [Colors.blue.shade400, Colors.blue.shade700], // Biru jika OFF
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              // [FIX 2] Ganti withOpacity jadi withValues
              BoxShadow(
                color: Colors.blue.withValues(alpha: 0.3), 
                blurRadius: 10, 
                offset: const Offset(0, 5)
              )
            ]
          ),
          child: Column(
            children: [
              const FaIcon(FontAwesomeIcons.faucetDrip, color: Colors.white, size: 40),
              const SizedBox(height: 10),
              const Text("Kontrol Penyiraman Manual", 
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)
              ),
              const SizedBox(height: 4),
              const Text("Tekan tombol di bawah untuk mengubah status pompa.", 
                style: TextStyle(color: Colors.white70, fontSize: 12), textAlign: TextAlign.center
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: isLoadingAction ? null : _togglePump,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: pumpStatus == "ON" ? Colors.red : Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  icon: isLoadingAction 
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)) 
                    : Icon(pumpStatus == "ON" ? Icons.stop_circle : Icons.power_settings_new),
                  label: Text(
                    isLoadingAction ? "MEMPROSES..." : (pumpStatus == "ON" ? "MATIKAN POMPA" : "NYALAKAN POMPA"),
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSensorCard(String title, String value, String unit, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        // [FIX 3] Ganti withOpacity jadi withValues
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: 24),
              Text(unit, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value, style: TextStyle(color: color, fontSize: 28, fontWeight: FontWeight.bold)),
              // [FIX 4] Ganti withOpacity jadi withValues
              Text(title, style: TextStyle(color: color.withValues(alpha: 0.8), fontSize: 12)),
            ],
          )
        ],
      ),
    );
  }
}