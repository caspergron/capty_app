import 'package:flutter/cupertino.dart';

import 'package:app/components/loaders/fading_circle.dart';
import 'package:app/themes/colors.dart';

class ChatImageLoaderList extends StatelessWidget {
  final int length;
  const ChatImageLoaderList({required this.length});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 76 + 20,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.antiAlias,
        itemCount: length,
        physics: const BouncingScrollPhysics(),
        itemBuilder: _imageLoaderItemCard,
        padding: const EdgeInsets.only(top: 12, bottom: 08),
      ),
    );
  }

  Widget _imageLoaderItemCard(BuildContext context, int index) {
    return Container(
      width: 110,
      height: 76,
      alignment: Alignment.center,
      child: const FadingCircle(size: 32),
      margin: EdgeInsets.only(left: index == 0 ? 12 : 0, right: index == length - 1 ? 12 : 06),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(06), border: Border.all(color: mediumBlue, width: 0.5)),
    );
  }
}
