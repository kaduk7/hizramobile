import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:hizramobile/models/http_login.dart';
import 'package:hizramobile/models/dasarGet.dart';
import 'package:hizramobile/models/get.dart';
import 'package:hizramobile/pages/home_get.dart';
import 'package:hizramobile/pages/home_page.dart';
import 'package:hizramobile/screens/login.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final storage = FlutterSecureStorage();

  Future<bool> checkLoginStatus() async {
    String? token = await storage.read(key: 'token');
    return token != null;
  }

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
        home: FutureBuilder<bool>(
          future: checkLoginStatus(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator(); // Atau SplashScreen jika Anda memiliki satu
            }
            if (snapshot.hasData) {
              return HomePage(); // Asumsi bahwa HomePage adalah halaman utama setelah login
            } else {
              return LoginScreen(); // Redirect ke login jika tidak ada token
            }
          },
        ),
        routes: {
          '/home': (context) => HomePage(),
          '/homeGet': (context) => HomeGet(),
          '/loginScreen': (context) => LoginScreen(),
          // Anda bisa menambahkan lebih banyak rute di sini
        },
      ),
    );
  }
}
