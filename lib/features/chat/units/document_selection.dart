import 'package:flutter/material.dart';

import 'package:app/components/loaders/loader_box.dart';
import 'package:app/extensions/flutter_ext.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/features/chat/units/chat_image_loader.dart';
import 'package:app/models/system/data_model.dart';
import 'package:app/models/system/doc_file.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/text_styles.dart';
import 'package:app/utils/assets.dart';
import 'package:app/widgets/core/memory_image.dart';
import 'package:app/widgets/library/circle_image.dart';
import 'package:app/widgets/library/svg_image.dart';

var _CAMERA = DataModel(label: 'camera', icon: Assets.svg1.camera, value: 'camera', valueInt: 0xFFF49B34);
var _GALLERY = DataModel(label: 'gallery', icon: Assets.svg1.image_square, value: 'gallery', valueInt: 0xFF00246B);

class DocumentSelection extends StatelessWidget {
  final int imageLoadCount;
  final List<DocFile> images;
  final bool isUploadType;
  final Function()? onCamera;
  final Function()? onGallery;
  final Function(int)? onImage;

  const DocumentSelection({
    this.images = const [],
    this.imageLoadCount = 0,
    this.isUploadType = false,
    this.onCamera,
    this.onGallery,
    this.onImage,
  });

  @override
  Widget build(BuildContext context) {
    var radius = const Radius.circular(08);
    var camera = _MenuBox(item: _CAMERA, onTap: onCamera, isUploadType: isUploadType);
    var gallery = _MenuBox(item: _GALLERY, onTap: onGallery, isUploadType: isUploadType);
    var imageListTop = images.isEmpty ? 0.0 : 12.0;
    var imageListBottom = isUploadType ? 0.0 : 8.0;
    return Container(
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(color: lightBlue, borderRadius: BorderRadius.only(topLeft: radius, topRight: radius)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          imageLoadCount > 0
              ? ChatImageLoaderList(length: imageLoadCount)
              : AnimatedContainer(
                  curve: Curves.easeIn,
                  duration: const Duration(milliseconds: 250),
                  height: images.isNotEmpty ? 76 + imageListTop + imageListBottom : 0,
                  padding: EdgeInsets.only(top: imageListTop, bottom: imageListBottom),
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    clipBehavior: Clip.antiAlias,
                    itemCount: images.length,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: _imageItemCard,
                    padding: EdgeInsets.zero,
                  ),
                ),
          AnimatedContainer(
            curve: Curves.easeIn,
            width: double.infinity,
            height: isUploadType ? 64 : 0,
            alignment: Alignment.center,
            duration: const Duration(milliseconds: 250),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(children: [Expanded(child: camera), const SizedBox(width: 12), Expanded(child: gallery)]),
          ),
        ],
      ),
    );
  }

  Widget _imageItemCard(BuildContext context, int index) {
    var image = images[index];
    var closeIcon = SvgImage(image: Assets.svg1.close_1, color: dark, height: 12);
    var errorIcon = SvgImage(image: Assets.svg1.image_square, height: 40, color: lightBlue.colorOpacity(0.5));
    return Container(
      width: 110,
      height: 76,
      margin: EdgeInsets.only(left: index == 0 ? 12 : 0, right: index == images.length - 1 ? 12 : 06),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(06)),
      child: Stack(
        children: [
          ImageMemory(
            width: 110,
            height: 76,
            radius: 06,
            fit: BoxFit.cover,
            color: dark.colorOpacity(0.1),
            filterQuality: FilterQuality.high,
            colorBlendMode: BlendMode.darken,
            imagePath: image.unit8List,
            error: LoaderBox(radius: 06, boxSize: const Size(110, 76), border: lightBlue.colorOpacity(0.4), child: errorIcon),
          ),
          Positioned(
            top: 4,
            right: 4,
            child: CircleImage(radius: 08, errorWidget: closeIcon, onTap: onImage == null ? null : () => onImage!(index)),
          ),
        ],
      ),
    );
  }
}

class _MenuBox extends StatelessWidget {
  final DataModel item;
  final Function()? onTap;
  final bool isUploadType;

  const _MenuBox({required this.item, required this.isUploadType, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: AnimatedContainer(
        height: isUploadType ? 40 : 0,
        alignment: Alignment.centerLeft,
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 08),
        decoration: BoxDecoration(color: Color(item.valueInt), borderRadius: BorderRadius.circular(06)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(width: 04),
            SvgImage(image: item.icon, height: 22, color: lightBlue),
            const SizedBox(width: 08),
            Expanded(child: Text(item.label.recast, style: TextStyles.text14_500.copyWith(color: lightBlue, height: 1.2))),
          ],
        ),
      ),
    );
  }
}
