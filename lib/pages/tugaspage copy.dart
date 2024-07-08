import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:hizramobile/constants/Theme.dart';
import 'package:hizramobile/pages/detailberita.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:http/http.dart' as http;

class TugasPage extends StatefulWidget {
  // const HomePage({super.key});
  // final List<dynamic> tesberita;
  // BeritaPage({required this.tesberita});
  const TugasPage({Key? key}) : super(key: key);
  @override
  _TugasPageState createState() => _TugasPageState();
}

class _TugasPageState extends State<TugasPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  List datatugas = [];

  @override
  void initState() {
    super.initState();
    getDatatugas();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> getDatatugas() async {
    final response = await http
        .get(Uri.parse('https://kantorhizratech.vercel.app/api/mobile/tugas'));

    if (response.statusCode == 200) {
      setState(() {
        datatugas = (json.decode(response.body));
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tugas Saya',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Color.fromARGB(172, 0, 49, 155),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: Colors.white,
          tabs: [
            Tab(text: 'Belum Dikerjakan'),
            Tab(text: 'Verifikasi Tugas'),
            Tab(text: 'Selesai'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          TugasOngoing(
            datatugas: datatugas,
          ),
          Request(
            datatugas: datatugas,
          ),
          Selesai(
            datatugas: datatugas,
          ),
        ],
      ),
    );
  }
}

class TugasOngoing extends StatelessWidget {
  final List<dynamic> datatugas;
  TugasOngoing({required this.datatugas});
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {

    List<dynamic> filteredTugas =
        datatugas.where((tugas) => tugas['status'] == 'Proses').toList();
    return Stack(
      children: <Widget>[
        Column(
          children: [
            Flexible(
              flex: 1,
              child: Container(
                  child: Stack(
                children: <Widget>[
                  SafeArea(
                    bottom: false,
                    right: false,
                    left: false,
                    top: false,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 0, right: 0),
                      child: _isLoading
                          ? CircularProgressIndicator()
                          : filteredTugas.isEmpty
                              ? Center(
                                  child: AnimatedContainer(
                                    duration: Duration(milliseconds: 500),
                                    width: 200,
                                    height: 200,
                                    child: Image.asset(
                                        'assets/hhh.gif'), // Placeholder gambar
                                  ),
                                )
                              : ListView.builder(
                                  itemCount: filteredTugas.length,
                                  // itemCount: widget.slide.length,
                                  itemBuilder: (context, index) {
                                    // var berita = databerita[index];
                                    var tugas = filteredTugas[index];
                                    return SingleChildScrollView(
                                      child: Container(
                                        margin: EdgeInsets.symmetric(
                                          vertical: 5,
                                          horizontal: 10,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10),
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
                                            tugas['namaJob'],
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          subtitle: Text(
                                            tugas['keterangan'],
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          // leading: Container(
                                          //   width: 50,
                                          //   height: 50,
                                          //   decoration: BoxDecoration(
                                          //     shape: BoxShape.rectangle,
                                          //     image: DecorationImage(
                                          //       fit: BoxFit.cover,
                                          //       image: NetworkImage(
                                          //         '$supabaseUrl/storage/v1/object/public/$supabaseBUCKET/berita-images/${berita['foto']}',
                                          //       ),
                                          //     ),
                                          //   ),
                                          // ),
                                          trailing: Text(
                                            tugas['status'],
                                          ),

                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    BeritaDetailPage(
                                                  berita: tugas,
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
    );
  }
}

class Request extends StatelessWidget {
  final List<dynamic> datatugas;

  Request({required this.datatugas});
  @override
  Widget build(BuildContext context) {
    List<dynamic> filteredTugas =
        datatugas.where((tugas) => tugas['status'] == 'Verifikasi').toList();
    return Stack(
      children: <Widget>[
        Column(
          
          children: [
            Flexible(
              flex: 1,
              child: Container(
                  child: Stack(
                children: <Widget>[
                  SafeArea(
                    bottom: false,
                    right: false,
                    left: false,
                    top: false,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 0, right: 0),
                      child: filteredTugas.isEmpty
                          ? Center(
                              child: AnimatedContainer(
                                duration: Duration(milliseconds: 500),
                                width: 200,
                                height: 200,
                                child: Image.asset(
                                    'assets/hhh.gif'), // Placeholder gambar
                              ),
                            )
                          : ListView.builder(
                              itemCount: filteredTugas.length,
                              // itemCount: widget.slide.length,
                              itemBuilder: (context, index) {
                                // var berita = databerita[index];
                                var tugas = filteredTugas[index];
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
                                        tugas['namaJob'],
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      subtitle: Text(
                                        tugas['keterangan'],
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      // leading: Container(
                                      //   width: 50,
                                      //   height: 50,
                                      //   decoration: BoxDecoration(
                                      //     shape: BoxShape.rectangle,
                                      //     image: DecorationImage(
                                      //       fit: BoxFit.cover,
                                      //       image: NetworkImage(
                                      //         '$supabaseUrl/storage/v1/object/public/$supabaseBUCKET/berita-images/${berita['foto']}',
                                      //       ),
                                      //     ),
                                      //   ),
                                      // ),
                                      trailing: Text(
                                        tugas['status'],
                                      ),

                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                BeritaDetailPage(
                                              berita: tugas,
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
    );
  }
}

class Selesai extends StatelessWidget {
  final List<dynamic> datatugas;

  Selesai({required this.datatugas});
  @override
  Widget build(BuildContext context) {
    List<dynamic> filteredTugas =
        datatugas.where((tugas) => tugas['status'] == 'Selesai').toList();
    return Stack(
      children: <Widget>[
        Column(
          children: [
            Flexible(
              flex: 1,
              child: Container(
                  child: Stack(
                children: <Widget>[
                  SafeArea(
                    bottom: false,
                    right: false,
                    left: false,
                    top: false,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 0, right: 0),
                      child: filteredTugas.isEmpty
                          ? Center(
                              child: AnimatedContainer(
                                duration: Duration(milliseconds: 500),
                                width: 200,
                                height: 200,
                                child: Image.asset(
                                    'assets/hhh.gif'), // Placeholder gambar
                              ),
                            )
                          : ListView.builder(
                              itemCount: filteredTugas.length,
                              // itemCount: widget.slide.length,
                              itemBuilder: (context, index) {
                                // var berita = databerita[index];
                                var tugas = filteredTugas[index];
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
                                        tugas['namaJob'],
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      subtitle: Text(
                                        tugas['keterangan'],
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      // leading: Container(
                                      //   width: 50,
                                      //   height: 50,
                                      //   decoration: BoxDecoration(
                                      //     shape: BoxShape.rectangle,
                                      //     image: DecorationImage(
                                      //       fit: BoxFit.cover,
                                      //       image: NetworkImage(
                                      //         '$supabaseUrl/storage/v1/object/public/$supabaseBUCKET/berita-images/${berita['foto']}',
                                      //       ),
                                      //     ),
                                      //   ),
                                      // ),
                                      trailing: Text(
                                        tugas['status'],
                                      ),

                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                BeritaDetailPage(
                                              berita: tugas,
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
    );
  }
}
