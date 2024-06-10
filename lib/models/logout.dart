import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HttpLogout {
  String? pesan;
  HttpLogout({required String pesan});
  final storage = FlutterSecureStorage();
  Future<HttpLogout> logout() async {
    await storage.delete(key: 'token');
    return HttpLogout(pesan: 'berhasil');
  }
}
