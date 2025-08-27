import 'dart:io';

import 'package:flutter/material.dart';

import 'package:app/constants/app_keys.dart';
import 'package:app/di.dart';
import 'package:app/extensions/flutter_ext.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/libraries/file_compressor.dart';
import 'package:app/libraries/image_croppers.dart';
import 'package:app/libraries/image_pickers.dart';
import 'package:app/models/system/data_model.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/text_styles.dart';
import 'package:app/utils/assets.dart';
import 'package:app/utils/dimensions.dart';
import 'package:app/utils/size_config.dart';
import 'package:app/widgets/core/pop_scope_navigator.dart';
import 'package:app/widgets/library/svg_image.dart';

Future<void> imageOptionSheet({required Function(File) onFile, String cropType = 'circle'}) async {
  var context = navigatorKey.currentState!.context;
  // sl<AppAnalytics>().screenView('upload-method-sheet');
  await showModalBottomSheet(
    context: context,
    isDismissible: false,
    shape: BOTTOM_SHEET_SHAPE,
    isScrollControlled: true,
    clipBehavior: Clip.antiAlias,
    builder: (builder) => PopScopeNavigator(canPop: false, child: _BottomSheetView(onFile, cropType)),
  );
}

class _BottomSheetView extends StatelessWidget {
  final Function(File) onFile;
  final String cropType;
  const _BottomSheetView(this.onFile, this.cropType);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.width,
      child: _screenView(context),
      decoration: BoxDecoration(color: primary, borderRadius: SHEET_RADIUS),
    );
  }

  Widget _screenView(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Row(
          children: [
            const SizedBox(width: 20),
            Expanded(child: Text('select_an_option'.recast, style: TextStyles.text18_700.copyWith(color: lightBlue))),
            const SizedBox(width: 10),
            InkWell(onTap: backToPrevious, child: SvgImage(image: Assets.svg1.close_1, height: 20, color: lightBlue)),
            const SizedBox(width: 20),
          ],
        ),
        const SizedBox(height: 20),
        const Divider(color: mediumBlue, height: 0.5, thickness: 0.5),
        const SizedBox(height: 28),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: _ImageUploadItem(type: CAMERA, onTap: _onCameraImage),
        ),
        const SizedBox(height: 20),
        const Padding(padding: EdgeInsets.symmetric(horizontal: 24), child: Divider(color: mediumBlue, height: 0.5, thickness: 0.5)),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: _ImageUploadItem(type: GALLERY, onTap: _onGalleryImage),
        ),
        const SizedBox(height: 20),
        SizedBox(height: BOTTOM_GAP),
      ],
    );
  }

  Future<void> _onCameraImage() async {
    var file = await sl<ImagePickers>().imageFromCamera();
    if (file == null) return backToPrevious();
    var cropped = await sl<ImageCroppers>().cropImage(image: file, cropType: cropType);
    if (cropped == null) return backToPrevious();
    var compressed = await sl<FileCompressor>().compressFileImage(image: cropped);
    backToPrevious();
    onFile(compressed);
  }

  Future<void> _onGalleryImage() async {
    var file = await sl<ImagePickers>().singleImageFromGallery();
    if (file == null) return backToPrevious();
    var cropped = await sl<ImageCroppers>().cropImage(image: file, cropType: cropType);
    if (cropped == null) return backToPrevious();
    var compressed = await sl<FileCompressor>().compressFileImage(image: cropped);
    backToPrevious();
    onFile(compressed);
  }
}

class _ImageUploadItem extends StatelessWidget {
  final Function() onTap;
  final DataModel type;
  const _ImageUploadItem({required this.onTap, required this.type});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          SvgImage(image: type.icon, color: lightBlue, height: 22),
          const SizedBox(width: 14),
          Expanded(child: Text(type.label.recast, style: TextStyles.text16_400.copyWith(color: lightBlue))),
          const SizedBox(width: 14),
          SvgImage(image: Assets.svg1.caret_right, color: skyBlue, height: 20),
        ],
      ),
    );
  }
}
