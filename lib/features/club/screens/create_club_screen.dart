import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:app/components/buttons/elevate_button.dart';
import 'package:app/components/loaders/screen_loader.dart';
import 'package:app/components/menus/back_menu.dart';
import 'package:app/di.dart';
import 'package:app/extensions/flutter_ext.dart';
import 'package:app/extensions/number_ext.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/features/club/units/nearby_courses_list.dart';
import 'package:app/features/club/view_models/create_club_view_model.dart';
import 'package:app/libraries/flush_popup.dart';
import 'package:app/preferences/user_preferences.dart';
import 'package:app/services/app_analytics.dart';
import 'package:app/services/validators.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/fonts.dart';
import 'package:app/themes/gradients.dart';
import 'package:app/themes/text_styles.dart';
import 'package:app/utils/dimensions.dart';
import 'package:app/utils/size_config.dart';
import 'package:app/widgets/core/input_field.dart';
import 'package:app/widgets/core/linear_progressbar.dart';
import 'package:app/widgets/library/map_address_picker.dart';
import 'package:app/widgets/ui/character_counter.dart';

class CreateClubScreen extends StatefulWidget {
  @override
  State<CreateClubScreen> createState() => _CreateClubScreenState();
}

class _CreateClubScreenState extends State<CreateClubScreen> {
  var _viewModel = CreateClubViewModel();
  var _modelData = CreateClubViewModel();
  var _name = TextEditingController();
  var _socialLink = TextEditingController();
  var _description = TextEditingController();
  var _focusNodes = [FocusNode(), FocusNode(), FocusNode()];

  @override
  void initState() {
    sl<AppAnalytics>().screenView('create-club-screen');
    _focusNodes.forEach((item) => item.addListener(() => setState(() {})));
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => _viewModel.initViewModel());
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _viewModel = Provider.of<CreateClubViewModel>(context, listen: false);
    _modelData = Provider.of<CreateClubViewModel>(context);
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
        title: Text('create_your_club'.recast),
        automaticallyImplyLeading: false,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LinearProgressbar(total: _modelData.step.toDouble(), separator: 2, valueColor: primary, height: 10, radius: 0),
        const SizedBox(height: 16),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: Dimensions.screen_padding),
          child: Text('${'step'.recast} ${_modelData.step.formatInt}', style: TextStyles.text24_600.copyWith(color: primary)),
        ),
        const SizedBox(height: 14),
        Expanded(
          child: ListView(
            shrinkWrap: true,
            clipBehavior: Clip.antiAlias,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: Dimensions.screen_padding),
            children: _modelData.step == 1 ? _step1View : _step2View,
          ),
        ),
        const SizedBox(height: 12),
        if (_modelData.courses.isNotEmpty) _bottomActions,
        SizedBox(height: BOTTOM_GAP),
      ],
    );
  }

  List<Widget> get _step1View {
    if (_modelData.loader.initial) return [];
    return [
      Text('club_name'.recast, style: TextStyles.text14_600.copyWith(color: primary)),
      const SizedBox(height: 04),
      InputField(
        controller: _name,
        hintText: '${'ex'.recast}: ${'storm_chasers'.recast}',
        focusNode: _focusNodes[0],
        keyboardType: TextInputType.name,
        enabledBorder: skyBlue,
        focusedBorder: mediumBlue,
      ),
      const SizedBox(height: 20),
      Text('club_location_and_courses'.recast, style: TextStyles.text14_600.copyWith(color: primary)),
      const SizedBox(height: 04),
      if (_modelData.coordinates.is_coordinate)
        Container(
          height: 35.height,
          width: double.infinity,
          decoration: BoxDecoration(border: Border.all(color: white), borderRadius: BorderRadius.circular(08)),
          // child: MapCoordinatesView(coordinates: _modelData.coordinates, showMarker: true),
          child: MapAddressPicker(coordinates: _modelData.coordinates, onMoveCamera: _viewModel.onCameraMove, zoomEnabled: true),
        ),
      const SizedBox(height: 20),
      if (_modelData.courses.isNotEmpty) Text('nearby_courses_within_50_km'.recast, style: TextStyles.text14_600.copyWith(color: primary)),
      if (_modelData.courses.isNotEmpty) const SizedBox(height: 10),
      Builder(builder: (context) {
        if (_modelData.courses.isEmpty && _modelData.clubs.isEmpty) {
          return _noCourseFound;
        } else if (_modelData.clubs.isNotEmpty) {
          return _clubExistIn10Km;
        } else {
          if (_modelData.courses.isEmpty) return _noCourseFound;
          return NearbyCoursesList(
            homeCourse: _modelData.homeCourse,
            courses: _modelData.courses,
            onConnect: _viewModel.onSetCourse,
            onSetHome: _viewModel.onSetHomeCourse,
            selectedCourses: _modelData.selectedCourses,
          );
        }
      }),
      const SizedBox(height: 20),
    ];
  }

  List<Widget> get _step2View {
    return [
      Text('communication_channel_link'.recast, style: TextStyles.text14_600.copyWith(color: primary)),
      const SizedBox(height: 04),
      InputField(
        controller: _socialLink,
        hintText: '${'ex'.recast}: https://wa.me/1234567890',
        focusNode: _focusNodes[1],
        enabledBorder: skyBlue,
        focusedBorder: mediumBlue,
        keyboardType: TextInputType.url,
        onFieldSubmitted: (value) => FocusScope.of(context).requestFocus(_focusNodes[2]),
      ),
      const SizedBox(height: 16),
      Text('club_description'.recast, style: TextStyles.text14_600.copyWith(color: primary)),
      const SizedBox(height: 04),
      InputField(
        minLines: 6,
        maxLines: 20,
        maxLength: 200,
        counterText: '',
        controller: _description,
        hintText: 'type_here'.recast,
        focusNode: _focusNodes[2],
        enabledBorder: skyBlue,
        focusedBorder: mediumBlue,
        onChanged: (v) => setState(() {}),
      ),
      if (_description.text.isNotEmpty) const SizedBox(height: 06),
      if (_description.text.isNotEmpty) CharacterCounter(count: _description.text.length, total: 200, color: primary),
      const SizedBox(height: 20),
    ];
  }

  Widget get _bottomActions {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(width: Dimensions.screen_padding),
        Expanded(
          child: ElevateButton(
            radius: 04,
            height: 42,
            background: skyBlue,
            onTap: _onBack,
            label: (_modelData.step == 1 ? 'cancel' : 'back').recast.toUpper,
            textStyle: TextStyles.text14_700.copyWith(color: primary, fontWeight: w600, height: 1.15),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevateButton(
            radius: 04,
            height: 42,
            label: (_modelData.step == 1 ? 'next' : 'confirm').recast.toUpper,
            onTap: _onNext,
            textStyle: TextStyles.text14_700.copyWith(color: lightBlue, fontWeight: w600, height: 1.15),
          ),
        ),
        SizedBox(width: Dimensions.screen_padding),
      ],
    );
  }

  void _onBack() => _modelData.step == 1 ? backToPrevious() : setState(() => _modelData.step = 1);

  void _onNext() {
    if (_modelData.step == 1) {
      if (_name.text.isEmpty) return FlushPopup.onWarning(message: 'please_write_your_club_name'.recast);
      if (_modelData.homeCourse.id == null) return FlushPopup.onWarning(message: 'please_select_a_home_course'.recast);
      setState(() => _modelData.step = 2);
    } else {
      if (_socialLink.text.isNotEmpty) {
        var invalidLink = sl<Validators>().validateSocialLink(_socialLink.text);
        if (invalidLink != null) return FlushPopup.onWarning(message: invalidLink);
      }
      var body = {
        'name': _name.text,
        'description': _description.text,
        'social_link': _socialLink.text,
        'country_id': UserPreferences.user.countryId,
      };
      _modelData.onCreateClub(body);
    }
  }

  Widget get _noCourseFound {
    var style = TextStyles.text12_400.copyWith(color: primary);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 11),
      decoration: BoxDecoration(color: const Color(0xFFF2F6FF), borderRadius: BorderRadius.circular(4)),
      child: Text('sorry_no_course_found_on_your_50_kilometer_radius'.recast, style: style),
    );
  }

  Widget get _clubExistIn10Km {
    var clubName = _modelData.clubs.first.name ?? '';
    var style = TextStyles.text12_400.copyWith(color: primary);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 11),
      decoration: BoxDecoration(color: const Color(0xFFF2F6FF), borderRadius: BorderRadius.circular(4)),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(text: 'sorry_your_club_is_within_10_km_of'.recast + ' ', style: style),
            TextSpan(text: clubName, style: TextStyles.text12_700.copyWith(color: primary)),
            TextSpan(text: '. ' + 'that_is_why_you_can_not_create_a_club_here'.recast, style: style),
          ],
        ),
      ),
    );
  }
}
