import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

import 'package:app/components/buttons/elevate_button.dart';
import 'package:app/components/loaders/positioned_loader.dart';
import 'package:app/constants/app_keys.dart';
import 'package:app/di.dart';
import 'package:app/extensions/flutter_ext.dart';
import 'package:app/extensions/number_ext.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/helpers/file_helper.dart';
import 'package:app/libraries/file_compressor.dart';
import 'package:app/models/system/doc_file.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/fonts.dart';
import 'package:app/themes/shadows.dart';
import 'package:app/themes/text_styles.dart';
import 'package:app/utils/assets.dart';
import 'package:app/utils/dimensions.dart';
import 'package:app/utils/transitions.dart';
import 'package:app/widgets/core/pop_scope_navigator.dart';
import 'package:app/widgets/library/svg_image.dart';

Future<void> imageRotateDialog({required File file, required Function(DocFile) onChanged}) async {
  final context = navigatorKey.currentState!.context;
  // sl<AppAnalytics>().screenView('image-rotate-popup');
  await showGeneralDialog(
    context: context,
    barrierLabel: 'Image Rotate Dialog',
    transitionDuration: DIALOG_DURATION,
    transitionBuilder: sl<Transitions>().topToBottom,
    pageBuilder: (buildContext, anim1, anim2) => PopScopeNavigator(canPop: false, child: Align(child: _DialogView(file, onChanged))),
    // pageBuilder: (buildContext, anim1, anim2) => _DialogView(file, onChanged),
  );
}

class _DialogView extends StatefulWidget {
  final File imageFile;
  final Function(DocFile) onChanged;

  const _DialogView(this.imageFile, this.onChanged);

  @override
  _DialogViewState createState() => _DialogViewState();
}

class _DialogViewState extends State<_DialogView> {
  var _loader = false;
  var _sliderValue = 0.0;
  double get _rotation => _sliderValue;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _loader = false;
    _sliderValue = 0.0;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 68.height,
      width: Dimensions.dialog_width,
      padding: EdgeInsets.symmetric(horizontal: Dimensions.dialog_padding, vertical: Dimensions.dialog_padding),
      decoration: BoxDecoration(color: primary, borderRadius: DIALOG_RADIUS, boxShadow: const [SHADOW_2]),
      child: Material(
        color: transparent,
        shape: DIALOG_SHAPE,
        child: Stack(children: [_screenView(context), if (_loader) const PositionedLoader()]),
      ),
    );
  }

  Widget _screenView(BuildContext context) {
    final percentage = _rotation / 180 * 100;
    var displayText = '';
    if (_rotation != 0) {
      if (_rotation > 0) {
        displayText = '+${percentage.abs().formatDouble}%';
      } else {
        displayText = '-${percentage.abs().formatDouble}%';
      }
    }
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: Text('rotate_disc_image'.recast, style: TextStyles.text16_600.copyWith(color: lightBlue))),
            const SizedBox(width: 08),
            InkWell(onTap: backToPrevious, child: SvgImage(image: Assets.svg1.close_1, color: lightBlue, height: 16)),
          ],
        ),
        const SizedBox(height: 24),
        Expanded(
          child: Container(
            width: double.infinity,
            height: double.infinity,
            // alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: 8.width, vertical: 6.width),
            decoration: BoxDecoration(color: white.colorOpacity(0.3), borderRadius: BorderRadius.circular(12)),
            child: Transform.rotate(
              angle: _rotation * math.pi / 180.0,
              child: Image.file(widget.imageFile, fit: BoxFit.contain, width: double.infinity, height: double.infinity),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Text('rotation'.recast, style: TextStyles.text12_600.copyWith(color: lightBlue, fontWeight: w500)),
            const Text(' '),
            Expanded(
              child: Text(
                displayText,
                style: TextStyles.text12_600.copyWith(color: lightBlue, fontWeight: w500),
              ),
            ),
            const SizedBox(width: 08),
            InkWell(onTap: () => setState(() => _sliderValue = 0), child: const Icon(Icons.refresh, color: orange, size: 14)),
            const SizedBox(width: 02),
            InkWell(
              onTap: () => setState(() => _sliderValue = 0),
              child: Text('reset'.recast, style: TextStyles.text12_600.copyWith(color: orange, fontWeight: w500)),
            )
          ],
        ),
        const SizedBox(height: 10),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(trackShape: const CenteredSliderTrackShape()),
          child: Slider(
            value: _sliderValue,
            min: -180,
            max: 180,
            activeColor: orange,
            inactiveColor: lightBlue,
            thumbColor: orange,
            onChanged: (v) => setState(() => _sliderValue = v),
          ),
        ),
        /*Slider(
          value: _sliderValue,
          min: -180, // Allow rotation from -180 to +180 degrees
          max: 180,
          activeColor: orange,
          inactiveColor: lightBlue,
          thumbColor: lightBlue,
          onChanged: (v) => setState(() => _sliderValue = v),
        ),*/
        const SizedBox(height: 32),
        Row(
          children: [
            Expanded(
              child: ElevateButton(
                radius: 04,
                height: 38,
                width: 33.width,
                background: skyBlue,
                onTap: backToPrevious,
                label: 'cancel'.recast.toUpper,
                textStyle: TextStyles.text14_700.copyWith(color: primary, fontWeight: w600, height: 1.15),
              ),
            ),
            const SizedBox(width: 08),
            Expanded(
              child: ElevateButton(
                radius: 04,
                height: 38,
                width: 33.width,
                loader: _loader,
                label: 'confirm'.recast.toUpper,
                onTap: () => _onConfirm(widget.imageFile, _rotation),
                textStyle: TextStyles.text14_700.copyWith(color: lightBlue, fontWeight: w600, height: 1.15),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<_RotateOutput> _rotateBytes(Uint8List bytes, double angleDeg, String extension) async {
    final decoded = img.decodeImage(bytes);
    if (decoded == null) throw Exception('Unsupported or corrupt image');

    final int ow = decoded.width;
    final int oh = decoded.height;
    final rotated = img.copyRotate(decoded, angle: angleDeg);
    final int cx = ((rotated.width - ow) / 2).floor().clamp(0, rotated.width - 1);
    final int cy = ((rotated.height - oh) / 2).floor().clamp(0, rotated.height - 1);
    final int cw = ow.clamp(1, rotated.width);
    final int ch = oh.clamp(1, rotated.height);
    final cropped = img.copyCrop(rotated, x: cx, y: cy, width: cw, height: ch);
    final ext = extension.toLowerCase();

    if (ext == 'png') {
      return _RotateOutput(Uint8List.fromList(img.encodePng(cropped)), 'png');
    } else {
      return _RotateOutput(Uint8List.fromList(img.encodeJpg(cropped, quality: 95)), 'jpg');
    }
  }

  Future<void> _onConfirm(File original, double angleDeg) async {
    final value = angleDeg.toInt();
    if (value == 0) return backToPrevious();

    try {
      setState(() => _loader = true);

      final bytes = await original.readAsBytes();
      final ext = _guessExt(original.path);
      final out = await _rotateBytes(bytes, angleDeg, ext);
      final dir = await getTemporaryDirectory();
      final outPath = '${dir.path}/rotated_${DateTime.now().millisecondsSinceEpoch}.${out.ext}';
      final file = await File(outPath).writeAsBytes(out.bytes);
      final compressed = await sl<FileCompressor>().compressFileImage(image: file, maxMB: 3);
      final docFiles = await sl<FileHelper>().renderFilesInModel([compressed]);

      widget.onChanged(docFiles.first);
      backToPrevious();
    } catch (e) {
      if (kDebugMode) print(e.toString());
      if (mounted) setState(() => _loader = false);
    } finally {
      if (mounted) setState(() => _loader = false);
    }
  }
}

String _guessExt(String path) {
  final lower = path.toLowerCase();
  if (lower.endsWith('.png')) return 'png';
  if (lower.endsWith('.jpg') || lower.endsWith('.jpeg')) return 'jpg';
  return 'jpg';
}

class _RotateOutput {
  final Uint8List bytes;
  final String ext;
  _RotateOutput(this.bytes, this.ext);
}

// Add this class to your existing file (anywhere outside your existing classes)
class CenteredSliderTrackShape extends SliderTrackShape with BaseSliderTrackShape {
  const CenteredSliderTrackShape();

  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    Offset offset = Offset.zero,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double trackHeight = sliderTheme.trackHeight!;
    final double trackLeft = offset.dx;
    final double trackTop = offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }

  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required TextDirection textDirection,
    required Offset thumbCenter,
    Offset? secondaryOffset,
    bool isDiscrete = false,
    bool isEnabled = false,
    double additionalActiveTrackHeight = 2,
  }) {
    final Rect trackRect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );

    final Canvas canvas = context.canvas;
    final Paint inactivePaint = Paint()
      ..color = sliderTheme.inactiveTrackColor!
      ..style = PaintingStyle.fill;

    final Paint activePaint = Paint()
      ..color = sliderTheme.activeTrackColor!
      ..style = PaintingStyle.fill;

    // Draw the entire track in inactive color
    final RRect trackRRect = RRect.fromRectAndRadius(trackRect, Radius.circular(trackRect.height / 2));
    canvas.drawRRect(trackRRect, inactivePaint);

    // Calculate the center position
    final double centerX = trackRect.left + trackRect.width / 2;

    // Draw active segment between center and thumb
    if (thumbCenter.dx != centerX) {
      final double leftX = math.min(centerX, thumbCenter.dx);
      final double rightX = math.max(centerX, thumbCenter.dx);
      final Rect activeRect = Rect.fromLTRB(leftX, trackRect.top, rightX, trackRect.bottom);
      final RRect activeRRect = RRect.fromRectAndRadius(activeRect, Radius.circular(trackRect.height / 2));
      canvas.drawRRect(activeRRect, activePaint);
    }
  }
}
