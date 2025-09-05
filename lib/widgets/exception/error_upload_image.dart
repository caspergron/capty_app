import 'package:app/components/loaders/fading_circle.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/text_styles.dart';
import 'package:app/utils/assets.dart';
import 'package:app/widgets/library/image_network.dart';
import 'package:app/widgets/library/svg_image.dart';
import 'package:flutter/material.dart';

class ErrorUploadImage extends StatelessWidget {
  final Color color;
  final String? discImage;

  const ErrorUploadImage({this.discImage, this.color = primary});

  @override
  Widget build(BuildContext context) => discImage == null ? _uploadView : _uploadedImageView;

  Widget get _uploadedImageView {
    return ImageNetwork(
      radius: 04,
      width: double.infinity,
      height: double.infinity,
      fit: BoxFit.contain,
      image: discImage,
      placeholder: const FadingCircle(size: 30, color: lightBlue),
      errorWidget: _uploadView,
    );
  }

  Widget get _uploadView {
    var borderRadius = BorderRadius.circular(4);
    var icon = SvgImage(image: Assets.svg1.upload, height: 16, color: color);
    var style = TextStyles.text10_400.copyWith(color: color, fontSize: 10.5);
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(borderRadius: borderRadius, border: Border.all(width: 0.5, color: color)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [icon, Text('upload_a_photo'.recast, textAlign: TextAlign.center, style: style)],
      ),
    );
  }
}
