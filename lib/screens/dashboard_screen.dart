import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart'; // Library Grafik
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // Library Ikon
import 'package:uas_iot/theme.dart'; // Tema warna kita

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPageBg, // Warna latar belakang putih tulang
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // =========================================
              // BAGIAN 1: HEADER (Selamat Datang)
              // =========================================
              _buildHeader(),

              const SizedBox(height: 20),

              // =========================================
              // BAGIAN 2: KARTU SENSOR (Grid 2x2)
              // =========================================
              // Kita pakai GridView agar rapi 2 kolom
              GridView.count(
                shrinkWrap: true, // Agar tidak error di dalam ScrollView
                physics:
                    const NeverScrollableScrollPhysics(), // Scroll ikut parent
                crossAxisCount: 2, // 2 Kolom
                crossAxisSpacing: 15, // Jarak antar kartu horizontal
                mainAxisSpacing: 15, // Jarak antar kartu vertikal
                childAspectRatio: 1.4, // Mengatur rasio lebar:tinggi kartu
                children: [
                  _buildSensorCard(
                    title: "Water Level",
                    value: "1.2",
                    unit: "Liter",
                    icon: Icons.water_drop,
                    color: Colors.blueAccent,
                  ),
                  _buildSensorCard(
                    title: "Light",
                    value: "500",
                    unit: "Lux",
                    icon: Icons.wb_sunny,
                    color: Colors.orangeAccent,
                  ),
                  _buildSensorCard(
                    title: "Temp",
                    value: "26°",
                    unit: "Celcius",
                    icon: FontAwesomeIcons.temperatureThreeQuarters,
                    color: Colors.redAccent,
                  ),
                  _buildSensorCard(
                    title: "Camera",
                    value: "ON",
                    unit: "Live",
                    icon: Icons.videocam,
                    color: Colors.purpleAccent,
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // =========================================
              // BAGIAN 3: GRAFIK PH (Chart)
              // =========================================
              Text("Statistik PH Tanah", style: kSubHeadingStyle),
              const SizedBox(height: 10),
              Container(
                height: 200,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      // PERBAIKAN 1: withOpacity -> withValues
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: LineChart(
                  _mainData(), // Fungsi konfigurasi chart ada di bawah
                ),
              ),

              const SizedBox(height: 20),

              // =========================================
              // BAGIAN 4: STATUS WATERING (Footer)
              // =========================================
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.cyan.shade100, Colors.blue.shade100],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Status Penyiraman", style: kSubHeadingStyle),
                        const SizedBox(height: 5),
                        Text("Terjadwal: 16.00 WIB", style: kBodyStyle),
                      ],
                    ),
                    const Icon(Icons.water_drop, size: 40, color: Colors.blue),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // --- WIDGET BUILDER: HEADER ---
  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        // Gradient Hijau ke Hitam (Sesuai desain)
        gradient: LinearGradient(
          colors: [kPrimaryColor, const Color(0xFF1B5E20)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            // PERBAIKAN 2: withOpacity -> withValues
            color: kPrimaryColor.withValues(alpha: 0.4),
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
            "Mahasiswa IoT", // Nanti bisa diganti nama user
            style: kHeadingStyle.copyWith(color: Colors.white, fontSize: 24),
          ),
        ],
      ),
    );
  }

  // --- WIDGET BUILDER: KARTU SENSOR KECIL ---
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
            // PERBAIKAN 3: withOpacity -> withValues
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Ikon di pojok kanan atas
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
                  // PERBAIKAN 4: withOpacity -> withValues
                  color: color.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 20),
              ),
            ],
          ),
          // Nilai Sensor
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

  // --- KONFIGURASI CHART DASHBOARD (DENGAN LABEL) ---
  LineChartData _mainData() {
    return LineChartData(
      // 1. Grid Latar Belakang (Opsional: biar lebih mudah baca angka)
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 1,
        verticalInterval: 2,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: Colors.grey.withValues(alpha: 0.1),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: Colors.grey.withValues(alpha: 0.1),
            strokeWidth: 1,
          );
        },
      ),

      // 2. Judul Sumbu X dan Y
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),

        // LABEL BAWAH (Sumbu X - Waktu/Jam)
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30, // Ruang untuk teks agar tidak kepotong
            interval: 2, // Tampilkan angka setiap kelipatan 2
            getTitlesWidget: (value, meta) {
              const style = TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              );

              // Custom Text sesuai nilai X
              Widget text;
              switch (value.toInt()) {
                case 0:
                  text = const Text('00:00', style: style);
                  break;
                case 2:
                  text = const Text('04:00', style: style);
                  break;
                case 4:
                  text = const Text('08:00', style: style);
                  break;
                case 6:
                  text = const Text('12:00', style: style);
                  break;
                case 8:
                  text = const Text('16:00', style: style);
                  break;
                case 10:
                  text = const Text('20:00', style: style);
                  break;
                default:
                  text = const Text('', style: style);
                  break;
              }
              return SideTitleWidget(axisSide: meta.axisSide, child: text);
            },
          ),
        ),

        // LABEL KIRI (Sumbu Y - Nilai pH)
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1, // Tampilkan angka setiap kelipatan 1
            getTitlesWidget: (value, meta) {
              const style = TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              );
              return Text(value.toInt().toString(), style: style);
            },
            reservedSize: 30, // Ruang untuk angka di kiri
          ),
        ),
      ),

      borderData: FlBorderData(show: false),
      minX: 0,
      maxX: 10,
      minY: 0,
      maxY: 6,
      lineBarsData: [
        LineChartBarData(
          spots: const [
            FlSpot(0, 3),
            FlSpot(2, 2),
            FlSpot(4, 5),
            FlSpot(6, 3.1),
            FlSpot(8, 4),
            FlSpot(10, 3),
          ],
          isCurved: true,
          gradient: const LinearGradient(colors: [Colors.blue, Colors.purple]),
          barWidth: 4,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [
                Colors.blue.withValues(alpha: 0.3),
                Colors.purple.withValues(alpha: 0.0),
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
