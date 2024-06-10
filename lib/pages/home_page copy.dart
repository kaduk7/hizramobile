import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:hizramobile/pages/beritapage.dart';
import 'package:hizramobile/pages/detailberita.dart';
import 'package:hizramobile/pages/detailslide.dart';
import 'package:hizramobile/pages/pengumumanpage.dart';
import 'package:hizramobile/pages/tugaspage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hizramobile/json/home_page_json.dart';
import 'package:hizramobile/models/logout.dart';
import 'package:hizramobile/models/slide.dart';
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
// import 'package:flutter_native_timezone/flutter_native_timezone.dart';

import '../constants/Theme.dart';
import '../models/http_login.dart';
import '../widgets/card-horizontal.dart';
import '../widgets/card-small.dart';
import '../widgets/card-square.dart';
import '../widgets/drawer.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class HomePage extends StatefulWidget {
  // const HomePage({super.key});
  const HomePage({Key? key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double sliderValue = 0.0;
  PageController pageController = PageController(initialPage: 0);
  int activeMenu = 0;
  bool isInit = true;
  int? karyawanId;
  String? nama;
  String? divisi;
  String _welcomeMessage = '';
  List data = [];
  List databerita = [];
  List datapengumuman = [];

  bool _isLoading = false;
  final storage = FlutterSecureStorage();
  final supabaseUrl = 'https://harkcrbmtskvtiboutxl.supabase.co';
  final supabaseKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImhhcmtjcmJtdHNrdnRpYm91dHhsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTczODY4MTgsImV4cCI6MjAzMjk2MjgxOH0.Oa2dnHnpsJbQviB4fNdIdwSxJgYR8BUS-Nd1VQWg7LY';
  final supabaseBUCKET = 'uploadfile';

  void initState() {
    super.initState();
    initializeDateFormatting('id_ID', null).then((_) {
      loadKaryawanDetails();
      _updateWelcomeMessage();
      fetchFoto();
      getDataBerita();
      getDatapengumuman();
    });
  }

  String formatTanggalIndonesia(String tanggal) {
    DateTime dateTime = DateTime.parse(tanggal);
    return DateFormat("d MMMM yyyy", "id_ID").format(dateTime);
  }

  void loadKaryawanDetails() async {
    final details = await Provider.of<HttpLogin>(context, listen: false)
        .getKaryawanDetails();
    if (details != null) {
      setState(() {
        nama = details['nama'];
        divisi = details['divisi'];
        karyawanId=details['karyawanId'];
      });
    }
  }

  Future<void> fetchFoto() async {
    final response = await http
        .get(Uri.parse('https://kantorhizratech.vercel.app/api/mobile/slide'));

    if (response.statusCode == 200) {
      setState(() {
        data = (json.decode(response.body))["data"];
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> getDataBerita() async {
    final response = await http
        .get(Uri.parse('https://kantorhizratech.vercel.app/api/mobile/berita'));

    if (response.statusCode == 200) {
      setState(() {
        databerita = (json.decode(response.body));
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> getDatapengumuman() async {
    final response = await http.get(
        Uri.parse('https://kantorhizratech.vercel.app/api/mobile/pengumuman'));

    if (response.statusCode == 200) {
      setState(() {
        datapengumuman = (json.decode(response.body))['data'];
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  void _updateWelcomeMessage() async {
    DateTime currentTime = DateTime.now().toLocal();
    String greeting;
    int hour = currentTime.hour;
    if (hour < 12) {
      greeting = 'Pagi';
    } else if (hour < 18) {
      greeting = 'Siang';
    } else {
      greeting = 'Malam';
    }

    setState(() {
      _welcomeMessage = 'Selamat $greeting, ';
    });
  }

  void _logout() async {
    _showMyDialog(context);
  }

  @override
  Widget build(BuildContext context) {
    final gambarslide = Provider.of<Slide>(context, listen: false);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        toolbarHeight: 100,
        flexibleSpace: Image.asset(
          'assets/header2.jpg',
          fit: BoxFit.fill,
          height: 140,
        ),
      ),
      backgroundColor: Colors.transparent,
      body: Stack(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/40.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              // height: MediaQuery.of(context).size.height,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 150), // Spacer
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('$_welcomeMessage ',
                            style: TextStyle(
                                color: Color.fromARGB(255, 43, 101, 128),
                                fontWeight: FontWeight.w600,
                                fontSize: 18)),
                        Text('${nama?.toUpperCase()}!' ?? "Loading name...",
                            style: TextStyle(
                                color: Color.fromARGB(255, 16, 77, 126),
                                fontWeight: FontWeight.w600,
                                fontSize: 20)),
                      ],
                    ),
                    SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor:
                                    Color.fromARGB(255, 232, 235, 104),
                                minimumSize: Size(100, 70), // Ukuran tombol
                                shape: RoundedRectangleBorder(
                                  // Bentuk tombol
                                  borderRadius: BorderRadius.circular(
                                      15), // Kotak tanpa lengkungan
                                ),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20), // Padding horizontal
                              ),
                              onPressed: () async {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          AbsensikaryawanPage()),
                                );
                              },
                              child: Column(
                                mainAxisSize:
                                    MainAxisSize.min, // Agar Row tidak meregang
                                children: [
                                  Image.asset('assets/icon/attendance.png',
                                      width: 40, height: 40),
                                ],
                              ),
                            ),
                            Text("Absensi",
                                style: TextStyle(
                                    color: NowUIColors.black.withOpacity(0.8),
                                    fontSize: 15.0))
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor:
                                    Color.fromARGB(172, 0, 49, 155),
                                minimumSize: Size(100, 70), // Ukuran tombol
                                shape: RoundedRectangleBorder(
                                  // Bentuk tombol
                                  borderRadius: BorderRadius.circular(
                                      15), // Kotak tanpa lengkungan
                                ),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20), // Padding horizontal
                              ),
                              onPressed: () async {
                               
                                // showLoadingDialog(context);
                                // await Future.delayed(
                                //     Duration(milliseconds: 500));
                                // Navigator.of(context, rootNavigator: true)
                                //     .pop();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => TugasPage(karyawanId:karyawanId!)),
                                );
                              },
                              child: Column(
                                mainAxisSize:
                                    MainAxisSize.min, // Agar Row tidak meregang
                                children: [
                                  Image.asset('assets/icon/notebook.png',
                                      width: 40, height: 40),
                                  // Teks pada tombol
                                ],
                              ),
                            ),
                            Text("Tugas",
                                style: TextStyle(
                                    color: NowUIColors.black.withOpacity(0.8),
                                    fontSize: 15.0))
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Color.fromARGB(172, 255, 0, 0),
                                minimumSize: Size(100, 70), // Ukuran tombol
                                shape: RoundedRectangleBorder(
                                  // Bentuk tombol
                                  borderRadius: BorderRadius.circular(
                                      15), // Kotak tanpa lengkungan
                                ),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20), // Padding horizontal
                              ),
                              onPressed: () async {
                                var pengumuman = datapengumuman;
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PengumumanPage(
                                            tespengumuman: pengumuman,divisi: divisi!,
                                          )),
                                );
                              },
                              child: Column(
                                mainAxisSize:
                                    MainAxisSize.min, // Agar Row tidak meregang
                                children: [
                                  Image.asset('assets/icon/megaphone.png',
                                      width: 40, height: 40),
                                ],
                              ),
                            ),
                            Text("Pengumuman",
                                style: TextStyle(
                                    color: NowUIColors.black.withOpacity(0.8),
                                    fontSize: 15.0))
                          ],
                        )
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Color.fromARGB(172, 255, 0, 0),
                                minimumSize: Size(100, 70), // Ukuran tombol
                                shape: RoundedRectangleBorder(
                                  // Bentuk tombol
                                  borderRadius: BorderRadius.circular(
                                      15), // Kotak tanpa lengkungan
                                ),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20), // Padding horizontal
                              ),
                              onPressed: () async {
                                var berita = databerita;
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          BeritaPage(tesberita: berita)),
                                );
                              },
                              child: Column(
                                mainAxisSize:
                                    MainAxisSize.min, // Agar Row tidak meregang
                                children: [
                                  Image.asset('assets/icon/digital-news.png',
                                      width: 40, height: 40),
                                ],
                              ),
                            ),
                            Text("Berita",
                                style: TextStyle(
                                    color: NowUIColors.black.withOpacity(0.8),
                                    fontSize: 15.0))
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor:
                                    Color.fromARGB(255, 232, 235, 104),
                                minimumSize: Size(100, 70), // Ukuran tombol
                                shape: RoundedRectangleBorder(
                                  // Bentuk tombol
                                  borderRadius: BorderRadius.circular(
                                      15), // Kotak tanpa lengkungan
                                ),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20), // Padding horizontal
                              ),
                              onPressed: () async {
                                var berita = databerita;
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          BeritaPage(tesberita: berita)),
                                );
                              },
                              child: Column(
                                mainAxisSize:
                                    MainAxisSize.min, // Agar Row tidak meregang
                                children: [
                                  Image.asset('assets/icon/calendar.png',
                                      width: 40, height: 40),
                                ],
                              ),
                            ),
                            Text("Acara",
                                style: TextStyle(
                                    color: NowUIColors.black.withOpacity(0.8),
                                    fontSize: 15.0))
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor:
                                    Color.fromARGB(172, 0, 49, 155),
                                minimumSize: Size(100, 70), // Ukuran tombol
                                shape: RoundedRectangleBorder(
                                  // Bentuk tombol
                                  borderRadius: BorderRadius.circular(
                                      15), // Kotak tanpa lengkungan
                                ),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20), // Padding horizontal
                              ),
                              onPressed: _logout,
                              child: Column(
                                mainAxisSize:
                                    MainAxisSize.min, // Agar Row tidak meregang
                                children: [
                                  Image.asset('assets/icon/logout.png',
                                      width: 40, height: 40),
                                ],
                              ),
                            ),
                            Text("Logout",
                                style: TextStyle(
                                    color: NowUIColors.black.withOpacity(0.8),
                                    fontSize: 15.0))
                          ],
                        )
                      ],
                    ),
                    SizedBox(height: 40),

                    data.isEmpty
                        ? SizedBox.shrink()
                        : Container(
                            width: 360,
                            height: 150,
                            child: CarouselSlider.builder(
                              itemCount: data.length,
                              itemBuilder: (context, index, realIndex) {
                                final item = data[index];
                                return Builder(
                                  builder: (BuildContext context) {
                                    return GestureDetector(
                                      onTap: () {
                                        // var slide = databerita;
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => SlideDetailPage(
                                                    slide: item,
                                                  )),
                                        );
                                      },
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 5.0),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          border: Border.all(
                                            color:
                                                Color.fromARGB(255, 1, 47, 68),
                                            width: 2.0,
                                          ),
                                        ),
                                        child: Image.network(
                                            '$supabaseUrl/storage/v1/object/public/$supabaseBUCKET/foto-slide/${item['gambar']}',
                                            fit: BoxFit.fill),
                                      ),
                                    );
                                  },
                                );
                              },
                              options: CarouselOptions(
                                height: 400.0,
                                enlargeCenterPage: true,
                                autoPlay: true,
                                viewportFraction: 0.8,
                              ),
                            ),
                          ),
                    SizedBox(height: 10),
                    databerita.isEmpty
                        ? SizedBox.shrink()
                        : Padding(
                            padding: EdgeInsets.only(top: 32),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    var berita = databerita;
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => BeritaPage(
                                                tesberita: berita,
                                              )),
                                    );
                                  },
                                  child: Text(
                                    "Berita Terbaru",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20.0,
                                        color: NowUIColors.text),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    var berita = databerita;
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => BeritaPage(
                                                tesberita: berita,
                                              )),
                                    );
                                  },
                                  child: Text(
                                    "Selengkapnya...",
                                    style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 146, 142, 142),
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w600),
                                  ),
                                )
                              ],
                            )),
                    SizedBox(
                      height: 250,
                      child: GridView.builder(
                        primary: false,
                        padding: EdgeInsets.symmetric(
                            horizontal: 5.0, vertical: 15.0),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemCount: databerita.length,
                        itemBuilder: (context, index) {
                          final berita = databerita[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      BeritaDetailPage(berita: berita),
                                ),
                              );
                            },
                            child: Container(
                              height: 100,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(6.0)),
                                image: DecorationImage(
                                  image: NetworkImage(
                                      '$supabaseUrl/storage/v1/object/public/$supabaseBUCKET/berita-images/${berita['foto']}'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Container(
                                    color: Colors.black54,
                                    padding: EdgeInsets.all(6.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          formatTanggalIndonesia(
                                              berita['tanggalBerita']),
                                          style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 231, 209, 7),
                                            fontSize: 12.0,
                                          ),
                                        ),
                                        SizedBox(height: 2.0),
                                        Text(
                                          berita['judul'],
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16.0,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
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
