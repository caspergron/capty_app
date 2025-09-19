import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:app/components/app_lists/disc_speciality_list.dart';
import 'package:app/components/app_lists/marketplace_disc_list.dart';
import 'package:app/components/buttons/elevate_button.dart';
import 'package:app/components/dialogs/zoom_image_dialog.dart';
import 'package:app/components/loaders/fading_circle.dart';
import 'package:app/components/loaders/screen_loader.dart';
import 'package:app/components/menus/back_menu.dart';
import 'package:app/constants/data_constants.dart';
import 'package:app/di.dart';
import 'package:app/extensions/flutter_ext.dart';
import 'package:app/extensions/number_ext.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/features/marketplace_management/marketplace_details/market_details_view_model.dart';
import 'package:app/models/marketplace/sales_ad.dart';
import 'package:app/preferences/user_preferences.dart';
import 'package:app/services/app_analytics.dart';
import 'package:app/services/routes.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/fonts.dart';
import 'package:app/themes/gradients.dart';
import 'package:app/themes/shadows.dart';
import 'package:app/themes/text_styles.dart';
import 'package:app/utils/assets.dart';
import 'package:app/utils/dimensions.dart';
import 'package:app/utils/size_config.dart';
import 'package:app/widgets/library/circle_image.dart';
import 'package:app/widgets/library/svg_image.dart';

class MarketDetailsScreen extends StatefulWidget {
  final bool isDelay;
  final SalesAd salesAd;
  const MarketDetailsScreen({required this.salesAd, this.isDelay = false});

  @override
  State<MarketDetailsScreen> createState() => _MarketDetailsScreenState();
}

class _MarketDetailsScreenState extends State<MarketDetailsScreen> {
  var _viewModel = MarketDetailsViewModel();
  var _modelData = MarketDetailsViewModel();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    sl<AppAnalytics>().screenView('market-details-screen');
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => _viewModel.initViewModel(widget.salesAd, widget.isDelay));
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _viewModel = Provider.of<MarketDetailsViewModel>(context, listen: false);
    _modelData = Provider.of<MarketDetailsViewModel>(context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _viewModel.disposeViewModel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        leading: const BackMenu(),
        title: Text(!widget.salesAd.is_my_disc ? 'seller_disc_details'.recast : 'my_disc_details'.recast),
      ),
      body: Container(
        width: SizeConfig.width,
        height: SizeConfig.height,
        decoration: BoxDecoration(gradient: BACKGROUND_GRADIENT),
        child: Stack(children: [_screenView(context), if (_modelData.loader.loader) const ScreenLoader()]),
      ),
    );
  }

  Widget _screenView(BuildContext context) {
    final marketplace = _modelData.marketplace;
    if (marketplace.id == null) return const SizedBox.shrink();
    final userDisc = marketplace.userDisc;
    final specialities = marketplace.specialityDiscs ?? [];
    final weight = userDisc?.weight == null ? 'n/a'.recast : '${userDisc?.weight.formatDouble} ${'gram'.recast}';
    final isDescription = marketplace.notes.toKey.isNotEmpty;
    final MeAsSeller = UserPreferences.user.id == widget.salesAd.sellerInfo?.id;
    return ListView(
      shrinkWrap: true,
      clipBehavior: Clip.antiAlias,
      padding: EdgeInsets.zero,
      physics: const BouncingScrollPhysics(),
      children: [
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          margin: EdgeInsets.symmetric(horizontal: Dimensions.screen_padding),
          // padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
          decoration: BoxDecoration(color: primary, borderRadius: BorderRadius.circular(12)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  InkWell(
                    onTap: () => zoomImageDialog(salesAd: _modelData.marketplace),
                    child: Center(
                      child: CircleImage(
                        borderWidth: 0.4,
                        radius: 22.width,
                        image: userDisc?.media?.url,
                        backgroundColor: primary,
                        placeholder: const FadingCircle(color: lightBlue),
                        errorWidget: SvgImage(image: Assets.svg1.disc_3, height: 42.width, color: lightBlue),
                      ),
                    ),
                  ),
                  Positioned(left: 0, right: 0, bottom: -20, child: Center(child: _discBasicInfo))
                ],
              ),
              const SizedBox(height: 36),
              const Divider(color: mediumBlue),
              const SizedBox(height: 14),
              Container(
                height: 60,
                width: double.infinity,
                padding: EdgeInsets.zero,
                margin: EdgeInsets.symmetric(horizontal: Dimensions.dialog_padding),
                decoration: BoxDecoration(border: Border.all(color: lightBlue), borderRadius: BorderRadius.circular(8)),
                child: Row(
                  children: [
                    Expanded(child: _DiscFlightInfo(label: 'speed'.recast, value: userDisc?.speed ?? 0)),
                    Container(height: 60, width: 0.5, color: lightBlue),
                    Expanded(child: _DiscFlightInfo(label: 'glide'.recast, value: userDisc?.glide ?? 0)),
                    Container(height: 60, width: 0.5, color: lightBlue),
                    Expanded(child: _DiscFlightInfo(label: 'turn'.recast, value: userDisc?.turn ?? 0)),
                    Container(height: 60, width: 0.5, color: lightBlue),
                    Expanded(child: _DiscFlightInfo(label: 'fade'.recast, value: userDisc?.fade ?? 0)),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                margin: EdgeInsets.symmetric(horizontal: Dimensions.dialog_padding),
                decoration: BoxDecoration(border: Border.all(color: lightBlue), borderRadius: BorderRadius.circular(8)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        SvgImage(image: Assets.svg1.review, height: 24, color: lightBlue),
                        const SizedBox(width: 06),
                        Text('specialty'.recast, style: TextStyles.text14_600.copyWith(color: lightBlue, height: 1)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    specialities.isNotEmpty
                        ? DiscSpecialityList(specialities: specialities)
                        : Text('no_speciality_available'.recast, style: TextStyles.text14_600.copyWith(color: lightBlue, height: 1)),
                    const SizedBox(height: 04),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(width: Dimensions.dialog_padding),
                  Expanded(flex: 10, child: _DiscInfo(icon: Assets.svg1.weight_scale, label: 'disc_weight'.recast, value: weight)),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 10,
                    child: _DiscInfo(icon: Assets.svg1.target, label: 'disc_type'.recast, value: userDisc?.type ?? 'n/a'.recast),
                  ),
                  SizedBox(width: Dimensions.dialog_padding),
                ],
              ),
              const SizedBox(height: 16),
              _DiscInfo(
                padding: Dimensions.dialog_padding,
                icon: Assets.svg1.disc_2,
                label: '${'disc_condition'.recast}: ${_modelData.marketplace.condition_number}/10',
                value: _modelData.marketplace.usedRange == null
                    ? 'n/a'.recast
                    : USED_DISC_INFO[_modelData.marketplace.condition_value!].recast,
              ),
              if (userDisc?.plastic?.id != null) ...[
                const SizedBox(height: 16),
                _DiscInfo(
                  icon: Assets.svg1.dna,
                  padding: Dimensions.dialog_padding,
                  label: 'disc_plastic'.recast,
                  value: userDisc?.plastic?.name ?? 'n/a'.recast,
                ),
              ],
              if (isDescription) ...[
                const SizedBox(height: 16),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: Dimensions.dialog_padding),
                  child: Text('disc_description'.recast, style: TextStyles.text16_600.copyWith(color: lightBlue)),
                ),
                const SizedBox(height: 08),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: Dimensions.dialog_padding),
                  child: Text(
                    _modelData.marketplace.notes ?? '',
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyles.text13_600.copyWith(color: lightBlue, fontWeight: w400),
                  ),
                ),
              ],
              if (!widget.salesAd.is_my_disc) const SizedBox(height: 28),
              if (!widget.salesAd.is_my_disc)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: Dimensions.dialog_padding),
                  child: ElevateButton(
                    radius: 04,
                    height: 38,
                    padding: 24,
                    width: double.infinity,
                    onTap: _onContactSeller,
                    label: 'contact_seller'.recast.toUpper,
                    textStyle: TextStyles.text14_700.copyWith(color: lightBlue, fontWeight: w600, height: 1.15),
                  ),
                ),
              const SizedBox(height: 16),
            ],
          ),
        ),
        if (!MeAsSeller) const SizedBox(height: 24),
        if (!MeAsSeller) _sellerClubAndTournamentInfo,
        if (_modelData.discList.isNotEmpty) ...[
          const SizedBox(height: 24),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Dimensions.screen_padding),
            child: Text('more_from_this_seller'.recast, style: TextStyles.text18_700.copyWith(color: primary, letterSpacing: 0.54)),
          ),
          const SizedBox(height: 08),
          MarketplaceDiscList(
            discs: _modelData.discList,
            onTap: (item) => Routes.user.market_details(salesAd: item, isDelay: true).pushReplacement(),
          ),
        ],
        SizedBox(height: BOTTOM_GAP),
      ],
    );
  }

  void _onContactSeller() {
    final chatBuddy = _modelData.marketplace.chat_buddy;
    final params = {'seller_id': chatBuddy.id, 'seller_name': chatBuddy.name, 'image': chatBuddy.media?.url};
    sl<AppAnalytics>().logEvent(name: 'contact_seller_view', parameters: params);
    Routes.user.chat(buddy: chatBuddy).push();
  }

  Widget get _discBasicInfo {
    final name = _modelData.marketplace.userDisc?.name ?? '';
    final price = '${_modelData.marketplace.price.formatDouble} ${_modelData.marketplace.currency_code}';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 02),
      decoration: BoxDecoration(color: skyBlue, border: Border.all(color: primary), borderRadius: BorderRadius.circular(06)),
      child: Column(
        children: [
          Text(name, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyles.text14_700.copyWith(color: dark, fontWeight: w700)),
          Text(price, style: TextStyles.text14_700.copyWith(color: orange, fontWeight: w700)),
          const SizedBox(height: 1),
        ],
      ),
    );
  }

  Widget get _sellerClubAndTournamentInfo {
    final clubTournament = _modelData.clubTournament;
    final seller = _modelData.marketplace.sellerInfo;
    final address = _modelData.marketplace.address;
    final friendInfoLabel = '${seller?.full_name ?? ''} ${'is_a_friend_of_you'.recast}.';
    final shippingLabel = _modelData.isShipping ? 'this_seller_offers_shipping'.recast : 'this_seller_does_not_offers_shipping'.recast;
    return Container(
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.symmetric(horizontal: Dimensions.screen_padding),
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
                image: seller?.media?.url,
                placeholder: const FadingCircle(size: 18),
                errorWidget: SvgImage(image: Assets.svg1.coach, height: 18, color: primary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  seller?.full_name ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyles.text16_600.copyWith(color: lightBlue, fontWeight: w500),
                ),
              ),
              const SizedBox(width: 08),
              SvgImage(image: Assets.svg1.location, height: 14, color: skyBlue),
              const SizedBox(width: 04),
              Text('${address?.distance.formatDouble} ${'km'.recast}', style: TextStyles.text12_600.copyWith(color: skyBlue)),
              const SizedBox(width: 02),
            ],
          ),
          const SizedBox(height: 10),
          Text('${'these_are_places_where_your_paths_cross'.recast}:', style: TextStyles.text14_600.copyWith(color: mediumBlue)),
          if (clubTournament.is_friend) const SizedBox(height: 08),
          if (clubTournament.is_friend)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgImage(image: Assets.svg1.coach_plus, height: 24, color: const Color(0xFFA5BAF2)),
                const SizedBox(width: 8),
                // '${seller?.full_name ?? ''} ${clubTournament.is_friend ? 'is_a_friend_of_you'.recast : 'is_not_a_friend_of_you'.recast}.',
                Expanded(child: Text(friendInfoLabel, style: TextStyles.text12_400.copyWith(color: mediumBlue))),
              ],
            ),
          if (clubTournament.clubs.haveList) ...[
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgImage(image: Assets.svg1.users, height: 24, color: const Color(0xFFA5BAF2)),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${'you_are_both_members_of_these_clubs'.recast}:', style: TextStyles.text12_400.copyWith(color: mediumBlue)),
                      const SizedBox(height: 04),
                      ListView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        clipBehavior: Clip.antiAlias,
                        itemCount: clubTournament.clubs!.length,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) => _sellerInfoItemCard(clubTournament.clubs![index].name),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
          if (clubTournament.tournaments.haveList) ...[
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgImage(image: Assets.svg1.challenge, height: 24, color: const Color(0xFFA5BAF2)),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${'you_will_both_attend'.recast}:', style: TextStyles.text12_400.copyWith(color: mediumBlue)),
                      const SizedBox(height: 04),
                      ListView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        clipBehavior: Clip.antiAlias,
                        itemCount: clubTournament.tournaments!.length,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) => _sellerInfoItemCard(clubTournament.tournaments![index].tournament_info_2),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
          if (_modelData.sellerAddresses.isNotEmpty) ...[
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgImage(image: Assets.svg1.location, height: 24, color: const Color(0xFFA5BAF2)),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${'the_seller_pick_up_points'.recast}:', style: TextStyles.text12_400.copyWith(color: mediumBlue)),
                      const SizedBox(height: 04),
                      ListView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        clipBehavior: Clip.antiAlias,
                        itemCount: _modelData.sellerAddresses.length,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, i) => _sellerInfoItemCard(_modelData.sellerAddresses[i].formatted_city_state_country),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgImage(image: Assets.svg1.truck, height: 24, color: const Color(0xFFA5BAF2)),
              const SizedBox(width: 09),
              Expanded(child: Text(shippingLabel, textAlign: TextAlign.start, style: TextStyles.text12_400.copyWith(color: mediumBlue))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _sellerInfoItemCard(String? label) {
    if (label == null) return const SizedBox.shrink();
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Padding(padding: EdgeInsets.only(top: 06), child: Icon(Icons.circle, size: 06, color: Color(0xFFA5BAF2))),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            maxLines: 2,
            textAlign: TextAlign.start,
            overflow: TextOverflow.ellipsis,
            style: TextStyles.text12_400.copyWith(color: mediumBlue),
          ),
        ),
      ],
    );
  }
}

class _DiscInfo extends StatelessWidget {
  final String icon;
  final String label;
  final String value;
  final double padding;
  const _DiscInfo({this.icon = '', this.label = '', this.value = '', this.padding = 0});

  @override
  Widget build(BuildContext context) {
    final style = TextStyles.text13_600.copyWith(color: lightBlue, fontWeight: w300);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: padding),
        SvgImage(image: icon, height: 34, color: lightBlue),
        const SizedBox(width: 06),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyles.text14_500.copyWith(color: lightBlue)),
              Text(value, maxLines: 2, overflow: TextOverflow.ellipsis, style: style),
            ],
          ),
        ),
        SizedBox(width: padding),
      ],
    );
  }
}

class _DiscFlightInfo extends StatelessWidget {
  final String label;
  final double value;

  const _DiscFlightInfo({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final style1 = TextStyles.text14_600.copyWith(color: lightBlue);
    final style2 = TextStyles.text16_700.copyWith(color: lightBlue);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 04),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Text(label, style: style1), const SizedBox(height: 01), Text(value.formatDouble, style: style2)],
      ),
    );
  }
}
