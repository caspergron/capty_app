import 'dart:async';
import 'dart:io' as io;
import 'dart:io';
import 'dart:ui' as ui;

import 'package:app/di.dart';
import 'package:app/helpers/file_helper.dart';
import 'package:app/libraries/file_compressor.dart';
import 'package:app/libraries/image_croppers.dart';
import 'package:app/models/system/doc_file.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';

class ImageService {
  Future<Uint8List?> fileToUnit8List(io.File file) async => (await file.readAsBytes()).buffer.asUint8List();

  Future<Uint8List?> UrlToUnit8List(String url) async => (await NetworkAssetBundle(Uri.parse(url)).load(url)).buffer.asUint8List();

  Future<Uint8List> getBytesFromAsset({required String path, Size size = const Size(40, 50)}) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec =
        await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: size.width.toInt(), targetHeight: size.height.toInt());
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
  }

  Future<ui.Image> fileToUiImage(File image) async {
    var imageBytes = await image.readAsBytes();
    var uiImage = await decodeImageFromList(imageBytes);
    return uiImage;
  }

  Future<DocFile> getClippedCircleImage(File fileImage) async {
    var cropped = await sl<ImageCroppers>().cropImage(image: fileImage, cropType: 'circle_clip');
    if (cropped == null) return DocFile();
    var compressed = await sl<FileCompressor>().compressFileImage(image: cropped);
    var docFiles = await sl<FileHelper>().renderFilesInModel([compressed]);
    return docFiles.isEmpty ? DocFile() : docFiles.first;
  }
}
