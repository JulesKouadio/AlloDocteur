import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:dio/dio.dart';


class ImageDownloader {
  final String imageUrl;
  final String fileName;

  ImageDownloader({required this.imageUrl, required this.fileName});

  Future<String> _getLocalPath() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> _getLocalFile() async {
    final path = await _getLocalPath();
    return File('$path/$fileName');
  }

  Future<File> downloadImage() async {
    final file = await _getLocalFile();
    if (await file.exists()) {
      return file;
    } else {
      final response = await Dio().get(
        imageUrl,
        options: Options(responseType: ResponseType.bytes),
      );
      return file.writeAsBytes(response.data);
    }
  }
}
