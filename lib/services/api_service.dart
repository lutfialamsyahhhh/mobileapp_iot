import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // =======================================================================
  // KONFIGURASI IP ADDRESS (WAJIB DIGANTI SETIAP PINDAH WIFI/RESTART)
  // =======================================================================
  // Ganti angka IP di bawah ini sesuai hasil 'ipconfig' di laptop Anda.
  // Jangan gunakan 'localhost' untuk Android/HP fisik.
  static const String baseUrl = "http://10.168.130.200:5000/api";

  // 1. Ambil Data Sensor (GET)
  static Future<Map<String, dynamic>> fetchSensors() async {
    try {
      // print("Mencoba koneksi ke: $baseUrl/sensors"); // Debugging Log

      final response = await http.get(Uri.parse('$baseUrl/sensors'));

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        // Format Backend Anda: { "status": "success", "data": { ... } }
        // Kita cek dulu apakah statusnya success
        if (jsonResponse['status'] == 'success') {
          return jsonResponse['data'];
        } else {
          // Jika backend membalas tapi statusnya error
          return {};
        }
      } else {
        // Jika server error (500) atau tidak ketemu (404)
        print("Server Error: ${response.statusCode}");
        return {};
      }
    } catch (e) {
      print("Gagal koneksi API: $e");
      // Kembalikan map kosong agar UI tidak crash saat RTO/Error
      return {};
    }
  }

  // 2. Kirim Perintah Kontrol (POST)
  static Future<bool> controlDevice(String component, String action) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/control'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"component": component, "action": action}),
      );

      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      print("Error control: $e");
      return false;
    }
  }
}
