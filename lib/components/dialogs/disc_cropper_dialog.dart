import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:custom_image_crop/custom_image_crop.dart';

import 'package:app/animations/fade_animation.dart';
import 'package:app/components/buttons/elevate_button.dart';
import 'package:app/components/loaders/positioned_loader.dart';
import 'package:app/constants/app_keys.dart';
import 'package:app/di.dart';
import 'package:app/extensions/flutter_ext.dart';
import 'package:app/extensions/number_ext.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/libraries/file_compressor.dart';
import 'package:app/libraries/flush_popup.dart';
import 'package:app/models/system/doc_file.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/fonts.dart';
import 'package:app/themes/shadows.dart';
import 'package:app/themes/text_styles.dart';
import 'package:app/utils/assets.dart';
import 'package:app/utils/dimensions.dart';
import 'package:app/utils/transitions.dart';
import 'package:app/widgets/core/memory_image.dart';
import 'package:app/widgets/core/pop_scope_navigator.dart';
import 'package:app/widgets/library/svg_image.dart';

const _INITIAL_ZOOM = 1.0;
const _INITIAL_ROTATE = 0.0;
const _DURATION_50 = Duration(milliseconds: 50);

Future<void> discCropperDialog({required File file, required Function(DocFile) onChanged}) async {
  var context = navigatorKey.currentState!.context;
  // sl<AppAnalytics>().screenView('disc-cropper-popup');
  await showGeneralDialog(
    context: context,
    barrierLabel: 'Disc Cropper Dialog',
    transitionDuration: DIALOG_DURATION,
    transitionBuilder: sl<Transitions>().topToBottom,
    pageBuilder: (buildContext, anim1, anim2) => PopScopeNavigator(canPop: false, child: Align(child: _DialogView(file, onChanged))),
    // pageBuilder: (buildContext, anim1, anim2) => _DialogView(file, onChanged),
  );
}

class _DialogView extends StatefulWidget {
  final File file;
  final Function(DocFile) onChanged;

  const _DialogView(this.file, this.onChanged);

  @override
  _DialogViewState createState() => _DialogViewState();
}

class _DialogViewState extends State<_DialogView> {
  var _loader = false;
  var _zoom = _INITIAL_ZOOM;
  var _globalZoom = _INITIAL_ZOOM;
  var _rotation = _INITIAL_ROTATE;
  var _globalRotation = _INITIAL_ROTATE;
  var _cropController = CustomImageCropController();
  var _memoryImage = null as MemoryImage?;
  var _isPreview = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _cropController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var key = '$_isPreview';
    var sectionView = _isPreview ? _PreviewImage(image: _memoryImage!, onTap: _onPreviewSection) : _cropperScreenView(context);
    return Container(
      height: _isPreview ? 55.height : 68.height,
      width: Dimensions.dialog_width,
      padding: EdgeInsets.symmetric(horizontal: Dimensions.dialog_padding, vertical: Dimensions.dialog_padding),
      decoration: BoxDecoration(color: primary, borderRadius: DIALOG_RADIUS, boxShadow: const [SHADOW_2]),
      child: Material(
        color: transparent,
        shape: DIALOG_SHAPE,
        child: Stack(children: [FadeAnimation(fadeKey: key, child: sectionView), if (_loader) const PositionedLoader()]),
      ),
    );
  }

  void _onPreviewSection() {
    setState(() => _isPreview = false);
    Future.delayed(_DURATION_50, () => _cropController.addTransition(CropImageData(scale: _globalZoom, angle: _globalRotation)));
  }

  Widget _cropperScreenView(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: Text('disc_details'.recast, style: TextStyles.text16_600.copyWith(color: lightBlue))),
            const SizedBox(width: 08),
            InkWell(onTap: backToPrevious, child: SvgImage(image: Assets.svg1.close_1, color: lightBlue, height: 16)),
          ],
        ),
        const SizedBox(height: 24),
        /*Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: CustomImageCrop(
              borderRadius: 12,
              backgroundColor: primary,
              outlineStrokeWidth: 2.5,
              imageFit: CustomImageFit.fitVisibleSpace,
              cropController: _cropController,
              image: FileImage(widget.file),

              // image: AssetImage(Assets.png_image.challenge),
            ),
          ),
        ),*/
        Expanded(
          child: CustomImageCrop(
            cropController: _cropController,
            image: AssetImage(widget.file.path),
          ),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(child: Text('zoom'.recast, style: TextStyles.text12_600.copyWith(color: lightBlue, fontWeight: w500))),
            const SizedBox(width: 08),
            InkWell(onTap: _onResetZoom, child: const Icon(Icons.refresh, color: orange, size: 14)),
            const SizedBox(width: 02),
            InkWell(
                onTap: _onResetZoom, child: Text('reset'.recast, style: TextStyles.text12_600.copyWith(color: orange, fontWeight: w500)))
          ],
        ),
        const SizedBox(height: 10),
        Slider(
          value: _zoom,
          min: 0.5,
          max: 3,
          activeColor: orange,
          inactiveColor: lightBlue,
          thumbColor: lightBlue,
          onChanged: _onZoom,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: Text('rotation'.recast, style: TextStyles.text12_600.copyWith(color: lightBlue, fontWeight: w500))),
            const SizedBox(width: 08),
            InkWell(onTap: _onResetRotate, child: const Icon(Icons.refresh, color: orange, size: 14)),
            const SizedBox(width: 02),
            InkWell(
                onTap: _onResetRotate, child: Text('reset'.recast, style: TextStyles.text12_600.copyWith(color: orange, fontWeight: w500)))
          ],
        ),
        const SizedBox(height: 10),
        Slider(
          value: _rotation,
          min: -pi,
          max: pi,
          activeColor: orange,
          inactiveColor: lightBlue,
          thumbColor: lightBlue,
          onChanged: _onRotate,
        ),
        const SizedBox(height: 32),
        Row(
          children: [
            Expanded(
              child: ElevateButton(
                radius: 04,
                height: 38,
                width: 33.width,
                background: skyBlue,
                onTap: _onPreview,
                label: 'preview'.recast.toUpper,
                textStyle: TextStyles.text14_700.copyWith(color: primary, fontWeight: w600, height: 1.15),
              ),
            ),
            const SizedBox(width: 08),
            Expanded(
              child: ElevateButton(
                radius: 04,
                height: 38,
                width: 33.width,
                label: 'confirm'.recast.toUpper,
                onTap: _onConfirm,
                textStyle: TextStyles.text14_700.copyWith(color: lightBlue, fontWeight: w600, height: 1.15),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _onZoom(double value) {
    _zoom = value;
    _cropController.addTransition(CropImageData(scale: value / _globalZoom));
    _globalZoom = value;
    setState(() {});
  }

  void _onRotate(double value) {
    _rotation = value;
    _cropController.addTransition(CropImageData(angle: value - _globalRotation));
    _globalRotation = value;
    setState(() {});
  }

  void _onResetZoom() {
    _cropController.addTransition(CropImageData(scale: _INITIAL_ZOOM / _zoom));
    _zoom = _INITIAL_ZOOM;
    _globalZoom = _INITIAL_ZOOM;
    setState(() {});
  }

  void _onResetRotate() {
    _cropController.addTransition(CropImageData(angle: _INITIAL_ROTATE - _rotation));
    _rotation = _INITIAL_ROTATE;
    _globalRotation = _INITIAL_ROTATE;
    setState(() {});
  }

  Future<void> _onPreview() async {
    var croppedBytes = await _cropController.onCropImage();
    if (croppedBytes == null) return FlushPopup.onWarning(message: 'image_corrupted_please_try_again'.recast);
    _memoryImage = croppedBytes;
    _isPreview = true;
    _globalZoom = _zoom;
    _globalRotation = _rotation;
    setState(() {});
  }

  Future<void> _onConfirm() async {
    setState(() => _loader = true);
    var croppedImage = await _cropController.onCropImage();
    if (croppedImage == null) return FlushPopup.onWarning(message: 'image_corrupted_please_try_again'.recast);
    _memoryImage = croppedImage;
    _globalZoom = _zoom;
    _globalRotation = _rotation;
    var compressed = await sl<FileCompressor>().compressMemoryImage(byteList: croppedImage.bytes, maxMB: 3);
    setState(() => _loader = false);
    var size = compressed.length ~/ 1024;
    var base64 = base64Encode(compressed);
    var docFile = DocFile(base64: base64, unit8List: compressed, size: size, isValid: true, isLarge: false);
    widget.onChanged(docFile);
    backToPrevious();
  }
}

class _PreviewImage extends StatelessWidget {
  final MemoryImage image;
  final Function() onTap;
  const _PreviewImage({required this.image, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: primary,
      width: double.infinity,
      height: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(child: Text('preview_image'.recast, style: TextStyles.text16_600.copyWith(color: lightBlue))),
              const SizedBox(width: 08),
              InkWell(onTap: onTap, child: SvgImage(image: Assets.svg1.close_1, color: lightBlue, height: 16)),
            ],
          ),
          const SizedBox(height: 40),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(border: Border.all(width: 0.5, color: lightBlue), borderRadius: BorderRadius.circular(08)),
              child: ImageMemory(imagePath: image.bytes),
            ),
          ),
          const SizedBox(height: 40),
          Center(
            child: ElevateButton(
              radius: 04,
              height: 38,
              width: 33.width,
              background: skyBlue,
              onTap: onTap,
              label: 'okay'.recast.toUpper,
              textStyle: TextStyles.text14_700.copyWith(color: primary, fontWeight: w600, height: 1.15),
            ),
          ),
          const SizedBox(height: 08),
        ],
      ),
    );
  }
}

class ResultScreen extends StatelessWidget {
  final MemoryImage image;

  const ResultScreen({required this.image});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Result'),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
                decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.blueGrey.shade400,
                  Colors.blueGrey.shade600,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            )),
          ),
          Center(
            child: Image(
              image: image,
            ),
          ),
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: ElevatedButton(
              child: const Text('Back'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ],
      ),
    );
  }
}
