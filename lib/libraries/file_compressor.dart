import 'dart:io';

import 'package:flutter/foundation.dart';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import 'package:app/extensions/flutter_ext.dart';

class FileCompressor {
  Future<List<File>> compressMultipleFileImage({required List<File> files, int maxMB = 4}) async {
    List<File> images = [];
    if (!files.haveList) return images;
    for (File item in files) {
      var image = await _compressFileImage(image: item, maxMB: maxMB);
      if (image != null) images.add(image);
    }
    return images;
  }

  Future<File?> _compressFileImage({required File image, int maxMB = 4}) async {
    int originalInBytes = await image.length();
    int originalInKB = originalInBytes ~/ 1024;
    if (kDebugMode) print('original: $originalInKB');
    if (originalInKB <= (1024 * maxMB)) return image;

    String directoryPath = await _getDirectoryPath();
    String fileName = '${path.basenameWithoutExtension(image.path)}_compressed.jpg';
    String targetPath = path.join(directoryPath, fileName);
    return _compressByQuality(image: image, targetPath: targetPath, maxMB: maxMB);
  }

  Future<File?> _compressByQuality({required File image, required String targetPath, int maxMB = 4}) async {
    var imageFile = File(''); // must be less than 4mb or maxMB
    for (int quality = 0; quality <= 100; quality = quality + 10) {
      var compressed = await FlutterImageCompress.compressAndGetFile(image.absolute.path, targetPath, quality: 100 - quality);
      if (compressed != null && await compressed.length() <= (1024 * 1024) * maxMB) {
        imageFile = File(compressed.path);
        break;
      }
    }
    return imageFile;
  }

  Future<File> compressFileImage({required File image, int maxMB = 4}) async {
    int originalInBytes = await image.length();
    int originalInKB = originalInBytes ~/ 1024;
    if (kDebugMode) print('original: $originalInKB');
    if (originalInKB <= (1024 * maxMB)) return image;

    String directoryPath = await _getDirectoryPath();
    String fileName = '${path.basenameWithoutExtension(image.path)}_compressed.jpg';
    String targetPath = path.join(directoryPath, fileName);

    var imageFile = File(''); // must be less than 4mb or maxMB
    for (int quality = 0; quality <= 100; quality = quality + 10) {
      var compressed = await FlutterImageCompress.compressAndGetFile(image.absolute.path, targetPath, quality: 100 - quality);
      if (compressed != null && await compressed.length() <= (1024 * 1024) * maxMB) {
        imageFile = File(compressed.path);
        break;
      }
    }

    if (kDebugMode) {
      int compressedInBytes = await imageFile.length();
      int compressedInKB = compressedInBytes ~/ 1024;
      print('compressed: $compressedInKB');
      print('Original file size: ${image.lengthSync()} bytes');
      print('Compressed file size: ${imageFile.lengthSync()} bytes');
    }

    return imageFile.path.isEmpty ? image : imageFile;
  }

  Future<String> _getDirectoryPath() async {
    final directory = await getTemporaryDirectory();
    return directory.path;
  }

  Future<Uint8List> compressMemoryImage({required Uint8List byteList, int maxMB = 4}) async {
    int originalInBytes = byteList.length;
    int originalInKB = (originalInBytes / 1024).toInt();
    if (originalInKB <= (1024 * maxMB)) return byteList;
    Uint8List? convertedList;
    for (int quality = 0; quality <= 100; quality = quality + 10) {
      var compressed = await FlutterImageCompress.compressWithList(byteList, quality: 100 - quality);
      if (compressed.isNotEmpty && compressed.length <= (1024 * 1024) * maxMB) {
        convertedList = compressed;
        break;
      }
    }
    return convertedList ?? byteList;
  }
}
