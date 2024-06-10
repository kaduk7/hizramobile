import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class DownloadNotifier extends ChangeNotifier {
  bool _isDownloading = false;
  String _status = 'Ready to download';

  bool get isDownloading => _isDownloading;
  String get status => _status;

 Future<void> downloadFile(String url, String filename) async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      if (await Permission.storage.request().isGranted) {
        _startDownload(url, filename);
      } else {
        _status = 'Permission denied';
        notifyListeners();
      }
    } else {
      _startDownload(url, filename);
    }
  }

  Future<void> _startDownload(String url, String filename) async {
    _isDownloading = true;
    _status = 'Downloading...';
    notifyListeners();

    try {
      final response = await http.get(Uri.parse(url));
      print('HTTP response status: ${response.statusCode}');
      if (response.statusCode == 200) {
        final directory = await getApplicationDocumentsDirectory();
        print('Directory: ${directory.path}');
        final filePath = '${directory.path}/$filename';
        print('Saving file to: $filePath');

        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);

        _status = 'Download complete: $filePath';
      } else {
        _status = 'Error: Failed to download file with status code: ${response.statusCode}';
      }
    } catch (e) {
      _status = 'Error: $e';
      print('Error: $e');
    } finally {
      _isDownloading = false;
      notifyListeners();
    }
  }
}
