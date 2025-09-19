import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';

import 'package:app/animations/fade_animation.dart';
import 'package:app/components/buttons/elevate_button.dart';
import 'package:app/components/dialogs/image_rotate_dialog.dart';
import 'package:app/components/loaders/screen_loader.dart';
import 'package:app/components/menus/back_menu.dart';
import 'package:app/components/sheets/image_option_sheet.dart';
import 'package:app/components/sheets/plastics_sheet.dart';
import 'package:app/di.dart';
import 'package:app/extensions/flutter_ext.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/features/disc_management/add_disc/add_disc_view_model.dart';
import 'package:app/features/disc_management/add_disc/units/disc_size_list.dart';
import 'package:app/helpers/file_helper.dart';
import 'package:app/libraries/flush_popup.dart';
import 'package:app/models/disc/parent_disc.dart';
import 'package:app/models/disc_bag/disc_bag.dart';
import 'package:app/services/app_analytics.dart';
import 'package:app/services/input_formatters.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/fonts.dart';
import 'package:app/themes/gradients.dart';
import 'package:app/themes/text_styles.dart';
import 'package:app/utils/assets.dart';
import 'package:app/utils/dimensions.dart';
import 'package:app/utils/size_config.dart';
import 'package:app/widgets/core/animated_radio.dart';
import 'package:app/widgets/core/input_field.dart';
import 'package:app/widgets/core/memory_image.dart';
import 'package:app/widgets/exception/error_upload_image.dart';
import 'package:app/widgets/library/dropdown_flutter.dart';
import 'package:app/widgets/library/svg_image.dart';
import 'package:app/widgets/ui/character_counter.dart';
import 'package:app/widgets/ui/label_placeholder.dart';
import 'package:app/widgets/ui/nav_button_box.dart';
import 'package:app/widgets/view/color_view.dart';
import 'package:app/widgets/view/disc_initial_info.dart';
import 'package:app/widgets/view/unit_suffix.dart';

class AddDiscScreen extends StatefulWidget {
  final ParentDisc disc;
  const AddDiscScreen({required this.disc});

  @override
  State<AddDiscScreen> createState() => _AddDiscScreenState();
}

class _AddDiscScreenState extends State<AddDiscScreen> {
  var _viewModel = AddDiscViewModel();
  var _modelData = AddDiscViewModel();
  var _weight = TextEditingController();
  var _comment = TextEditingController();
  var _focusNodes = [FocusNode(), FocusNode()];
  var _speed = TextEditingController();
  var _glide = TextEditingController();
  var _turn = TextEditingController();
  var _fade = TextEditingController();
  var _discNodes = [FocusNode(), FocusNode(), FocusNode(), FocusNode()];

  @override
  void initState() {
    _setInitialStates();
    sl<AppAnalytics>().screenView('add-disc-screen');
    _focusNodes.forEach((item) => item.addListener(() => setState(() {})));
    _discNodes.forEach((item) => item.addListener(() => setState(() {})));
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => _viewModel.initViewModel(widget.disc));
    super.initState();
  }

  void _setInitialStates() {
    final disc = widget.disc;
    _speed.text = '${disc.speed ?? ''}';
    _glide.text = '${disc.glide ?? ''}';
    _turn.text = '${disc.turn ?? ''}';
    _fade.text = '${disc.fade ?? ''}';
  }

  @override
  void didChangeDependencies() {
    _viewModel = Provider.of<AddDiscViewModel>(context, listen: false);
    _modelData = Provider.of<AddDiscViewModel>(context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _weight.dispose();
    _comment.dispose();
    _speed.dispose();
    _glide.dispose();
    _turn.dispose();
    _fade.dispose();
    _focusNodes.forEach((item) => item.removeListener(() {}));
    _discNodes.forEach((item) => item.removeListener(() {}));
    _focusNodes.forEach((item) => item.dispose());
    _discNodes.forEach((item) => item.dispose());
    _viewModel.clearStates();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loader = _modelData.loader.loader;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: const BackMenu(),
        title: Text('add_your_disc'.recast),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        width: SizeConfig.width,
        height: SizeConfig.height,
        decoration: BoxDecoration(gradient: BACKGROUND_GRADIENT),
        child: Stack(children: [_screenView(context), if (loader) const ScreenLoader()]),
      ),
      bottomNavigationBar: NavButtonBox(loader: loader, childHeight: 42, child: _navbarButton(context)),
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
            onTap: backToPrevious,
            loader: _modelData.loader.loader,
            label: 'cancel'.recast.toUpper,
            textStyle: TextStyles.text14_700.copyWith(color: primary, fontWeight: w600, height: 1.15),
          ),
        ),
        const SizedBox(width: 08),
        Expanded(
          child: ElevateButton(
            radius: 04,
            height: 42,
            loader: _modelData.loader.loader,
            label: 'add_disc'.recast.toUpper,
            onTap: _onAddDisc,
            textStyle: TextStyles.text14_700.copyWith(color: lightBlue, fontWeight: w600, height: 1.15),
          ),
        ),
      ],
    );
  }

  void _onAddDisc() {
    if (_speed.text.isEmpty) return FlushPopup.onWarning(message: 'please_write_your_disc_speed'.recast);
    if (_glide.text.isEmpty) return FlushPopup.onWarning(message: 'please_write_your_disc_glide'.recast);
    if (_turn.text.isEmpty) return FlushPopup.onWarning(message: 'please_write_your_disc_turn'.recast);
    if (_fade.text.isEmpty) return FlushPopup.onWarning(message: 'please_write_your_disc_fade'.recast);
    if (_modelData.discBag.id == null) return FlushPopup.onWarning(message: 'please_select_a_bag_for_your_disc'.recast);
    final invalidImage = _modelData.selectedRadio == 'image' && _modelData.discFile.unit8List == null;
    if (invalidImage) return FlushPopup.onWarning(message: 'please_pick_a_color_of_your_disc_image_or_add_your_disc_image'.recast);
    final params = {
      'speed': _speed.text,
      'glide': _glide.text,
      'turn': _turn.text,
      'fade': _fade.text,
      'description': _comment.text,
      'weight': _weight.text.isEmpty ? 0 : _weight.text,
    };
    _viewModel.onAddDisc(params);
  }

  Widget _screenView(BuildContext context) {
    final disc = _modelData.disc;
    final isDiscBags = _modelData.discBags.isNotEmpty;
    return ListView(
      shrinkWrap: true,
      clipBehavior: Clip.antiAlias,
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: Dimensions.screen_padding),
      children: [
        const SizedBox(height: 16),
        DiscInitialInfo(disc: disc),
        const SizedBox(height: 12),
        Text('disc_details'.recast, style: TextStyles.text14_600.copyWith(color: dark)),
        const SizedBox(height: 04),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 08),
          decoration: BoxDecoration(
            color: lightBlue,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(width: 0.50, color: primary),
          ),
          child: FadeAnimation(
            duration: const Duration(milliseconds: 800),
            fadeKey: '${_modelData.isEditDetails}',
            child: !_modelData.isEditDetails
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      DiscSizeList(
                        sizes: [
                          double.parse(_speed.text.isEmpty ? '0' : _speed.text),
                          double.parse(_glide.text.isEmpty ? '0' : _glide.text),
                          double.parse(_turn.text.isEmpty ? '0' : _turn.text),
                          double.parse(_fade.text.isEmpty ? '0' : _fade.text),
                        ],
                      ),
                      const SizedBox(width: 10),
                      InkWell(onTap: _onEditDetails, child: SvgImage(image: Assets.svg1.edit, height: 20, color: primary)),
                    ],
                  )
                : Column(
                    children: [
                      Row(
                        children: [
                          const SizedBox(width: 20),
                          Expanded(child: Text('speed'.recast, style: TextStyles.text12_600.copyWith(color: dark))),
                          const SizedBox(width: 06),
                          Expanded(child: Text('glide'.recast, style: TextStyles.text12_600.copyWith(color: dark))),
                          const SizedBox(width: 06),
                          Expanded(child: Text('turn'.recast, style: TextStyles.text12_600.copyWith(color: dark))),
                          const SizedBox(width: 06),
                          Expanded(child: Text('fade'.recast, style: TextStyles.text12_600.copyWith(color: dark))),
                          const SizedBox(width: 20),
                        ],
                      ),
                      const SizedBox(height: 04),
                      Row(
                        children: [
                          const SizedBox(width: 20),
                          Expanded(
                            child: InputField(
                              maxLength: 4,
                              cursorHeight: 10,
                              counterText: '',
                              controller: _speed,
                              hintText: '${'ex'.recast}: 6.5',
                              focusNode: _discNodes[0],
                              enabledBorder: mediumBlue,
                              focusedBorder: mediumBlue,
                              borderRadius: BorderRadius.circular(04),
                              textInputAction: TextInputAction.next,
                              contentPadding: const EdgeInsets.fromLTRB(08, 7.5, 04, 7.5),
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              onFieldSubmitted: (value) => FocusScope.of(context).requestFocus(_discNodes[1]),
                              inputFormatters: [FloatNumberInputFormatter()],
                            ),
                          ),
                          const SizedBox(width: 06),
                          Expanded(
                            child: InputField(
                              maxLength: 4,
                              cursorHeight: 10,
                              counterText: '',
                              controller: _glide,
                              hintText: '${'ex'.recast}: 5',
                              focusNode: _discNodes[1],
                              enabledBorder: mediumBlue,
                              focusedBorder: mediumBlue,
                              borderRadius: BorderRadius.circular(04),
                              textInputAction: TextInputAction.next,
                              contentPadding: const EdgeInsets.fromLTRB(08, 7.5, 04, 7.5),
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              onFieldSubmitted: (value) => FocusScope.of(context).requestFocus(_discNodes[2]),
                              inputFormatters: [FloatNumberInputFormatter()],
                            ),
                          ),
                          const SizedBox(width: 06),
                          Expanded(
                            child: InputField(
                              maxLength: 4,
                              cursorHeight: 10,
                              counterText: '',
                              controller: _turn,
                              hintText: '${'ex'.recast}: -1',
                              focusNode: _discNodes[2],
                              enabledBorder: mediumBlue,
                              focusedBorder: mediumBlue,
                              borderRadius: BorderRadius.circular(04),
                              textInputAction: TextInputAction.next,
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              contentPadding: const EdgeInsets.fromLTRB(08, 7.5, 04, 7.5),
                              onFieldSubmitted: (value) => FocusScope.of(context).requestFocus(_discNodes[3]),
                              inputFormatters: [FloatNumberInputFormatter()],
                            ),
                          ),
                          const SizedBox(width: 06),
                          Expanded(
                            child: InputField(
                              maxLength: 4,
                              cursorHeight: 10,
                              counterText: '',
                              controller: _fade,
                              hintText: '${'ex'.recast}: 1',
                              focusNode: _discNodes[3],
                              enabledBorder: mediumBlue,
                              focusedBorder: mediumBlue,
                              borderRadius: BorderRadius.circular(04),
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              contentPadding: const EdgeInsets.fromLTRB(08, 7.5, 04, 7.5),
                              inputFormatters: [FloatNumberInputFormatter()],
                            ),
                          ),
                          const SizedBox(width: 20),
                        ],
                      ),
                      const SizedBox(height: 10),
                      ElevateButton(
                        radius: 04,
                        height: 30,
                        padding: 16,
                        label: 'update'.recast.toUpper,
                        onTap: _onUpdateDiscDetails,
                        textStyle: TextStyles.text12_700.copyWith(color: lightBlue, fontWeight: w600, height: 1),
                      ),
                    ],
                  ),
          ),
        ),
        const SizedBox(height: 12),
        if (_modelData.plastics.isNotEmpty) ...[
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
        Text('weight'.recast, style: TextStyles.text14_600.copyWith(color: dark)),
        const SizedBox(height: 04),
        InputField(
          fontSize: 12,
          controller: _weight,
          hintText: '${'ex'.recast}: 125',
          focusNode: _focusNodes.first,
          keyboardType: TextInputType.number,
          enabledBorder: lightBlue,
          focusedBorder: lightBlue,
          borderRadius: BorderRadius.circular(04),
          suffixIcon: UnitSuffix(),
          inputFormatters: [FilteringTextInputFormatter.digitsOnly, PriceInputFormatter()],
        ),
        const SizedBox(height: 12),
        if (isDiscBags) Text('bag'.recast, style: TextStyles.text14_600.copyWith(color: dark)),
        if (isDiscBags) const SizedBox(height: 04),
        if (isDiscBags)
          DropdownFlutter<DiscBag>(
            hint: 'select_a_bag'.recast,
            items: _modelData.discBags,
            value: _modelData.discBag.id == null ? null : _modelData.discBag,
            hintLabel: _modelData.discBag.id == null ? null : _modelData.discBags.firstWhere((item) => item == item).label,
            onChanged: (v) => setState(() => _modelData.discBag = v!),
          ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('disc_image'.recast, style: TextStyles.text14_600.copyWith(color: dark)),
                  const SizedBox(height: 08),
                  AnimatedRadio(
                    label: 'pick_color'.recast,
                    value: _modelData.selectedRadio == 'color',
                    onChanged: () => _viewModel.onRadioChange('color'),
                  ),
                  const SizedBox(height: 10),
                  AnimatedRadio(
                    label: 'upload_image'.recast,
                    value: _modelData.selectedRadio == 'image',
                    onChanged: () => _viewModel.onRadioChange('image'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 04),
            FadeAnimation(
              fadeKey: _modelData.selectedRadio,
              duration: DURATION_700,
              child: _modelData.selectedRadio == 'color'
                  ? ColorView(color: _modelData.color, onColor: (v) => setState(() => _modelData.color = v))
                  : ImageMemory(
                      radius: 04,
                      width: 70,
                      height: 70,
                      imagePath: _modelData.discFile.unit8List,
                      // error: ErrorUploadImage(discImage: widget.disc.media.url),
                      error: const ErrorUploadImage(),
                      onTap: () => imageOptionSheet(onFile: _onImage, cropType: 'circle_clip'),
                    ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text('notes'.recast, style: TextStyles.text14_600.copyWith(color: dark)),
        const SizedBox(height: 08),
        InputField(
          fontSize: 12,
          minLines: 06,
          maxLines: 12,
          counterText: '',
          maxLength: 150,
          controller: _comment,
          hintText: 'write_notes_here'.recast,
          focusNode: _focusNodes.last,
          enabledBorder: lightBlue,
          focusedBorder: lightBlue,
          onChanged: (v) => setState(() {}),
          borderRadius: BorderRadius.circular(04),
        ),
        if (_comment.text.isNotEmpty) const SizedBox(height: 06),
        if (_comment.text.isNotEmpty) CharacterCounter(count: _comment.text.length, total: 150),
        SizedBox(height: BOTTOM_GAP),
      ],
    );
  }

  Future<void> _onPlastic() async {
    if (_modelData.plastics.isEmpty) return;
    await Future.delayed(const Duration(milliseconds: 200));
    final plastic = _modelData.plastic;
    unawaited(plasticsSheet(plastic: plastic, plastics: _modelData.plastics, onChanged: (v) => setState(() => _modelData.plastic = v)));
  }

  void _onEditDetails() => setState(() => _modelData.isEditDetails = true);

  void _onUpdateDiscDetails() => setState(() => _modelData.isEditDetails = false);

  Future<void> _onImage(File fileImage) async {
    setState(() => _modelData.loader.common = true);
    final docFiles = await sl<FileHelper>().renderFilesInModel([fileImage]);
    if (docFiles.isEmpty) return setState(() => _modelData.loader.common = false);
    _modelData.discFile = docFiles.first;
    if (_modelData.discFile.unit8List == null) return setState(() => _modelData.loader.common = false);
    if (Platform.isIOS) await imageRotateDialog(file: _modelData.discFile.file!, onChanged: (v) => setState(() => _modelData.discFile = v));
    setState(() => _modelData.loader.common = false);
    // unawaited(discCropperDialog(file: file, onChanged: _viewModel.onImage));
  }
}
