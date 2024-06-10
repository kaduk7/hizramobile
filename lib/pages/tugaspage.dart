import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:hizramobile/constants/Theme.dart';
import 'package:hizramobile/pages/detailberita.dart';
import 'package:hizramobile/pages/detailtugas.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:http/http.dart' as http;

class TugasPage extends StatefulWidget {
  final int karyawanId;
  TugasPage({required this.karyawanId});
  @override
  _TugasPageState createState() => _TugasPageState();
}

class _TugasPageState extends State<TugasPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  List datatugas = [];
  bool _isLoading = false;

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
    setState(() {
      _isLoading = true;
    });
    final response = await http
        .get(Uri.parse('https://kantorhizratech.vercel.app/api/mobile/tugas'));
    if (mounted) {
      setState(() {
        datatugas = (json.decode(response.body));
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> filteredTugas = datatugas
        .where((tugas) =>
            tugas['status'] == 'Proses' &&
            tugas['karyawanId'] == widget.karyawanId)
        .toList();
    List<dynamic> filteredTugasVerifikasi = datatugas
        .where((tugas) =>
            tugas['status'] == 'Verifikasi' &&
            tugas['karyawanId'] == widget.karyawanId)
        .toList();
    List<dynamic> filteredTugasSelesai = datatugas
        .where((tugas) =>
            tugas['status'] == 'Selesai' &&
            tugas['karyawanId'] == widget.karyawanId)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Tugas Saya',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Color.fromRGBO(18, 81, 89, 1),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: Colors.white,
          indicatorColor: Colors.black,
          unselectedLabelColor: Colors.black,
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
          Stack(
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
                                ? Center(child: CircularProgressIndicator())
                                : filteredTugas.isEmpty
                                    ? Center(
                                        child: AnimatedContainer(
                                          duration: Duration(milliseconds: 500),
                                          width: 200,
                                          height: 200,
                                          child: Image.asset('assets/hhh.gif'),
                                        ),
                                      )
                                    : ListView.builder(
                                        itemCount: filteredTugas.length,
                                        itemBuilder: (context, index) {
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
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                  vertical: 10,
                                                  horizontal: 8,
                                                ),
                                                title: Text(
                                                  tugas['namaJob'],
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                subtitle: Text(
                                                  tugas['keterangan'],
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                trailing: Text(
                                                  tugas['status'],
                                                ),
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          TugasDetailPage(
                                                        tugas: tugas,
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
          ),
          Stack(
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
                                ? Center(child: CircularProgressIndicator())
                                : filteredTugasVerifikasi.isEmpty
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
                                        itemCount:
                                            filteredTugasVerifikasi.length,
                                        // itemCount: widget.slide.length,
                                        itemBuilder: (context, index) {
                                          // var berita = databerita[index];
                                          var tugas =
                                              filteredTugasVerifikasi[index];
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
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                  vertical: 10,
                                                  horizontal: 8,
                                                ),
                                                title: Text(
                                                  tugas['namaJob'],
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                subtitle: Text(
                                                  tugas['keterangan'],
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                trailing: Text(
                                                  tugas['status'],
                                                ),
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          TugasDetailPage(
                                                        tugas: tugas,
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
          ),
          Stack(
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
                                ? Center(child: CircularProgressIndicator())
                                : filteredTugasSelesai.isEmpty
                                    ? Center(
                                        child: AnimatedContainer(
                                          duration: Duration(milliseconds: 500),
                                          width: 200,
                                          height: 200,
                                          child: Image.asset('assets/hhh.gif'),
                                        ),
                                      )
                                    : ListView.builder(
                                        itemCount: filteredTugasSelesai.length,
                                        itemBuilder: (context, index) {
                                          var tugas =
                                              filteredTugasSelesai[index];
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
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                  vertical: 10,
                                                  horizontal: 8,
                                                ),
                                                title: Text(
                                                  tugas['namaJob'],
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                subtitle: Text(
                                                  tugas['keterangan'],
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                trailing: Text(
                                                  tugas['status'],
                                                  style: TextStyle(
                                                    color: tugas['status']
                                                                .toLowerCase() ==
                                                            'Proses'
                                                        ? Colors.green
                                                        : tugas['status']
                                                                    .toLowerCase() ==
                                                                'verifikasi'
                                                            ? Colors.orange
                                                            : Colors.blue,
                                                  ),
                                                ),
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          TugasDetailPage(
                                                        tugas: tugas,
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
          ),
        ],
      ),
    );
  }
}
