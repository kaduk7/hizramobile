import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hizramobile/constants/Theme.dart';
import 'package:hizramobile/pages/detailberita.dart';
import 'package:hizramobile/pages/detailpengumuman.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_html/flutter_html.dart';

class PengumumanPage extends StatefulWidget {
  // const PengumumanPage({Key? key}) : super(key: key);
  final List<dynamic> tespengumuman;
  final String divisi;
  PengumumanPage({required this.tespengumuman,required this.divisi});
  @override
  _PengumumanPageState createState() => _PengumumanPageState();
}

class _PengumumanPageState extends State<PengumumanPage> {
  final supabaseUrl = 'https://harkcrbmtskvtiboutxl.supabase.co';
  final supabaseKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImhhcmtjcmJtdHNrdnRpYm91dHhsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTczODY4MTgsImV4cCI6MjAzMjk2MjgxOH0.Oa2dnHnpsJbQviB4fNdIdwSxJgYR8BUS-Nd1VQWg7LY';
  final supabaseBUCKET = 'uploadfile';
  List datapengumuman = [];

  void initState() {
    super.initState();
    initializeDateFormatting('id_ID', null).then((_) {
      // getDatapengumuman();
    });
  }

  String formatTanggalIndonesia(String tanggal) {
    DateTime dateTime = DateTime.parse(tanggal);
    return DateFormat("d MMMM yyyy", "id_ID").format(dateTime);
  }

  // Future<void> getDatapengumuman() async {
  //   final response = await http.get(
  //       Uri.parse('https://kantorhizratech.vercel.app/api/mobile/pengumuman'));

  //   if (response.statusCode == 200) {
  //     setState(() {
  //       datapengumuman = (json.decode(response.body))['data'];
  //     });
  //   } else {
  //     throw Exception('Failed to load data');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    List<dynamic> filteredTugas = widget.tespengumuman
        .where((pengumuman) => pengumuman['divisi']
            .toString()
            .toLowerCase()
            .contains(widget.divisi.toLowerCase()))
        .toList();
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: Text('Pengumuman',
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
                              padding: const EdgeInsets.only(left: 0, right: 0),
                              child: ListView.builder(
                                // itemCount: widget.tespengumuman.length,
                                itemCount: filteredTugas.length,
                                itemBuilder: (context, index) {
                                  // var pengumuman = widget.tespengumuman[index];
                                  var pengumuman = filteredTugas[index];

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
                                          pengumuman['judul'],
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              color: NowUIColors.black
                                                  .withOpacity(0.8),
                                              fontSize: 20.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        leading: Container(
                                          width: 30,
                                          height: 30,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.rectangle,
                                            image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: AssetImage(
                                                'assets/icon/megaphone.png',
                                              ),
                                            ),
                                          ),
                                        ),
                                        trailing: Text(
                                          formatTanggalIndonesia(
                                              pengumuman['tanggalPengumuman']),
                                        ),
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  PengumumanDetailPage(
                                                pengumuman: pengumuman,
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
