import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hizramobile/models/dasarGet.dart';
import 'package:hizramobile/models/download.dart';
import 'package:hizramobile/models/get.dart';
import 'package:hizramobile/models/http_login.dart';
import 'package:hizramobile/models/slide.dart';
import 'package:hizramobile/pages/home_get.dart';
import 'package:hizramobile/pages/home_page.dart';
import 'package:hizramobile/pages/homedasarGet.dart';
import 'package:hizramobile/screens/login.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';




import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';

import 'pages/home_page2.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  bool isLoggedIn = await HttpLogin.checkIfLoggedIn();
  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
   final bool isLoggedIn;

  MyApp({required this.isLoggedIn});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => HttpLogin()),
        ChangeNotifierProvider(create: (context) => DasarGet()),
        ChangeNotifierProvider(create: (context) => Get()),
        ChangeNotifierProvider(create: (context) => Slide()),
        ChangeNotifierProvider(create: (context) => DownloadNotifier()),
        // Tambahkan lebih banyak provider jika diperlukan
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: isLoggedIn ? HomePage() : LoginScreen(),
        // Atur rute lainnya jika ada
        routes: {
          '/home': (context) => HomePage(),
          '/home2': (context) => HomePage2(),
          '/homeGet': (context) => HomeGet(),
          '/loginScreen': (context) => LoginScreen(),
        },
      ),
    );
  }
}