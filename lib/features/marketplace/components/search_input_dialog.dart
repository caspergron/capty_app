import 'package:app/animations/tween_list_item.dart';
import 'package:app/components/buttons/elevate_button.dart';
import 'package:app/constants/app_keys.dart';
import 'package:app/di.dart';
import 'package:app/extensions/flutter_ext.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/libraries/flush_popup.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/fonts.dart';
import 'package:app/themes/shadows.dart';
import 'package:app/themes/text_styles.dart';
import 'package:app/utils/assets.dart';
import 'package:app/utils/dimensions.dart';
import 'package:app/utils/transitions.dart';
import 'package:app/widgets/core/input_field.dart';
import 'package:app/widgets/core/pop_scope_navigator.dart';
import 'package:app/widgets/library/svg_image.dart';
import 'package:flutter/material.dart';

Future<void> searchInputDialog({required String searchKey, Function(String)? onFilter}) async {
  var context = navigatorKey.currentState!.context;
  var padding = MediaQuery.of(context).viewInsets;
  var child = Align(child: _DialogView(searchKey, onFilter));

  await showGeneralDialog(
    context: context,
    barrierLabel: 'Search Input Dialog',
    transitionDuration: DIALOG_DURATION,
    transitionBuilder: sl<Transitions>().bottomToTop,
    pageBuilder: (buildContext, anim1, anim2) => Padding(padding: padding, child: PopScopeNavigator(canPop: false, child: child)),
  );
}

class _DialogView extends StatefulWidget {
  final String searchKey;
  final Function(String)? onFilter;
  const _DialogView(this.searchKey, this.onFilter);

  @override
  State<_DialogView> createState() => _DialogViewState();
}

class _DialogViewState extends State<_DialogView> {
  var _focusNode = FocusNode();
  var _search = TextEditingController();

  @override
  void initState() {
    // sl<AppAnalytics>().screenView('search-input-popup');
    _focusNode.addListener(() => setState(() {}));
    _search.text = widget.searchKey;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Dimensions.dialog_width,
      padding: EdgeInsets.symmetric(horizontal: Dimensions.dialog_padding, vertical: Dimensions.dialog_padding),
      decoration: BoxDecoration(color: primary, borderRadius: DIALOG_RADIUS, boxShadow: const [SHADOW_2]),
      child: Material(color: transparent, child: _screenView(context), shape: DIALOG_SHAPE),
    );
  }

  Widget _screenView(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('search_disc'.recast, style: TextStyles.text16_600.copyWith(color: lightBlue)),
            InkWell(onTap: backToPrevious, child: SvgImage(image: Assets.svg1.close_1, height: 18, color: lightBlue)),
          ],
        ),
        const SizedBox(height: 32),
        Text('search_by_disc_name'.recast.firstLetterCapital, style: TextStyles.text16_600.copyWith(color: white, fontWeight: w700)),
        const SizedBox(height: 12),
        TweenListItem(
          child: InputField(
            fontSize: 12,
            controller: _search,
            focusNode: _focusNode,
            enabledBorder: lightBlue,
            focusedBorder: lightBlue,
            borderRadius: BorderRadius.circular(04),
            hintText: 'write_here'.recast,
          ),
        ),
        const SizedBox(height: 32),
        ElevateButton(
          radius: 04,
          height: 36,
          onTap: _onSave,
          width: double.infinity,
          label: 'search'.recast.toUpper,
          textStyle: TextStyles.text14_700.copyWith(color: lightBlue, fontWeight: w600, height: 1.15),
        ),
      ],
    );
  }

  void _onSave() {
    if (_search.text.isEmpty) return FlushPopup.onWarning(message: 'please_write_any_disc_name'.recast);
    if (widget.onFilter != null) widget.onFilter!(_search.text);
    backToPrevious();
  }
}
