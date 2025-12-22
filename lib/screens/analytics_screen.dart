import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:uas_iot/theme.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

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
        automaticallyImplyLeading: false, // Hilangkan tombol back default
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Judul Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: kCardBg,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  "RIWAYAT DATA PER JAM",
                  style: kSubHeadingStyle.copyWith(fontSize: 14),
                ),
              ),
            ),

            // Grid 4 Grafik
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2, // 2 Kolom
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1.0, // Kotak Persegi (Square)
              children: [
                _buildChartCard("CAHAYA/JAM", Colors.orange, [
                  2,
                  4,
                  3,
                  5,
                  4,
                  6,
                ]),
                _buildChartCard("HUMIDITY/JAM", Colors.blue, [
                  5,
                  5,
                  4,
                  6,
                  5,
                  7,
                ]),
                _buildChartCard("SUHU/JAM", Colors.red, [3, 3, 4, 3, 5, 4]),
                _buildChartCard("PH TANAH/JAM", Colors.green, [
                  4,
                  5,
                  4,
                  3,
                  4,
                  5,
                ]),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // --- WIDGET CHART ANALYTICS (DENGAN LABEL) ---
  Widget _buildChartCard(String title, Color color, List<double> dataPoints) {
    List<FlSpot> spots = dataPoints.asMap().entries.map((e) {
      return FlSpot(e.key.toDouble(), e.value);
    }).toList();

    return Container(
      padding: const EdgeInsets.fromLTRB(
        8,
        12,
        16,
        8,
      ), // Padding disesuaikan agar angka muat
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            title,
            style: kBodyStyle.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: false),

                // KONFIGURASI LABEL SUMBU
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),

                  // Label Bawah (Angka kecil 0, 1, 2...)
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 22,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value
                              .toInt()
                              .toString(), // Tampilkan angka sederhana 1, 2, 3
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 10,
                          ),
                        );
                      },
                    ),
                  ),

                  // Label Kiri (Nilai Sensor)
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 28, // Beri ruang agar angka puluhan muat
                      interval: 2, // Loncat 2 angka biar tidak penuh
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 10,
                          ),
                        );
                      },
                    ),
                  ),
                ),

                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    color: color,
                    barWidth: 3,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: color.withValues(alpha: 0.2),
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
