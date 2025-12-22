import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:uas_iot/theme.dart';

class HarvestScreen extends StatelessWidget {
  const HarvestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPageBg,
      appBar: AppBar(
        title: Text(
          "Manajemen Panen",
          style: kSubHeadingStyle.copyWith(color: Colors.white),
        ),
        backgroundColor: kDarkBg,
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // =========================================
            // 1. SUMMARY CARDS (Bagian Atas)
            // =========================================
            SizedBox(
              height: 100,
              // ListView Horizontal agar bisa digeser jika layar sempit
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildSummaryCard("Total Bulan Ini", "50 kg", Colors.green),
                  _buildSummaryCard("Minggu Ini", "12 kg", Colors.blue),
                  _buildSummaryCard("Rata-rata/hari", "2 kg", Colors.orange),
                  _buildSummaryCard("Prediksi", "+5 kg", Colors.purple),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // =========================================
            // 2. RIWAYAT PANEN (Tabel Sederhana)
            // =========================================
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: kCardBg, // Warna abu-abu sesuai desain
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Riwayat Panen Terbaru", style: kSubHeadingStyle),
                  const SizedBox(height: 10),
                  // Header Tabel
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Tanggal",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Jenis",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Qty",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Status",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const Divider(),
                  // Data Dummy (List Panen)
                  _buildHarvestRow(
                    "01 Des",
                    "Selada",
                    "5 kg",
                    "Selesai",
                    Colors.green,
                  ),
                  _buildHarvestRow(
                    "28 Nov",
                    "Bayam",
                    "3 kg",
                    "Selesai",
                    Colors.green,
                  ),
                  _buildHarvestRow(
                    "25 Nov",
                    "Kangkung",
                    "4 kg",
                    "Sortir",
                    Colors.orange,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // =========================================
            // 3. GRAFIK PRODUKTIVITAS (Bawah)
            // =========================================
            Container(
              height: 250,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: kCardBg,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Grafik Produktivitas", style: kSubHeadingStyle),
                  const Text(
                    "Chart: Produktivitas per Minggu",
                    style: TextStyle(fontSize: 12),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: BarChart(
                      BarChartData(
                        borderData: FlBorderData(show: false),
                        gridData: const FlGridData(show: false),
                        titlesData: const FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          topTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          rightTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: _bottomTitles,
                            ),
                          ),
                        ),
                        barGroups: [
                          _makeBarGroup(0, 5), // Minggu 1
                          _makeBarGroup(1, 8), // Minggu 2
                          _makeBarGroup(2, 6), // Minggu 3
                          _makeBarGroup(3, 9), // Minggu 4
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Spasi ekstra agar tidak ketutup navigasi bawah
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // --- WIDGET HELPERS ---

  Widget _buildSummaryCard(String title, String value, Color color) {
    return Container(
      width: 130,
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 5),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHarvestRow(
    String date,
    String type,
    String qty,
    String status,
    Color statusColor,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(date),
          Text(type),
          Text(qty),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text(
              status,
              style: TextStyle(
                color: statusColor,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Konfigurasi Bar Chart
  BarChartGroupData _makeBarGroup(int x, double y) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: kPrimaryColor,
          width: 20,
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
  }

  // Label Bawah Chart
  static Widget _bottomTitles(double value, TitleMeta meta) {
    const style = TextStyle(fontSize: 10);
    String text;
    switch (value.toInt()) {
      case 0:
        text = 'Mg 1';
        break;
      case 1:
        text = 'Mg 2';
        break;
      case 2:
        text = 'Mg 3';
        break;
      case 3:
        text = 'Mg 4';
        break;
      default:
        text = '';
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(text, style: style),
    );
  }
}
