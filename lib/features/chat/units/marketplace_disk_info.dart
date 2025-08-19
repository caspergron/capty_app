import 'package:flutter/material.dart';

import 'package:app/animations/tween_list_item.dart';
import 'package:app/components/loaders/fading_circle.dart';
import 'package:app/extensions/flutter_ext.dart';
import 'package:app/extensions/number_ext.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/helpers/enums.dart';
import 'package:app/models/chat/chat_buddy.dart';
import 'package:app/models/marketplace/sales_ad.dart';
import 'package:app/services/routes.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/fonts.dart';
import 'package:app/themes/shadows.dart';
import 'package:app/themes/text_styles.dart';
import 'package:app/utils/assets.dart';
import 'package:app/widgets/library/circle_image.dart';
import 'package:app/widgets/library/svg_image.dart';

// var desc1 = 'Club connection: Wesley De Ridder will attend same tournament as this user';
// var desc2 = 'Club connection: Wesley De Ridder will attend same tournament as this user';

class MarketplaceDiskInfo extends StatelessWidget {
  final ChatBuddy buddy;
  final List<SalesAd> discs;
  const MarketplaceDiskInfo({required this.buddy, this.discs = const []});

  @override
  Widget build(BuildContext context) {
    var nameStyle = TextStyles.text16_600.copyWith(color: lightBlue, fontWeight: w500);
    return Container(
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: primary,
        boxShadow: const [SHADOW_1],
        border: Border.all(color: primary, width: 0.6),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleImage(
                radius: 14,
                borderWidth: 1,
                borderColor: mediumBlue,
                backgroundColor: lightBlue,
                image: buddy.media?.url,
                placeholder: const FadingCircle(size: 18),
                errorWidget: SvgImage(image: Assets.svg1.coach, height: 18, color: primary),
                onTap: () => buddy.id == null ? null : Routes.user.player_profile(playerId: buddy.id!).push(),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: InkWell(
                  onTap: () => buddy.id == null ? null : Routes.user.player_profile(playerId: buddy.id!).push(),
                  child: Text(buddy.full_name, maxLines: 1, overflow: TextOverflow.ellipsis, style: nameStyle),
                ),
              ),
              if (buddy.distance != null && buddy.distance! > 0) ...[
                const SizedBox(width: 08),
                SvgImage(image: Assets.svg1.location, height: 14, color: skyBlue),
                const SizedBox(width: 04),
                Text('${buddy.distance.formatDouble} ${'km'.recast}', style: TextStyles.text12_600.copyWith(color: skyBlue)),
                const SizedBox(width: 02),
              ],
            ],
          ),
          /*const SizedBox(height: 08),
          Text('Intersection', style: TextStyles.text14_600.copyWith(color: mediumBlue)),
          const SizedBox(height: 08),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgImage(image: Assets.svg1.users, height: 24, color: const Color(0xFFA5BAF2)),
              const SizedBox(width: 8),
              Expanded(child: Text(desc1, style: TextStyles.text10_400.copyWith(color: mediumBlue, fontSize: 11))),
            ],
          ),
          const SizedBox(height: 08),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgImage(image: Assets.svg1.challenge, height: 24, color: const Color(0xFFA5BAF2)),
              const SizedBox(width: 8),
              Expanded(child: Text(desc1, style: TextStyles.text10_400.copyWith(color: mediumBlue, fontSize: 11))),
            ],
          ),*/
          if (discs.isNotEmpty) const SizedBox(height: 12),
          if (discs.isNotEmpty) Text('discs_for_sale'.recast, style: TextStyles.text14_600.copyWith(color: mediumBlue)),
          if (discs.isNotEmpty) const SizedBox(height: 08),
          if (discs.isNotEmpty)
            SizedBox(
              height: 40,
              child: ListView.builder(
                shrinkWrap: true,
                clipBehavior: Clip.antiAlias,
                itemCount: discs.length,
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.zero,
                itemBuilder: _discItemCard,
              ),
            ),
        ],
      ),
    );
  }

  Widget _discItemCard(BuildContext context, int index) {
    var item = discs[index];
    return TweenListItem(
      index: index,
      twinAnim: TwinAnim.right_to_left,
      child: Container(
        width: 40,
        key: Key('index_$index'),
        padding: const EdgeInsets.all(04),
        margin: EdgeInsets.only(right: index == discs.length - 1 ? 0 : 02),
        decoration: BoxDecoration(color: primary, borderRadius: BorderRadius.circular(12)),
        child: CircleImage(
          image: item.userDisc?.media?.url,
          borderColor: lightBlue,
          borderWidth: 0.4,
          placeholder: const FadingCircle(size: 20),
          errorWidget: SvgImage(image: Assets.svg1.disc_2, color: primary.colorOpacity(0.8), height: 24),
        ),
      ),
    );
  }
}

/*class _MarketplaceUser extends StatelessWidget {
  final ChatBuddy buddy;
  const _MarketplaceUser({required this.buddy});

  @override
  Widget build(BuildContext context) {
    var overflow = TextOverflow.ellipsis;
    var style2 = TextStyles.text14_500.copyWith(color: primary, height: 1);
    return Column(
      children: [
        CircleImage(
          radius: 36,
          borderWidth: 1,
          borderColor: mediumBlue,
          backgroundColor: lightBlue,
          placeholder: const FadingCircle(size: 32),
          errorWidget: SvgImage(image: Assets.svg1.coach, height: 48, color: primary),
        ),
        const SizedBox(height: 10),
        Text('Tanvir Anwar Rafi', textAlign: TextAlign.center, style: TextStyles.text18_600.copyWith(color: primary)),
        const SizedBox(height: 04),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgImage(image: Assets.svg1.email, color: primary, height: 16),
            const SizedBox(width: 03),
            Flexible(child: Text('tanviranwarrafi@gmail.com', maxLines: 1, textAlign: TextAlign.center, overflow: overflow, style: style2)),
          ],
        ),
      ],
    );
  }
}*/
