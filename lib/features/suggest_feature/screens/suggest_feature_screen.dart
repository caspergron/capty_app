import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:app/components/buttons/elevate_button.dart';
import 'package:app/components/loaders/fading_circle.dart';
import 'package:app/components/loaders/screen_loader.dart';
import 'package:app/components/menus/back_menu.dart';
import 'package:app/constants/date_formats.dart';
import 'package:app/extensions/flutter_ext.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/features/suggest_feature/units/vote_icon.dart';
import 'package:app/features/suggest_feature/view_models/suggest_feature_view_model.dart';
import 'package:app/libraries/flush_popup.dart';
import 'package:app/libraries/formatters.dart';
import 'package:app/models/feature/feature.dart';
import 'package:app/services/routes.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/fonts.dart';
import 'package:app/themes/gradients.dart';
import 'package:app/themes/text_styles.dart';
import 'package:app/utils/assets.dart';
import 'package:app/utils/dimensions.dart';
import 'package:app/utils/size_config.dart';
import 'package:app/widgets/core/input_field.dart';
import 'package:app/widgets/library/circle_image.dart';
import 'package:app/widgets/library/svg_image.dart';
import 'package:app/widgets/ui/character_counter.dart';

class SuggestFeatureScreen extends StatefulWidget {
  @override
  State<SuggestFeatureScreen> createState() => _SuggestFeatureScreenState();
}

class _SuggestFeatureScreenState extends State<SuggestFeatureScreen> {
  var _viewModel = SuggestFeatureViewModel();
  var _modelData = SuggestFeatureViewModel();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _title = TextEditingController();
  final _feature = TextEditingController();
  final _focusNodes = [FocusNode(), FocusNode()];

  @override
  void initState() {
    // sl<AppAnalytics>().screenView('suggest-feature-screen');
    _focusNodes.forEach((item) => item.addListener(() => setState(() {})));
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => _viewModel.initViewModel());
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _viewModel = Provider.of<SuggestFeatureViewModel>(context, listen: false);
    _modelData = Provider.of<SuggestFeatureViewModel>(context);
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
        title: Text('suggest_feature'.recast),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        width: SizeConfig.width,
        height: SizeConfig.height,
        decoration: BoxDecoration(gradient: BACKGROUND_GRADIENT),
        child: Stack(children: [_screenView(context), if (_modelData.loader) const ScreenLoader()]),
      ),
    );
  }

  Widget _screenView(BuildContext context) {
    final features = _modelData.suggestedFeatures;
    return ListView(
      shrinkWrap: true,
      clipBehavior: Clip.antiAlias,
      padding: EdgeInsets.symmetric(horizontal: Dimensions.screen_padding),
      physics: const BouncingScrollPhysics(),
      children: [
        const SizedBox(height: 16),
        Text('feature_title'.recast.allFirstLetterCapital, style: TextStyles.text14_600.copyWith(color: primary)),
        const SizedBox(height: 06),
        InputField(
          controller: _title,
          focusNode: _focusNodes.first,
          hintText: '${'ex'.recast}. ${'i_want_a_match_service'.recast}',
          textCapitalization: TextCapitalization.sentences,
          borderRadius: BorderRadius.circular(06),
          focusedBorder: primary.colorOpacity(0.6),
          enabledBorder: lightBlue,
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (value) => FocusScope.of(context).requestFocus(_focusNodes.last),
        ),
        const SizedBox(height: 12),
        Text('suggest_feature'.recast, style: TextStyles.text14_600.copyWith(color: primary)),
        const SizedBox(height: 06),
        InputField(
          minLines: 06,
          maxLines: 12,
          counterText: '',
          maxLength: 150,
          controller: _feature,
          hintText: 'write_your_suggestion_here'.recast,
          focusNode: _focusNodes.last,
          enabledBorder: lightBlue,
          focusedBorder: primary.colorOpacity(0.6),
          onChanged: (v) => setState(() {}),
          borderRadius: BorderRadius.circular(06),
        ),
        if (_feature.text.isNotEmpty) ...[const SizedBox(height: 06), CharacterCounter(count: _feature.text.length, total: 150)],
        const SizedBox(height: 20),
        ElevateButton(
          radius: 04,
          height: 42,
          width: double.infinity,
          label: 'send_suggestion'.recast.toUpper,
          onTap: _onSendSuggestion,
          textStyle: TextStyles.text14_700.copyWith(color: lightBlue, fontWeight: w600, height: 1.15),
        ),
        if (features.isNotEmpty) ...[
          const SizedBox(height: 24),
          Text('suggested_features'.recast, style: TextStyles.text24_600.copyWith(color: primary, fontWeight: w500)),
          const SizedBox(height: 16),
          _SuggestFeaturesList(features: features, onVote: _viewModel.onVote),
        ],
        SizedBox(height: BOTTOM_GAP),
      ],
    );
  }

  void _clearStates() {
    _feature.clear();
    _title.clear();
    setState(() {});
  }

  Future<void> _onSendSuggestion() async {
    if (_title.text.isEmpty) return FlushPopup.onWarning(message: 'please_write_your_feature_title'.recast);
    if (_feature.text.isEmpty) return FlushPopup.onWarning(message: 'please_write_your_feature_suggestion'.recast);
    final response = await _viewModel.onSendSuggestion(title: _title.text, feature: _feature.text);
    if (response) _clearStates();
  }
}

class _SuggestFeaturesList extends StatelessWidget {
  final List<Feature> features;
  final Function(Feature)? onVote;
  const _SuggestFeaturesList({this.features = const [], this.onVote});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      clipBehavior: Clip.antiAlias,
      itemCount: features.length,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemBuilder: _suggestedFeatureItemCard,
    );
  }

  Widget _suggestedFeatureItemCard(BuildContext context, int index) {
    final item = features[index];
    final user = item.user;
    final totalItem = features.length;
    return InkWell(
      onTap: () => Routes.user.suggestion_details(feature: item).push(),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        margin: EdgeInsets.only(bottom: index == totalItem - 1 ? 0 : 10),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(04), border: Border.all(color: lightBlue.colorOpacity(0.8))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleImage(
                  radius: 17,
                  backgroundColor: lightBlue,
                  image: user?.media?.url,
                  placeholder: const FadingCircle(size: 14),
                  errorWidget: SvgImage(image: Assets.svg1.coach, color: primary, height: 22),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user?.full_name ?? 'n/a'.recast,
                        textAlign: TextAlign.start,
                        style: TextStyles.text14_600.copyWith(color: primary),
                      ),
                      const SizedBox(height: 1),
                      Text(
                        Formatters.formatDate(DATE_FORMAT_13, item.createdAt),
                        textAlign: TextAlign.start,
                        style: TextStyles.text12_400.copyWith(color: primary, height: 1, fontWeight: w500),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 04),
                VoteIcon(totalVote: item.totalVotes ?? 0, onTap: () => onVote == null ? null : onVote!(item)),
              ],
            ),
            const SizedBox(height: 08),
            Text(
              item.title ?? 'n/a'.recast,
              textAlign: TextAlign.start,
              style: TextStyles.text14_500.copyWith(color: primary, fontSize: 13.5, height: 1.15),
            ),
            const SizedBox(height: 04),
            Text(
              item.description ?? 'n/a'.recast,
              textAlign: TextAlign.start,
              style: TextStyles.text14_400.copyWith(color: primary, fontSize: 13.5, height: 1.15),
            ),
          ],
        ),
      ),
    );
  }
}
