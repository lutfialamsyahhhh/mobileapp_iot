import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CctvTab extends StatefulWidget {
  const CctvTab({super.key});

  @override
  State<CctvTab> createState() => _CctvTabState();
}

class _CctvTabState extends State<CctvTab> {
  // IP ADDRESS ESP32-CAM (Pastikan sama dengan IP di Serial Monitor)
  final String streamUrl = "http://192.168.169.15:81/stream";
  
  // Key unik untuk memaksa refresh widget Image
  Key _uniqueKey = UniqueKey();

  void _refreshCamera() {
    setState(() {
      _uniqueKey = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Monitoring Visual", 
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)
          ),
          const Text(
            "Live Stream dari ESP32-CAM", 
            style: TextStyle(color: Colors.grey)
          ),
          const SizedBox(height: 20),

          // Container Video
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade800, width: 4),
              boxShadow: const [
                BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0,5))
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Gambar Stream
                Image.network(
                  streamUrl,
                  key: _uniqueKey,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 250,
                  // Tampilan saat loading/error
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 250,
                      color: Colors.grey[900],
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const FaIcon(FontAwesomeIcons.videoSlash, color: Colors.grey, size: 40),
                            const SizedBox(height: 10),
                            const Text(
                              "SINYAL HILANG", 
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
                            ),
                            const Text(
                              "Periksa koneksi ESP32", 
                              style: TextStyle(color: Colors.grey, fontSize: 12)
                            ),
                            const SizedBox(height: 15),
                            ElevatedButton.icon(
                              onPressed: _refreshCamera,
                              label: const Text("Coba Hubungkan Ulang"),
                              icon: const Icon(Icons.refresh),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
                
                // Overlay Label "LIVE"
                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      // [FIX] Mengganti withOpacity jadi withValues(alpha: ...)
                      color: Colors.red.withValues(alpha: 0.8),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.circle, color: Colors.white, size: 8),
                        SizedBox(width: 4),
                        Text(
                          "LIVE RECORDING", 
                          style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)
                        ),
                      ],
                    ),
                  ),
                ),

                // Overlay Controls Bawah
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: FloatingActionButton.small(
                    onPressed: _refreshCamera,
                    // [FIX] Mengganti withOpacity jadi withValues(alpha: ...)
                    backgroundColor: Colors.white.withValues(alpha: 0.2),
                    child: const Icon(Icons.refresh, color: Colors.white),
                  ),
                )
              ],
            ),
          ),

          const SizedBox(height: 10),
          
          // Info IP
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue.shade100),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline, color: Colors.blue),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text(
                    "Pastikan HP dan ESP32 berada di jaringan WiFi/Hotspot yang sama.", 
                    style: TextStyle(fontSize: 12, color: Colors.blueGrey)
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}