import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hizramobile/constants/Theme.dart';
import 'package:hizramobile/pages/detailberita.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:http/http.dart' as http;

class BeritaPage extends StatefulWidget {
  // const HomePage({super.key});
  final List<dynamic> tesberita;
  BeritaPage({required this.tesberita});
  // const BeritaPage({Key? key}) : super(key: key);
  final _BeritaPageState BeritaState = _BeritaPageState();
  @override
  _BeritaPageState createState() => _BeritaPageState();
}

class _BeritaPageState extends State<BeritaPage> {
  final supabaseUrl = 'https://harkcrbmtskvtiboutxl.supabase.co';
  final supabaseKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImhhcmtjcmJtdHNrdnRpYm91dHhsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTczODY4MTgsImV4cCI6MjAzMjk2MjgxOH0.Oa2dnHnpsJbQviB4fNdIdwSxJgYR8BUS-Nd1VQWg7LY';
  final supabaseBUCKET = 'uploadfile';
  List databerita = [];

  void initState() {
    super.initState();
    initializeDateFormatting('id_ID', null).then((_) {
      // getDataBerita();
    });
  }

  String formatTanggalIndonesia(String tanggal) {
    DateTime dateTime = DateTime.parse(tanggal);
    return DateFormat("d MMMM yyyy", "id_ID").format(dateTime);
  }

  // Future<void> getDataBerita() async {
  //   final response = await http
  //       .get(Uri.parse('https://kantorhizratech.vercel.app/api/mobile/berita'));

  //   if (response.statusCode == 200) {
  //     setState(() {
  //       databerita = (json.decode(response.body));
  //     });
  //   } else {
  //     throw Exception('Failed to load data');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: Text('Berita',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
           backgroundColor: Color.fromRGBO(18, 81, 89, 1),
        ),
        backgroundColor: Colors.transparent,
        body: Stack(
          children: <Widget>[
            Column(
              children: [
                Flexible(
                  flex: 1,
                  child: Container(
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage("assets/17.jpg"),
                              fit: BoxFit.cover)),
                      child: Stack(
                        children: <Widget>[
                          SafeArea(
                            bottom: false,
                            right: false,
                            left: false,
                            top: false,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 0, right: 0),
                              child: ListView.builder(
                                // itemCount: databerita.length,
                                itemCount: widget.tesberita.length,
                                itemBuilder: (context, index) {
                                  // var berita = databerita[index];
                                  var berita = widget.tesberita[index];
                                  return SingleChildScrollView(
                                    child: Container(
                                      margin: EdgeInsets.symmetric(
                                        vertical: 5,
                                        horizontal: 10,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black26,
                                            blurRadius: 4,
                                            offset: Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: ListTile(
                                        contentPadding: EdgeInsets.symmetric(
                                          vertical: 10,
                                          horizontal: 8,
                                        ),
                                        title: Text(
                                          berita['judul'],
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        leading: Container(
                                          width: 50,
                                          height: 50,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.rectangle,
                                            image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: NetworkImage(
                                                '$supabaseUrl/storage/v1/object/public/$supabaseBUCKET/berita-images/${berita['foto']}',
                                              ),
                                            ),
                                          ),
                                        ),
                                        trailing: Text(
                                          formatTanggalIndonesia(
                                              berita['tanggalBerita']),
                                        ),
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  BeritaDetailPage(
                                                berita: berita,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  );
                                },
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
