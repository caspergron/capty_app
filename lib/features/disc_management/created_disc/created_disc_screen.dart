import 'package:flutter/material.dart';

import 'package:app/components/buttons/elevate_button.dart';
import 'package:app/components/loaders/fading_circle.dart';
import 'package:app/components/loaders/screen_loader.dart';
import 'package:app/extensions/flutter_ext.dart';
import 'package:app/extensions/number_ext.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/models/disc/user_disc.dart';
import 'package:app/services/routes.dart';
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
import 'package:app/widgets/ui/colored_disc.dart';
import 'package:app/widgets/ui/nav_button_box.dart';

class CreatedDiscScreen extends StatefulWidget {
  final UserDisc disc;
  final bool isDisc;
  const CreatedDiscScreen({required this.disc, required this.isDisc});

  @override
  State<CreatedDiscScreen> createState() => _CreatedDiscScreenState();
}

class _CreatedDiscScreenState extends State<CreatedDiscScreen> {
  var _loader = false;

  @override
  void initState() {
    // sl<AppAnalytics>().screenView('created-disc-screen');
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
          title: Text(widget.isDisc ? 'added_discs'.recast : 'created_sales_ad'.recast),
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
        ElevateButton(
          radius: 04,
          height: 42,
          background: skyBlue,
          onTap: () => Routes.user.landing(index: widget.isDisc ? 3 : 4).pushAndRemove(),
          label: widget.isDisc ? 'go_to_disc_management'.recast.toUpper : 'go_to_marketplace'.recast.toUpper,
          textStyle: TextStyles.text14_700.copyWith(color: primary, fontWeight: w600, height: 1.15),
        ),
        const SizedBox(width: 08),
        Expanded(
          child: ElevateButton(
            radius: 04,
            height: 42,
            onTap: _onCreateAnother,
            label: widget.isDisc ? 'add_another_disc'.recast.toUpper : 'create_another_sales_ad'.recast.toUpper,
            textStyle: TextStyles.text14_700.copyWith(color: lightBlue, fontWeight: w600, height: 1.15),
          ),
        ),
      ],
    );
  }

  void _onCreateAnother() {
    backToPrevious();
    backToPrevious();
  }

  Widget _screenView(BuildContext context) {
    final userDisc = widget.disc;
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
          decoration: BoxDecoration(color: primary, borderRadius: BorderRadius.circular(08)),
          child: Stack(
            children: [
              Builder(builder: (context) {
                if (userDisc.color != null) {
                  return Container(
                    height: 75.width,
                    width: double.infinity,
                    color: transparent,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.only(top: 24, bottom: 10),
                    child: ColoredDisc(
                      size: 70.width,
                      iconSize: 30.width,
                      discColor: userDisc.disc_color!,
                      brandIcon: userDisc.brand?.media?.url,
                    ),
                  );
                } else {
                  return ImageNetwork(
                    radius: 08,
                    width: 65.width,
                    height: 75.width,
                    fit: BoxFit.contain,
                    image: userDisc.media?.url,
                    placeholder: const FadingCircle(size: 40, color: lightBlue),
                    errorWidget: Center(child: SvgImage(image: Assets.svg1.disc_2, fit: BoxFit.cover, height: 30.width)),
                  );
                }
              }),
              Positioned(left: 0, right: 0, bottom: userDisc.color != null ? 20 : 10, child: Center(child: _discInfo))
            ],
          ),
        ),
        SizedBox(height: 10.height),
        Text(
          widget.isDisc ? 'your_disc_has_been_added_successfully'.recast : 'we_have_created_this_sales_ad'.recast,
          textAlign: TextAlign.center,
          style: TextStyles.text24_600.copyWith(color: primary, fontWeight: w500),
        )
      ],
    );
  }

  Widget get _discInfo {
    final name = widget.disc.name ?? 'n/a'.recast;
    final subLabel = '${widget.disc.brand?.name ?? 'n/a'.recast} . ${widget.disc.type ?? 'n/a'.recast}';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 06),
      decoration: BoxDecoration(color: skyBlue, border: Border.all(color: primary), borderRadius: BorderRadius.circular(12)),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(text: name, style: TextStyles.text18_700.copyWith(color: primary)),
            TextSpan(text: '\n', style: TextStyles.text14_400.copyWith(color: primary)),
            TextSpan(text: subLabel, style: TextStyles.text14_400.copyWith(color: primary)),
          ],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
