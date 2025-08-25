import 'package:app/components/buttons/elevate_button.dart';
import 'package:app/components/loaders/screen_loader.dart';
import 'package:app/components/menus/back_menu.dart';
import 'package:app/di.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/features/club/components/course_selection_sheet.dart';
import 'package:app/features/club/components/course_settings_dialog.dart';
import 'package:app/features/club/components/edit_club_desc_sheet.dart';
import 'package:app/features/club/components/edit_club_link_sheet.dart';
import 'package:app/features/club/components/edit_club_name_sheet.dart';
import 'package:app/features/club/view_models/club_settings_view_model.dart';
import 'package:app/libraries/launchers.dart';
import 'package:app/models/club/club.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/fonts.dart';
import 'package:app/themes/gradients.dart';
import 'package:app/themes/text_styles.dart';
import 'package:app/utils/assets.dart';
import 'package:app/utils/dimensions.dart';
import 'package:app/utils/size_config.dart';
import 'package:app/widgets/library/svg_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ClubSettingsScreen extends StatefulWidget {
  final Club club;
  const ClubSettingsScreen({required this.club});

  @override
  State<ClubSettingsScreen> createState() => _ClubSettingsScreenState();
}

class _ClubSettingsScreenState extends State<ClubSettingsScreen> {
  var _viewModel = ClubSettingsViewModel();
  var _modelData = ClubSettingsViewModel();

  @override
  void initState() {
    // sl<AppAnalytics>().screenView('club-settings-screen');
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => _viewModel.initViewModel(widget.club));
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _viewModel = Provider.of<ClubSettingsViewModel>(context, listen: false);
    _modelData = Provider.of<ClubSettingsViewModel>(context);
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
      appBar: AppBar(
        centerTitle: true,
        leading: const BackMenu(),
        title: Text(_modelData.club.name ?? widget.club.name ?? 'club_settings'.recast),
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
    var courses = _modelData.club.courses ?? [];
    var socialLink = _modelData.club.socialLink;
    var titleStyle = TextStyles.text14_600.copyWith(color: primary, height: 1, fontSize: 15);
    return ListView(
      clipBehavior: Clip.antiAlias,
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: Dimensions.screen_padding),
      children: [
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(08), border: Border.all(color: primary)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(child: Text('club_name'.recast, style: titleStyle)),
                  const SizedBox(width: 06),
                  InkWell(
                    child: SvgImage(image: Assets.svg1.edit, color: primary, height: 18),
                    onTap: () => editClubNameSheet(club: _modelData.club, onUpdate: (v) => setState(() => _modelData.club = v)),
                  ),
                ],
              ),
              const SizedBox(height: 02),
              Row(
                children: [
                  const Text('⛳', style: TextStyle(fontSize: 15)),
                  const SizedBox(width: 08),
                  Expanded(child: Text(_modelData.club.name ?? '', style: TextStyles.text14_400.copyWith(color: primary))),
                ],
              ),
              const SizedBox(height: 01),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(08), border: Border.all(color: primary)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(child: Text('connected_courses'.recast, style: titleStyle)),
                  const SizedBox(width: 06),
                  if (courses.isNotEmpty) SvgImage(image: Assets.svg1.edit, color: primary, height: 18),
                ],
              ),
              const SizedBox(height: 02),
              if (courses.isEmpty) const SizedBox(height: 14),
              if (courses.isEmpty)
                Text(
                  'No course connected yet. To create a new course, click on the connect new course button.',
                  textAlign: TextAlign.center,
                  style: TextStyles.text14_400.copyWith(color: primary, height: 1.3),
                ),
              if (courses.isEmpty) const SizedBox(height: 12),
              courses.isEmpty
                  ? Center(
                      child: ElevateButton(
                        radius: 04,
                        height: 36,
                        padding: 16,
                        label: 'connect_new_course'.recast.toUpper,
                        onTap: () => courseSettingsDialog(club: widget.club, onConnect: () => courseSelectionSheet(club: widget.club)),
                        icon: SvgImage(image: Assets.svg1.plus, height: 17, color: lightBlue),
                        textStyle: TextStyles.text14_700.copyWith(color: lightBlue, fontWeight: w600, height: 1.15),
                      ),
                    )
                  : ListView.separated(
                      shrinkWrap: true,
                      clipBehavior: Clip.antiAlias,
                      padding: EdgeInsets.zero,
                      itemCount: 3,
                      // itemCount: _modelData.club.courses!.length,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: _courseItemCard,
                      separatorBuilder: (context, index) => const SizedBox(height: 03),
                    ),
              const SizedBox(height: 01),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(08), border: Border.all(color: primary)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(child: Text('club_links'.recast, style: titleStyle)),
                  const SizedBox(width: 06),
                  InkWell(
                    child: SvgImage(image: Assets.svg1.edit, color: primary, height: 18),
                    onTap: () => editClubLinkSheet(club: _modelData.club, onUpdate: (v) => setState(() => _modelData.club = v)),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text('whats_app_link'.recast, style: TextStyles.text14_500.copyWith(color: primary, height: 1)),
              Row(
                children: [
                  const Text('🔗', style: TextStyle(fontSize: 15)),
                  const SizedBox(width: 08),
                  Expanded(
                    child: InkWell(
                      onTap: () => socialLink == null ? null : sl<Launchers>().launchInBrowser(url: socialLink),
                      child: Text(
                        socialLink ?? 'no_link_available_yet'.recast,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyles.text14_400.copyWith(
                          color: primary,
                          decoration: socialLink == null ? null : TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 01),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(08), border: Border.all(color: primary)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(child: Text('club_description'.recast, style: titleStyle)),
                  const SizedBox(width: 06),
                  InkWell(
                    child: SvgImage(image: Assets.svg1.edit, color: primary, height: 18),
                    onTap: () => editClubDescSheet(club: _modelData.club, onUpdate: (v) => setState(() => _modelData.club = v)),
                  ),
                ],
              ),
              const SizedBox(height: 02),
              Row(
                children: [
                  const Text('ℹ️', style: TextStyle(fontSize: 15)),
                  const SizedBox(width: 08),
                  Expanded(
                    child: Text(
                      _modelData.club.description ?? 'no_description_available_now'.recast,
                      textAlign: TextAlign.start,
                      style: TextStyles.text14_400.copyWith(color: primary),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 01),
            ],
          ),
        ),
        SizedBox(height: BOTTOM_GAP),
      ],
    );
  }

  Widget _courseItemCard(BuildContext context, int index) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('🌲', style: TextStyle(fontSize: 20)),
        const SizedBox(width: 08),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _modelData.club.name ?? '',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyles.text14_400.copyWith(color: primary),
              ),
              Text(
                '10 ${'km'.recast}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyles.text14_400.copyWith(color: primary),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
