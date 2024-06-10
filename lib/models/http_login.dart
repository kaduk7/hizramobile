import 'dart:convert';
// import 'dart:ffi';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class HttpLogin with ChangeNotifier {
  final FlutterSecureStorage storage = FlutterSecureStorage();
  Map<String, dynamic> _data = {};
  Map<String, dynamic> _datakaryawan = {};
  Map<String, dynamic> _databerita = {};
  late String _pesan;

  Map<String, dynamic> get data => _data;
  Map<String, dynamic> get datakaryawan => _datakaryawan;
  Map<String, dynamic> get databerita => _databerita;
  String get pesan => _pesan;

  int get jumlahData => _data.length;

  bool isWithinRange = false;

  Future<void> koneksiAPI(String usernama, String password) async {
    Uri url = Uri.parse("https://kantorhizratech.vercel.app/api/mobile/login");

    try {
      var response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'usernama': usernama, 'password': password}),
      );

      if (json.decode(response.body)["pesan"] == 'Login berhasil') {
        var responseData = json.decode(response.body);
        _pesan = responseData["pesan"];
        _data = responseData["data"];
        _datakaryawan = responseData["data"]["KaryawanTb"];
        //  String token = responseData["data"];
        // await storage.write(key: 'token', value: token);
        // print('isi token $token');
        // SharedPreferences prefs = await SharedPreferences.getInstance();
        // await prefs.setBool('isLoggedIn', true);
        String? token = json.encode(responseData["data"]);
        if (token != null) {
          await storage.write(key: 'token', value: token);
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setBool('isLoggedIn', true);
          notifyListeners();
        } else {
          print("Token not found in response");
        }
        notifyListeners();
      } else {
        _pesan = json.decode(response.body)["pesan"];
        print('pesan: ${pesan}');
      }
    } catch (e) {
      print('Kesalahan: $e');
    }
  }

  Future<void> checkLocation() async {
    const double officeLatitude = 0.472916; // Contoh Latitude
    const double officeLongitude = 101.426786; // Contoh Longitude

    LocationPermission permission = await Geolocator.requestPermission();
    if (permission != LocationPermission.denied &&
        permission != LocationPermission.deniedForever) {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      double distanceInMeters = Geolocator.distanceBetween(position.latitude,
          position.longitude, officeLatitude, officeLongitude);
      isWithinRange = distanceInMeters <= 30;
      print(isWithinRange);
      notifyListeners();
    }
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    await storage.delete(key: 'token');
    notifyListeners();
  }

  static Future<bool> checkIfLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  Future<String?> getToken() async {
    try {
      String? token = await storage.read(key: 'token');
      return token;
    } catch (e) {
      print("Error retrieving token: $e");
      return null;
    }
  }

  Future<Map<String, dynamic>?> getKaryawanDetails() async {
    try {
      String? token = await storage.read(key: 'token');
      print('token: $token');
      if (token != null) {
        Map<String, dynamic> decodedToken = json.decode(token);
        int? karyawanId = decodedToken['karyawanId'];
        String? nama = decodedToken['KaryawanTb']['nama'];
        String? divisi = decodedToken['KaryawanTb']['divisi'];
        String? foto = decodedToken['KaryawanTb']['foto'];
        // String? id=decodedToken['KaryawanTb']['id'];
        return {
          'nama': nama,
          'divisi': divisi,
          'foto': foto,
          'karyawanId': karyawanId
        };
      } else {
        print("Token not found");
        return null;
      }
    } catch (e) {
      print("Error retrieving karyawan details: $e");
      return null;
    }
  }

}
