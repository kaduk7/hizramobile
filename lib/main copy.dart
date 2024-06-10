import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hizramobile/models/dasarGet.dart';
import 'package:hizramobile/models/get.dart';
import 'package:hizramobile/models/http_login.dart';
import 'package:hizramobile/pages/home_get.dart';
import 'package:hizramobile/pages/home_page.dart';
import 'package:hizramobile/pages/homedasarGet.dart';
import 'package:hizramobile/screens/login.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';


// import './pages/home_stateful.dart';


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';

void main() {
    runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => HttpLogin()),
        ChangeNotifierProvider(create: (context) => DasarGet()),
        ChangeNotifierProvider(create: (context) => Get()),
        // Tambahkan lebih banyak provider jika diperlukan
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: LoginScreen(),
        // Atur rute lainnya jika ada
        routes: {
          '/home': (context) => HomePage(),
          '/homeGet': (context) => HomeGet(),
          '/loginScreen': (context) => LoginScreen(),
        },
      ),
    );
  }
}