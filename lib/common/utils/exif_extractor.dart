import 'dart:io';

import 'package:exif/exif.dart';

class ExifExtractor {
  static Future getInfo(List<String> arguments) async {
    for (final filename in arguments) {
      print("read $filename ..");

      final fileBytes = File(filename).readAsBytesSync();
      final data = await readExifFromBytes(fileBytes);

      if (data.isEmpty) {
        print("No EXIF information found");
        return;
      }
      if (data.containsKey('JPEGThumbnail')) {
        print('File has JPEG thumbnail');
        data.remove('JPEGThumbnail');
      }
      if (data.containsKey('TIFFThumbnail')) {
        print('File has TIFF thumbnail');
        data.remove('TIFFThumbnail');
      }

      // for (final entry in data.entries) {
      // print("${entry.key}");
      // print("${entry.value}");
      // print('tagType: ${entry.value.tagType}');
      // print('value.toString: ${entry.value.toString()}');
      // }
    }
  }

  static Future<String?> getDate(String file) async {
    final fileBytes = File(file).readAsBytesSync();
    final data = await readExifFromBytes(fileBytes);

    if (data.isEmpty) {
      print("No EXIF information found");
      return null;
    }
    if (data.containsKey('JPEGThumbnail')) {
      print('File has JPEG thumbnail');
      data.remove('JPEGThumbnail');
    }
    if (data.containsKey('TIFFThumbnail')) {
      print('File has TIFF thumbnail');
      data.remove('TIFFThumbnail');
    }

    final dateTimeOriginal = data['EXIF DateTimeOriginal']?.printable;
    final dateTimeDigitized = data['EXIF DateTimeDigitized']?.printable;
    final dateTime = data['Image DateTime']?.printable;

    return dateTimeOriginal ?? dateTimeDigitized ?? dateTime;
  }
}
