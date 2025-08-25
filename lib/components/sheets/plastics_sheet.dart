import 'package:app/animations/fade_animation.dart';
import 'package:app/components/buttons/elevate_button.dart';
import 'package:app/components/buttons/outline_button.dart';
import 'package:app/components/headers/sheet_header_1.dart';
import 'package:app/components/loaders/screen_loader.dart';
import 'package:app/components/menus/prefix_menu.dart';
import 'package:app/constants/app_keys.dart';
import 'package:app/extensions/flutter_ext.dart';
import 'package:app/extensions/number_ext.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/libraries/flush_popup.dart';
import 'package:app/models/plastic/plastic.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/fonts.dart';
import 'package:app/themes/text_styles.dart';
import 'package:app/utils/assets.dart';
import 'package:app/utils/dimensions.dart';
import 'package:app/utils/size_config.dart';
import 'package:app/widgets/core/input_field.dart';
import 'package:app/widgets/core/pop_scope_navigator.dart';
import 'package:app/widgets/library/svg_image.dart';
import 'package:app/widgets/ui/nav_button_box.dart';
import 'package:flutter/material.dart';

Future<void> plasticsSheet({required Plastic plastic, required List<Plastic> plastics, required Function(Plastic)? onChanged}) async {
  var context = navigatorKey.currentState!.context;
  var padding = MediaQuery.of(context).viewInsets;
  var child = _BottomSheetView(plastic, plastics, onChanged);

  await showModalBottomSheet(
    context: context,
    isDismissible: false,
    enableDrag: false,
    isScrollControlled: true,
    shape: BOTTOM_SHEET_SHAPE,
    clipBehavior: Clip.antiAlias,
    builder: (builder) => Padding(padding: padding, child: PopScopeNavigator(canPop: false, child: child)),
  );
}

class _BottomSheetView extends StatefulWidget {
  final Plastic plastic;
  final List<Plastic> plastics;
  final Function(Plastic)? onChanged;
  const _BottomSheetView(this.plastic, this.plastics, this.onChanged);

  @override
  State<_BottomSheetView> createState() => _BottomSheetViewState();
}

class _BottomSheetViewState extends State<_BottomSheetView> {
  var _loader = false;
  var _plastic = Plastic();
  var _focusNode = FocusNode();
  var _search = TextEditingController();

  @override
  void initState() {
    _focusNode.addListener(() => setState(() {}));
    if (widget.plastics.isNotEmpty) _plastic = widget.plastic;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 75.height,
      width: SizeConfig.width,
      decoration: BoxDecoration(color: primary, borderRadius: SHEET_RADIUS),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SheetHeader1(label: 'select_plastic'.recast),
          const SizedBox(height: 16),
          if (widget.plastics.isNotEmpty)
            InputField(
              padding: 20,
              cursorHeight: 14,
              controller: _search,
              fillColor: skyBlue,
              hintText: 'search_by_plastic_name'.recast,
              focusNode: _focusNode,
              onChanged: (v) => setState(() {}),
              prefixIcon: PrefixMenu(icon: Assets.svg1.search_2, isFocus: _focusNode.hasFocus),
            ),
          Expanded(child: Stack(children: [_screenView(context), if (_loader) const ScreenLoader()])),
          if (widget.plastics.isNotEmpty) NavButtonBox(loader: _loader, childHeight: 42, child: _actionButtons),
        ],
      ),
    );
  }

  Widget get _actionButtons {
    return Row(
      children: [
        Expanded(
          child: OutlineButton(
            radius: 04,
            height: 42,
            background: skyBlue,
            onTap: backToPrevious,
            label: 'cancel'.recast.toUpper,
            textStyle: TextStyles.text14_700.copyWith(color: primary, fontWeight: w600, height: 1.15),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevateButton(
            radius: 04,
            height: 42,
            onTap: _onConfirm,
            label: 'confirm'.recast.toUpper,
            textStyle: TextStyles.text14_700.copyWith(color: lightBlue, fontWeight: w600, height: 1.15),
          ),
        ),
      ],
    );
  }

  void _onConfirm() {
    if (_plastic.id == null) return FlushPopup.onWarning(message: 'please_select_any_disc_plastic'.recast);
    if (widget.onChanged != null) widget.onChanged!(_plastic);
    backToPrevious();
  }

  Widget _screenView(BuildContext context) {
    if (_loader) return const SizedBox.shrink();
    if (widget.plastics.isEmpty) return _NoPlasticFound();
    var plastics = Plastic.plastics_by_name(widget.plastics, _search.text);
    return ListView(
      shrinkWrap: true,
      controller: ScrollController(),
      clipBehavior: Clip.antiAlias,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      children: plastics.isEmpty
          ? [const SizedBox(height: 20), _NoPlasticFound(), SizedBox(height: BOTTOM_GAP)]
          : [
              const SizedBox(height: 20),
              _PlasticsList(plastics: plastics, plastic: _plastic, onChanged: (v) => setState(() => _plastic = v)),
              SizedBox(height: BOTTOM_GAP),
            ],
    );
  }
}

class _PlasticsList extends StatelessWidget {
  final Plastic plastic;
  final List<Plastic> plastics;
  final Function(Plastic)? onChanged;
  const _PlasticsList({required this.plastic, this.plastics = const [], this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 08,
      runSpacing: 08,
      clipBehavior: Clip.antiAlias,
      children: List.generate(plastics.length, (index) => _plasticItemCard(context, index)).toList(),
    );
  }

  Widget _plasticItemCard(BuildContext context, int index) {
    var item = plastics[index];
    var selected = plastic.id != null && plastic.id == item.id;
    return InkWell(
      onTap: () => onChanged == null ? null : onChanged!(item),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 06),
        decoration: BoxDecoration(
          color: selected ? skyBlue : transparent,
          border: Border.all(color: lightBlue),
          borderRadius: BorderRadius.circular(04),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              item.name ?? '',
              textAlign: TextAlign.start,
              style: TextStyles.text14_400.copyWith(color: selected ? primary : lightBlue, height: 1.1, fontWeight: selected ? w700 : w400),
            ),
            if (selected) const SizedBox(width: 06),
            if (selected)
              FadeAnimation(
                fadeKey: item.name ?? '',
                duration: DURATION_1000,
                child: SvgImage(image: Assets.svg1.tick, color: selected ? primary : lightBlue, height: 18),
              ),
          ],
        ),
      ),
    );
  }
}

class _NoPlasticFound extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var description = 'we_could_not_find_any_plastic_right_now_please_try_again_later'.recast;
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 4.height),
          SvgImage(image: Assets.svg3.not_found, height: 16.height, color: lightBlue),
          const SizedBox(height: 28),
          Text('${'no_disc_plastic_found'.recast}!', textAlign: TextAlign.center, style: TextStyles.text16_600.copyWith(color: lightBlue)),
          const SizedBox(height: 04),
          Text(description, textAlign: TextAlign.center, style: TextStyles.text14_400.copyWith(color: lightBlue)),
        ],
      ),
    );
  }
}
