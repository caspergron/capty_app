import 'dart:convert';

import 'package:app/animations/tween_list_item.dart';
import 'package:app/components/app_lists/disc_speciality_list.dart';
import 'package:app/components/app_lists/label_wrap_list.dart';
import 'package:app/components/buttons/elevate_button.dart';
import 'package:app/components/buttons/outline_button.dart';
import 'package:app/components/loaders/screen_loader.dart';
import 'package:app/components/sheets/brands_sheet.dart';
import 'package:app/constants/app_keys.dart';
import 'package:app/extensions/flutter_ext.dart';
import 'package:app/extensions/number_ext.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/libraries/toasts_popups.dart';
import 'package:app/models/common/brand.dart';
import 'package:app/models/common/tag.dart';
import 'package:app/models/marketplace/marketplace_filter.dart';
import 'package:app/models/system/data_model.dart';
import 'package:app/preferences/app_preferences.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/fonts.dart';
import 'package:app/themes/text_styles.dart';
import 'package:app/utils/assets.dart';
import 'package:app/utils/dimensions.dart';
import 'package:app/utils/size_config.dart';
import 'package:app/widgets/core/expansion.dart';
import 'package:app/widgets/core/pop_scope_navigator.dart';
import 'package:app/widgets/library/svg_image.dart';
import 'package:app/widgets/ui/label_placeholder.dart';
import 'package:app/widgets/ui/nav_button_box.dart';
import 'package:flutter/material.dart';

var _BRAND = DataModel(label: 'brand');
var _TYPE = DataModel(label: 'type', valueInt: 2);
var _TAGS = DataModel(label: 'tags', valueInt: 4);
var _FLIGHT_PATH = DataModel(label: 'flight_numbers', valueInt: 6);
// var _CONDITION = DataModel(label: 'condition', valueInt: 7);
// var _WEIGHT = DataModel(label: 'weight', valueInt: 9);
// var _PRICE = DataModel(label: 'price', valueInt: 11);
// var _SORT_BY = DataModel(label: 'sort_by', valueInt: 7);

Future<void> marketplaceFilterSheet({required MarketplaceFilter filterOption, Function(MarketplaceFilter)? onFilter}) async {
  var context = navigatorKey.currentState!.context;
  var padding = MediaQuery.of(context).viewInsets;
  var child = _BottomSheetView(filterOption, onFilter);
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
  final MarketplaceFilter filterOption;
  final Function(MarketplaceFilter)? onFilter;
  const _BottomSheetView(this.filterOption, this.onFilter);

  @override
  State<_BottomSheetView> createState() => _BottomSheetViewState();
}

class _BottomSheetViewState extends State<_BottomSheetView> {
  var _loader = true;
  var _types = <Tag>[];
  var _brands = <Brand>[];
  var _tags = <Tag>[];
  // var _sortBy = DataModel();
  var _speed = const RangeValues(1, 15);
  var _glide = const RangeValues(0, 7);
  var _turn = const RangeValues(-5, 1);
  var _fade = const RangeValues(0, 5);
  // var _condition = const RangeValues(0, 10);
  // var _weight = const RangeValues(100, 200);
  // var _price = const RangeValues(0, 1000);

  @override
  void initState() {
    _setInitialStates();
    _fetchDiscTypes();
    _fetchSpecialDiscTags();
    super.initState();
    // sl<AppAnalytics>().screenView('marketplace_filter-sheet');
  }

  void _setInitialStates() {
    // final sortBy = widget.filterOption.sortBy;
    _types = widget.filterOption.types;
    _brands = widget.filterOption.brands;
    _tags = widget.filterOption.tags;
    _speed = widget.filterOption.speed;
    _glide = widget.filterOption.glide;
    _turn = widget.filterOption.turn;
    _fade = widget.filterOption.fade;
    // _condition = widget.filterOption.condition;
    // _weight = widget.filterOption.weight;
    // _price = widget.filterOption.price;
    // if (sortBy != null) _sortBy = sortBy;
  }

  Future<void> _fetchSpecialDiscTags() async => AppPreferences.fetchSpecialDiscTags();

  Future<void> _fetchDiscTypes() async {
    await AppPreferences.fetchDiscTypeTags();
    setState(() => _loader = false);
  }

  @override
  void dispose() {
    _types = [];
    _brands = [];
    _tags = [];
    _speed = const RangeValues(1, 15);
    _glide = const RangeValues(0, 7);
    _turn = const RangeValues(-5, 1);
    _fade = const RangeValues(0, 5);
    super.dispose();
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
          Column(
            children: [
              const SizedBox(height: 16),
              Text('filter_marketplace_discs'.recast, style: TextStyles.text18_600.copyWith(color: lightBlue)),
              const SizedBox(height: 18),
              const Divider(color: mediumBlue, height: 0.5, thickness: 0.5),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(child: Stack(children: [_screenView(context), if (_loader) const ScreenLoader()])),
          NavButtonBox(loader: _loader, childHeight: 42, child: _actionButtons),
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
            label: 'reset_filter'.recast.toUpper,
            textStyle: TextStyles.text14_700.copyWith(color: primary, fontWeight: w600, height: 1.15),
            onTap: _onResetFilter,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevateButton(
            radius: 04,
            height: 42,
            onTap: _onFilter,
            label: 'filter'.recast.toUpper,
            textStyle: TextStyles.text14_700.copyWith(color: lightBlue, fontWeight: w600, height: 1.15),
          ),
        ),
      ],
    );
  }

  Widget _screenView(BuildContext context) {
    if (_loader) return const SizedBox.shrink();
    var tags = AppPreferences.specialTags;
    var discTypeTags = AppPreferences.discTypeTags;
    var typeLabels = _types.isEmpty ? <String>[] : _types.map((e) => e.displayName ?? '').toList();
    var brandLabels = _brands.isEmpty ? <String>[] : _brands.map((e) => e.name ?? '').toList();
    var tagLabels = _tags.isEmpty ? <String>[] : _tags.map((e) => e.displayName ?? '').toList();
    // var priceLabelValue = '${'from'.recast}: ${_price.start.toInt()} ${'to'.recast} ${_price.end.toInt()}';
    // var weightLabelValue = '${'from'.recast}: ${_weight.start.toInt()} ${'to'.recast} ${_weight.end.toInt()}';
    // var conditionLabelValue = '${'from'.recast}: ${_condition.end.toInt()} ${'to'.recast} ${_condition.start.toInt()}';
    return ListView(
      controller: ScrollController(),
      clipBehavior: Clip.antiAlias,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      children: [
        const SizedBox(height: 10),
        TweenListItem(
          index: _BRAND.valueInt,
          child: LabelPlaceholder(
            height: 44,
            textColor: primary,
            background: lightBlue,
            label: _BRAND.label.recast,
            endIcon: SvgImage(image: Assets.svg1.caret_down_2, height: 16, color: primary),
            onTap: () => brandsSheet(brands: _brands, onChanged: (v) => setState(() => _brands = v)),
          ),
        ),
        if (brandLabels.isNotEmpty) ...[
          const SizedBox(height: 06),
          LabelWrapList(animIndex: 1, items: brandLabels, onItem: (index) => setState(() => _brands.removeAt(index))),
        ],
        const SizedBox(height: 16),
        _ExpansionLabel(
          item: _TYPE,
          isExpanded: false,
          list: DiscSpecialityList(specialities: discTypeTags, selectedSpecialities: _types, onSelect: _onSelectDiscType),
        ),
        if (typeLabels.isNotEmpty) ...[
          const SizedBox(height: 06),
          LabelWrapList(animIndex: 3, items: typeLabels, onItem: (index) => setState(() => _types.removeAt(index))),
        ],
        const SizedBox(height: 16),
        _ExpansionLabel(
          item: _TAGS,
          isExpanded: false,
          list: DiscSpecialityList(specialities: tags, selectedSpecialities: _tags, onSelect: _onSelectTag),
        ),
        if (tagLabels.isNotEmpty) ...[
          const SizedBox(height: 06),
          LabelWrapList(animIndex: 5, items: tagLabels, onItem: (index) => setState(() => _tags.removeAt(index))),
        ],
        const SizedBox(height: 16),
        _ExpansionLabel(item: _FLIGHT_PATH, list: Column(crossAxisAlignment: CrossAxisAlignment.start, children: _flightPathSections)),
        const SizedBox(height: 16),
        /*_ExpansionLabel(
          item: _CONDITION,
          list: _RangeSliderOption(
            index: 8,
            maxValue: 10,
            // isOpposite: true,
            rangeValue: _condition,
            label: 'range_10_0'.recast,
            labelValue: conditionLabelValue,
            onChanged: (v) => setState(() => _condition = v),
          ),
        ),
        const SizedBox(height: 16),*/
        /*_ExpansionLabel(
          item: _WEIGHT,
          list: _RangeSliderOption(
            index: 10,
            minValue: 100,
            maxValue: 200,
            rangeValue: _weight,
            label: 'range_100_200'.recast,
            labelValue: weightLabelValue,
            onChanged: (v) => setState(() => _weight = v),
          ),
        ),
        const SizedBox(height: 16),*/
        /*_ExpansionLabel(
          item: _PRICE,
          list: _RangeSliderOption(
            index: 12,
            maxValue: 1000,
            rangeValue: _price,
            label: 'range_0_1000'.recast,
            labelValue: priceLabelValue,
            onChanged: (v) => setState(() => _price = v),
          ),
        ),
        const SizedBox(height: 16),*/
        /*_ExpansionLabel(
          item: _SORT_BY,
          isExpanded: false,
          list: SortByList(selectedItems: _sortBy.value.isEmpty ? [] : [_sortBy], onSelect: _onSelectSortBy),
        ),
        const SizedBox(height: 16),*/
      ],
    );
  }

  List<Widget> get _flightPathSections {
    var speedValueLabel = '${'from'.recast}: ${_speed.start.toInt()} ${'to'.recast} ${_speed.end.toInt()}';
    var glideValueLabel = '${'from'.recast}: ${_glide.start.toInt()} ${'to'.recast} ${_glide.end.toInt()}';
    var turnValueLabel = '${'from'.recast}: ${_turn.start.toInt()} ${'to'.recast} ${_turn.end.toInt()}';
    var fadeValueLabel = '${'from'.recast}: ${_fade.start.toInt()} ${'to'.recast} ${_fade.end.toInt()}';
    return [
      const SizedBox(height: 12),
      _RangeSliderOption(
        minValue: 1,
        maxValue: 15,
        label: 'speed_1_15'.recast,
        labelValue: speedValueLabel,
        rangeValue: _speed,
        onChanged: (v) => setState(() => _speed = v),
      ),
      const SizedBox(height: 12),
      _RangeSliderOption(
        index: 1,
        maxValue: 7,
        label: 'glide_0_7'.recast,
        labelValue: glideValueLabel,
        rangeValue: _glide,
        onChanged: (v) => setState(() => _glide = v),
      ),
      const SizedBox(height: 12),
      _RangeSliderOption(
        index: 2,
        minValue: -5,
        maxValue: 1,
        label: 'turn_5_1'.recast,
        labelValue: turnValueLabel,
        rangeValue: _turn,
        onChanged: (v) => setState(() => _turn = v),
      ),
      const SizedBox(height: 12),
      _RangeSliderOption(
        index: 3,
        maxValue: 5,
        label: 'fade_0_5'.recast,
        labelValue: fadeValueLabel,
        rangeValue: _fade,
        onChanged: (v) => setState(() => _fade = v),
      ),
      const SizedBox(height: 12),
    ];
  }

  void _onResetFilter() {
    final filter = MarketplaceFilter(types: [], tags: [], brands: []);
    if (widget.onFilter != null) widget.onFilter!(filter);
    backToPrevious();
  }

  void _onSelectTag(Tag item) {
    _tags = _tags.toList();
    var index = _tags.isEmpty ? -1 : _tags.indexWhere((element) => element.id == item.id);
    index < 0 ? _tags.add(item) : _tags.removeAt(index);
    setState(() {});
  }

  void _onSelectDiscType(Tag item) {
    _types = _types.toList();
    var index = _types.isEmpty ? -1 : _types.indexWhere((element) => element.id == item.id);
    index < 0 ? _types.add(item) : _types.removeAt(index);
    setState(() {});
  }

  /*void _onSelectSortBy(DataModel item) {
    _sortBy = DataModel();
    _sortBy = item;
    setState(() {});
  }*/

  bool get _isValidated {
    final invalidFlight1 = (_speed.start == 1 && _speed.end == 15) && (_glide.start == 0 && _glide.end == 7);
    final invalidFlight2 = (_turn.start == -5 && _turn.end == 1) && (_fade.start == 0 && _fade.end == 5);
    // final conditionPaths = _condition.start == 0 && _condition.end == 10;
    // final weightAndPricePaths = (_weight.start == 100 && _weight.end == 200) && (_price.start == 0 && _price.end == 1000);
    final invalidLists = _types.isEmpty && _brands.isEmpty && _tags.isEmpty /*&& _sortBy.value.toKey.isEmpty*/;
    var isInvalid = invalidFlight1 && invalidFlight2 && invalidLists /*&& conditionPaths && weightAndPricePaths*/;
    return !isInvalid;
  }

  void _onFilter() {
    if (!_isValidated) return ToastPopup.onWarning(message: 'please_select_at_least_one_filter_option'.recast);
    final typeIds = _types.isEmpty ? <int>[] : _types.map((e) => e.id.nullToInt).toList();
    final tagIds = _tags.isEmpty ? <int>[] : _tags.map((e) => e.id.nullToInt).toList();
    final brandIds = _brands.isEmpty ? <int>[] : _brands.map((e) => e.id.nullToInt).toList();
    // final sortByParam = _sortBy.value.isEmpty ? '' : '&sort_by=${_sortBy.value}';
    final tagParam = tagIds.isEmpty ? '' : '&tag_ids=$tagIds';
    final typeParam = typeIds.isEmpty ? '' : '&type_ids=$typeIds';
    final brandParam = brandIds.isEmpty ? '' : '&brand_ids=$brandIds';
    final speedParam = {'from': _speed.start.toInt(), 'to': _speed.end.toInt()};
    final glideParam = {'from': _glide.start.toInt(), 'to': _glide.end.toInt()};
    final turnParam = {'from': _turn.start.toInt(), 'to': _turn.end.toInt()};
    final fadeParam = {'from': _fade.start.toInt(), 'to': _fade.end.toInt()};
    final flightParams = {'speed': speedParam, 'glide': glideParam, 'turn': turnParam, 'fade': fadeParam};
    final flightParameters = '&flight=${jsonEncode(flightParams)}';
    // final conditionParam = jsonEncode({'from': _condition.start.toInt(), 'to': _condition.end.toInt()});
    // final weightParam = jsonEncode({'from': _weight.start.toInt(), 'to': _weight.end.toInt()});
    // final priceParam = jsonEncode({'from': _price.start.toInt(), 'to': _price.end.toInt()});
    // final flightParameters = '&flight=${jsonEncode(flightParams)}&condition=$conditionParam&weight=$weightParam&price=$priceParam';
    // final parameters = '&enable_custom_sort=true$tagParam$typeParam$brandParam$sortByParam$flightParameters'.trim();
    final parameters = '&enable_custom_sort=true$tagParam$typeParam$brandParam$flightParameters'.trim();
    final filter = MarketplaceFilter(
      types: _types,
      tags: _tags,
      brands: _brands,
      speed: _speed,
      glide: _glide,
      turn: _turn,
      fade: _fade,
      // condition: _condition,
      // price: _price,
      // weight: _weight,
      // sortBy: _sortBy,
      parameters: parameters,
    );
    if (widget.onFilter != null) widget.onFilter!(filter);
    backToPrevious();
  }
}

class _RangeSliderOption extends StatelessWidget {
  final int index;
  final String label;
  final String labelValue;
  final RangeValues rangeValue;
  final double minValue;
  final double maxValue;
  final bool isOpposite;
  final Function(RangeValues)? onChanged;

  const _RangeSliderOption({
    required this.rangeValue,
    this.index = 0,
    this.maxValue = 0,
    this.minValue = 0,
    this.onChanged,
    this.label = '',
    this.labelValue = '',
    this.isOpposite = false,
  });

  @override
  Widget build(BuildContext context) {
    final min_value = isOpposite ? maxValue.formatDouble : minValue.formatDouble;
    final max_value = isOpposite ? minValue.formatDouble : maxValue.formatDouble;
    final minTextWidget = Text(min_value, style: TextStyles.text12_600.copyWith(color: white, fontSize: 11));
    final maxTextWidget = Text(max_value, style: TextStyles.text12_600.copyWith(color: white, fontSize: 11));
    final minTooltipLabel = '${(isOpposite ? rangeValue.end : rangeValue.start).round()}';
    final maxTooltipLabel = '${(isOpposite ? rangeValue.start : rangeValue.end).round()}';
    return TweenListItem(
      index: index,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(label, style: TextStyles.text12_600.copyWith(color: primary)),
              const Spacer(),
              Text(labelValue, style: TextStyles.text12_600.copyWith(color: primary)),
            ],
          ),
          const SizedBox(height: 08),
          Stack(
            clipBehavior: Clip.none,
            children: [
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  valueIndicatorColor: orange,
                  activeTrackColor: orange,
                  inactiveTrackColor: orange.colorOpacity(0.15),
                  disabledActiveTrackColor: lightBlue,
                  disabledInactiveTrackColor: lightBlue,
                  thumbColor: orange,
                  thumbShape: const RoundSliderThumbShape(),
                  showValueIndicator: ShowValueIndicator.onDrag,
                  valueIndicatorShape: const PaddleSliderValueIndicatorShape(),
                ),
                child: RangeSlider(
                  values: rangeValue,
                  min: minValue,
                  max: maxValue,
                  labels: RangeLabels(minTooltipLabel, maxTooltipLabel),
                  onChanged: (v) => onChanged == null ? null : onChanged!(v),
                ),
              ),
              if (rangeValue.start > minValue)
                Positioned(left: 0, top: 0, bottom: 0, child: CircleAvatar(radius: 12, backgroundColor: warning, child: minTextWidget)),
              if (rangeValue.end < maxValue)
                Positioned(right: 0, top: 0, bottom: 0, child: CircleAvatar(radius: 12, backgroundColor: warning, child: maxTextWidget)),
            ],
          ),
        ],
      ),
    );
  }
}

class _ExpansionLabel extends StatelessWidget {
  // final double gap;
  final DataModel item;
  final Widget list;
  final bool isExpanded;

  const _ExpansionLabel({required this.item, /*this.gap = 0,*/ this.list = const SizedBox.shrink(), this.isExpanded = true});

  @override
  Widget build(BuildContext context) {
    var style = TextStyles.text14_400.copyWith(color: primary, height: 1);
    return TweenListItem(
      index: item.valueInt,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: lightBlue,
          border: const Border(bottom: BorderSide(color: offWhite4)),
          borderRadius: BorderRadius.circular(04),
        ),
        child: Expansion(
          tilePadding: EdgeInsets.zero,
          childrenPadding: EdgeInsets.zero,
          // initiallyExpanded: isExpanded,
          trailing: SvgImage(image: Assets.svg1.caret_down_2, height: 16, color: primary),
          title: Text(item.label.recast, maxLines: 1, overflow: TextOverflow.ellipsis, style: style),
          children: [
            if (list != const SizedBox.shrink()) const SizedBox(height: 10),
            Container(
              child: list,
              width: double.infinity,
              padding: EdgeInsets.zero,
              // padding: EdgeInsets.symmetric(horizontal: gap),
              decoration: BoxDecoration(color: lightBlue, borderRadius: BorderRadius.circular(04)),
            ),
          ],
        ),
      ),
    );
  }
}
