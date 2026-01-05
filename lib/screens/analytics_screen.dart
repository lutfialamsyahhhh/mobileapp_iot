import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:uas_iot/theme.dart';
import 'package:uas_iot/services/api_service.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  // --- VARIABEL PENYIMPAN DATA ---
  List<FlSpot> lightSpots = [const FlSpot(0, 0)];
  List<FlSpot> humSpots = [const FlSpot(0, 0)];
  List<FlSpot> tempSpots = [const FlSpot(0, 0)];
  List<FlSpot> soilSpots = [const FlSpot(0, 0)];

  double timeCounter = 0; // Sumbu X berjalan
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _getData();

    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      _getData();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _getData() async {
    try {
      final data = await ApiService.fetchSensors();
      if (data.isEmpty) return;

      if (mounted) {
        setState(() {
          timeCounter++;

          // Ambil Data (Aman dari null)
          double lux = double.tryParse(data['cahaya'].toString()) ?? 0;
          double hum =
              double.tryParse(data['kelembapan_udara'].toString()) ?? 0;
          double temp = double.tryParse(data['suhu'].toString()) ?? 0;
          double soil =
              double.tryParse(data['kelembapan_tanah'].toString()) ?? 0;

          // Update Grafik
          _updateList(lightSpots, lux);
          _updateList(humSpots, hum);
          _updateList(tempSpots, temp);
          _updateList(soilSpots, soil);
        });
      }
    } catch (e) {
      print("Error Analytics: $e");
    }
  }

  // Batasi hanya 20 data terakhir agar grafik bergerak mulus
  void _updateList(List<FlSpot> list, double value) {
    list.add(FlSpot(timeCounter, value));
    if (list.length > 20) {
      list.removeAt(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPageBg,
      appBar: AppBar(
        title: Text(
          "Analitik Sensor",
          style: kSubHeadingStyle.copyWith(color: Colors.white),
        ),
        backgroundColor: kDarkBg,
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Judul Halaman
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: kCardBg,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Center(
                child: Text(
                  "MONITORING REALTIME",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),

            // Grid Grafik
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.9, // Sedikit lebih tinggi agar muat
              children: [
                _buildCleanChart("CAHAYA", "Lux", Colors.orange, lightSpots),
                _buildCleanChart("UDARA", "%", Colors.blue, humSpots),
                _buildCleanChart("SUHU", "°C", Colors.red, tempSpots),
                _buildCleanChart("TANAH", "%", Colors.green, soilSpots),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // --- WIDGET CHART YANG SUDAH DIRAPIKAN ---
  Widget _buildCleanChart(
    String title,
    String unit,
    Color color,
    List<FlSpot> spots,
  ) {
    // Ambil nilai terakhir untuk ditampilkan angka besarnya
    double lastValue = spots.isNotEmpty ? spots.last.y : 0;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Header (Judul Kecil & Angka Besar)
          Text(
            title,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            "${lastValue.toStringAsFixed(1)} $unit", // Tampilkan angka realtime
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),

          const SizedBox(height: 10),

          // 2. Grafik Bersih
          Expanded(
            child: LineChart(
              LineChartData(
                // HILANGKAN GRID KOTAK-KOTAK
                gridData: FlGridData(show: false),

                // HILANGKAN LABEL YANG BIKIN SEMAK
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ), // Hapus label bawah
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ), // Hapus label kiri (opsional, biar bersih)
                ),

                borderData: FlBorderData(show: false),

                // DATA GARIS
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true, // Garis melengkung halus
                    color: color,
                    barWidth: 3,
                    isStrokeCapRound: true,

                    // INI SOLUSI TANDA ANEH: Matikan dotData (titik-titik)
                    dotData: FlDotData(show: false),

                    // Warna gradasi di bawah garis
                    belowBarData: BarAreaData(
                      show: true,
                      color: color.withOpacity(0.2),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
