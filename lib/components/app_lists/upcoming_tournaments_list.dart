import 'package:flutter/material.dart';

import 'package:app/animations/tween_list_item.dart';
import 'package:app/constants/date_formats.dart';
import 'package:app/extensions/number_ext.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/helpers/enums.dart';
import 'package:app/libraries/formatters.dart';
import 'package:app/models/common/tournament.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/fonts.dart';
import 'package:app/themes/text_styles.dart';
import 'package:app/utils/dimensions.dart';

class UpcomingTournamentsList extends StatelessWidget {
  final String label;
  final List<Tournament> tournaments;
  final Function(Tournament)? onTap;

  const UpcomingTournamentsList({this.label = '', this.tournaments = const [], this.onTap});

  @override
  Widget build(BuildContext context) {
    var listTitle = '$label ${'upcoming_tournaments'.recast}'.trim();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: Dimensions.screen_padding),
          child: Text(listTitle, style: TextStyles.text18_700.copyWith(color: primary, letterSpacing: 0.54)),
        ),
        const SizedBox(height: 08),
        SizedBox(
          height: 140 + 24,
          child: ListView.builder(
            shrinkWrap: true,
            clipBehavior: Clip.antiAlias,
            itemCount: tournaments.length,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(bottom: 24),
            itemBuilder: _tournamentItemCard,
          ),
        ),
      ],
    );
  }

  Widget _tournamentItemCard(BuildContext context, int index) {
    var item = tournaments[index];
    var gap = Dimensions.screen_padding;
    return InkWell(
      onTap: onTap == null ? null : () => onTap!(item),
      child: TweenListItem(
        index: index,
        twinAnim: TwinAnim.right_to_left,
        child: Container(
          width: 64.width,
          key: Key('index_$index'),
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
          margin: EdgeInsets.only(left: index == 0 ? gap : 0, right: index == tournaments.length - 1 ? gap : 12),
          decoration: BoxDecoration(color: primary, borderRadius: BorderRadius.circular(12)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    Formatters.formatDate(DATE_FORMAT_16, item.eventDate),
                    style: TextStyles.text40_700.copyWith(color: lightBlue, fontWeight: w500),
                  ),
                  const SizedBox(height: 01),
                  Text(
                    Formatters.formatDate(DATE_FORMAT_11, item.eventDate),
                    style: TextStyles.text12_600.copyWith(color: lightBlue),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.eventName ?? '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyles.text14_400.copyWith(color: skyBlue),
                  ),
                  const SizedBox(height: 03),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
