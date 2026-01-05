import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:uas_iot/theme.dart';
import 'package:uas_iot/services/api_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // 1. Variabel Data UI
  String temp = "0";
  String soilMoist = "0";
  String airHum = "0";
  String pumpStatus = "OFF";
  String lux = "0";

  // 2. Variabel untuk Grafik (Realtime)
  List<FlSpot> historyData = []; // Menyimpan riwayat suhu
  double timeIndex = 0; // Sumbu X (Waktu berjalan)

  Timer? _timer;

  @override
  void initState() {
    super.initState();

    // Inisialisasi grafik kosong agar tidak error
    historyData.add(const FlSpot(0, 0));

    _getData();

    // Refresh otomatis setiap 2 detik
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      _getData();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // 3. Fungsi Ambil Data & Update Grafik
  Future<void> _getData() async {
    try {
      final data = await ApiService.fetchSensors();

      if (data.isEmpty) return;

      if (mounted) {
        setState(() {
          // --- Update Kartu Sensor ---
          // Menggunakan teknik '??' agar tidak crash jika data null
          double suhuAsli = double.tryParse(data['suhu'].toString()) ?? 0.0;

          temp = suhuAsli.toString();
          soilMoist = (data['kelembapan_tanah'] ?? 0).toString();
          airHum = (data['kelembapan_udara'] ?? 0).toString();
          pumpStatus = (data['status_pompa'] ?? "OFF").toString();
          lux = (data['cahaya'] ?? 0).toString();

          // --- Update Grafik Realtime ---
          timeIndex++;
          // Masukkan data suhu terbaru ke grafik
          historyData.add(FlSpot(timeIndex, suhuAsli));

          // Agar grafik tidak menumpuk, kita hanya simpan 10 data terakhir
          if (historyData.length > 10) {
            historyData.removeAt(0);
          }
        });
      }
    } catch (e) {
      print("Error update dashboard: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPageBg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 20),

              // GRID SENSOR
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: 1.1,
                children: [
                  _buildSensorCard(
                    title: "Soil Moist",
                    value: soilMoist,
                    unit: "%",
                    icon: Icons.grass,
                    color: Colors.brown,
                  ),
                  _buildSensorCard(
                    title: "Air Hum",
                    value: airHum,
                    unit: "%",
                    icon: Icons.cloud,
                    color: Colors.blueAccent,
                  ),
                  _buildSensorCard(
                    title: "Temp",
                    value: "$temp°",
                    unit: "Celcius",
                    icon: FontAwesomeIcons.temperatureThreeQuarters,
                    color: Colors.redAccent,
                  ),
                  _buildSensorCard(
                    title: "Light",
                    value: lux,
                    unit: "Lux",
                    icon: Icons.wb_sunny,
                    color: Colors.orangeAccent,
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // STATUS POMPA
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: pumpStatus == "ON"
                      ? Colors.green.withOpacity(0.1)
                      : Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: pumpStatus == "ON" ? Colors.green : Colors.red,
                    width: 2,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Status Pompa Air", style: kSubHeadingStyle),
                        const SizedBox(height: 5),
                        Text(
                          pumpStatus,
                          style: kHeadingStyle.copyWith(
                            color: pumpStatus == "ON"
                                ? Colors.green
                                : Colors.red,
                            fontSize: 24,
                          ),
                        ),
                      ],
                    ),
                    Icon(
                      Icons.water_drop,
                      size: 40,
                      color: pumpStatus == "ON" ? Colors.green : Colors.red,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // GRAFIK SUHU REALTIME
              Text("Statistik Suhu (Realtime)", style: kSubHeadingStyle),
              const SizedBox(height: 10),
              Container(
                height: 200,
                padding: const EdgeInsets.only(right: 20, top: 20, bottom: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                // PANGGIL WIDGET GRAFIK DISINI
                child: LineChart(_mainData()),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [kPrimaryColor, const Color(0xFF1B5E20)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: kPrimaryColor.withOpacity(0.4),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Selamat Datang,",
            style: kHeadingStyle.copyWith(color: Colors.white, fontSize: 16),
          ),
          const SizedBox(height: 5),
          Text(
            "Mahasiswa IoT",
            style: kHeadingStyle.copyWith(color: Colors.white, fontSize: 24),
          ),
        ],
      ),
    );
  }

  Widget _buildSensorCard({
    required String title,
    required String value,
    required String unit,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: kBodyStyle.copyWith(fontWeight: FontWeight.bold),
              ),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 20),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value, style: kSensorValueStyle),
              Text(unit, style: kBodyStyle.copyWith(fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }

  // --- LOGIKA GRAFIK DINAMIS ---
  LineChartData _mainData() {
    return LineChartData(
      gridData: FlGridData(show: false),
      titlesData: FlTitlesData(show: false),
      borderData: FlBorderData(show: false),
      // Atur batas min/max grafik agar tidak gepeng
      minY: 0,
      maxY: 100, // Asumsi suhu max 100, bisa diubah
      lineBarsData: [
        LineChartBarData(
          spots: historyData, // <--- INI SUDAH PAKAI DATA ASLI
          isCurved: true,
          gradient: const LinearGradient(colors: [Colors.blue, Colors.purple]),
          barWidth: 4,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: true), // Tampilkan titik
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [
                Colors.blue.withOpacity(0.3),
                Colors.purple.withOpacity(0.0),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ],
    );
  }
}
