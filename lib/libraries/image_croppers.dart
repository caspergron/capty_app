import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:image_cropper/image_cropper.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import 'package:app/constants/app_keys.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/themes/colors.dart';

const _RECTANGLE_RATIO = CropAspectRatio(ratioX: 600, ratioY: 380);
const _CIRCLE_RATIO = CropAspectRatio(ratioX: 600, ratioY: 600);
const _REGULAR_RATIO = CropAspectRatio(ratioX: 600, ratioY: 380);

// crop type: circle, circle_clip, rectangle, square
class ImageCroppers {
  final _imageCropper = ImageCropper();

  Future<File?> cropImage({required File image, String cropType = ''}) async {
    final crop_style = _cropStyle(cropType);
    final aspect_ratio = _aspectRatio(cropType);
    final cropped = await _imageCropper.cropImage(
      maxHeight: 600,
      maxWidth: 1000,
      compressQuality: 20,
      sourcePath: image.path,
      aspectRatio: aspect_ratio,
      compressFormat: ImageCompressFormat.png,
      uiSettings: [
        Platform.isIOS
            ? IOSUiSettings(
                title: 'edit_photo'.recast,
                cancelButtonTitle: 'cancel'.recast,
                doneButtonTitle: 'done'.recast,
                cropStyle: crop_style,
              )
            : AndroidUiSettings(
                lockAspectRatio: false,
                toolbarColor: primary,
                // backgroundColor: dark,
                statusBarColor: transparent,
                toolbarWidgetColor: white,
                // cropFrameColor: transparent,
                toolbarTitle: 'edit_photo'.recast,
                cropStyle: crop_style,
                hideBottomControls: false,
                initAspectRatio: CropAspectRatioPreset.original,
              ),
      ],
    );
    resetStatusBarColor();
    // SystemChrome.setSystemUIOverlayStyle(OVERLAY_STYLE);
    if (cropped == null) return null;
    if (cropType != 'circle_clip') return File(cropped.path);
    final clippedCircleImage = await _convertToCircular(File(cropped.path));
    return clippedCircleImage;
  }

  void resetStatusBarColor() {
    final context = navigatorKey.currentState!.context;
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Theme.of(context).appBarTheme.foregroundColor,
        statusBarIconBrightness: Brightness.light,
      ),
    );
  }

  CropStyle _cropStyle(String type) {
    if (type == 'circle' || type == 'circle_clip') {
      return CropStyle.circle;
    } else if (type == 'rectangle') {
      return CropStyle.rectangle;
    } else {
      return CropStyle.rectangle;
    }
  }

  CropAspectRatio _aspectRatio(String type) {
    if (type == 'circle' || type == 'circle_clip') {
      return _CIRCLE_RATIO;
    } else if (type == 'rectangle') {
      return _RECTANGLE_RATIO;
    } else {
      return _REGULAR_RATIO;
    }
  }

  Future<File> _convertToCircular(File imageFile) async {
    final data = await imageFile.readAsBytes();
    final codec = await ui.instantiateImageCodec(data);
    final frame = await codec.getNextFrame();
    final image = frame.image;

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final paint = Paint();
    final size = Size(image.width.toDouble(), image.height.toDouble());

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.shortestSide / 2;

    canvas.drawCircle(center, radius, Paint()..color = Colors.transparent);
    canvas.clipPath(Path()..addOval(Rect.fromCircle(center: center, radius: radius)));
    canvas.drawImage(image, Offset.zero, paint);

    final finalImage = await recorder.endRecording().toImage(image.width, image.height);
    final pngBytes = await finalImage.toByteData(format: ui.ImageByteFormat.png);

    final directory = await getTemporaryDirectory();
    final filePath = path.join(directory.path, 'circle_${DateTime.now().millisecondsSinceEpoch}.png');
    final file = File(filePath);
    return file.writeAsBytes(pngBytes!.buffer.asUint8List());
  }
}
