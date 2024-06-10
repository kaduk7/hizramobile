import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class Get with ChangeNotifier {
  Map<String, dynamic> _data = {};

  Map<String, dynamic> get data => _data;

  int get jumlahData => _data.length;

  void connectAPI(String id) async {
    var url =
        Uri.parse("https://kantorhizratech.vercel.app/api/mobile/pengumuman/" + id);
        
// try {
//     var response = await http.get(url);

//     if (response.statusCode == 200) {
//       List<dynamic> _data =(json.decode(response.body))["data"];
//       print(data); // Do something with the data, e.g., updating the state
//     } else {
//       print('Failed to load data with status code: ${response.statusCode}');
//     }
//   } catch (e) {
//     print('An error occurred: $e');
//   }

    try {
      var hasilResponse = await http.get(url);

      if (hasilResponse.statusCode == 200) {
        _data = (json.decode(hasilResponse.body))["data"];
        print(data);
        notifyListeners();
      } else {
        print('Request failed with status: ${hasilResponse.statusCode}.');
      }
    } catch (e) {
      print('An error occurred: $e');
    }
  }
}
