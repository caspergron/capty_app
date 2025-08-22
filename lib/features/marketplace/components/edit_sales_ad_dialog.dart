import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:app/animations/fade_animation.dart';
import 'package:app/components/app_lists/label_wrap_list.dart';
import 'package:app/components/buttons/elevate_button.dart';
import 'package:app/components/dialogs/image_rotate_dialog.dart';
import 'package:app/components/loaders/positioned_loader.dart';
import 'package:app/components/sheets/image_option_sheet.dart';
import 'package:app/components/sheets/plastics_sheet.dart';
import 'package:app/components/sheets/special_tags_sheet.dart';
import 'package:app/constants/app_keys.dart';
import 'package:app/constants/data_constants.dart';
import 'package:app/di.dart';
import 'package:app/extensions/flutter_ext.dart';
import 'package:app/extensions/number_ext.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/helpers/file_helper.dart';
import 'package:app/libraries/flush_popup.dart';
import 'package:app/models/common/tag.dart';
import 'package:app/models/marketplace/sales_ad.dart';
import 'package:app/models/plastic/plastic.dart';
import 'package:app/models/system/doc_file.dart';
import 'package:app/preferences/app_preferences.dart';
import 'package:app/repository/disc_repo.dart';
import 'package:app/services/input_formatters.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/fonts.dart';
import 'package:app/themes/shadows.dart';
import 'package:app/themes/text_styles.dart';
import 'package:app/utils/assets.dart';
import 'package:app/utils/dimensions.dart';
import 'package:app/utils/transitions.dart';
import 'package:app/widgets/core/animated_radio.dart';
import 'package:app/widgets/core/input_field.dart';
import 'package:app/widgets/core/memory_image.dart';
import 'package:app/widgets/core/pop_scope_navigator.dart';
import 'package:app/widgets/exception/error_upload_image.dart';
import 'package:app/widgets/library/svg_image.dart';
import 'package:app/widgets/ui/character_counter.dart';
import 'package:app/widgets/ui/label_placeholder.dart';

Future<void> editSalesAdDiscDialog({required SalesAd marketplace, Function(Map<String, dynamic>, DocFile?)? onSave}) async {
  var context = navigatorKey.currentState!.context;
  var padding = MediaQuery.of(context).viewInsets;
  var child = Align(child: _DialogView(marketplace, onSave));
  await showGeneralDialog(
    context: context,
    barrierLabel: 'Edit Wishlist Disc Dialog',
    transitionDuration: DIALOG_DURATION,
    transitionBuilder: sl<Transitions>().bottomToTop,
    pageBuilder: (buildContext, anim1, anim2) => Padding(padding: padding, child: PopScopeNavigator(canPop: false, child: child)),
  );
}

class _DialogView extends StatefulWidget {
  final SalesAd marketplace;
  final Function(Map<String, dynamic>, DocFile?)? onSave;
  const _DialogView(this.marketplace, this.onSave);

  @override
  State<_DialogView> createState() => _DialogViewState();
}

class _DialogViewState extends State<_DialogView> {
  var _loader = false;
  var _brand = TextEditingController();
  var _model = TextEditingController();
  var _weight = TextEditingController();
  var _comment = TextEditingController();
  var _colorOrImage = DISC_OPTIONS.last;
  var _color = lightBlue;
  var _discFile = DocFile();
  var _plastic = Plastic();
  var _plastics = <Plastic>[];
  var _specialTags = <Tag>[];
  var _disabledFocusNodes = [FocusNode(), FocusNode()];
  var _discSizeFocusNodes = [FocusNode(), FocusNode(), FocusNode(), FocusNode()];
  var _focusNodes = [FocusNode(), FocusNode()];

  @override
  void initState() {
    _setInitialStates();
    AppPreferences.fetchSpecialDiscTags();
    _fetchPlasticsByDiscBrandId();
    // sl<AppAnalytics>().screenView('edit-disc-popup');
    _disabledFocusNodes.forEach((item) => item.addListener(() => setState(() {})));
    _discSizeFocusNodes.forEach((item) => item.addListener(() => setState(() {})));
    _focusNodes.forEach((item) => item.addListener(() => setState(() {})));
    super.initState();
  }

  void _setInitialStates() {
    var marketplace = widget.marketplace;
    var userDisc = marketplace.userDisc;
    var parentDisc = userDisc?.parentDisc;
    _brand.text = parentDisc?.brand?.name ?? 'n/a'.recast;
    _model.text = parentDisc?.name ?? 'n/a'.recast;
    _weight.text = '${userDisc?.weight == null ? 0 : userDisc?.weight.formatDouble}';
    _comment.text = marketplace.notes ?? '';
    _specialTags = marketplace.specialityDiscs ?? [];
    setState(() {});
    // if (userDisc?.color != null) _color = userDisc!.disc_color!;
    // if (disc.media?.id != null) _colorOrImage = DISC_OPTIONS.last;
  }

  Future<void> _fetchPlasticsByDiscBrandId() async {
    var discBrandId = widget.marketplace.userDisc?.parentDisc?.discBrandId;
    var plasticId = widget.marketplace.userDisc?.discPlasticId;
    var response = await sl<DiscRepository>().plasticsByDiscBrandId(discBrandId!);
    if (response.isNotEmpty) _plastics = response;
    var index = _plastics.isEmpty || plasticId == null ? -1 : _plastics.indexWhere((item) => item.id == plasticId);
    if (index >= 0) _plastic = _plastics[index];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var stackList = [_screenView(context), if (_loader) const PositionedLoader()];
    return SingleChildScrollView(
      padding: MediaQuery.of(context).viewInsets,
      child: Container(
        width: Dimensions.dialog_width,
        padding: EdgeInsets.symmetric(horizontal: Dimensions.dialog_padding, vertical: Dimensions.dialog_padding),
        decoration: BoxDecoration(color: primary, borderRadius: DIALOG_RADIUS, boxShadow: const [SHADOW_2]),
        child: Material(color: transparent, shape: DIALOG_SHAPE, child: Stack(children: stackList)),
      ),
    );
  }

  Widget _screenView(BuildContext context) {
    var discSpecialities = AppPreferences.specialTags;
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
        ListView(
          shrinkWrap: true,
          clipBehavior: Clip.antiAlias,
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
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
            Text('disc_special_features'.recast, style: TextStyles.text13_600.copyWith(color: lightBlue)),
            const SizedBox(height: 08),
            LabelPlaceholder(
              height: 40,
              textColor: dark,
              fontSize: 12,
              background: lightBlue,
              hint: 'select_special_features',
              label: _specialTags.isEmpty ? '' : '${_specialTags.length} ${'feature_selected'.recast}',
              endIcon: SvgImage(image: Assets.svg1.caret_down_1, height: 19, color: dark),
              onTap: () => specialTagsSheet(selectedTags: _specialTags, onChanged: (v) => setState(() => _specialTags = v)),
            ),
            if (_specialTags.isNotEmpty) const SizedBox(height: 08),
            if (_specialTags.isNotEmpty)
              LabelWrapList(
                fontSize: 12,
                items: _specialTags.map((e) => e.displayName ?? '').toList(),
                onItem: (index) => setState(() => _specialTags.removeAt(index)),
              ),
            const SizedBox(height: 14),
            if (_plastics.isNotEmpty) ...[
              Text('plastic'.recast, style: TextStyles.text13_600.copyWith(color: lightBlue)),
              const SizedBox(height: 06),
              LabelPlaceholder(
                height: 40,
                textColor: dark,
                fontSize: 12,
                background: lightBlue,
                hint: 'select_plastic',
                label: _plastic.name ?? '',
                endIcon: SvgImage(image: Assets.svg1.caret_down_1, height: 19, color: dark),
                onTap: () => plasticsSheet(plastic: _plastic, plastics: _plastics, onChanged: (v) => setState(() => _plastic = v)),
              ),
              const SizedBox(height: 14),
            ],
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
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('disc_image'.recast, style: TextStyles.text13_600.copyWith(color: lightBlue)),
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
                  child: ImageMemory(
                    radius: 04,
                    width: 70,
                    height: 70,
                    color: dark.colorOpacity(0.15),
                    imagePath: _discFile.unit8List,
                    onTap: () => imageOptionSheet(onFile: _onImage, cropType: 'circle_clip'),
                    error: ErrorUploadImage(color: lightBlue, discImage: widget.marketplace.userDisc?.media?.url),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text('notes'.recast, style: TextStyles.text13_600.copyWith(color: lightBlue)),
            const SizedBox(height: 06),
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
              borderRadius: BorderRadius.circular(04),
            ),
            if (_comment.text.isNotEmpty) const SizedBox(height: 06),
            if (_comment.text.isNotEmpty) CharacterCounter(count: _comment.text.length, total: 150),
            const SizedBox(height: 20),
          ],
        ),
        const SizedBox(height: 20),
        ElevateButton(
          radius: 04,
          height: 36,
          onTap: _onSave,
          width: double.infinity,
          label: 'save_details'.recast.toUpper,
          textStyle: TextStyles.text14_700.copyWith(color: lightBlue, fontWeight: w600, height: 1.15),
        ),
        const SizedBox(height: 02),
      ],
    );
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

  Future<void> _onSave() async {
    if (_plastic.id == null) return FlushPopup.onWarning(message: 'please_select_the_plastic_material_of_your_disc'.recast);
    if (_weight.text.isEmpty) return FlushPopup.onWarning(message: 'please_write_your_disc_weight'.recast);
    var invalidImage = widget.marketplace.userDisc?.media?.id == null && _discFile.file == null;
    if (invalidImage) return FlushPopup.onWarning(message: 'please_add_your_disc_image'.recast);
    var marketplace = widget.marketplace;
    var userDisc = marketplace.userDisc;
    var parentDisc = userDisc?.parentDisc;
    var userDiscId = userDisc?.id;
    var parentDiscId = parentDisc?.id;
    var salesAdTypeId = marketplace.salesAdType?.id;
    var colorValue = _color.toARGB32().toRadixString(16).padLeft(8, '0').substring(2);
    var specialityIds = _specialTags.isEmpty ? <int>[] : _specialTags.map((e) => e.id ?? DEFAULT_ID).toList();
    var body = {
      'sales_ad_type_id': salesAdTypeId,
      'user_disc_id': userDiscId,
      'parent_disc_id': parentDiscId,
      'price': marketplace.price,
      'currency_id': marketplace.currencyId,
      'is_shipping': marketplace.isShipping,
      'shipping_method': marketplace.shippingMethod,
      // 'condition': marketplace.condition,
      'used_range': marketplace.usedRange,
      'speed': userDisc?.speed ?? parentDisc?.speed ?? 1,
      'glide': userDisc?.glide ?? parentDisc?.glide ?? 0,
      'turn': userDisc?.turn ?? parentDisc?.turn ?? 0,
      'fade': userDisc?.fade ?? parentDisc?.fade ?? 0,
      'disc_plastic_id': _plastic.id,
      'weight': _weight.text,
      'color': colorValue,
      'notes': _comment.text,
      'tags': specialityIds,
    };
    var discImage = _discFile.file == null ? null : _discFile;
    if (widget.onSave != null) widget.onSave!(body, discImage);
    backToPrevious();
  }
}
