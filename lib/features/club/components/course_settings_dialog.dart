import 'dart:io';

import 'package:flutter/material.dart';

import 'package:app/components/buttons/elevate_button.dart';
import 'package:app/components/buttons/outline_button.dart';
import 'package:app/constants/app_keys.dart';
import 'package:app/di.dart';
import 'package:app/extensions/flutter_ext.dart';
import 'package:app/extensions/number_ext.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/models/club/club.dart';
import 'package:app/models/club/course.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/fonts.dart';
import 'package:app/themes/shadows.dart';
import 'package:app/themes/text_styles.dart';
import 'package:app/utils/assets.dart';
import 'package:app/utils/dimensions.dart';
import 'package:app/utils/size_config.dart';
import 'package:app/utils/transitions.dart';
import 'package:app/widgets/core/pop_scope_navigator.dart';
import 'package:app/widgets/library/svg_image.dart';
import 'package:app/widgets/ui/icon_box.dart';

Future<void> courseSettingsDialog({required Club club, Function()? onConnect, Function(Club)? onUpdate}) async {
  var context = navigatorKey.currentState!.context;
  // sl<AppAnalytics>().screenView('course-settings-popup');
  var child = Align(child: _DialogView(club, onConnect, onUpdate));
  await showGeneralDialog(
    context: context,
    barrierLabel: 'Course Settings Dialog',
    transitionDuration: DIALOG_DURATION,
    transitionBuilder: sl<Transitions>().bottomToTop,
    pageBuilder: (buildContext, anim1, anim2) => PopScopeNavigator(canPop: false, child: child),
  );
}

class _DialogView extends StatelessWidget {
  final Club club;
  final Function()? onConnect;
  final Function(Club)? onUpdate;
  const _DialogView(this.club, this.onConnect, this.onUpdate);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Dimensions.dialog_width + 10,
      margin: EdgeInsets.only(top: SizeConfig.statusBar + (Platform.isIOS ? 10 : 16), bottom: Platform.isIOS ? 32 : 20),
      padding: EdgeInsets.symmetric(horizontal: Dimensions.dialog_padding),
      decoration: BoxDecoration(color: primary, borderRadius: DIALOG_RADIUS, boxShadow: const [SHADOW_2]),
      child: Material(color: transparent, child: _screenView(context), shape: DIALOG_SHAPE),
    );
  }

  Widget _screenView(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 22),
        Align(
          alignment: Alignment.topRight,
          child: InkWell(onTap: backToPrevious, child: SvgImage(image: Assets.svg1.close_1, color: skyBlue, height: 20)),
        ),
        Center(child: SvgImage(image: Assets.svg3.training, color: mediumBlue, height: 16.height)),
        const SizedBox(height: 20),
        Center(child: Text('club_courses'.recast, style: TextStyles.text20_500.copyWith(color: lightBlue, fontWeight: w500))),
        const SizedBox(height: 20),
        Text(
          '${'courses'.recast} (20)',
          textAlign: TextAlign.start,
          style: TextStyles.text18_700.copyWith(color: lightBlue, fontWeight: w500),
        ),
        const SizedBox(height: 08),
        _CoursesList(
          homeCourse: club.homeCourse!,
          courses: [club.homeCourse!],
          onDelete: _onDeleteCourse,
          onSetHome: _onSetHomeCourse,
          // selectedCourses: _modelData.selectedCourses,
        ),
        const SizedBox(height: 40),
        Center(
          child: ElevateButton(
            radius: 04,
            height: 42,
            padding: 24,
            onTap: _onConnectCourse,
            label: 'connect_new_course'.recast.toUpper + ' ',
            icon: SvgImage(image: Assets.svg1.plus, height: 20, color: white),
            textStyle: TextStyles.text14_700.copyWith(color: lightBlue, fontWeight: w600, height: 1.15),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  void _onDeleteCourse(Course item) {
    if (onUpdate == null) return;
    onUpdate!(club);
  }

  void _onSetHomeCourse(Course item) {}

  void _onConnectCourse() {
    if (onConnect == null) return;
    backToPrevious();
    onConnect!();
  }
}

class _CoursesList extends StatelessWidget {
  final Course homeCourse;
  final List<Course> courses;
  final Function(Course)? onSetHome;
  final Function(Course)? onDelete;

  const _CoursesList({required this.homeCourse, this.onSetHome, this.onDelete, this.courses = const []});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      itemCount: courses.length,
      itemBuilder: _courseItemCard,
      physics: const NeverScrollableScrollPhysics(),
    );
  }

  Widget _courseItemCard(BuildContext context, int index) {
    var item = courses[index];
    var isLast = index == courses.length - 1;
    var isHome = homeCourse.id != null && homeCourse.id == item.id;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 04),
      margin: EdgeInsets.only(bottom: isLast ? 0 : 04),
      child: Row(
        children: [
          SvgImage(image: Assets.svg1.map_pin, height: 20, width: 32, fit: BoxFit.cover, color: lightBlue),
          const SizedBox(width: 06),
          Expanded(
            child: Text(
              item.name ?? '',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyles.text14_500.copyWith(color: lightBlue, fontWeight: w500),
            ),
          ),
          const SizedBox(width: 04),
          isHome
              ? Row(
                  children: [
                    SvgImage(image: Assets.svg1.tick, height: 13, color: orange),
                    const SizedBox(width: 04),
                    Text('home_course'.recast, style: TextStyles.text13_600.copyWith(color: orange, fontWeight: w700)),
                  ],
                )
              : OutlineButton(
                  height: 26,
                  radius: 04,
                  border: mediumBlue,
                  background: skyBlue,
                  label: 'set_as_home'.recast.toUpper,
                  onTap: () => onSetHome == null ? null : onSetHome!(item),
                  textStyle: TextStyles.text13_600.copyWith(color: primary.colorOpacity(1), fontWeight: w500, height: 1.3),
                ),
          if (!isHome) const SizedBox(width: 06),
          if (!isHome)
            IconBox(
              size: 26,
              background: warning,
              icon: SvgImage(image: Assets.svg1.trash, height: 19, color: white),
              onTap: () => onDelete == null ? null : onDelete!(item),
            ),
        ],
      ),
    );
  }
}
