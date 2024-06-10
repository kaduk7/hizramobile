import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:hizramobile/constants/Theme.dart';
import 'package:intl/intl.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../models/download.dart';
import 'package:permission_handler/permission_handler.dart';

class TugasDetailPage extends StatelessWidget {
  final Map<String, dynamic> tugas;

  TugasDetailPage({required this.tugas});

  String formatTanggalIndonesia(String tanggal) {
    DateTime dateTime = DateTime.parse(tanggal);
    return DateFormat("d MMMM yyyy", "id_ID").format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    Future<void> downloadFile(String url, String fileName) async {
      Dio dio = Dio();

      try {
        // Dapatkan direktori dokumen aplikasi
        Directory appDocDir = await getApplicationDocumentsDirectory();
        String savePath = '${appDocDir.path}/$fileName';

        // Mulai unduhan file
        await dio.download(
          url,
          savePath,
        );

        // Tampilkan pesan jika unduhan berhasil
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('File berhasil diunduh!'),
            duration: Duration(seconds: 2),
          ),
        );
      } catch (e) {
        // Tampilkan pesan jika terjadi kesalahan saat mengunduh file
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Terjadi kesalahan saat mengunduh file!'),
            duration: Duration(seconds: 2),
          ),
        );
        print('Error downloading file: $e');
      }
    }

    final supabaseUrl = 'https://harkcrbmtskvtiboutxl.supabase.co';
    final supabaseBUCKET = 'uploadfile';

    var namaTeamList = jsonDecode(tugas['namaTeam']) as List<dynamic>;
    var namaTeam = namaTeamList.isNotEmpty ? namaTeamList[0]['label'] : 'N/A';

    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Tugas',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Color.fromRGBO(18, 81, 89, 1),
      ),
      backgroundColor: NowUIColors.bgColorScreen,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    'Nama Tugas',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    ':',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    tugas['namaJob'],
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.0),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    'Keterangan',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    ':',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    tugas['keterangan'],
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.0),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    'Tanggal Mulai',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    ':',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    formatTanggalIndonesia(tugas['tanggalMulai']),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.0),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    'Deadline',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    ':',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    formatTanggalIndonesia(tugas['deadline']),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.0),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    'Nama team',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    ':',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    namaTeam,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.0),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    'Status',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    ':',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    tugas['status'],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: tugas['status'].toLowerCase() == 'proses'
                          ? Colors.green
                          : tugas['status'].toLowerCase() == 'verifikasi'
                              ? Colors.orange
                              : Colors.blue,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.0),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    'Surat Tugas',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    ':',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    tugas['suratTugas'],
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.0),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    'Berita Acara',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    ':',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    tugas['beritaAcara'],
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.0),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    'Laporan Anggaran',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    ':',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    tugas['laporanAnggaran'],
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30.0),
            tugas['status'].toLowerCase() == "selesai"
                ? SizedBox(height: 30.0)
                : Center(
                    child: ElevatedButton(
                      onPressed: () {
                        String fileUrl =
                            'https://harkcrbmtskvtiboutxl.supabase.co/storage/v1/object/public/uploadfile/foto-slide/1717488247305-4.jpg';
                        String fileName = 'samplefile.jpg';
                        downloadFile(fileUrl, fileName);
                      },
                      child: Text('Konfirmasi Selesai'),
                    ),
                  ),
            // SizedBox(height: 100.0),
            // if (notifier.isDownloading)
            //   CircularProgressIndicator()
            // else
            //   ElevatedButton(
            //     onPressed: () {
            //       notifier.downloadFile(
            //         'https://harkcrbmtskvtiboutxl.supabase.co/storage/v1/object/public/uploadfile/foto-slide/1717488247305-4.jpg',
            //         'yourfile.pdf',
            //       );
            //     },
            //     child: Text('Download File'),
            //   ),
            // SizedBox(height: 20),
            // Text(notifier.status),
          ],
        ),
      ),
    );
  }
}
