import 'package:flutter/material.dart';

import 'package:app/animations/tween_list_item.dart';
import 'package:app/components/buttons/elevate_button.dart';
import 'package:app/components/loaders/fading_circle.dart';
import 'package:app/constants/date_formats.dart';
import 'package:app/extensions/flutter_ext.dart';
import 'package:app/extensions/number_ext.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/helpers/enums.dart';
import 'package:app/libraries/formatters.dart';
import 'package:app/models/chat/chat_message.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/fonts.dart';
import 'package:app/themes/text_styles.dart';
import 'package:app/utils/assets.dart';
import 'package:app/utils/dimensions.dart';
import 'package:app/widgets/library/circle_image.dart';
import 'package:app/widgets/library/svg_image.dart';

class NewMessagesList extends StatelessWidget {
  final List<ChatMessage> messages;
  final Function(ChatMessage)? onTap;

  const NewMessagesList({this.messages = const [], this.onTap});

  @override
  Widget build(BuildContext context) {
    var gap = EdgeInsets.symmetric(horizontal: Dimensions.screen_padding);
    var style = TextStyles.text18_700.copyWith(color: primary, letterSpacing: 0.54);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(padding: gap, child: Text('new_messages'.recast, style: style)),
        const SizedBox(height: 08),
        SizedBox(
          height: 130 + 12,
          child: ListView.builder(
            shrinkWrap: true,
            clipBehavior: Clip.antiAlias,
            itemCount: messages.length,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(bottom: 12),
            itemBuilder: _messageItemCard,
          ),
        ),
      ],
    );
  }

  Widget _messageItemCard(BuildContext context, int index) {
    var item = messages[index];
    var gap = Dimensions.screen_padding;
    return InkWell(
      onTap: () => onTap == null ? null : onTap!(item),
      child: TweenListItem(
        index: index,
        twinAnim: TwinAnim.right_to_left,
        child: Container(
          width: 64.width,
          key: Key('index_$index'),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          margin: EdgeInsets.only(left: index == 0 ? gap : 0, right: index == messages.length - 1 ? gap : 08),
          decoration: BoxDecoration(color: primary, borderRadius: BorderRadius.circular(12)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleImage(
                    radius: 14,
                    image: item.endUser?.media?.url,
                    color: popupBearer.colorOpacity(0.1),
                    backgroundColor: primary,
                    placeholder: const FadingCircle(size: 16, color: lightBlue),
                    errorWidget: SvgImage(image: Assets.svg1.coach, height: 16, color: lightBlue),
                  ),
                  const SizedBox(width: 08),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.endUser?.name ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyles.text16_700.copyWith(color: lightBlue),
                        ),
                        const SizedBox(height: 02),
                        Text(
                          Formatters.formatDate(DATE_FORMAT_9, item.sendTime),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyles.text10_400.copyWith(color: skyBlue, fontWeight: w500, fontSize: 11),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              Text(
                item.message ?? '',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyles.text12_600.copyWith(color: skyBlue, fontWeight: w400, height: 1.1),
              ),
              ElevateButton(
                height: 30,
                width: double.infinity,
                radius: 04,
                background: mediumBlue,
                icon: SvgImage(image: Assets.svg1.comment, height: 14, color: white),
                label: 'open_message'.recast.toUpper,
                textStyle: TextStyles.text12_700.copyWith(color: white, fontSize: 11, height: 1),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
