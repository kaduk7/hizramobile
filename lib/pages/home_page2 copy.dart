import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hizramobile/json/home_page_json.dart';
import 'package:hizramobile/models/logout.dart';
import 'package:hizramobile/pages/absenkaryawan.dart';
import 'package:hizramobile/pages/coba.dart';
import 'package:hizramobile/screens/login.dart';
import 'package:hizramobile/theme/colors.dart';
import 'package:hizramobile/theme/styles.dart';
import 'package:hizramobile/widgets/custom_slider.dart';
import 'package:animate_do/animate_do.dart';
import 'package:hizramobile/widgets/navbar.dart';
import 'package:provider/provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../constants/Theme.dart';
import '../models/http_login.dart';
import '../widgets/card-horizontal.dart';
import '../widgets/card-small.dart';
import '../widgets/card-square.dart';
import '../widgets/drawer.dart';

class HomePage2 extends StatefulWidget {
  // const HomePage({super.key});
  const HomePage2({Key? key}) : super(key: key);
  @override
  _HomePage2State createState() => _HomePage2State();
}

class _HomePage2State extends State<HomePage2> {
  double sliderValue = 0.0;
  PageController pageController = PageController(initialPage: 0);
  int activeMenu = 0;
  bool isInit = true;
  String? nama;
  String? divisi;
  String? foto;

  bool _isLoading = false;
  final storage = FlutterSecureStorage();
  final supabaseUrl = 'https://yfvmvycfljbsxcwlwupa.supabase.co';
  final supabaseKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inlmdm12eWNmbGpic3hjd2x3dXBhIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDg5MTc5OTgsImV4cCI6MjAyNDQ5Mzk5OH0.9l2SEcIPZ8Ibd7mXKr_oyk4RmNgZMsvXLx3h2wqDgU0';
  final supabaseBUCKET = 'uploadfile';

  void initState() {
    super.initState();
    loadKaryawanDetails();
  }

  void loadKaryawanDetails() async {
    final details = await Provider.of<HttpLogin>(context, listen: false)
        .getKaryawanDetails();
    if (details != null) {
      setState(() {
        nama = details['nama'];
        divisi = details['divisi'];
        foto = details['foto'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: getBody(),
    );
  }

  Widget getBody() {
    final List<Widget> imageSliders =
        ['assets/bg7.jpg', 'assets/bg2.jpeg', 'assets/bg5.jpeg']
            .map((item) => Container(
                  child: Center(
                    child: Image.asset(item, fit: BoxFit.fitWidth, width: 2000),
                  ),
                ))
            .toList();

    final dataLogin = Provider.of<HttpLogin>(context, listen: false);

    void _logout() async {
      _showMyDialog(context);
    }

    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          toolbarHeight: 100,
          flexibleSpace: Image.asset(
            'assets/header.jpg',
            fit: BoxFit.fill,
            height: 140,
          ),
        ),
        backgroundColor: NowUIColors.bgColorScreen,
        body: Stack(
          children: <Widget>[
            Column(
              children: [
                Flexible(
                  flex: 1,
                  child: Container(
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage("assets/35.jpg"),
                              fit: BoxFit.fill)),
                      child: Stack(
                        children: <Widget>[
                          SafeArea(
                            bottom: false,
                            right: false,
                            left: false,
                            top: false,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 0, right: 0, top: 130.0),
                              child: Column(
                                children: [
                                  // Container(
                                  //   padding: const EdgeInsets.only(
                                  //       top: 100.0, left: 20.0),
                                  //   decoration: BoxDecoration(
                                  //       color: Colors.transparent,
                                  //       boxShadow: [
                                  //         BoxShadow(
                                  //             color: Colors.transparent,
                                  //             spreadRadius: -10,
                                  //             blurRadius: 12,
                                  //             offset: Offset(0, 5))
                                  //       ]),
                                  //   child: Row(
                                  //     children: [
                                  //       CircleAvatar(
                                  //           backgroundImage: NetworkImage(
                                  //               "$supabaseUrl/storage/v1/object/public/$supabaseBUCKET/foto-profil/$foto"),
                                  //           // backgroundImage: AssetImage("assets/profile-img.jpg"),
                                  //           radius: 30.0),
                                  //       Padding(
                                  //         padding:
                                  //             const EdgeInsets.only(left: 5.0),
                                  //         child: Column(
                                  //           mainAxisAlignment:
                                  //               MainAxisAlignment.start,
                                  //           crossAxisAlignment:
                                  //               CrossAxisAlignment.start,
                                  //           children: [
                                  //             Padding(
                                  //               padding: const EdgeInsets.only(
                                  //                   left: 1.0),
                                  //               child: Text(
                                  //                   ' $nama' ??
                                  //                       "Loading name...",
                                  //                   style: TextStyle(
                                  //                       color: Colors.black,
                                  //                       fontWeight:
                                  //                           FontWeight.w600,
                                  //                       fontSize: 20)),
                                  //             ),
                                  //             Padding(
                                  //               padding: const EdgeInsets.only(
                                  //                   left: 3.0),
                                  //               child: Text(
                                  //                   ' $divisi' ??
                                  //                       "Loading name...",
                                  //                   style: TextStyle(
                                  //                       color: Colors.black,
                                  //                       fontWeight:
                                  //                           FontWeight.w600,
                                  //                       fontSize: 13)),
                                  //             ),
                                  //           ],
                                  //         ),
                                  //       ),
                                  //       // Padding(
                                  //       //   padding: const EdgeInsets.only(left: 75.0),
                                  //       //   child: CircleAvatar(
                                  //       //       backgroundImage: AssetImage(
                                  //       //           "assets/favico.png"),
                                  //       //       // backgroundImage: AssetImage("assets/profile-img.jpg"),
                                  //       //       radius: 50.0),
                                  //       // ),
                                  //     ],
                                  //   ),
                                  // ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 20.0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text('Selamat Datang, ',
                                            style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 1, 47, 68),
                                                fontWeight: FontWeight.w600,
                                                fontSize: 18)),
                                        Text(' $nama' ?? "Loading name...",
                                            style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 8, 115, 202),
                                                fontWeight: FontWeight.w600,
                                                fontSize: 20)),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10.0, left: 20, right: 20),
                                    child: Container(
                                      width: 360,
                                      height: 220,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 10.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        foregroundColor:
                                                            Colors.white,
                                                        backgroundColor:
                                                            Color.fromARGB(255,
                                                                232, 235, 104),
                                                        minimumSize: Size(100,
                                                            70), // Ukuran tombol
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          // Bentuk tombol
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  15), // Kotak tanpa lengkungan
                                                        ),
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal:
                                                                    20), // Padding horizontal
                                                      ),
                                                      onPressed: () async {
                                                        showLoadingDialog(
                                                            context);
                                                        await Future.delayed(
                                                            Duration(
                                                                milliseconds:
                                                                    500));
                                                        Navigator.of(context,
                                                                rootNavigator:
                                                                    true)
                                                            .pop();
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  AbsensikaryawanPage()),
                                                        );
                                                      },
                                                      child: Column(
                                                        mainAxisSize: MainAxisSize
                                                            .min, // Agar Row tidak meregang
                                                        children: [
                                                          Image.asset(
                                                              'assets/icon/attendance.png',
                                                              width: 40,
                                                              height: 40),
                                                        ],
                                                      ),
                                                    ),
                                                    Text("Absensi",
                                                        style: TextStyle(
                                                            color: NowUIColors
                                                                .black
                                                                .withOpacity(
                                                                    0.8),
                                                            fontSize: 15.0))
                                                  ],
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        foregroundColor:
                                                            Colors.white,
                                                        backgroundColor:
                                                            Color.fromARGB(172,
                                                                0, 49, 155),
                                                        minimumSize: Size(100,
                                                            70), // Ukuran tombol
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          // Bentuk tombol
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  15), // Kotak tanpa lengkungan
                                                        ),
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal:
                                                                    20), // Padding horizontal
                                                      ),
                                                      onPressed: () async {
                                                        showLoadingDialog(
                                                            context);
                                                        await Future.delayed(
                                                            Duration(
                                                                milliseconds:
                                                                    500));
                                                        Navigator.of(context,
                                                                rootNavigator:
                                                                    true)
                                                            .pop();
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  ArtikelPage()),
                                                        );
                                                      },
                                                      child: Column(
                                                        mainAxisSize: MainAxisSize
                                                            .min, // Agar Row tidak meregang
                                                        children: [
                                                          Image.asset(
                                                              'assets/icon/notebook.png',
                                                              width: 40,
                                                              height: 40),
                                                          // Teks pada tombol
                                                        ],
                                                      ),
                                                    ),
                                                    Text("Tugas",
                                                        style: TextStyle(
                                                            color: NowUIColors
                                                                .black
                                                                .withOpacity(
                                                                    0.8),
                                                            fontSize: 15.0))
                                                  ],
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        foregroundColor:
                                                            Colors.white,
                                                        backgroundColor:
                                                            Color.fromARGB(
                                                                172, 255, 0, 0),
                                                        minimumSize: Size(100,
                                                            70), // Ukuran tombol
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          // Bentuk tombol
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  15), // Kotak tanpa lengkungan
                                                        ),
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal:
                                                                    20), // Padding horizontal
                                                      ),
                                                      onPressed: () {
                                                        // Aksi yang terjadi ketika tombol ditekan
                                                        print(
                                                            'Tombol dengan Ikon ditekan');
                                                      },
                                                      child: Column(
                                                        mainAxisSize: MainAxisSize
                                                            .min, // Agar Row tidak meregang
                                                        children: [
                                                          Image.asset(
                                                              'assets/icon/megaphone.png',
                                                              width: 40,
                                                              height: 40),
                                                        ],
                                                      ),
                                                    ),
                                                    Text("Pengumuman",
                                                        style: TextStyle(
                                                            color: NowUIColors
                                                                .black
                                                                .withOpacity(
                                                                    0.8),
                                                            fontSize: 15.0))
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 10.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        foregroundColor:
                                                            Colors.white,
                                                        backgroundColor:
                                                            Color.fromARGB(
                                                                172, 255, 0, 0),
                                                        minimumSize: Size(100,
                                                            70), // Ukuran tombol
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          // Bentuk tombol
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  15), // Kotak tanpa lengkungan
                                                        ),
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal:
                                                                    20), // Padding horizontal
                                                      ),
                                                      onPressed: () {
                                                        // Aksi yang terjadi ketika tombol ditekan
                                                        print(
                                                            'Tombol dengan Ikon ditekan');
                                                      },
                                                      child: Column(
                                                        mainAxisSize: MainAxisSize
                                                            .min, // Agar Row tidak meregang
                                                        children: [
                                                          Image.asset(
                                                              'assets/icon/digital-news.png',
                                                              width: 40,
                                                              height: 40),
                                                        ],
                                                      ),
                                                    ),
                                                    Text("Berita",
                                                        style: TextStyle(
                                                            color: NowUIColors
                                                                .black
                                                                .withOpacity(
                                                                    0.8),
                                                            fontSize: 15.0))
                                                  ],
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        foregroundColor:
                                                            Colors.white,
                                                        backgroundColor:
                                                            Color.fromARGB(255,
                                                                232, 235, 104),
                                                        minimumSize: Size(100,
                                                            70), // Ukuran tombol
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          // Bentuk tombol
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  15), // Kotak tanpa lengkungan
                                                        ),
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal:
                                                                    20), // Padding horizontal
                                                      ),
                                                      onPressed: _logout,
                                                      child: Column(
                                                        mainAxisSize: MainAxisSize
                                                            .min, // Agar Row tidak meregang
                                                        children: [
                                                          Image.asset(
                                                              'assets/icon/calendar.png',
                                                              width: 40,
                                                              height: 40),
                                                        ],
                                                      ),
                                                    ),
                                                    Text("Acara",
                                                        style: TextStyle(
                                                            color: NowUIColors
                                                                .black
                                                                .withOpacity(
                                                                    0.8),
                                                            fontSize: 15.0))
                                                  ],
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        foregroundColor:
                                                            Colors.white,
                                                        backgroundColor:
                                                            Color.fromARGB(172,
                                                                0, 49, 155),
                                                        minimumSize: Size(100,
                                                            70), // Ukuran tombol
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          // Bentuk tombol
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  15), // Kotak tanpa lengkungan
                                                        ),
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal:
                                                                    20), // Padding horizontal
                                                      ),
                                                      onPressed: _logout,
                                                      child: Column(
                                                        mainAxisSize: MainAxisSize
                                                            .min, // Agar Row tidak meregang
                                                        children: [
                                                          Image.asset(
                                                              'assets/icon/logout.png',
                                                              width: 40,
                                                              height: 40),
                                                        ],
                                                      ),
                                                    ),
                                                    Text("Logout",
                                                        style: TextStyle(
                                                            color: NowUIColors
                                                                .black
                                                                .withOpacity(
                                                                    0.8),
                                                            fontSize: 15.0))
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      // decoration: BoxDecoration(
                                      //   borderRadius: BorderRadius.circular(
                                      //       10), // Kotak dengan sudut tumpul
                                      //   border: Border.all(
                                      //     color: Color.fromARGB(255, 1, 47, 68),
                                      //     width: 1.0,
                                      //   ),
                                      // ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 20.0),
                                    child: Container(
                                      width: 360,
                                      height: 150,
                                      child: CarouselSlider(
                                        // options: CarouselOptions(
                                        //   autoPlay: true,
                                        //   aspectRatio: 2.0,
                                        //   enlargeCenterPage: true,
                                        // ),
                                        options: CarouselOptions(
                                          height: 400.0,
                                          enlargeCenterPage:
                                              true, // Membuat foto di tengah lebih besar
                                          autoPlay:
                                              true, // Slide foto secara otomatis
                                          // autoPlayInterval: Duration(
                                          //     seconds:
                                          //         2), // Interval antar slide
                                          viewportFraction: 0.8,
                                        ),
                                        items: [
                                          'assets/1.jpg',
                                          'assets/2.jpg',
                                          'assets/3.jpg',
                                          'assets/4.jpg'
                                        ].map((i) {
                                          return Builder(
                                            builder: (BuildContext context) {
                                              return Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                margin: EdgeInsets.symmetric(
                                                    horizontal: 5.0),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5), // Kotak dengan sudut tumpul
                                                  border: Border.all(
                                                    color: Color.fromARGB(
                                                        255, 1, 47, 68),
                                                    width: 2.0,
                                                  ),
                                                ),
                                                child: Image.asset(i,
                                                    fit: BoxFit.fill),
                                              );
                                            },
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      )),
                ),
              ],
            ),
          ],
        ));
  }
}

void showLoadingDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return Center(child: CircularProgressIndicator());
    },
  );
}

Future<void> _showMyDialog(BuildContext context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // User must tap button!
    builder: (BuildContext context) {
      final dataLogin = Provider.of<HttpLogin>(context, listen: false);
      return AlertDialog(
        title: Text('Konfirmasi'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Apakah kamu ingin logout?'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('No'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text('Yes'),
            onPressed: () async {
              showDialog(
                context: context,
                builder: (context) {
                  return Center(child: CircularProgressIndicator());
                },
              );
              await Future.delayed(Duration(milliseconds: 500));
              await dataLogin.logout();

              Navigator.of(context).pop();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
          ),
        ],
      );
    },
  );
}
