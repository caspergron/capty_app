import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:app/components/buttons/outline_button.dart';
import 'package:app/extensions/flutter_ext.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/models/club/course.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/fonts.dart';
import 'package:app/themes/text_styles.dart';
import 'package:app/utils/assets.dart';
import 'package:app/widgets/library/svg_image.dart';

class NearbyCoursesList extends StatelessWidget {
  final Course homeCourse;
  final List<Course> courses;
  final ScrollPhysics physics;
  final Function(Course)? onSetHome;
  final Function(Course)? onConnect;
  final List<Course> selectedCourses;

  const NearbyCoursesList({
    required this.homeCourse,
    this.onSetHome,
    this.onConnect,
    this.courses = const [],
    this.selectedCourses = const [],
    this.physics = const NeverScrollableScrollPhysics(),
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      itemCount: courses.length,
      itemBuilder: _courseItemCard,
      physics: physics,
    );
  }

  Widget _courseItemCard(BuildContext context, int index) {
    var item = courses[index];
    var isLast = index == courses.length - 1;
    if (kDebugMode) print(item.toJson());
    var isConnect = selectedCourses.isNotEmpty && selectedCourses.any((element) => element.id == item.id);
    var isHome = homeCourse.id != null && homeCourse.id == item.id;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 04),
      margin: EdgeInsets.only(bottom: isLast ? 0 : 04),
      child: Row(
        children: [
          SvgImage(image: Assets.svg1.map_pin, height: 32, width: 32, fit: BoxFit.cover, color: dark),
          const SizedBox(width: 06),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyles.text12_400.copyWith(color: primary),
                ),
                const SizedBox(height: 1),
                Text('${item.distance ?? 0} ${'km'.recast}', style: TextStyles.text10_400.copyWith(color: primary))
              ],
            ),
          ),
          const SizedBox(width: 04),
          OutlineButton(
            height: 30,
            radius: 50,
            border: mediumBlue,
            label: 'set_as_home'.recast.toUpper,
            background: skyBlue.colorOpacity(isHome ? 0.7 : 1),
            onTap: () => onSetHome == null ? null : onSetHome!(item),
            textStyle: TextStyles.text14_500.copyWith(color: primary.colorOpacity(isHome ? 0.4 : 1), fontWeight: w500, height: 1.3),
          ),
          const SizedBox(width: 04),
          OutlineButton(
            height: 30,
            radius: 50,
            border: mediumBlue,
            label: 'connect'.recast.toUpper,
            background: skyBlue.colorOpacity(isConnect ? 0.7 : 1),
            textStyle: TextStyles.text14_500.copyWith(color: primary.colorOpacity(isConnect ? 0.4 : 1), fontWeight: w500, height: 1.3),
            onTap: () => onConnect == null ? null : onConnect!(item),
          ),
        ],
      ),
    );
  }
}
