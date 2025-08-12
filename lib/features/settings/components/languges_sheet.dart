import 'package:flutter/material.dart';

import 'package:app/animations/fade_animation.dart';
import 'package:app/components/loaders/positioned_loader.dart';
import 'package:app/constants/app_keys.dart';
import 'package:app/extensions/flutter_ext.dart';
import 'package:app/extensions/number_ext.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/models/public/language.dart';
import 'package:app/preferences/app_preferences.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/text_styles.dart';
import 'package:app/utils/assets.dart';
import 'package:app/utils/dimensions.dart';
import 'package:app/widgets/core/pop_scope_navigator.dart';
import 'package:app/widgets/library/svg_image.dart';

Future<void> languagesSheet({required Language language, Function(Language)? onLanguage}) async {
  var context = navigatorKey.currentState!.context;
  await showModalBottomSheet(
    context: context,
    showDragHandle: false,
    isDismissible: false,
    isScrollControlled: true,
    shape: BOTTOM_SHEET_SHAPE,
    clipBehavior: Clip.antiAlias,
    builder: (builder) => PopScopeNavigator(canPop: false, child: _BottomSheetView(language, onLanguage)),
  );
}

class _BottomSheetView extends StatefulWidget {
  final Language language;
  final Function(Language)? onLanguage;
  const _BottomSheetView(this.language, this.onLanguage);

  @override
  State<_BottomSheetView> createState() => _BottomSheetViewState();
}

class _BottomSheetViewState extends State<_BottomSheetView> {
  var _loader = true;

  @override
  void initState() {
    // sl<AppAnalytics>().screenView('language-sheet');
    _fetchLanguages();
    super.initState();
  }

  Future<void> _fetchLanguages() async {
    await AppPreferences.fetchLanguages();
    setState(() => _loader = false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60.height,
      width: double.infinity,
      decoration: BoxDecoration(color: primary, borderRadius: SHEET_RADIUS),
      child: Stack(children: [_screenView(context), if (_loader) const PositionedLoader()]),
    );
  }

  Widget _screenView(BuildContext context) {
    var decoration = BoxDecoration(color: mediumBlue, borderRadius: BorderRadius.circular(2));
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 06),
        Center(child: Container(height: 4, width: 28.width, decoration: decoration)),
        const SizedBox(height: 14),
        Row(
          children: [
            SizedBox(width: Dimensions.dialog_padding),
            Expanded(child: Text('select_language'.recast, style: TextStyles.text18_600.copyWith(color: lightBlue))),
            const SizedBox(width: 10),
            InkWell(onTap: backToPrevious, child: const Icon(Icons.close, color: lightBlue, size: 22)),
            SizedBox(width: Dimensions.dialog_padding),
          ],
        ),
        const SizedBox(height: 16),
        const Divider(color: mediumBlue, height: 0.5, thickness: 0.5),
        const SizedBox(height: 02),
        Expanded(child: _LanguageList(language: widget.language, languages: AppPreferences.languages, onSelect: _onLanguage)),
        SizedBox(height: BOTTOM_GAP)
      ],
    );
  }

  void _onLanguage(Language item, int index) {
    backToPrevious();
    if (widget.onLanguage != null) widget.onLanguage!(item);
  }
}

class _LanguageList extends StatelessWidget {
  final List<Language> languages;
  final Language language;
  final Function(Language, int)? onSelect;

  const _LanguageList({required this.language, this.languages = const [], this.onSelect});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      clipBehavior: Clip.antiAlias,
      itemCount: AppPreferences.languages.length,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemBuilder: _languageItemCard,
    );
  }

  Widget _languageItemCard(BuildContext context, int index) {
    var item = AppPreferences.languages[index];
    var selected = language.id != null && language.id == item.id;
    var checkedIcon = SvgImage(image: Assets.svg2.check_circle, color: lightBlue, height: 18);
    var isLast = index == AppPreferences.languages.length - 1;
    return InkWell(
      onTap: onSelect == null ? null : () => onSelect!(item, index),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(border: isLast ? null : const Border(bottom: BorderSide(color: lightBlue, width: 0.5))),
        child: Row(
          children: [
            Expanded(child: Text(item.name ?? '', style: TextStyles.text16_400.copyWith(color: lightBlue))),
            if (selected) const SizedBox(width: 12),
            if (selected) FadeAnimation(fadeKey: item.code ?? '', duration: const Duration(milliseconds: 1000), child: checkedIcon),
          ],
        ),
      ),
    );
  }
}
