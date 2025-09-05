import 'package:flutter/material.dart';

import 'package:app/components/buttons/elevate_button.dart';
import 'package:app/components/loaders/fading_circle.dart';
import 'package:app/components/loaders/screen_loader.dart';
import 'package:app/extensions/flutter_ext.dart';
import 'package:app/extensions/number_ext.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/models/system/data_model.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/fonts.dart';
import 'package:app/themes/gradients.dart';
import 'package:app/themes/text_styles.dart';
import 'package:app/utils/assets.dart';
import 'package:app/utils/dimensions.dart';
import 'package:app/utils/size_config.dart';
import 'package:app/widgets/core/pop_scope_navigator.dart';
import 'package:app/widgets/library/image_network.dart';
import 'package:app/widgets/library/svg_image.dart';
import 'package:app/widgets/ui/nav_button_box.dart';

class RecommendedDiscScreen extends StatefulWidget {
  final String disc;
  const RecommendedDiscScreen({required this.disc});

  @override
  State<RecommendedDiscScreen> createState() => _RecommendedDiscScreenState();
}

class _RecommendedDiscScreenState extends State<RecommendedDiscScreen> {
  var _loader = false;

  @override
  void initState() {
    // sl<AppAnalytics>().screenView('recommended-disc-screen');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScopeNavigator(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: Text('recommended_disc'.recast),
        ),
        body: Container(
          width: SizeConfig.width,
          height: SizeConfig.height,
          decoration: BoxDecoration(gradient: BACKGROUND_GRADIENT),
          child: Stack(children: [_screenView(context), if (_loader) const ScreenLoader()]),
        ),
        bottomNavigationBar: NavButtonBox(loader: _loader, childHeight: 42, child: _navbarButton(context)),
      ),
    );
  }

  Widget _navbarButton(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevateButton(
            radius: 04,
            height: 42,
            onTap: _onAddToWishlist,
            label: 'add_disc_to_wishlist'.recast.toUpper,
            textStyle: TextStyles.text14_700.copyWith(color: lightBlue, fontWeight: w600, height: 1.15),
          ),
        ),
        const SizedBox(width: 08),
        ElevateButton(
          radius: 04,
          height: 42,
          padding: 10.width,
          background: skyBlue,
          onTap: _onSeeNext,
          label: 'see_next'.recast.toUpper,
          textStyle: TextStyles.text14_700.copyWith(color: primary, fontWeight: w600, height: 1.15),
        ),
      ],
    );
  }

  void _onAddToWishlist() {
    backToPrevious();
    backToPrevious();
  }

  void _onSeeNext() {
    backToPrevious();
    backToPrevious();
  }

  Widget _screenView(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      clipBehavior: Clip.antiAlias,
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: Dimensions.screen_padding),
      children: [
        const SizedBox(height: 16),
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(border: Border.all(color: dark, width: 2), borderRadius: BorderRadius.circular(08)),
          child: Column(
            children: [
              Stack(
                children: [
                  ImageNetwork(
                    radius: 08,
                    width: 65.width,
                    height: 75.width,
                    fit: BoxFit.contain,
                    // image: DUMMY_DISC_IMAGE,
                    color: popupBearer.colorOpacity(0.1),
                    placeholder: const FadingCircle(size: 40, color: lightBlue),
                  ),
                  Positioned(left: 0, right: 0, bottom: 10, child: Center(child: _discInformation))
                ],
              ),
              const SizedBox(height: 20),
              Container(
                height: 66,
                width: double.infinity,
                padding: EdgeInsets.zero,
                decoration: BoxDecoration(color: primary, border: Border.all(color: lightBlue), borderRadius: BorderRadius.circular(8)),
                child: Row(
                  children: [
                    Expanded(child: _DicInfo(label: 'speed'.recast, value: 6.5)),
                    Container(height: 66, width: 0.5, color: lightBlue),
                    Expanded(child: _DicInfo(label: 'speed'.recast, value: 5)),
                    Container(height: 66, width: 0.5, color: lightBlue),
                    Expanded(child: _DicInfo(label: 'turn'.recast, value: -1)),
                    Container(height: 66, width: 0.5, color: lightBlue),
                    Expanded(child: _DicInfo(label: 'fade'.recast, value: 1)),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          decoration: BoxDecoration(color: primary, borderRadius: BorderRadius.circular(04)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('reasons_why_this_discs_will_improve_your_game'.recast, style: TextStyles.text16_700.copyWith(color: lightBlue)),
              const SizedBox(height: 12),
              _RecommendedInfoList(listItems: _STABILITY_LIST),
            ],
          ),
        ),
      ],
    );
  }

  Widget get _discInformation {
    var style = TextStyles.text14_400.copyWith(color: primary);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 06),
      decoration: BoxDecoration(color: skyBlue, border: Border.all(color: primary), borderRadius: BorderRadius.circular(12)),
      child: Text.rich(
        textAlign: TextAlign.center,
        TextSpan(
          text: 'Zone' + '\n',
          style: TextStyles.text18_700.copyWith(color: primary),
          children: [TextSpan(text: 'Discraft . Putter', style: style)],
        ),
      ),
    );
  }
}

class _DicInfo extends StatelessWidget {
  final String label;
  final double value;

  const _DicInfo({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    var style1 = TextStyles.text14_600.copyWith(color: lightBlue);
    var style2 = TextStyles.text16_700.copyWith(color: lightBlue);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 04),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Text(label, style: style1), const SizedBox(height: 01), Text(value.formatDouble, style: style2)],
      ),
    );
  }
}

class _RecommendedInfoList extends StatelessWidget {
  final List<DataModel> listItems;

  const _RecommendedInfoList({this.listItems = const []});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      clipBehavior: Clip.antiAlias,
      itemCount: listItems.length,
      itemBuilder: _selectableListItem,
      padding: EdgeInsets.zero,
    );
  }

  Widget _selectableListItem(BuildContext context, int index) {
    var item = listItems[index];
    var color = lightBlue;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.zero,
      margin: EdgeInsets.only(bottom: index == listItems.length - 1 ? 0 : 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(radius: 12, backgroundColor: orange, child: SvgImage(image: Assets.svg1.tick, color: white, height: 16)),
          const SizedBox(width: 10),
          Expanded(child: Text(item.label, style: TextStyles.text14_400.copyWith(color: color, height: 1.3))),
        ],
      ),
    );
  }
}

List<DataModel> _STABILITY_LIST = [
  DataModel(label: 'I prefer very over stable discs', value: 'i_prefer_very_over_stable_discs'),
  DataModel(label: 'I like stable/straight flyers', value: 'i_like_stable_straight_flyers'),
  DataModel(label: 'I prefer under stable discs (easier turnover/flex lines)', value: 'i_prefer_under_stable_discs'),
  DataModel(label: 'I like a mix depending on the situation', value: 'i_like_a_mix_depending_on_the_situation'),
];
