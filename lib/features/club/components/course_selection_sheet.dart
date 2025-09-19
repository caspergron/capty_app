import 'package:flutter/material.dart';

import 'package:app/components/headers/sheet_header_1.dart';
import 'package:app/constants/app_keys.dart';
import 'package:app/extensions/number_ext.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/models/club/club.dart';
import 'package:app/models/club/course.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/text_styles.dart';
import 'package:app/utils/assets.dart';
import 'package:app/utils/dimensions.dart';
import 'package:app/utils/size_config.dart';
import 'package:app/widgets/core/pop_scope_navigator.dart';
import 'package:app/widgets/library/svg_image.dart';

Future<void> courseSelectionSheet({required Club club}) async {
  final context = navigatorKey.currentState!.context;
  final padding = MediaQuery.of(context).viewInsets;
  await showModalBottomSheet(
    context: context,
    isDismissible: false,
    enableDrag: false,
    isScrollControlled: true,
    shape: BOTTOM_SHEET_SHAPE,
    clipBehavior: Clip.antiAlias,
    builder: (builder) => Padding(padding: padding, child: PopScopeNavigator(canPop: false, child: _BottomSheetView(club))),
  );
}

class _BottomSheetView extends StatefulWidget {
  final Club club;
  const _BottomSheetView(this.club);

  @override
  State<_BottomSheetView> createState() => _BottomSheetViewState();
}

class _BottomSheetViewState extends State<_BottomSheetView> {
  var _loader = true;
  var _courses = <Course>[];

  @override
  void initState() {
    // sl<AppAnalytics>().screenView('course-selection-sheet');
    super.initState();
  }

  /*Future<void> initViewModel() async {
    final position = await sl<Locations>().fetchLocationPermission();
    final response = await sl<ClubRepository>().findNearbyCourses(position);
    _loader = false;
    setState(() {});
  }*/

  @override
  Widget build(BuildContext context) {
    final padding = EdgeInsets.symmetric(horizontal: Dimensions.screen_padding);
    final style = TextStyles.text16_600.copyWith(color: lightBlue);
    return Container(
      height: 70.height,
      width: SizeConfig.width,
      decoration: const BoxDecoration(color: primary, borderRadius: SHEET_RADIUS),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SheetHeader1(label: 'connect_new_course'.recast),
          const SizedBox(height: 16),
          if (_courses.isNotEmpty) Padding(padding: padding, child: Text('nearby_courses_within_50_km'.recast, style: style)),
          Expanded(
              child: Stack(children: [
            _screenView(context), /*if (_loader) const ScreenLoader()*/
          ])),
          if (_courses.isNotEmpty) SizedBox(height: BOTTOM_GAP),
        ],
      ),
    );
  }

  Widget _screenView(BuildContext context) {
    if (_loader) return const SizedBox.shrink();
    if (_courses.isEmpty) return _noCourseFound;
    return ListView(
      shrinkWrap: true,
      controller: ScrollController(),
      clipBehavior: Clip.antiAlias,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      children: [const SizedBox(height: 12), SizedBox(height: BOTTOM_GAP)],
    );
  }

  Widget get _noCourseFound {
    final description = 'no_course_found_around_50km_on_your_location_please_try_Again_later'.recast;
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 4.height),
          SvgImage(image: Assets.svg3.not_found, height: 16.height, color: lightBlue),
          const SizedBox(height: 28),
          Text('${'no_course_found'.recast}!', textAlign: TextAlign.center, style: TextStyles.text16_600.copyWith(color: lightBlue)),
          const SizedBox(height: 04),
          Text(description, textAlign: TextAlign.center, style: TextStyles.text14_400.copyWith(color: lightBlue)),
        ],
      ),
    );
  }
}
