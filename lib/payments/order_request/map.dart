import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:get/get.dart';
import 'package:rebuild_flat/basics/app_colors.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  LatLng? selectedPoint;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: const Text("اختر موقعك على الخريطة"),
      ),
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              initialCenter: LatLng(33.5138, 36.2765), // دمشق (مركز البداية)
              initialZoom: 10,
              onTap: (tapPosition, point) {
                setState(() {
                  selectedPoint = point;
                });
                debugPrint("Latitude: ${point.latitude}, Longitude: ${point.longitude}");
              },
            ),
            children: [
              TileLayer(
                urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",

                userAgentPackageName: 'com.example.rebuild_flat',
              ),

              if (selectedPoint != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: selectedPoint!,
                      width: 50,
                      height: 50,
                      child: const Icon(
                        Icons.location_on,
                        color: Colors.red,
                        size: 40,
                      ),
                    ),
                  ],
                ),
            ],
          ),

          // زر تأكيد الموقع
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                if (selectedPoint != null) {
                  Get.back(result: selectedPoint); // رجّع النقطة للصفحة السابقة
                } else {
                  Get.snackbar("تنبيه", "من فضلك اختر موقعك على الخريطة أولاً");
                }
              },
              child: const Text(
                "تأكيد الموقع",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          )
        ],
      ),
    );
  }
}
