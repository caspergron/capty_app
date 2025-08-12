import 'package:flutter/material.dart';

import 'package:app/components/loaders/fading_circle.dart';
import 'package:app/constants/date_formats.dart';
import 'package:app/extensions/number_ext.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/libraries/formatters.dart';
import 'package:app/models/common/end_user.dart';
import 'package:app/models/feature/feature_comment.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/text_styles.dart';
import 'package:app/utils/assets.dart';
import 'package:app/widgets/library/circle_image.dart';
import 'package:app/widgets/library/svg_image.dart';

class SuggestionMessageList extends StatelessWidget {
  final EndUser sender;
  final List<FeatureComment> messages;

  const SuggestionMessageList({required this.sender, this.messages = const []});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      itemCount: messages.length,
      itemBuilder: _messageItemCard,
      physics: const NeverScrollableScrollPhysics(),
    );
  }

  Widget _messageItemCard(BuildContext context, int index) {
    var item = messages[index];
    var myself = item.user?.id == sender.id;
    return Container(
      alignment: myself ? Alignment.centerRight : Alignment.centerLeft,
      margin: EdgeInsets.only(bottom: index == messages.length - 1 ? 0 : 10),
      child: Column(
        crossAxisAlignment: myself ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: myself ? primary : lightBlue, borderRadius: BorderRadius.circular(06)),
            constraints: BoxConstraints(minWidth: 20, maxWidth: 70.width),
            child: Column(
              crossAxisAlignment: myself ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                if (!myself)
                  Row(
                    children: [
                      CircleImage(
                        radius: 14,
                        backgroundColor: primary,
                        image: item.user?.media?.url,
                        placeholder: const FadingCircle(size: 14),
                        errorWidget: SvgImage(image: Assets.svg1.coach, color: lightBlue, height: 18),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.user?.full_name ?? 'n/a'.recast,
                              textAlign: TextAlign.right,
                              style: TextStyles.text12_600.copyWith(color: primary, fontSize: 12.5, height: 1),
                            ),
                            const SizedBox(height: 02),
                            Text(
                              Formatters.formatDate(DATE_FORMAT_9, item.createdAt),
                              textAlign: TextAlign.right,
                              style: TextStyles.text10_400.copyWith(color: primary, height: 1),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                if (!myself) const SizedBox(height: 04),
                Text(
                  item.message ?? 'n/a'.recast,
                  textAlign: TextAlign.left,
                  style: TextStyles.text14_400.copyWith(color: myself ? lightBlue : primary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
