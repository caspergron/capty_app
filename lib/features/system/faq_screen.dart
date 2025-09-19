import 'dart:io';

import 'package:flutter/material.dart';

import 'package:app/components/menus/back_menu.dart';
import 'package:app/extensions/number_ext.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/models/system/data_model.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/fonts.dart';
import 'package:app/themes/text_styles.dart';
import 'package:app/utils/assets.dart';
import 'package:app/utils/dimensions.dart';
import 'package:app/utils/size_config.dart';
import 'package:app/widgets/core/expansion.dart';
import 'package:app/widgets/library/svg_image.dart';

class FaqScreen extends StatefulWidget {
  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  @override
  void initState() {
    // sl<AppAnalytics>().screenView('frequent-question-screen');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final views = [_bannerImage, Expanded(child: _screenView)];
    return Scaffold(body: Container(width: SizeConfig.width, height: SizeConfig.height, child: Column(children: views)));
  }

  Widget get _bannerImage {
    final top = SizeConfig.statusBar + (Platform.isIOS ? 08 : 16);
    final bannerImage = Image.asset(Assets.png_image.about_us, width: double.infinity, height: 36.height, fit: BoxFit.cover);
    return Stack(children: [bannerImage, Positioned(top: top, left: 16, child: const BackMenu(iconColor: lightBlue))]);
  }

  Widget get _screenView {
    final capty = SvgImage(image: Assets.app.capty, height: 24, color: primary);
    final captyName = SvgImage(image: Assets.app.capty_name, height: 24, color: primary);
    return ListView(
      shrinkWrap: true,
      clipBehavior: Clip.antiAlias,
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: Dimensions.screen_padding),
      children: [
        const SizedBox(height: 24),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [capty, const SizedBox(width: 10), captyName]),
        const SizedBox(height: 24),
        Text('Frequently Asked Questions', style: TextStyles.text20_500.copyWith(color: primary, fontWeight: w600)),
        const SizedBox(height: 08),
        ListView.builder(
          shrinkWrap: true,
          clipBehavior: Clip.antiAlias,
          itemBuilder: _faqItemCard,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _FAQ_LIST.length,
          padding: const EdgeInsets.only(bottom: 24),
        )
      ],
    );
  }

  Widget _faqItemCard(BuildContext context, int index) {
    final faq = _FAQ_LIST[index];
    final isLast = index == _FAQ_LIST.length - 1;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 04),
      decoration: BoxDecoration(border: isLast ? null : const Border(bottom: BorderSide(color: lightBlue))),
      child: Expansion(
        tilePadding: const EdgeInsets.symmetric(vertical: 04),
        childrenPadding: EdgeInsets.zero,
        title: Text(faq.label.recast, style: TextStyles.text14_600.copyWith(color: primary)),
        trailing: SvgImage(image: Assets.svg1.caret_down_2, height: 16, color: primary),
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(faq.value.recast, style: TextStyles.text14_400.copyWith(color: primary)),
          )
        ],
      ),
    );
  }
}

List<DataModel> _FAQ_LIST = [
  DataModel(label: 'faq_question_1', value: 'faq_answer_1'),
  DataModel(label: 'faq_question_2', value: 'faq_answer_2'),
  DataModel(label: 'faq_question_3', value: 'faq_answer_3'),
  DataModel(label: 'faq_question_4', value: 'faq_answer_4'),
];
