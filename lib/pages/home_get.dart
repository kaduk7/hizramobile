import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hizramobile/models/get.dart';
import 'package:provider/provider.dart';

class HomeGet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<Get>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text("GET "),
      ),
      body: Container(
        width: double.infinity,
        margin: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Container(
                height: 100,
                width: 100,
                
                
              ),
            ),
            SizedBox(height: 20),
            FittedBox(
              child: Consumer<Get>(
                builder: (context, value, child) => Text(
                  (value.data["id"] == null)
                      ? "ID : Belum ada data"
                      : "ID : ${value.data["id"]}",
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
            SizedBox(height: 20),
            FittedBox(child: Text("Judul : ", style: TextStyle(fontSize: 20))),
            FittedBox(
              child: Consumer<Get>(
                builder: (context, value, child) => Text(
                 (value.data["judul"] == null)
                      ? "Belum ada data"
                      : "${value.data["judul"]}",
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
            SizedBox(height: 20),
            FittedBox(child: Text("Isi : ", style: TextStyle(fontSize: 20))),
            FittedBox(
              child: Consumer<Get>(
                builder: (context, value, child) => Text(
                  (value.data["isi"] == null)
                      ? "Belum ada data"
                      : value.data["isi"],
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
            SizedBox(height: 100),
            OutlinedButton(
              onPressed: () {
                dataProvider.connectAPI((1 + Random().nextInt(10)).toString());
              },
              child: Text(
                "GET DATA",
                style: TextStyle(
                  fontSize: 25,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
