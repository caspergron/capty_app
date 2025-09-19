import 'package:flutter/material.dart';

import 'package:app/animations/tween_list_item.dart';
import 'package:app/components/loaders/fading_circle.dart';
import 'package:app/extensions/number_ext.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/helpers/enums.dart';
import 'package:app/models/leaderboard/pdga_user.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/fonts.dart';
import 'package:app/themes/text_styles.dart';
import 'package:app/utils/assets.dart';
import 'package:app/widgets/library/circle_image.dart';
import 'package:app/widgets/library/image_network.dart';
import 'package:app/widgets/library/svg_image.dart';

class PlayersList extends StatelessWidget {
  final String menu;
  final double gap;
  final List<PdgaUser> players;
  final List<PdgaUser> topPlayers;
  final Function(PdgaUser)? onItem;

  const PlayersList({this.gap = 0, this.players = const [], this.topPlayers = const [], this.onItem, this.menu = 'rating'});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (topPlayers.isNotEmpty) const SizedBox(height: 20),
        if (topPlayers.isNotEmpty)
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SizedBox(width: gap),
              ...topPlayers.asMap().entries.map((entry) => Expanded(child: _topPlayerItemCard(entry))).toList(),
              SizedBox(width: gap),
            ],
          ),
        if (topPlayers.isNotEmpty) const SizedBox(height: 08),
        ListView.builder(
          shrinkWrap: true,
          clipBehavior: Clip.antiAlias,
          itemCount: players.length,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: gap),
          itemBuilder: _playerItemCard,
        ),
      ],
    );
  }

  Widget _playerItemCard(BuildContext context, int index) {
    final item = players[index];
    final isPositive = _arrowIconStatus(item);
    return InkWell(
      onTap: () => _onItem(item),
      child: TweenListItem(
        index: index,
        child: Container(
          width: double.infinity,
          key: Key('player-$index'),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 9),
          margin: EdgeInsets.only(bottom: index == players.length - 1 ? 0 : 08),
          decoration: BoxDecoration(color: primary, borderRadius: BorderRadius.circular(8)),
          child: Row(
            children: [
              Container(
                width: 46,
                child: Text(
                  (index + 4).formatInt,
                  textAlign: TextAlign.start,
                  style: TextStyles.text24_600.copyWith(color: lightBlue, fontWeight: w500, height: 1),
                ),
              ),
              const SizedBox(width: 02),
              ImageNetwork(
                width: 32,
                radius: 06,
                height: 32,
                background: mediumBlue,
                image: item.media?.url,
                placeholder: const FadingCircle(size: 20, color: white),
                errorWidget: SvgImage(image: Assets.svg1.coach, color: primary, height: 24),
              ),
              const SizedBox(width: 08),
              Expanded(
                child: Text(
                  item.name ?? '',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyles.text14_400.copyWith(color: lightBlue, height: 1),
                ),
              ),
              const SizedBox(width: 4),
              if (_isImprovement)
                SvgImage(
                  height: 14,
                  color: isPositive ? success : error,
                  image: isPositive ? Assets.svg1.arrow_up : Assets.svg1.arrow_down,
                ),
              if (_isImprovement) const SizedBox(width: 04),
              Text(_playerRating(item), style: TextStyles.text18_700.copyWith(color: lightBlue, height: 1)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _topPlayerItemCard(MapEntry<int, PdgaUser> entry) {
    final index = entry.key;
    final item = entry.value;
    final right = index == 0 ? 8.0 : 0.0;
    final left = index == topPlayers.length - 1 ? 8.0 : 0.0;
    final isTopper = index == 1;
    final background = _backgroundColor(index);
    final isPositive = _arrowIconStatus(item);
    return InkWell(
      onTap: () => _onItem(item),
      child: TweenListItem(
        index: index,
        twinAnim: TwinAnim.right_to_left,
        child: Container(
          margin: EdgeInsets.only(left: left, right: right),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: double.infinity,
                height: isTopper ? 160 : 140,
                decoration: BoxDecoration(color: primary, borderRadius: BorderRadius.circular(12)),
                child: item.id == null
                    ? Column(
                        children: [
                          SizedBox(height: isTopper ? 90 : 85),
                          SizedBox(height: isTopper ? 20 : 14),
                          Text(
                            _playerPositionName(index),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyles.text16_600.copyWith(color: lightBlue, height: 1, fontSize: 15),
                          ),
                        ],
                      )
                    : Column(
                        children: [
                          SizedBox(height: isTopper ? 90 : 85),
                          Text(
                            item.id == null ? _playerPositionName(index) : item.name ?? '',
                            maxLines: 1,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyles.text12_700.copyWith(color: lightBlue, fontSize: 12.5),
                          ),
                          SizedBox(height: isTopper ? 08 : 04),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _playerRating(item),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyles.text18_700.copyWith(color: lightBlue, height: 1),
                              ),
                              if (_isImprovement) const SizedBox(width: 04),
                              if (_isImprovement)
                                SvgImage(
                                  height: 14,
                                  color: isPositive ? success : error,
                                  image: isPositive ? Assets.svg1.arrow_up : Assets.svg1.arrow_down,
                                ),
                            ],
                          ),
                        ],
                      ),
              ),
              Positioned(
                left: 0,
                right: 0,
                top: -32,
                child: Center(
                  child: CircleImage(
                    radius: 48,
                    borderWidth: 6,
                    borderColor: background,
                    image: item.media?.url,
                    placeholder: FadingCircle(color: background, size: 40),
                    // backgroundColor: image == null ? primary : background,
                    errorWidget: SvgImage(image: Assets.svg1.coach, height: 54, color: background),
                  ),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                top: 47,
                child: Center(
                  child: Container(
                    width: 30,
                    height: 30,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(color: background, shape: BoxShape.circle),
                    child: Text('${_playerPosition(index)}', style: TextStyles.text18_700.copyWith(color: white, height: 1.2)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onItem(PdgaUser item) => onItem == null || item.id == null ? null : onItem!(item);

  bool get _isImprovement => menu.toKey != 'rating'.toKey;

  bool _arrowIconStatus(PdgaUser item) {
    if (menu.toKey == 'rating'.toKey) {
      return false;
    } else if (menu.toKey == 'improvement'.toKey) {
      return item.currentImprovement != null && item.currentImprovement! >= 0;
    } else {
      return item.yearlyImprovement != null && item.yearlyImprovement! >= 0;
    }
  }

  String _playerRating(PdgaUser item) {
    if (menu.toKey == 'rating'.toKey) {
      return item.formatted_current_rating;
    } else if (menu.toKey == 'improvement'.toKey) {
      return item.formated_current_improvement;
    } else {
      return item.formated_yearly_improvement;
    }
  }

  String _playerPositionName(int index) {
    if (index == 0) {
      return '2nd_player'.recast;
    } else if (index == 1) {
      return '1st_player'.recast;
    } else {
      return '3rd_player'.recast;
    }
  }

  int _playerPosition(int index) {
    if (index == 0) {
      return 2;
    } else if (index == 1) {
      return 1;
    } else {
      return 3;
    }
  }

  Color _backgroundColor(int index) {
    if (index == 0) {
      return silver;
    } else if (index == 1) {
      return gold;
    } else {
      return warning;
    }
  }
}
