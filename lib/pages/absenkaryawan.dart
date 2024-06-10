import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hizramobile/constants/Theme.dart';
import 'package:hizramobile/models/lokasi.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/http_login.dart';
import '../widgets/navbar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class AbsensikaryawanPage extends StatefulWidget {
  const AbsensikaryawanPage({Key? key}) : super(key: key);
  @override
  _AbsensikaryawanState createState() => _AbsensikaryawanState();
}

class _AbsensikaryawanState extends State<AbsensikaryawanPage> {
  String? _filePath;

  Future<void> _pickFile() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      // Meminta izin membaca penyimpanan eksternal
      await Permission.storage.request();
      // Periksa kembali status izin setelah permintaan
      status = await Permission.storage.status;
      if (!status.isGranted) {
        // Izin ditolak, beri tahu pengguna
         ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Terjadi kesalahan saat mengunduh file!'),
            duration: Duration(seconds: 2),
          ),
        );
        return ;
      }
    }

    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        _filePath = result.files.single.path!;
      });
    } else {
      // User canceled the picker
    }
  }

  int? karyawanId;
  bool isWithinRange = false;

  void initState() {
    super.initState();
    loadlokasi();
  }

  bool _isLoading = false;
  bool _isLoadinglokasi = false;

  void loadlokasi() async {
    setState(() {
      _isLoadinglokasi = true;
    });
    bool xxx = await checkLocation();

    if (mounted) {
      setState(() {
        isWithinRange = xxx;
        _isLoadinglokasi = false;
      });
    }
  }

  void handlePresensi(String keterangan) async {
    setState(() {
      _isLoading = true;
    });
    bool isWithinRange = await checkLocation();
    final details = await Provider.of<HttpLogin>(context, listen: false)
        .getKaryawanDetails();
    if (details != null) {
      setState(() {
        karyawanId = details['karyawanId'];
      });
    }
    print('karyawanId: $karyawanId');
    if (isWithinRange) {
      var response = await http.post(
        Uri.parse('https://kantorhizratech.vercel.app/api/mobile/absen'),
        // headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'karyawanId': karyawanId,
          'keterangan': keterangan,
        }),
      );
      print(response.body);
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Presensi berhasil')));
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Berhasil"),
              content: Text("Anda berhasil absen $keterangan"),
              actions: <Widget>[
                TextButton(
                  child: Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Gagal menyimpan data')));
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Absensi Gagal"),
              content: Text("Ada kesalahan"),
              actions: <Widget>[
                TextButton(
                  child: Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Anda tidak berada dalam radius yang diizinkan')));
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Absensi Gagal"),
            content: Text("Anda tidak berada dalam radius yang diizinkan"),
            actions: <Widget>[
              TextButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop(); // Menutup dialog
                },
              ),
            ],
          );
        },
      );
    }
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: Text('Presensi',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          backgroundColor: Color.fromRGBO(18, 81, 89, 1),
        ),
        backgroundColor: NowUIColors.bgColorScreen,
        body: Stack(
          children: <Widget>[
            Column(
              children: [
                Flexible(
                  flex: 1,
                  child: Container(
                      margin: EdgeInsets.only(top: 30),
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage("assets/bgabsen1.jpg"),
                              fit: BoxFit.cover)),
                      child: Stack(
                        children: <Widget>[
                          SafeArea(
                            bottom: false,
                            right: false,
                            left: false,
                            top: false,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 0, right: 0, top: 80.0),
                              child: Column(
                                children: [
                                  Container(
                                    width: 360,
                                    height: 320,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage("assets/maps.png"),
                                        fit: BoxFit.cover,
                                      ),
                                      borderRadius: BorderRadius.circular(0),
                                      border: Border.all(
                                        color: Colors.blue,
                                        width: 2.0,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: _isLoadinglokasi
                                        ? CircularProgressIndicator()
                                        : Text(
                                            isWithinRange == false
                                                ? 'Anda tidak berada dalam radius yang diizinkan'
                                                : "Anda dalam radius yang diizinkan, Silahkan Melakukan Absensi",
                                            style: TextStyle(
                                              fontSize: 20,
                                              color: isWithinRange == false
                                                  ? Colors.red
                                                  : Color.fromARGB(
                                                      255, 10, 119, 14),
                                            ),
                                          ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 42, right: 32),
                                    child: Center(
                                      child: _isLoading
                                          ? CircularProgressIndicator()
                                          : Row(
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
                                                                255, 1, 47, 68),
                                                        minimumSize: Size(130,
                                                            60), // Ukuran tombol
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          // Bentuk tombol
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  10), // Kotak tanpa lengkungan
                                                        ),
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal:
                                                                    20), // Padding horizontal
                                                      ),
                                                      onPressed: () =>
                                                          handlePresensi(
                                                              'Masuk'),
                                                      child: Column(
                                                        mainAxisSize: MainAxisSize
                                                            .min, // Agar Row tidak meregang
                                                        children: [
                                                          Icon(
                                                            Icons.how_to_reg,
                                                            size: 40,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Text("Absen Masuk",
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
                                                                255, 1, 47, 68),
                                                        minimumSize:
                                                            Size(130, 60),
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 20),
                                                      ),
                                                      onPressed: () =>
                                                          handlePresensi(
                                                              'Pulang'),
                                                      child: Column(
                                                        mainAxisSize: MainAxisSize
                                                            .min, // Agar Row tidak meregang
                                                        children: [
                                                          Icon(
                                                            Icons
                                                                .directions_walk,
                                                            size: 40,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Text("Absen Pulang",
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
                                  ),
                                  ElevatedButton(
                                    onPressed: _pickFile,
                                    child: Text('Choose File'),
                                  ),
                                  SizedBox(height: 20),
                                  if (_filePath != null)
                                    Text('File Path: $_filePath')
                                  else
                                    Text('No file selected'),
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
