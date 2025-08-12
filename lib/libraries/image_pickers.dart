import 'dart:io';

import 'package:image_picker/image_picker.dart';

import 'package:app/extensions/string_ext.dart';

class ImagePickers {
  final _imagePicker = ImagePicker();

  Future<File?> imageFromCamera() async {
    var image = await _imagePicker.pickImage(source: ImageSource.camera);
    if (image == null) return null;
    return File(image.path);
  }

  Future<File?> singleImageFromGallery() async {
    var image = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (image == null) return null;
    return File(image.path);
  }

  /*Future<List<File>> multiImageFromGallery() async {
    List<File> imageFiles = [];
    var images = await _imagePicker.pickMultiImage();
    if (images.isEmpty) return imageFiles;
    images.forEach((item) => imageFiles.add(File(item.path)));
    return imageFiles;
  }*/

  Future<List<File>> multiImageFromGallery({required int limit}) async {
    if (limit < 2) {
      var image = await singleImageFromGallery();
      return image == null ? [] : [image];
    }
    List<File> imageFiles = [];
    var images = await _imagePicker.pickMultiImage(limit: limit);
    if (images.isEmpty) return imageFiles;
    var jpgImages = images.where((item) => item.path.fileExtension == 'jpg' || item.path.fileExtension == 'jpeg').toList();
    if (jpgImages.isEmpty) return imageFiles;
    jpgImages.forEach((item) => imageFiles.add(File(item.path)));
    return imageFiles;
  }
}
