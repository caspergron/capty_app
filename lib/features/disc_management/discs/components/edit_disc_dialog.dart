import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:app/animations/fade_animation.dart';
import 'package:app/components/buttons/elevate_button.dart';
import 'package:app/components/dialogs/image_rotate_dialog.dart';
import 'package:app/components/loaders/positioned_loader.dart';
import 'package:app/components/sheets/image_option_sheet.dart';
import 'package:app/components/sheets/plastics_sheet.dart';
import 'package:app/constants/app_keys.dart';
import 'package:app/constants/data_constants.dart';
import 'package:app/di.dart';
import 'package:app/extensions/flutter_ext.dart';
import 'package:app/extensions/number_ext.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/helpers/file_helper.dart';
import 'package:app/libraries/flush_popup.dart';
import 'package:app/models/disc/user_disc.dart';
import 'package:app/models/disc_bag/disc_bag.dart';
import 'package:app/models/plastic/plastic.dart';
import 'package:app/models/system/doc_file.dart';
import 'package:app/repository/disc_bag_repo.dart';
import 'package:app/repository/disc_repo.dart';
import 'package:app/repository/user_repo.dart';
import 'package:app/services/input_formatters.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/shadows.dart';
import 'package:app/themes/text_styles.dart';
import 'package:app/utils/assets.dart';
import 'package:app/utils/dimensions.dart';
import 'package:app/utils/size_config.dart';
import 'package:app/utils/transitions.dart';
import 'package:app/widgets/core/animated_radio.dart';
import 'package:app/widgets/core/input_field.dart';
import 'package:app/widgets/core/memory_image.dart';
import 'package:app/widgets/core/pop_scope_navigator.dart';
import 'package:app/widgets/exception/error_upload_image.dart';
import 'package:app/widgets/library/dropdown_flutter.dart';
import 'package:app/widgets/library/svg_image.dart';
import 'package:app/widgets/ui/character_counter.dart';
import 'package:app/widgets/ui/label_placeholder.dart';
import 'package:app/widgets/view/color_view.dart';

Future<void> editDiscDialog({required UserDisc disc, Function(UserDisc)? onSave}) async {
  var context = navigatorKey.currentState!.context;
  var padding = MediaQuery.of(context).viewInsets;
  var child = Align(child: _DialogView(disc, onSave));
  await showGeneralDialog(
    context: context,
    barrierLabel: 'Edit Disc Dialog',
    transitionDuration: DIALOG_DURATION,
    transitionBuilder: sl<Transitions>().bottomToTop,
    pageBuilder: (buildContext, anim1, anim2) => Padding(padding: padding, child: PopScopeNavigator(canPop: false, child: child)),
  );
}

class _DialogView extends StatefulWidget {
  final UserDisc disc;
  final Function(UserDisc)? onSave;
  const _DialogView(this.disc, this.onSave);

  @override
  State<_DialogView> createState() => _DialogViewState();
}

class _DialogViewState extends State<_DialogView> {
  var _loader = true;
  var _brand = TextEditingController();
  var _model = TextEditingController();
  var _speed = TextEditingController();
  var _glide = TextEditingController();
  var _turn = TextEditingController();
  var _fade = TextEditingController();
  var _weight = TextEditingController();
  var _comment = TextEditingController();
  var _colorOrImage = DISC_OPTIONS.first;
  var _color = const Color(0xFFFD131B);
  var _discFile = DocFile();
  var _discBag = DiscBag();
  var _plastic = Plastic();
  var _discBags = <DiscBag>[];
  var _plastics = <Plastic>[];
  var _disabledFocusNodes = [FocusNode(), FocusNode()];
  var _discSizeFocusNodes = [FocusNode(), FocusNode(), FocusNode(), FocusNode()];
  var _focusNodes = [FocusNode(), FocusNode()];

  @override
  void initState() {
    _setInitialStates();
    _fetchPlasticsByDiscBrandId();
    _fetchAllDiscBags();
    // sl<AppAnalytics>().screenView('edit-disc-popup');
    _disabledFocusNodes.forEach((item) => item.addListener(() => setState(() {})));
    _discSizeFocusNodes.forEach((item) => item.addListener(() => setState(() {})));
    _focusNodes.forEach((item) => item.addListener(() => setState(() {})));
    super.initState();
  }

  void _setInitialStates() {
    var disc = widget.disc;
    _brand.text = disc.brand?.name ?? 'n/a'.recast;
    _model.text = disc.name ?? 'n/a'.recast;
    _speed.text = '${disc.speed == null ? 0 : disc.speed.formatDouble}';
    _glide.text = '${disc.glide == null ? 0 : disc.glide.formatDouble}';
    _turn.text = '${disc.turn == null ? 0 : disc.turn.formatDouble}';
    _fade.text = '${disc.fade == null ? 0 : disc.fade.formatDouble}';
    _weight.text = '${disc.weight == null ? 0 : disc.weight.formatDouble}';
    _comment.text = disc.description ?? '';
    if (disc.disc_color != null) _color = disc.disc_color!;
    if (disc.media?.id != null) _colorOrImage = DISC_OPTIONS.last;
  }

  Future<void> _fetchPlasticsByDiscBrandId() async {
    if (widget.disc.brand?.id == null) return;
    var response = await sl<DiscRepository>().plasticsByDiscBrandId(widget.disc.brand!.id!);
    if (response.isNotEmpty) _plastics = response;
    var invalidPlastic = _plastics.isEmpty || widget.disc.plastic?.id == null;
    var index = invalidPlastic ? -1 : _plastics.indexWhere((item) => item.id == widget.disc.plastic?.id);
    if (index >= 0) _plastic = _plastics[index];
    setState(() {});
  }

  Future<void> _fetchAllDiscBags() async {
    var response = await sl<DiscBagRepository>().fetchDiscBags();
    if (response.isNotEmpty) _discBags = response;
    var invalidBag = _discBags.isEmpty || widget.disc.bagId == null;
    var index = invalidBag ? -1 : _discBags.indexWhere((item) => item.id == widget.disc.bagId);
    if (index >= 0) _discBag = _discBags[index];
    setState(() => _loader = false);
  }

  @override
  Widget build(BuildContext context) {
    var stackList = [_screenView(context), if (_loader) const PositionedLoader()];
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Container(
        height: SizeConfig.height,
        width: Dimensions.dialog_width,
        margin: EdgeInsets.only(top: SizeConfig.statusBar + (Platform.isIOS ? 10 : 16), bottom: BOTTOM_GAP + (Platform.isIOS ? 0 : 20)),
        // height: SizeConfig.height - SizeConfig.statusBar - SizeConfig.bottom,
        padding: EdgeInsets.symmetric(horizontal: Dimensions.dialog_padding, vertical: Dimensions.dialog_padding),
        decoration: BoxDecoration(color: primary, borderRadius: DIALOG_RADIUS, boxShadow: const [SHADOW_2]),
        child: Material(color: transparent, shape: DIALOG_SHAPE, child: Stack(children: stackList)),
      ),
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
            Text('update_disc_details'.recast, style: TextStyles.text16_600.copyWith(color: lightBlue)),
            InkWell(onTap: backToPrevious, child: SvgImage(image: Assets.svg1.close_1, height: 18, color: lightBlue)),
          ],
        ),
        const SizedBox(height: 24),
        Expanded(
          child: ListView(
            shrinkWrap: true,
            clipBehavior: Clip.antiAlias,
            padding: EdgeInsets.zero,
            physics: const BouncingScrollPhysics(),
            children: [
              Row(
                children: [
                  Expanded(child: Text('brand'.recast, style: TextStyles.text13_600.copyWith(color: lightBlue))),
                  const SizedBox(width: 14),
                  Expanded(child: Text('model_name'.recast, style: TextStyles.text13_600.copyWith(color: lightBlue))),
                ],
              ),
              const SizedBox(height: 06),
              Row(
                children: [
                  Expanded(
                    child: InputField(
                      cursorHeight: 10,
                      controller: _brand,
                      hintText: '${'ex'.recast}: ${'Zone'.recast}',
                      readOnly: true,
                      showCursor: false,
                      fillColor: skyBlue,
                      enabledBorder: skyBlue,
                      focusedBorder: skyBlue,
                      focusNode: _disabledFocusNodes[0],
                      borderRadius: BorderRadius.circular(04),
                      contentPadding: const EdgeInsets.fromLTRB(08, 7.5, 04, 7.5),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: InputField(
                      cursorHeight: 10,
                      controller: _model,
                      hintText: '${'ex'.recast}: ${'crave'.recast}',
                      readOnly: true,
                      showCursor: false,
                      fillColor: skyBlue,
                      enabledBorder: skyBlue,
                      focusedBorder: skyBlue,
                      focusNode: _disabledFocusNodes[1],
                      borderRadius: BorderRadius.circular(04),
                      contentPadding: const EdgeInsets.fromLTRB(08, 7.5, 04, 7.5),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(child: Text('speed'.recast, style: TextStyles.text13_600.copyWith(color: lightBlue))),
                  const SizedBox(width: 06),
                  Expanded(child: Text('glide'.recast, style: TextStyles.text13_600.copyWith(color: lightBlue))),
                  const SizedBox(width: 06),
                  Expanded(child: Text('turn'.recast, style: TextStyles.text13_600.copyWith(color: lightBlue))),
                  const SizedBox(width: 06),
                  Expanded(child: Text('fade'.recast, style: TextStyles.text13_600.copyWith(color: lightBlue))),
                ],
              ),
              const SizedBox(height: 06),
              Row(
                children: [
                  Expanded(
                    child: InputField(
                      maxLength: 4,
                      cursorHeight: 10,
                      counterText: '',
                      controller: _speed,
                      hintText: '${'ex'.recast}: 6.5',
                      focusNode: _discSizeFocusNodes[0],
                      enabledBorder: mediumBlue,
                      focusedBorder: mediumBlue,
                      borderRadius: BorderRadius.circular(04),
                      textInputAction: TextInputAction.next,
                      contentPadding: const EdgeInsets.fromLTRB(08, 7.5, 04, 7.5),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      onFieldSubmitted: (value) => FocusScope.of(context).requestFocus(_discSizeFocusNodes[1]),
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
                      focusNode: _discSizeFocusNodes[1],
                      enabledBorder: mediumBlue,
                      focusedBorder: mediumBlue,
                      borderRadius: BorderRadius.circular(04),
                      textInputAction: TextInputAction.next,
                      contentPadding: const EdgeInsets.fromLTRB(08, 7.5, 04, 7.5),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      onFieldSubmitted: (value) => FocusScope.of(context).requestFocus(_discSizeFocusNodes[2]),
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
                      focusNode: _discSizeFocusNodes[2],
                      enabledBorder: mediumBlue,
                      focusedBorder: mediumBlue,
                      borderRadius: BorderRadius.circular(04),
                      textInputAction: TextInputAction.next,
                      contentPadding: const EdgeInsets.fromLTRB(08, 7.5, 04, 7.5),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      onFieldSubmitted: (value) => FocusScope.of(context).requestFocus(_discSizeFocusNodes[3]),
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
                      focusNode: _discSizeFocusNodes[3],
                      enabledBorder: mediumBlue,
                      focusedBorder: mediumBlue,
                      borderRadius: BorderRadius.circular(04),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      contentPadding: const EdgeInsets.fromLTRB(08, 7.5, 04, 7.5),
                      inputFormatters: [FloatNumberInputFormatter()],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text('plastic'.recast, style: TextStyles.text13_600.copyWith(color: lightBlue)),
              const SizedBox(height: 06),
              LabelPlaceholder(
                height: 40,
                background: lightBlue,
                textColor: dark,
                fontSize: 12,
                hint: 'select_plastic',
                label: _plastic.name ?? '',
                endIcon: SvgImage(image: Assets.svg1.caret_down_1, height: 19, color: dark),
                onTap: _onPlastic,
              ),
              const SizedBox(height: 14),
              Text('weight'.recast, style: TextStyles.text13_600.copyWith(color: lightBlue)),
              const SizedBox(height: 06),
              InputField(
                fontSize: 12,
                controller: _weight,
                hintText: '${'ex'.recast}: 125',
                focusNode: _focusNodes.first,
                enabledBorder: lightBlue,
                focusedBorder: lightBlue,
                keyboardType: TextInputType.number,
                borderRadius: BorderRadius.circular(04),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly, PriceInputFormatter()],
              ),
              const SizedBox(height: 14),
              Text('bag'.recast, style: TextStyles.text13_600.copyWith(color: lightBlue)),
              const SizedBox(height: 06),
              DropdownFlutter<DiscBag>(
                height: 38,
                items: _discBags,
                hint: 'select_a_bag'.recast,
                value: _discBag.id == null ? null : _discBag,
                hintLabel: _discBag.id == null ? null : _discBags.firstWhere((item) => item == item).label,
                onChanged: (v) => setState(() => _discBag = v!),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('disc_image'.recast, style: TextStyles.text13_600.copyWith(color: lightBlue)),
                        const SizedBox(height: 08),
                        AnimatedRadio(
                          color: lightBlue,
                          label: 'pick_color'.recast,
                          value: _colorOrImage == 'color',
                          onChanged: () => _onRadio('color'),
                          style: TextStyles.text14_400.copyWith(color: lightBlue, fontSize: 13),
                        ),
                        const SizedBox(height: 10),
                        AnimatedRadio(
                          color: lightBlue,
                          label: 'upload_image'.recast,
                          value: _colorOrImage == 'image',
                          onChanged: () => _onRadio('image'),
                          style: TextStyles.text14_400.copyWith(color: lightBlue, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 04),
                  FadeAnimation(
                    fadeKey: _colorOrImage,
                    duration: DURATION_700,
                    child: _colorOrImage == 'color'
                        ? ColorView(color: _color, onColor: (v) => setState(() => _color = v))
                        : ImageMemory(
                            radius: 04,
                            width: 70,
                            height: 70,
                            imagePath: _discFile.unit8List,
                            onTap: () => imageOptionSheet(onFile: _onImage, cropType: 'circle_clip'),
                            error: ErrorUploadImage(color: lightBlue, discImage: widget.disc.media?.url),
                          ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Text('notes'.recast, style: TextStyles.text13_600.copyWith(color: lightBlue)),
                  const Spacer(),
                  InkWell(
                    onTap: () => _comment.clear(),
                    child: Text('🧹${'clear_notes'.recast}', style: TextStyles.text13_600.copyWith(color: orange)),
                  ),
                ],
              ),
              const SizedBox(height: 06),
              InputField(
                fontSize: 12,
                minLines: 06,
                maxLines: 16,
                counterText: '',
                maxLength: 300,
                controller: _comment,
                hintText: 'write_notes_here'.recast,
                focusNode: _focusNodes.last,
                enabledBorder: lightBlue,
                focusedBorder: lightBlue,
                borderRadius: BorderRadius.circular(04),
              ),
              if (_comment.text.isNotEmpty) const SizedBox(height: 06),
              if (_comment.text.isNotEmpty) CharacterCounter(count: _comment.text.length, total: 300),
              const SizedBox(height: 20),
            ],
          ),
        ),
        const SizedBox(height: 20),
        ElevateButton(
          radius: 04,
          height: 42,
          onTap: _onSave,
          width: double.infinity,
          label: 'save_details'.recast.toUpper,
          textStyle: TextStyles.text14_600.copyWith(color: lightBlue, fontSize: 15, height: 1.15),
        ),
      ],
    );
  }

  Future<void> _onPlastic() async {
    if (_plastics.isEmpty) return;
    await Future.delayed(const Duration(milliseconds: 200));
    unawaited(plasticsSheet(plastic: _plastic, plastics: _plastics, onChanged: (v) => setState(() => _plastic = v)));
  }

  void _onRadio(String value) {
    if (_colorOrImage == value) return;
    _colorOrImage = value;
    _color = lightBlue;
    _discFile = DocFile();
    setState(() {});
  }

  Future<void> _onImage(File fileImage) async {
    setState(() => _loader = true);
    var docFiles = await sl<FileHelper>().renderFilesInModel([fileImage]);
    if (docFiles.isEmpty) return setState(() => _loader = false);
    _discFile = docFiles.first;
    if (_discFile.unit8List == null) return setState(() => _loader = false);
    if (Platform.isIOS) await imageRotateDialog(file: _discFile.file!, onChanged: (v) => setState(() => _discFile = v));
    setState(() => _loader = false);
    // unawaited(discCropperDialog(file: file, onChanged: (v) => setState(() => _discFile = v)));
  }

  void _onSave() {
    if (_speed.text.isEmpty) return FlushPopup.onWarning(message: 'please_write_your_disc_speed'.recast);
    if (_glide.text.isEmpty) return FlushPopup.onWarning(message: 'please_write_your_disc_glide'.recast);
    if (_turn.text.isEmpty) return FlushPopup.onWarning(message: 'please_write_your_disc_turn'.recast);
    if (_fade.text.isEmpty) return FlushPopup.onWarning(message: 'please_write_your_disc_fade'.recast);
    if (_discBag.id == null) return FlushPopup.onWarning(message: 'please_select_a_bag_for_your_disc'.recast);
    var invalidImage = _colorOrImage == 'image' && _discFile.file == null && widget.disc.media?.id == null;
    if (invalidImage) return FlushPopup.onWarning(message: 'please_add_your_disc_image'.recast);
    _onUpdateDisc();
  }

  Future<int?> _fetchMediaId() async {
    if (_discFile.file == null) return widget.disc.media?.id;
    var base64 = 'data:image/jpeg;base64,${_discFile.base64}';
    var mediaBody = {'section': 'disc', 'alt_texts': 'user_disc', 'type': 'image', 'image': base64};
    var response = await sl<UserRepository>().uploadBase64Media(mediaBody);
    return response?.id;
  }

  Future<void> _onUpdateDisc() async {
    setState(() => _loader = true);
    var mediaId = null as int?;
    var isMediaUpload = _colorOrImage == 'image';
    if (isMediaUpload) mediaId = await _fetchMediaId();
    if (isMediaUpload && mediaId == null) return setState(() => _loader = false);
    var body = _updateDiscBody;
    body.addAll({'media_id': isMediaUpload ? mediaId : null});
    var response = await sl<DiscRepository>().updateUserDisc(widget.disc.id!, body);
    if (response == null) return setState(() => _loader = false);
    setState(() => _loader = false);
    if (widget.onSave != null) widget.onSave!(response);
    backToPrevious();
  }

  Map<String, dynamic> get _updateDiscBody {
    var parentDiscId = widget.disc.parentDiscId;
    var isMediaUpload = _colorOrImage == 'image';
    var colorValue = _color.toARGB32().toRadixString(16).padLeft(8, '0').substring(2);
    return {
      'disc_id': parentDiscId,
      'weight': _weight.text,
      'speed': _speed.text,
      'glide': _glide.text,
      'turn': _turn.text,
      'fade': _fade.text,
      'disc_plastic_id': _plastic.id,
      'description': _comment.text,
      'bag_id': _discBag.id,
      'color': isMediaUpload ? null : colorValue,
    };
  }
}
