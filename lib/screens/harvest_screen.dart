import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
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
                color: Colors.white, // Gunakan putih agar lebih kontras
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
                  Text("Riwayat Panen Terbaru", style: kSubHeadingStyle),
                  const SizedBox(height: 10),
                  // Header Tabel
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          "Tanggal",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          "Jenis",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          "Qty",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          "Status",
                          style: TextStyle(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.end,
                        ),
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
                  _buildHarvestRow(
                    "20 Nov",
                    "Sawi",
                    "6 kg",
                    "Selesai",
                    Colors.green,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // =========================================
            // 3. GRAFIK PRODUKTIVITAS (Bawah)
            // =========================================
            Container(
              height: 300, // Sedikit lebih tinggi agar label muat
              padding: const EdgeInsets.all(16),
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
                  Text("Grafik Produktivitas", style: kSubHeadingStyle),
                  Text(
                    "Chart: Hasil Panen (Kg) per Minggu",
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: BarChart(
                      BarChartData(
                        borderData: FlBorderData(show: false),
                        gridData: const FlGridData(show: false),
                        titlesData: FlTitlesData(
                          leftTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          topTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          rightTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: _bottomTitles,
                              reservedSize: 30,
                            ),
                          ),
                        ),
                        // Konfigurasi Bar Chart
                        barGroups: [
                          _makeBarGroup(0, 5), // Minggu 1: 5 Kg
                          _makeBarGroup(1, 8), // Minggu 2: 8 Kg
                          _makeBarGroup(2, 6), // Minggu 3: 6 Kg
                          _makeBarGroup(3, 9), // Minggu 4: 9 Kg
                        ],
                        // Jarak antar grup batang
                        alignment: BarChartAlignment.spaceAround,
                        maxY: 12, // Batas atas grafik
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
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
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
      padding: const EdgeInsets.symmetric(vertical: 10.0), // Jarak lebih lega
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(flex: 2, child: Text(date)),
          Expanded(flex: 3, child: Text(type)),
          Expanded(flex: 2, child: Text(qty)),
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.centerRight,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Konfigurasi Batang Grafik (Bar)
  BarChartGroupData _makeBarGroup(int x, double y) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: kPrimaryColor,
          width: 25, // Batang sedikit lebih gemuk
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(6),
            topRight: Radius.circular(6),
          ),
          // Tambahkan label angka di atas batang
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: 12, // Tinggi background abu-abu
            color: Colors.grey.withOpacity(0.1),
          ),
        ),
      ],
    );
  }

  // Label Bawah Chart
  static Widget _bottomTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.bold,
      color: Colors.grey,
    );
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
      space: 8, // Jarak teks dengan grafik
      child: Text(text, style: style),
    );
  }
}
