import 'dart:async';
import 'dart:io';

import 'package:app/animations/fade_animation.dart';
import 'package:app/animations/tween_list_item.dart';
import 'package:app/components/app_lists/label_wrap_list.dart';
import 'package:app/components/buttons/elevate_button.dart';
import 'package:app/components/dialogs/image_rotate_dialog.dart';
import 'package:app/components/loaders/screen_loader.dart';
import 'package:app/components/menus/back_menu.dart';
import 'package:app/components/menus/label_suffix.dart';
import 'package:app/components/sheets/image_option_sheet.dart';
import 'package:app/components/sheets/plastics_sheet.dart';
import 'package:app/components/sheets/special_tags_sheet.dart';
import 'package:app/constants/data_constants.dart';
import 'package:app/di.dart';
import 'package:app/extensions/flutter_ext.dart';
import 'package:app/extensions/number_ext.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/features/marketplace_management/create_sales_ad/components/add_home_address_dialog.dart';
import 'package:app/features/marketplace_management/create_sales_ad/create_sales_ad_view_model.dart';
import 'package:app/helpers/file_helper.dart';
import 'package:app/libraries/flush_popup.dart';
import 'package:app/models/common/tag.dart';
import 'package:app/models/disc/user_disc.dart';
import 'package:app/preferences/user_preferences.dart';
import 'package:app/services/app_analytics.dart';
import 'package:app/services/input_formatters.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/fonts.dart';
import 'package:app/themes/gradients.dart';
import 'package:app/themes/shadows.dart';
import 'package:app/themes/text_styles.dart';
import 'package:app/utils/assets.dart';
import 'package:app/utils/dimensions.dart';
import 'package:app/utils/size_config.dart';
import 'package:app/widgets/core/animated_radio.dart';
import 'package:app/widgets/core/input_field.dart';
import 'package:app/widgets/core/linear_progressbar.dart';
import 'package:app/widgets/core/memory_image.dart';
import 'package:app/widgets/core/pop_scope_navigator.dart';
import 'package:app/widgets/exception/error_upload_image.dart';
import 'package:app/widgets/library/svg_image.dart';
import 'package:app/widgets/ui/character_counter.dart';
import 'package:app/widgets/ui/icon_box.dart';
import 'package:app/widgets/ui/label_placeholder.dart';
import 'package:app/widgets/ui/nav_button_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class CreateSalesAdScreen extends StatefulWidget {
  final int tabIndex;
  final UserDisc userDisc;
  const CreateSalesAdScreen({required this.tabIndex, required this.userDisc});

  @override
  State<CreateSalesAdScreen> createState() => _CreateSalesAdScreenState();
}

class _CreateSalesAdScreenState extends State<CreateSalesAdScreen> {
  var _viewModel = CreateSalesAdViewModel();
  var _modelData = CreateSalesAdViewModel();
  var _weight = TextEditingController();
  var _comment = TextEditingController();
  var _price = TextEditingController();
  var _focusNodes = [FocusNode(), FocusNode(), FocusNode()];

  @override
  void initState() {
    _setInitialStates();
    sl<AppAnalytics>().screenView('create-sales-ad-screen');
    _focusNodes.forEach((item) => item.addListener(() => setState(() {})));
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => _viewModel.initViewModel(widget.userDisc));
    super.initState();
  }

  void _setInitialStates() {
    var userDisc = widget.userDisc;
    _comment.text = userDisc.description ?? '';
    _weight.text = userDisc.weight == null ? '' : '${userDisc.weight!.toInt()}';
  }

  @override
  void didChangeDependencies() {
    _viewModel = Provider.of<CreateSalesAdViewModel>(context, listen: false);
    _modelData = Provider.of<CreateSalesAdViewModel>(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var loader = _modelData.loader.loader;
    return PopScopeNavigator(
      canPop: false,
      onPop: _onBack,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: BackMenu(onTap: _onBack),
          title: Text('create_sales_ad'.recast),
          automaticallyImplyLeading: false,
        ),
        body: Container(
          width: SizeConfig.width,
          height: SizeConfig.height,
          decoration: BoxDecoration(gradient: BACKGROUND_GRADIENT),
          child: Stack(children: [_screenView(context), if (loader) const ScreenLoader()]),
        ),
        bottomNavigationBar: NavButtonBox(loader: loader, childHeight: 42, child: _navbarButton(context)),
      ),
    );
  }

  Widget _navbarButton(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevateButton(
            radius: 04,
            height: 42,
            background: skyBlue,
            onTap: _onBack,
            loader: _modelData.loader.loader,
            label: _modelData.step == 1 ? 'cancel'.recast.toUpper : 'back'.recast.toUpper,
            textStyle: TextStyles.text14_700.copyWith(color: primary, fontWeight: w600, height: 1.15),
          ),
        ),
        const SizedBox(width: 08),
        Expanded(
          child: ElevateButton(
            radius: 04,
            height: 42,
            onTap: _onNext,
            loader: _modelData.loader.loader,
            label: _modelData.step < 4 ? 'next'.recast.toUpper : 'confirm'.recast.toUpper,
            textStyle: TextStyles.text14_700.copyWith(color: lightBlue, fontWeight: w600, height: 1.15),
          ),
        ),
      ],
    );
  }

  Widget _screenView(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 02),
        LinearProgressbar(total: _modelData.step.toDouble(), separator: 2, valueColor: primary, height: 10, radius: 0),
        const SizedBox(height: 12),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: Dimensions.screen_padding),
          child: Text('${'step'.recast.toUpper} - ${_modelData.step.formatInt}', style: TextStyles.text20_500.copyWith(color: dark)),
        ),
        const SizedBox(height: 24),
        Expanded(
          child: TweenListItem(
            index: _modelData.step,
            child: ListView(
              shrinkWrap: true,
              clipBehavior: Clip.antiAlias,
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: Dimensions.screen_padding),
              children: _modelData.step == 2 ? _stepTwoView : _stepOneView,
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> get _stepOneView {
    var userDisc = widget.userDisc;
    var isPlastics = _modelData.plastics.isNotEmpty;
    var intIndex = _modelData.usedValue.toInt();
    var conditionIndex = intIndex > 10 ? 10 : intIndex;
    var specialTagLabels = _modelData.specialTags.isEmpty ? <String>[] : _modelData.specialTags.map((e) => e.displayName ?? '').toList();
    return [
      Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 08),
        decoration: BoxDecoration(
          color: lightBlue,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(width: 0.50, color: primary),
          boxShadow: const [SHADOW_1],
        ),
        child: Column(
          children: [
            Row(
              children: [
                const SizedBox(width: 20),
                Expanded(child: Text('disc_name'.recast, style: TextStyles.text12_600.copyWith(color: dark))),
                const SizedBox(width: 08),
                Expanded(child: Text('manufacture'.recast, style: TextStyles.text12_600.copyWith(color: dark))),
                const SizedBox(width: 08),
                Expanded(child: Text('disc_type'.recast, style: TextStyles.text12_600.copyWith(color: dark))),
                const SizedBox(width: 20),
              ],
            ),
            const SizedBox(height: 08),
            const Divider(height: 1, color: primary, thickness: 0.5),
            const SizedBox(height: 07),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const SizedBox(width: 20),
                Expanded(
                  child: Text(
                    userDisc.name ?? 'n/a'.recast,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyles.text12_600.copyWith(color: dark, fontWeight: w400),
                  ),
                ),
                const SizedBox(width: 08),
                Expanded(
                  child: Text(
                    userDisc.brand?.name ?? 'n/a'.recast,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyles.text12_600.copyWith(color: dark, fontWeight: w400),
                  ),
                ),
                const SizedBox(width: 08),
                Expanded(
                  child: Text(
                    userDisc.type ?? 'n/a'.recast,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyles.text12_600.copyWith(color: dark, fontWeight: w400),
                  ),
                ),
                const SizedBox(width: 20),
              ],
            ),
          ],
        ),
      ),
      const SizedBox(height: 12),
      if (isPlastics) ...[
        Text('plastic'.recast, style: TextStyles.text14_600.copyWith(color: dark)),
        const SizedBox(height: 04),
        LabelPlaceholder(
          height: 40,
          background: lightBlue,
          textColor: dark,
          fontSize: 12,
          onTap: _onPlastic,
          hint: 'select_plastic',
          label: _modelData.plastic.name ?? '',
          endIcon: SvgImage(image: Assets.svg1.caret_down_1, height: 19, color: dark),
        ),
        const SizedBox(height: 12),
      ],
      Row(
        children: [
          Expanded(child: Text('weight'.recast, style: TextStyles.text14_600.copyWith(color: dark))),
          const SizedBox(width: 14),
          Expanded(child: Text('price'.recast, style: TextStyles.text14_600.copyWith(color: dark))),
        ],
      ),
      const SizedBox(height: 04),
      Row(
        children: [
          Expanded(
            child: InputField(
              fontSize: 12,
              controller: _weight,
              hintText: '${'ex'.recast}: 125',
              focusNode: _focusNodes[0],
              keyboardType: TextInputType.number,
              enabledBorder: lightBlue,
              focusedBorder: lightBlue,
              borderRadius: BorderRadius.circular(04),
              suffixIcon: LabelSuffix(label: 'gram'.recast),
              inputFormatters: [FilteringTextInputFormatter.digitsOnly, PriceInputFormatter()],
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: InputField(
              fontSize: 12,
              controller: _price,
              hintText: '${'ex'.recast}: 20',
              focusNode: _focusNodes[2],
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly, PriceInputFormatter()],
              enabledBorder: lightBlue,
              focusedBorder: lightBlue,
              borderRadius: BorderRadius.circular(04),
              suffixIcon: LabelSuffix(label: UserPreferences.currencyCode),
            ),
          ),
        ],
      ),
      const SizedBox(height: 12),
      Text('disc_condition'.recast, style: TextStyles.text14_600.copyWith(color: dark)),
      const SizedBox(height: 04),
      Slider(
        min: 1,
        max: 10,
        divisions: 9,
        inactiveColor: skyBlue,
        activeColor: orange,
        value: 11 - _modelData.usedValue,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        allowedInteraction: SliderInteraction.tapAndSlide,
        onChanged: (value) => setState(() => _modelData.usedValue = 11 - value),
      ),
      const SizedBox(height: 04),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 04),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(10, (index) => Text('${10 - index}', style: TextStyles.text12_600.copyWith(color: primary))),
        ),
      ),
      const SizedBox(height: 06),
      Text(USED_DISC_INFO[conditionIndex - 1].recast, style: TextStyles.text13_600.copyWith(color: primary, fontWeight: w500, height: 1.3)),
      const SizedBox(height: 16),
      Row(
        children: [
          Expanded(child: Text('disc_special_features'.recast, style: TextStyles.text14_600.copyWith(color: dark, height: 1))),
          const SizedBox(width: 08),
          IconBox(
            background: primary,
            onTap: () => specialTagsSheet(selectedTags: _modelData.specialTags, onChanged: _onSelectDiscSpeciality),
            icon: SvgImage(image: Assets.svg1.plus, height: 17, color: lightBlue),
          ),
        ],
      ),
      if (specialTagLabels.isNotEmpty) const SizedBox(height: 08),
      if (specialTagLabels.isEmpty)
        Text('if_you_tag_your_sales_ad_it_makes_it_more'.recast, style: TextStyles.text12_400.copyWith(color: dark, fontSize: 13))
      else
        LabelWrapList(fontSize: 12, items: specialTagLabels, onItem: (index) => setState(() => _modelData.specialTags.removeAt(index))),
      const SizedBox(height: 16),
      Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('disc_image'.recast, style: TextStyles.text14_600.copyWith(color: dark)),
                const SizedBox(height: 08),
                AnimatedRadio(label: 'upload_image'.recast, value: true),
                const SizedBox(height: 04),
                Text(
                  '* ${'mandatory_to_upload_image_for_sales_ads'.recast}',
                  textAlign: TextAlign.start,
                  style: TextStyles.text10_400.copyWith(color: gold, fontSize: 12, fontWeight: w500),
                )
              ],
            ),
          ),
          const SizedBox(height: 04),
          FadeAnimation(
            fadeKey: 'true',
            duration: DURATION_700,
            child: ImageMemory(
              radius: 04,
              width: 70,
              height: 70,
              imagePath: _modelData.discFile.unit8List,
              onTap: () => imageOptionSheet(onFile: _onImage, cropType: 'circle_clip'),
              error: ErrorUploadImage(color: lightBlue, discImage: widget.userDisc.media?.url),
            ),
          ),
        ],
      ),
      const SizedBox(height: 12),
      Text('sales_ad_notes'.recast, style: TextStyles.text14_600.copyWith(color: dark)),
      const SizedBox(height: 08),
      InputField(
        fontSize: 12,
        minLines: 06,
        maxLines: 12,
        counterText: '',
        maxLength: 150,
        controller: _comment,
        hintText: 'write_notes_here'.recast,
        focusNode: _focusNodes[1],
        enabledBorder: lightBlue,
        focusedBorder: lightBlue,
        onChanged: (v) => setState(() {}),
        borderRadius: BorderRadius.circular(04),
      ),
      if (_comment.text.isNotEmpty) ...[
        const SizedBox(height: 06),
        CharacterCounter(count: _comment.text.length, total: 150, color: dark),
      ],
      SizedBox(height: BOTTOM_GAP),
    ];
  }

  void _onPlastic() {
    if (_modelData.plastics.isEmpty) return;
    plasticsSheet(plastic: _modelData.plastic, plastics: _modelData.plastics, onChanged: (v) => setState(() => _modelData.plastic = v));
  }

  void _onSelectDiscSpeciality(List<Tag> tagItems) => setState(() => _modelData.specialTags = tagItems);

  List<Widget> get _stepTwoView {
    var userDisc = widget.userDisc;
    var weight = _weight.text;
    var price = _price.text.isEmpty ? 'n/a'.recast : '${_price.text} ${UserPreferences.currencyCode}';
    var intIndex = _modelData.usedValue.toInt();
    var conditionIndex = intIndex > 10 ? 10 : intIndex;
    return [
      Row(
        children: [
          Expanded(child: _detailsInfo(label: 'disc_name'.recast, value: userDisc.name ?? 'n/a'.recast)),
          const SizedBox(width: 08),
          Expanded(child: _detailsInfo(label: 'manufacture'.recast, value: userDisc.brand?.name ?? 'n/a'.recast)),
        ],
      ),
      const Padding(padding: EdgeInsets.symmetric(vertical: 10), child: Divider(color: skyBlue)),
      Row(
        children: [
          Expanded(child: _detailsInfo(label: 'disc_type'.recast, value: userDisc.type ?? 'n/a'.recast)),
          const SizedBox(width: 08),
          Expanded(child: _detailsInfo(label: 'plastic'.recast, value: _modelData.plastic.label ?? 'n/a'.recast)),
        ],
      ),
      const Padding(padding: EdgeInsets.symmetric(vertical: 10), child: Divider(color: skyBlue)),
      Row(
        children: [
          Expanded(child: _detailsInfo(label: 'weight'.recast, value: weight.isEmpty ? 'n/a'.recast : '$weight ${'gram'.recast}')),
          const SizedBox(width: 08),
          Expanded(child: _detailsInfo(label: 'price'.recast, value: price)),
        ],
      ),
      const Padding(padding: EdgeInsets.symmetric(vertical: 10), child: Divider(color: skyBlue)),
      _detailsInfo(label: 'disc_condition'.recast, value: USED_DISC_INFO[conditionIndex - 1].recast),
      const Padding(padding: EdgeInsets.symmetric(vertical: 10), child: Divider(color: skyBlue)),
      _detailsInfo(
        label: 'speciality'.recast,
        value: _modelData.specialTags.isEmpty ? 'n/a'.recast : _modelData.specialTags.map((item) => item.displayName ?? '').join(', '),
      ),
      const Padding(padding: EdgeInsets.symmetric(vertical: 10), child: Divider(color: skyBlue)),
      _detailsInfo(label: 'sales_ad_notes'.recast, value: _comment.text.isEmpty ? 'n/a'.recast : _comment.text),
      if (_modelData.discFile.file != null || widget.userDisc.media?.url != null) ...[
        const Padding(padding: EdgeInsets.symmetric(vertical: 10), child: Divider(color: skyBlue)),
        Text('disc_image'.recast, style: TextStyles.text13_600.copyWith(color: primary.colorOpacity(0.6))),
        const SizedBox(height: 06),
        Align(
          alignment: Alignment.centerLeft,
          child: ImageMemory(
            radius: 04,
            width: 70,
            height: 70,
            imagePath: _modelData.discFile.unit8List,
            error: ErrorUploadImage(color: lightBlue, discImage: widget.userDisc.media?.url),
          ),
        ),
      ],
      SizedBox(height: BOTTOM_GAP),
    ];
  }

  Widget _detailsInfo({String label = '', String value = ''}) {
    var title = Text(label, style: TextStyles.text13_600.copyWith(color: primary.colorOpacity(0.6)));
    var subtitle = Text(value, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyles.text14_600.copyWith(color: primary));
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [title, const SizedBox(height: 04), subtitle]);
  }

  void _onBack() {
    if (_modelData.step == 1) return backToPrevious();
    setState(() => _modelData.step--);
  }

  void _onNext() {
    var userDisc = widget.userDisc;
    Map<String, dynamic> params = {
      'speed': userDisc.speed ?? 1,
      'glide': userDisc.glide ?? 0,
      'turn': userDisc.turn ?? 0,
      'fade': userDisc.fade ?? 0,
      'price': _price.text,
      'notes': _comment.text,
      'weight': _weight.text.isEmpty ? 0 : _weight.text,
    };
    if (_modelData.step == 2) _viewModel.onCreateSalesAd(params, widget.userDisc.media?.id);
    if (_modelData.step == 2) return;
    if (_modelData.step == 1) {
      var isHomeAddress = _modelData.address.id != null && _modelData.address.is_home;
      if (!isHomeAddress) return unawaited(addHomeAddressDialog());
      if (_price.text.isEmpty) return FlushPopup.onWarning(message: 'please_write_the_price_of_your_disc'.recast);
      var invalidImage = _modelData.discFile.file == null && widget.userDisc.media?.id == null;
      if (invalidImage) return FlushPopup.onWarning(message: 'please_add_your_disc_image'.recast);
    }
    setState(() => _modelData.step++);
  }

  Future<void> _onImage(File fileImage) async {
    setState(() => _modelData.loader.common = true);
    var docFiles = await sl<FileHelper>().renderFilesInModel([fileImage]);
    if (docFiles.isEmpty) return setState(() => _modelData.loader.common = false);
    _modelData.discFile = docFiles.first;
    if (_modelData.discFile.unit8List == null) return setState(() => _modelData.loader.common = false);
    if (Platform.isIOS) await imageRotateDialog(file: _modelData.discFile.file!, onChanged: (v) => setState(() => _modelData.discFile = v));
    setState(() => _modelData.loader.common = false);
  }
}
