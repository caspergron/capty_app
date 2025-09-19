import 'package:flutter/material.dart';

import 'package:app/extensions/flutter_ext.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/models/system/data_model.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/fonts.dart';
import 'package:app/themes/text_styles.dart';
import 'package:app/utils/size_config.dart';
import 'package:app/widgets/library/svg_image.dart';

// ExpansionStatus: 0->close, 1->open, 2->idle

class SpinnerMenu extends StatelessWidget {
  final double height;
  final int expansionStatus;
  final List<Color> circleColors;
  final List<DataModel> circleItems;
  final Function(DataModel) itemOnTap;

  const SpinnerMenu({
    required this.itemOnTap,
    this.height = 80,
    this.expansionStatus = 2,
    this.circleItems = const [],
    this.circleColors = const [white, white, white],
  });

  @override
  Widget build(BuildContext context) {
    if (expansionStatus == 2) return const SizedBox.shrink();
    final isOpen = expansionStatus == 1;
    return Container(
      height: height * 2,
      width: SizeConfig.width,
      alignment: Alignment.center,
      padding: EdgeInsets.zero,
      child: SizedBox(
        height: height * 2,
        width: SizeConfig.width,
        child: Stack(
          children: <Widget>[
            TweenAnimationBuilder(
              curve: Curves.easeInOutQuad,
              tween: Tween<double>(begin: isOpen ? -3.14 : 0, end: isOpen ? 0 : -3.14),
              duration: Duration(milliseconds: isOpen ? 500 : 800),
              builder: (context, value, child) => Transform.rotate(angle: value, alignment: Alignment.bottomCenter, child: child),
              child: _EmptyLayer(radius: height * 2, color: circleColors[2]),
            ),
            TweenAnimationBuilder(
              tween: Tween<double>(begin: isOpen ? -3.14 : 0, end: isOpen ? 0 : -3.14),
              curve: Curves.easeInOutQuad,
              duration: const Duration(milliseconds: 600),
              builder: (context, value, child) => Transform.rotate(angle: value, alignment: Alignment.bottomCenter, child: child),
              child: _EmptyLayer(radius: height * 2, color: circleColors[1]),
            ),
            TweenAnimationBuilder(
              curve: Curves.easeInOutQuad,
              tween: Tween<double>(begin: isOpen ? -3.14 : 0, end: isOpen ? 0 : -3.14),
              duration: Duration(milliseconds: isOpen ? 800 : 500),
              builder: (context, value, child) => Transform.rotate(angle: value, alignment: Alignment.bottomCenter, child: child),
              child: _PrimaryCircleMenu(circleItems: circleItems, radius: height * 2, color: mediumBlue, itemOnTap: itemOnTap),
            ),
          ],
        ),
      ),
    );
  }
}

class _PrimaryCircleMenu extends StatelessWidget {
  final List<DataModel> circleItems;
  final Color color;
  final double radius;
  final Function(DataModel) itemOnTap;

  const _PrimaryCircleMenu({required this.itemOnTap, this.color = lightBlue, this.radius = 80, this.circleItems = const []});

  @override
  Widget build(BuildContext context) {
    final radianGap = 3.14159 / circleItems.length;
    final start = radianGap / 2;
    return ClipRect(
      child: Align(
        heightFactor: 0.5,
        alignment: Alignment.topCenter,
        child: Container(
          width: radius,
          height: radius,
          padding: EdgeInsets.zero,
          decoration: BoxDecoration(border: Border.all(color: white), shape: BoxShape.circle, color: color.colorOpacity(0.5)),
          child: Center(
            child: Stack(
              fit: StackFit.expand,
              clipBehavior: Clip.none,
              children: circleItems.asMap().entries.map((entry) {
                return Transform.translate(
                  offset: Offset.fromDirection(-(start + (entry.key * radianGap)), radius / 3),
                  child: GestureDetector(onTap: () => itemOnTap(entry.value), child: _circleMenuItem(entry.value)),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _circleMenuItem(DataModel model) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgImage(image: model.icon, color: primary, height: 26),
        const SizedBox(height: 02),
        Text(model.label.recast, textAlign: TextAlign.center, style: TextStyles.text10_400.copyWith(color: primary, fontWeight: w700)),
      ],
    );
  }
}

class _EmptyLayer extends StatelessWidget {
  final Color color;
  final double radius;

  const _EmptyLayer({this.color = white, this.radius = 80});

  @override
  Widget build(BuildContext context) {
    final child = Container(width: radius, height: radius, decoration: BoxDecoration(shape: BoxShape.circle, color: color));
    return ClipRect(child: Align(heightFactor: 0.5, alignment: Alignment.topCenter, child: child));
  }
}
