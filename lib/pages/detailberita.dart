import 'package:flutter/material.dart';
import 'package:hizramobile/constants/Theme.dart';
import 'package:intl/intl.dart';
import 'package:flutter_html/flutter_html.dart';

class BeritaDetailPage extends StatelessWidget {
  final Map<String, dynamic> berita;

  BeritaDetailPage({required this.berita});

  String formatTanggalIndonesia(String tanggal) {
    DateTime dateTime = DateTime.parse(tanggal);
    return DateFormat("d MMMM yyyy", "id_ID").format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    final supabaseUrl = 'https://harkcrbmtskvtiboutxl.supabase.co';
    final supabaseBUCKET = 'uploadfile';

    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Berita',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          backgroundColor: Color.fromRGBO(18, 81, 89, 1),
      ),
      backgroundColor: NowUIColors.bgColorScreen,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(
                    '$supabaseUrl/storage/v1/object/public/$supabaseBUCKET/berita-images/${berita['foto']}',
                  ),
                ),
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              berita['judul'],
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(
              formatTanggalIndonesia(berita['tanggalBerita']),
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: 1.0),
            Html(
              data: berita['isi'], // Menggunakan HTML dari data yang diberikan
              style: {
                "html": Style(
                  fontSize: FontSize(16.0), // Mengatur ukuran font
                ),
              },
            ),
          ],
        ),
      ),
    );
  }
}
