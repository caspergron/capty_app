import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:app/components/buttons/elevate_button.dart';
import 'package:app/components/loaders/fading_circle.dart';
import 'package:app/components/loaders/screen_loader.dart';
import 'package:app/components/menus/back_menu.dart';
import 'package:app/constants/date_formats.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/features/suggest_feature/components/post_feedback_sheet.dart';
import 'package:app/features/suggest_feature/units/suggestion_message_list.dart';
import 'package:app/features/suggest_feature/units/vote_icon.dart';
import 'package:app/features/suggest_feature/view_models/suggestion_details_view_model.dart';
import 'package:app/libraries/formatters.dart';
import 'package:app/models/common/end_user.dart';
import 'package:app/models/feature/feature.dart';
import 'package:app/preferences/user_preferences.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/fonts.dart';
import 'package:app/themes/gradients.dart';
import 'package:app/themes/text_styles.dart';
import 'package:app/utils/assets.dart';
import 'package:app/utils/dimensions.dart';
import 'package:app/utils/size_config.dart';
import 'package:app/widgets/library/circle_image.dart';
import 'package:app/widgets/library/svg_image.dart';
import 'package:app/widgets/ui/nav_button_box.dart';

class SuggestionDetailsScreen extends StatefulWidget {
  final Feature feature;
  const SuggestionDetailsScreen({required this.feature});

  @override
  State<SuggestionDetailsScreen> createState() => _SuggestionDetailsScreenState();
}

class _SuggestionDetailsScreenState extends State<SuggestionDetailsScreen> {
  var _viewModel = SuggestionDetailsViewModel();
  var _modelData = SuggestionDetailsViewModel();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _focusNode = FocusNode();

  @override
  void initState() {
    // sl<AppAnalytics>().screenView('suggestion-details-screen');
    _focusNode.addListener(() => setState(() {}));
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => _viewModel.initViewModel(widget.feature));
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _viewModel = Provider.of<SuggestionDetailsViewModel>(context, listen: false);
    _modelData = Provider.of<SuggestionDetailsViewModel>(context);
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
        title: Text('suggestion_details'.recast),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        width: SizeConfig.width,
        height: SizeConfig.height,
        decoration: BoxDecoration(gradient: BACKGROUND_GRADIENT),
        child: Stack(children: [_screenView(context), if (_modelData.loader) const ScreenLoader()]),
      ),
      bottomNavigationBar: NavButtonBox(
        childHeight: 42,
        loader: _modelData.loader,
        child: ElevateButton(radius: 04, height: 42, label: 'post_your_feedback'.recast.toUpper, onTap: _onPostFeedback),
      ),
    );
  }

  void _onPostFeedback() => postFeedbackSheet(suggestion: _modelData.feature, onPost: _viewModel.onPostFeedback);

  Widget _screenView(BuildContext context) {
    final user = UserPreferences.user;
    final comments = _modelData.feature.comments ?? [];
    final totalVote = _modelData.feature.votes ?? 0;
    final voteIcon = VoteIcon(totalVote: totalVote, onTap: _viewModel.onVote);
    return ListView(
      clipBehavior: Clip.antiAlias,
      controller: _viewModel.scrollControl,
      physics: const ClampingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: Dimensions.screen_padding),
      children: [
        const SizedBox(height: 16),
        Stack(
          clipBehavior: Clip.none,
          children: [_suggestionInformationView, Positioned(right: 14, bottom: -12, child: voteIcon)],
        ),
        const SizedBox(height: 24),
        SuggestionMessageList(messages: comments, sender: EndUser(id: user.id, name: user.full_name)),
        SizedBox(height: BOTTOM_GAP),
      ],
    );
  }

  Widget get _suggestionInformationView {
    final feature = _modelData.feature;
    final user = feature.user;
    return Container(
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(color: primary, borderRadius: BorderRadius.circular(08)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleImage(
                radius: 14,
                backgroundColor: lightBlue,
                image: user?.media?.url,
                placeholder: const FadingCircle(size: 14),
                errorWidget: SvgImage(image: Assets.svg1.coach, color: primary, height: 18),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(user?.full_name ?? 'n/a'.recast, style: TextStyles.text16_700.copyWith(color: lightBlue)),
                    const SizedBox(height: 1),
                    Text(
                      Formatters.formatDate(DATE_FORMAT_14, feature.createdAt),
                      textAlign: TextAlign.start,
                      style: TextStyles.text12_400.copyWith(color: lightBlue, height: 1, fontWeight: w500),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text('feature_title'.recast, style: TextStyles.text14_600.copyWith(color: lightBlue)),
          Text(feature.title ?? 'n/a'.recast, style: TextStyles.text14_400.copyWith(color: lightBlue)),
          const SizedBox(height: 12),
          Text('suggested_feature'.recast, style: TextStyles.text14_600.copyWith(color: lightBlue)),
          Text(feature.description ?? 'n/a'.recast, style: TextStyles.text14_400.copyWith(color: lightBlue)),
        ],
      ),
    );
  }
}
