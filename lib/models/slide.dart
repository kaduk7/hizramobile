import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class Slide with ChangeNotifier {
  List foto = [];

  int get jumlahData => foto.length;

  void slideFoto() async {
    final response = await http
        .get(Uri.parse('https://kantorhizratech.vercel.app/api/mobile/slide'));

    if (response.statusCode == 200) {
      foto = (json.decode(response.body))["data"];
    } else {
      throw Exception('Failed to load data');
    }
    print('foto:$foto');
    notifyListeners();
  }
}
