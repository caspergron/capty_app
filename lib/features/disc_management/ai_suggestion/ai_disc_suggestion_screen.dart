import 'package:app/components/buttons/elevate_button.dart';
import 'package:app/components/loaders/screen_loader.dart';
import 'package:app/components/menus/back_menu.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/features/disc_management/ai_suggestion/ai_disc_suggestion_view_model.dart';
import 'package:app/features/disc_management/ai_suggestion/units/stepper_list.dart';
import 'package:app/models/system/data_model.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/fonts.dart';
import 'package:app/themes/gradients.dart';
import 'package:app/themes/text_styles.dart';
import 'package:app/utils/dimensions.dart';
import 'package:app/utils/size_config.dart';
import 'package:app/widgets/core/pop_scope_navigator.dart';
import 'package:app/widgets/core/rectangle_check_box.dart';
import 'package:app/widgets/library/dropdown_flutter.dart';
import 'package:app/widgets/ui/nav_button_box.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AiDiscSuggestionScreen extends StatefulWidget {
  @override
  State<AiDiscSuggestionScreen> createState() => _AiDiscSuggestionScreenState();
}

class _AiDiscSuggestionScreenState extends State<AiDiscSuggestionScreen> {
  var _viewModel = AiDiscSuggestionViewModel();
  var _modelData = AiDiscSuggestionViewModel();

  @override
  void initState() {
    // sl<AppAnalytics>().screenView('ai-disc-suggestion-screen');
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => _viewModel.initViewModel());
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _viewModel = Provider.of<AiDiscSuggestionViewModel>(context, listen: false);
    _modelData = Provider.of<AiDiscSuggestionViewModel>(context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _viewModel.disposeViewModel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScopeNavigator(
      canPop: false,
      onPop: _viewModel.onBack,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: BackMenu(onTap: _viewModel.onBack),
          title: Text('ai_disc_suggestion'.recast),
          automaticallyImplyLeading: false,
        ),
        body: Container(
          width: SizeConfig.width,
          height: SizeConfig.height,
          decoration: BoxDecoration(gradient: BACKGROUND_GRADIENT),
          child: Stack(children: [_screenView(context), if (_modelData.loader) const ScreenLoader()]),
        ),
        bottomNavigationBar: NavButtonBox(childHeight: 42, loader: _modelData.loader, child: _bottomNavbar),
      ),
    );
  }

  Widget get _bottomNavbar {
    return ElevateButton(
      radius: 04,
      height: 42,
      width: double.infinity,
      label: 'next'.recast.toUpper,
      onTap: _viewModel.onNext,
      textStyle: TextStyles.text14_700.copyWith(color: lightBlue, fontWeight: w600, height: 1.15),
    );
  }

  Widget _screenView(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      clipBehavior: Clip.antiAlias,
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: Dimensions.screen_padding),
      children: [
        const SizedBox(height: 14),
        Center(child: StepperList(totalStep: 4, step: _modelData.step)),
        const SizedBox(height: 20),
        Builder(builder: (context) {
          if (_modelData.step == 2) {
            return suggestionStep_2;
          } else if (_modelData.step == 3) {
            return suggestionStep_3;
          } else if (_modelData.step == 4) {
            return suggestionStep_4;
          } else {
            return suggestionStep_1;
          }
        }),
        SizedBox(height: BOTTOM_GAP),
      ],
    );
  }

  Widget get suggestionStep_1 {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('how_long_do_you_throw'.recast, style: TextStyles.text20_500.copyWith(color: primary, fontWeight: w600)),
        const SizedBox(height: 08),
        Text('pick_your_backhand_distance_that_you_reach'.recast, style: TextStyles.text12_700.copyWith(color: primary)),
        const SizedBox(height: 12),
        DropdownFlutter<DataModel>(
          hint: 'select_distance'.recast,
          items: CHAT_SUGGESTIONS,
          background: primary,
          color: lightBlue,
          value: _modelData.distance.value.isEmpty ? null : _modelData.distance,
          hintLabel: _modelData.distance.value.isEmpty ? null : CHAT_SUGGESTIONS.firstWhere((item) => item == item).label,
          onChanged: (v) => setState(() => _modelData.distance = v!),
        ),
      ],
    );
  }

  Widget get suggestionStep_2 {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('where_are_you_strongest'.recast, style: TextStyles.text20_500.copyWith(color: primary, fontWeight: w600)),
        const SizedBox(height: 08),
        Text('click_the_3_options_where_you_feel_you_are_strongest'.recast, style: TextStyles.text12_700.copyWith(color: primary)),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          decoration: BoxDecoration(color: primary, borderRadius: BorderRadius.circular(04)),
          child: _SelectableList(total: 3, listItems: _modelData.strongestList, onSelect: _viewModel.onSelectStrongest),
        ),
      ],
    );
  }

  Widget get suggestionStep_3 {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('stability_and_wind'.recast, style: TextStyles.text20_500.copyWith(color: primary, fontWeight: w600)),
        const SizedBox(height: 08),
        Text('click_1_option_where_you_feel_you_are_comfortable'.recast, style: TextStyles.text12_700.copyWith(color: primary)),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          decoration: BoxDecoration(color: primary, borderRadius: BorderRadius.circular(04)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('how_comfortable_are_you_with_over_stable_discs'.recast, style: TextStyles.text16_700.copyWith(color: lightBlue)),
              const SizedBox(height: 12),
              _SelectableList(listItems: _modelData.stabilityList, onSelect: _viewModel.onSelectStability),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          decoration: BoxDecoration(color: primary, borderRadius: BorderRadius.circular(04)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('do_you_need_discs_that_perform_well_in_windy_conditions'.recast,
                  style: TextStyles.text16_700.copyWith(color: lightBlue)),
              const SizedBox(height: 12),
              _SelectableList(listItems: _modelData.windList, onSelect: _viewModel.onSelectWind),
            ],
          ),
        ),
      ],
    );
  }

  Widget get suggestionStep_4 {
    var plasticLabel = 'do_you_prefer_premium_plastics_or_base_plastic'.recast;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('plastic_grip_and_technicality'.recast, style: TextStyles.text20_500.copyWith(color: primary, fontWeight: w600)),
        const SizedBox(height: 08),
        Text('click_on_1_option'.recast, style: TextStyles.text12_700.copyWith(color: primary)),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          decoration: BoxDecoration(color: primary, borderRadius: BorderRadius.circular(04)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(plasticLabel, style: TextStyles.text16_700.copyWith(color: lightBlue)),
              const SizedBox(height: 12),
              _SelectableList(listItems: _modelData.plasticList, onSelect: _viewModel.onSelectPlastic),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          decoration: BoxDecoration(color: primary, borderRadius: BorderRadius.circular(04)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('how_important_is_grip_in_wet_conditions_to_you'.recast, style: TextStyles.text16_700.copyWith(color: lightBlue)),
              const SizedBox(height: 12),
              _SelectableList(listItems: _modelData.gripList, onSelect: _viewModel.onSelectGrip),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          decoration: BoxDecoration(color: primary, borderRadius: BorderRadius.circular(04)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('do_you_play_in_heavily_wooded_courses'.recast, style: TextStyles.text16_700.copyWith(color: lightBlue)),
              const SizedBox(height: 12),
              _SelectableList(listItems: _modelData.fieldList, onSelect: _viewModel.onSelectField),
            ],
          ),
        ),
      ],
    );
  }
}

class _SelectableList extends StatelessWidget {
  final int total;
  final List<DataModel> listItems;
  final Function(DataModel, int)? onSelect;

  const _SelectableList({this.total = 1, this.listItems = const [], this.onSelect});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      clipBehavior: Clip.antiAlias,
      itemCount: listItems.length,
      itemBuilder: _selectableListItem,
      padding: EdgeInsets.zero,
    );
  }

  Widget _selectableListItem(BuildContext context, int index) {
    var item = listItems[index];
    var selected = item.valueInt == 1;
    var color = selected ? white : lightBlue;
    var totalSelected = listItems.where((item) => item.valueInt == 1).toList().length;
    return InkWell(
      onTap: onSelect == null || (totalSelected == total && !selected && total != 1) ? null : () => onSelect!(item, index),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.zero,
        margin: EdgeInsets.only(bottom: index == listItems.length - 1 ? 0 : 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RectangleCheckBox(isChecked: selected, color: lightBlue, selectedColor: white),
            const SizedBox(width: 04),
            Expanded(child: Text(item.label.recast, style: TextStyles.text14_400.copyWith(color: color, height: 1.3))),
          ],
        ),
      ),
    );
  }
}
