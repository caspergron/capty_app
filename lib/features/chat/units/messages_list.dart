import 'package:flutter/material.dart';

import 'package:app/components/loaders/fading_circle.dart';
import 'package:app/components/loaders/loader_box.dart';
import 'package:app/constants/data_constants.dart';
import 'package:app/constants/date_formats.dart';
import 'package:app/extensions/flutter_ext.dart';
import 'package:app/extensions/number_ext.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/libraries/formatters.dart';
import 'package:app/models/chat/chat_buddy.dart';
import 'package:app/models/chat/chat_content.dart';
import 'package:app/models/chat/chat_message.dart';
import 'package:app/models/marketplace/sales_ad.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/fonts.dart';
import 'package:app/themes/text_styles.dart';
import 'package:app/utils/assets.dart';
import 'package:app/widgets/core/memory_image.dart';
import 'package:app/widgets/library/circle_image.dart';
import 'package:app/widgets/library/image_network.dart';
import 'package:app/widgets/library/svg_image.dart';
import 'package:app/widgets/ui/colored_disc.dart';

class MessagesList extends StatelessWidget {
  final ChatBuddy sender;
  final List<ChatMessage> messages;
  final ScrollPhysics physics;

  const MessagesList({required this.sender, this.messages = const [], this.physics = const NeverScrollableScrollPhysics()});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      itemCount: messages.length,
      itemBuilder: _messageItemCard,
      physics: physics,
    );
  }

  bool _isDateMessage(int index) {
    var message = messages[index];
    if (message.createdAt == null) return false;
    if (index == 0) return true;
    var previousMessage = messages[index - 1];
    if (previousMessage.createdAt == null) return false;
    return !DateUtils.isSameDay(message.createdAt!.parseDate, previousMessage.createdAt!.parseDate);
  }

  String _messageDate(String date) {
    var difference = currentDate.difference(date.parseDate).inDays;
    switch (difference) {
      case 0:
        return 'today';
      case 1:
        return 'yesterday';
      case 2:
        return Formatters.formatDate(DATE_FORMAT_1, date);
      case 3:
        return Formatters.formatDate(DATE_FORMAT_1, date);
      case 4:
        return Formatters.formatDate(DATE_FORMAT_1, date);
      case 5:
        return Formatters.formatDate(DATE_FORMAT_1, date);
      case 6:
        return Formatters.formatDate(DATE_FORMAT_1, date);
      default:
        return Formatters.formatDate(DATE_FORMAT_14, date);
    }
  }

  bool _isSameUser(int? userId1, int? userId2) => userId1 == null || userId2 == null ? true : userId1 == userId2;

  bool _isShowTime(int index) {
    var message = messages[index];
    if (message.createdAt == null) return false;
    if (index == messages.length - 1) return true;
    return !_isSameUser(message.senderId, messages[index + 1].senderId);
  }

  Widget _messageItemCard(BuildContext context, int index) {
    var item = messages[index];
    var isMe = item.senderId == sender.id;
    // print('senderId: ${item.senderId} -> sender: ${sender.id}');
    var isDateMessage = _isDateMessage(index);
    var isShowTime = _isShowTime(index);
    var time = Formatters.formatTime('${item.sendTime}');
    return Container(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      margin: EdgeInsets.only(bottom: index == messages.length - 1 ? 20 : (!isShowTime ? 6 : 16)),
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          if (index != 0 && isDateMessage) const SizedBox(height: 10),
          if (isDateMessage) _messageDateInfo(item),
          if (isDateMessage) const SizedBox(height: 16),
          if (item.sales_ad_info != null) _DiscCard(salesAd: item.sales_ad_info!, isMe: isMe),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: _boxDecoration(index, isMe),
            constraints: BoxConstraints(minWidth: 20, maxWidth: 70.width),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [_messageImageList(item, isMe), _chatMessage(item.message, isMe)],
            ),
          ),
          Builder(builder: (context) {
            var padding = const EdgeInsets.only(top: 02);
            var style = TextStyles.text12_600.copyWith(color: primary, fontWeight: w500);
            if (item.chatStatus.toKey.isEmpty) {
              return Padding(padding: padding, child: Text('${'sending'.recast}...', style: style));
            } else if (item.chatStatus.toKey == 'error'.toKey) {
              return Padding(padding: padding, child: SvgImage(image: Assets.svg2.warning, color: orange.colorOpacity(0.7), height: 16));
              // return Container(height: 16, padding: padding, child: ErrorChatPopupMenu(item: DataModel(), onSelect: (v) {}));
            } else if (item.chat_status) {
              return !isShowTime ? const SizedBox.shrink() : Padding(padding: padding, child: Text(time, style: style));
            } else {
              return const SizedBox.shrink();
            }
          }),
        ],
      ),
    );
  }

  BoxDecoration _boxDecoration(int index, bool isMe) {
    var radius = const Radius.circular(10);
    var isNextSame = index != messages.length - 1 && _isSameUser(messages[index].id, messages[index + 1].id);
    var left = isMe || (!isMe && isNextSame) ? radius : Radius.zero;
    var right = !isMe || (isMe && isNextSame) ? radius : Radius.zero;
    var borderRadius = BorderRadius.only(topLeft: radius, topRight: radius, bottomLeft: left, bottomRight: right);
    return BoxDecoration(color: isMe ? primary : lightBlue, borderRadius: borderRadius);
  }

  Widget _messageDateInfo(ChatMessage message) {
    return Row(
      children: [
        const Expanded(child: Divider(color: lightBlue, thickness: 0.8)),
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(color: lightBlue, borderRadius: BorderRadius.circular(16)),
          child: Text(_messageDate(message.createdAt!), style: TextStyles.text12_600.copyWith(color: primary)),
        ),
        const Expanded(child: Divider(color: lightBlue, thickness: 0.8)),
      ],
    );
  }

  Widget _chatMessage(String? message, bool isMe) {
    if (message.toKey.isEmpty) return const SizedBox.shrink();
    // var align = isMe ? TextAlign.left : TextAlign.left;
    var style = TextStyles.text14_400.copyWith(color: isMe ? lightBlue : primary, height: 1);
    return Text(message!, textAlign: TextAlign.left, style: style);
  }

  Widget _messageImageList(ChatMessage chat, bool isMe) {
    var imageList = chat.chat_images;
    if (imageList.isEmpty) return const SizedBox.shrink();
    var padding = EdgeInsets.only(bottom: chat.message.toKey.isEmpty ? 0 : 08);
    if (imageList.length == 1) return Padding(padding: padding, child: _imageItemCard(imageList.first, chat.chat_status, true, isMe));
    return GridView.builder(
      padding: padding,
      shrinkWrap: true,
      clipBehavior: Clip.antiAlias,
      itemCount: imageList.length,
      gridDelegate: _gridDelegate,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) => _imageItemCard(imageList[index], chat.chat_status, false, isMe),
    );
  }

  SliverGridDelegateWithFixedCrossAxisCount get _gridDelegate {
    return const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 3,
      crossAxisSpacing: 6,
      mainAxisSpacing: 6,
      childAspectRatio: 1.5,
    );
  }

  Widget _imageItemCard(ChatContent image, bool isSent, bool isSingle, bool isMe) {
    var color = (isMe ? lightBlue : primary).colorOpacity(0.4);
    var size = const Size(double.infinity, double.infinity);
    var errorIcon = SvgImage(image: Assets.svg1.image_square, height: 28, color: color);
    return isSent
        ? ImageNetwork(
            radius: 6,
            width: double.infinity,
            height: 100,
            image: image.path,
            color: dark.colorOpacity(0.1),
            placeholder: LoaderBox(radius: 06, boxSize: size, border: color, child: const FadingCircle(size: 24, color: lightBlue)),
            errorWidget: LoaderBox(radius: 06, boxSize: size, border: color, child: errorIcon),
          )
        : ImageMemory(
            radius: 06,
            fit: BoxFit.cover,
            height: double.infinity,
            filterQuality: FilterQuality.high,
            colorBlendMode: BlendMode.darken,
            imagePath: image.doc?.unit8List,
            width: double.infinity,
            error: LoaderBox(radius: 06, boxSize: size, border: color, child: errorIcon),
          );
  }
}

class _DiscCard extends StatelessWidget {
  final SalesAd salesAd;
  final bool isMe;
  const _DiscCard({required this.salesAd, required this.isMe});

  @override
  Widget build(BuildContext context) {
    var userDisc = salesAd.userDisc;
    var parentDisc = userDisc?.parentDisc;
    return Container(
      margin: const EdgeInsets.only(bottom: 06),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(color: isMe ? primary : lightBlue, borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Builder(builder: (context) {
                if (userDisc?.media?.url != null) {
                  return CircleImage(
                    radius: 36,
                    borderWidth: 0.4,
                    borderColor: lightBlue,
                    image: userDisc?.media?.url,
                    placeholder: const FadingCircle(size: 30),
                    errorWidget: SvgImage(image: Assets.svg1.disc_3, height: 50, color: primary),
                    // errorWidget: ColoredDisc(size: 104, iconSize: 24, discColor: Colors.deepOrangeAccent),
                  );
                } else if (userDisc?.color != null) {
                  return ColoredDisc(
                    size: 72,
                    iconSize: 26,
                    discColor: userDisc!.disc_color!,
                    brandIcon: parentDisc?.brand_media.url,
                  );
                } else {
                  return CircleImage(
                    radius: 36,
                    borderWidth: 0.4,
                    borderColor: lightBlue,
                    image: parentDisc?.media.url,
                    placeholder: const FadingCircle(size: 30),
                    errorWidget: SvgImage(image: Assets.svg1.disc_3, height: 50, color: lightBlue),
                  );
                }
              }),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      parentDisc?.name ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyles.text16_600.copyWith(color: isMe ? lightBlue : primary),
                    ),
                    const SizedBox(height: 02),
                    Text(
                      '${parentDisc?.brand?.name ?? ''} ${userDisc?.plastic == null ? '' : '•'} ${userDisc?.plastic?.name ?? ''}',
                      textAlign: TextAlign.center,
                      style: TextStyles.text14_500.copyWith(color: isMe ? skyBlue : primary),
                    ),
                    const SizedBox(height: 02),
                    Text(
                      '${salesAd.price.formatDouble} ${salesAd.currency_code}',
                      style: TextStyles.text16_600.copyWith(color: warning),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (salesAd.usedRange != null) ...[
            const SizedBox(height: 08),
            Text(
              '${'disc_condition'.recast}: ${salesAd.condition_number}/10',
              style: TextStyles.text14_600.copyWith(color: isMe ? lightBlue : primary),
            ),
            const SizedBox(height: 02),
            Text(
              salesAd.usedRange == null ? 'n/a'.recast : USED_DISC_INFO[salesAd.condition_value!].recast,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyles.text12_400.copyWith(color: isMe ? lightBlue : primary),
            ),
          ],
          if (salesAd.address != null) ...[
            const SizedBox(height: 08),
            Text('address'.recast, style: TextStyles.text14_600.copyWith(color: isMe ? lightBlue : primary)),
            const SizedBox(height: 02),
            Text(
              salesAd.address?.formatted_city_state_country ?? '',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyles.text12_400.copyWith(color: isMe ? lightBlue : primary),
            ),
          ],
        ],
      ),
    );
  }
}
