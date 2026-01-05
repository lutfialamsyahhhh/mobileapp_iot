import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart'; // Tambahan buat debugPrint

class ApiService {
  // IP ADDRESS FLASK (Sesuaikan dengan ipconfig laptopmu)
  static const String baseUrl = "http://192.168.130.200:5000";

  // Ambil Data Sensor
  static Future<Map<String, dynamic>> fetchSensors() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/api/sensors'))
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == 'success') {
          return jsonResponse['data'];
        }
      }
    } catch (e) {
      // Ganti print biasa jadi debugPrint biar warning hilang
      debugPrint("⚠️ Gagal koneksi API: $e");
    }
    return {}; // Return map kosong jika gagal
  }

  // Kirim Perintah Kontrol (Pompa)
  static Future<bool> controlDevice(String component, String action) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/control'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"component": component, "action": action}),
      ).timeout(const Duration(seconds: 5));

      return response.statusCode == 200;
    } catch (e) {
      // Ganti print biasa jadi debugPrint biar warning hilang
      debugPrint("⚠️ Gagal kirim perintah: $e");
      return false;
    }
  }
}