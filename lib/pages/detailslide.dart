import 'package:flutter/material.dart';
import 'package:hizramobile/constants/Theme.dart';
import 'package:intl/intl.dart';
import 'package:flutter_html/flutter_html.dart';

class SlideDetailPage extends StatelessWidget {
  final Map<String, dynamic> slide;

  SlideDetailPage({required this.slide});

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
        title: Text(slide['judul'],
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
         backgroundColor: Color.fromARGB(172, 0, 49, 155),
      ),
      backgroundColor: NowUIColors.bgColorScreen,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           
            Text(
              slide['judul'],
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 1.0),
             Container(
              width: double.infinity,
              height: 200,
              margin: EdgeInsets.only(top: 20),
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: NetworkImage(
                    '$supabaseUrl/storage/v1/object/public/$supabaseBUCKET/foto-slide/${slide['gambar']}',
                  ),
                ),
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }
}
