import 'dart:async';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:app/components/buttons/elevate_button.dart';
import 'package:app/components/buttons/outline_button.dart';
import 'package:app/components/loaders/positioned_loader.dart';
import 'package:app/constants/app_keys.dart';
import 'package:app/di.dart';
import 'package:app/extensions/flutter_ext.dart';
import 'package:app/extensions/number_ext.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/features/club/view_models/club_view_model.dart';
import 'package:app/features/home/home_view_model.dart';
import 'package:app/models/club/club.dart';
import 'package:app/repository/club_repo.dart';
import 'package:app/repository/user_repo.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/fonts.dart';
import 'package:app/themes/shadows.dart';
import 'package:app/themes/text_styles.dart';
import 'package:app/utils/assets.dart';
import 'package:app/utils/dimensions.dart';
import 'package:app/utils/transitions.dart';
import 'package:app/widgets/core/pop_scope_navigator.dart';
import 'package:app/widgets/library/svg_image.dart';

Future<void> clubSettingsDialog({List<Club> clubs = const [], Function(List<Club>)? onLeave, Function()? onJoin}) async {
  final context = navigatorKey.currentState!.context;
  // sl<AppAnalytics>().screenView('club-settings-popup');
  final child = Align(child: _DialogView(clubs, onLeave, onJoin));
  await showGeneralDialog(
    context: context,
    barrierLabel: 'Club Created Dialog',
    transitionDuration: DIALOG_DURATION,
    transitionBuilder: sl<Transitions>().topToBottom,
    pageBuilder: (buildContext, anim1, anim2) => PopScopeNavigator(canPop: false, child: child),
  );
}

class _DialogView extends StatefulWidget {
  final List<Club> clubs;
  final Function(List<Club>)? onLeave;
  final Function()? onJoin;
  const _DialogView(this.clubs, this.onLeave, this.onJoin);

  @override
  State<_DialogView> createState() => _DialogViewState();
}

class _DialogViewState extends State<_DialogView> {
  var _loader = false;
  var _clubs = <Club>[];

  @override
  void initState() {
    _clubs = widget.clubs;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Dimensions.dialog_width,
      padding: EdgeInsets.symmetric(vertical: Dimensions.dialog_padding, horizontal: Dimensions.dialog_padding),
      decoration: BoxDecoration(color: primary, borderRadius: DIALOG_RADIUS, boxShadow: const [SHADOW_2]),
      child: Material(
        color: transparent,
        shape: DIALOG_SHAPE,
        child: Stack(children: [_screenView(context), if (_loader) const PositionedLoader()]),
      ),
    );
  }

  Widget _screenView(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Align(
          alignment: Alignment.topRight,
          child: InkWell(onTap: backToPrevious, child: SvgImage(image: Assets.svg1.close_1, height: 20, color: lightBlue)),
        ),
        const SizedBox(height: 10),
        SvgImage(image: Assets.svg3.training, height: 100, color: mediumBlue),
        const SizedBox(height: 16),
        Text('club_settings'.recast.toUpper, textAlign: TextAlign.center, style: TextStyles.text18_600.copyWith(color: lightBlue)),
        const SizedBox(height: 20),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            '${'your_clubs'.recast} (${widget.clubs.length})',
            style: TextStyles.text16_600.copyWith(color: lightBlue, fontWeight: w500),
          ),
        ),
        const SizedBox(height: 12),
        ListView.builder(
          shrinkWrap: true,
          clipBehavior: Clip.antiAlias,
          padding: EdgeInsets.zero,
          itemCount: widget.clubs.length,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: _clubItemCard,
        ),
        const SizedBox(height: 36),
        ElevateButton(
          radius: 04,
          height: 42,
          padding: 30,
          onTap: () => widget.onJoin == null ? null : widget.onJoin!(),
          label: 'join_a_new_club'.recast.toUpper,
          icon: SvgImage(image: Assets.svg1.plus, height: 20, color: lightBlue),
          textStyle: TextStyles.text14_700.copyWith(fontSize: 15, color: lightBlue, fontWeight: w600, height: 1.15),
        ),
        const SizedBox(height: 06),
      ],
    );
  }

  Widget _clubItemCard(BuildContext context, int index) {
    final item = widget.clubs[index];
    final isLast = index == widget.clubs.length - 1;
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: isLast ? 0 : 10),
      child: Column(
        children: [
          Row(
            children: [
              SvgImage(image: Assets.svg1.map_pin, height: 20, color: lightBlue),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  item.name ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyles.text14_400.copyWith(color: lightBlue, fontSize: 15, height: 1),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                '${'members'.recast.firstLetterCapital}: ${item.totalMember.formatInt}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyles.text14_400.copyWith(color: lightBlue, fontSize: 15, height: 1),
              ),
            ],
          ),
          const SizedBox(height: 08),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (item.is_default)
                Row(
                  children: [
                    SvgImage(image: Assets.svg1.tick, height: 12, color: orange),
                    const SizedBox(width: 04),
                    Text('default_club'.recast.toUpper, style: TextStyles.text12_700.copyWith(color: orange, height: 1)),
                  ],
                )
              else
                ElevateButton(
                  height: 28,
                  radius: 04,
                  padding: 10,
                  background: skyBlue,
                  onTap: () => _onDefaultClub(item, index),
                  label: 'set_as_default'.recast.toUpper,
                  textStyle: TextStyles.text12_700.copyWith(color: primary, height: 1),
                ),
              if (!item.is_default) const SizedBox(width: 12),
              if (!item.is_default)
                OutlineButton(
                  height: 28,
                  radius: 04,
                  padding: 10,
                  loader: _loader,
                  background: transparent,
                  onTap: () => _onLeftClub(item, index),
                  label: 'leave_club'.recast.toUpper,
                  icon: SvgImage(image: Assets.svg1.logout, height: 13, color: white),
                  textStyle: TextStyles.text12_700.copyWith(color: lightBlue, height: 1),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _onLeftClub(Club item, int index) async {
    setState(() => _loader = true);
    final body = {'club_id': item.id};
    final response = await sl<ClubRepository>().leaveClub(body);
    if (!response) return setState(() => _loader = false);
    _clubs.removeAt(index);
    setState(() => _loader = false);
    if (widget.onLeave != null) widget.onLeave!(_clubs);
  }

  Future<void> _onDefaultClub(Club item, int index) async {
    setState(() => _loader = true);
    final body = {'club_id': item.id};
    final response = await sl<ClubRepository>().markAsDefaultClub(body);
    if (response == null) return setState(() => _loader = false);
    final context = navigatorKey.currentState!.context;
    _clubs.forEach((item) => item.isDefault = false);
    _clubs[index] = response;
    unawaited(sl<UserRepository>().fetchProfileInfo());
    await Provider.of<HomeViewModel>(context, listen: false).fetchDefaultClubInfo();
    await Provider.of<ClubViewModel>(context, listen: false).fetchDefaultClub();
    setState(() => _loader = false);
    if (widget.onLeave != null) widget.onLeave!(_clubs);
  }
}
