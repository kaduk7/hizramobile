import 'dart:ffi';

import 'package:geolocator/geolocator.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

Future<bool> checkLocation() async {
  Uri url = Uri.parse("https://kantorhizratech.vercel.app/api/mobile/lokasi");

  var hasilResponse = await http.get(url);
  bool isWithinRange = false;
  if (hasilResponse.statusCode == 200) {
    var data = json.decode(hasilResponse.body);

    // Mendapatkan lokasi dari data
    String lokasi = data['lokasi'];
    int radius=data['radius'];
    List<String> lokasiSplit = lokasi.split(', ');
    double officeLatitude = double.parse(lokasiSplit[0]);
    double officeLongitude = double.parse(lokasiSplit[1]);
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission != LocationPermission.denied &&
        permission != LocationPermission.deniedForever) {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      double distanceInMeters = Geolocator.distanceBetween(position.latitude,
          position.longitude, officeLatitude, officeLongitude);
      isWithinRange = distanceInMeters <= radius;
      print(isWithinRange);
    }
  } else {
    print('Gagal mengambil data lokasi');
  }
  return isWithinRange;
}
