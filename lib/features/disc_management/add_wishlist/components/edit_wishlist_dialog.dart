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
import 'package:app/models/disc/wishlist.dart';
import 'package:app/models/plastic/plastic.dart';
import 'package:app/models/system/doc_file.dart';
import 'package:app/repository/disc_repo.dart';
import 'package:app/repository/user_repo.dart';
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
import 'package:app/widgets/view/color_view.dart';
import 'package:app/widgets/view/unit_suffix.dart';

Future<void> editWishlistDisc({required Wishlist wishlist, bool isUpdateAndAdd = false, Function(Wishlist, bool)? onSave}) async {
  var context = navigatorKey.currentState!.context;
  var padding = MediaQuery.of(context).viewInsets;
  var child = Align(child: _DialogView(wishlist, isUpdateAndAdd, onSave));
  await showGeneralDialog(
    context: context,
    barrierLabel: 'Edit Wishlist Disc Dialog',
    transitionDuration: DIALOG_DURATION,
    transitionBuilder: sl<Transitions>().bottomToTop,
    pageBuilder: (buildContext, anim1, anim2) => Padding(padding: padding, child: PopScopeNavigator(canPop: false, child: child)),
  );
}

class _DialogView extends StatefulWidget {
  final Wishlist wishlist;
  final bool isUpdateAndAdd;
  final Function(Wishlist, bool)? onSave;
  const _DialogView(this.wishlist, this.isUpdateAndAdd, this.onSave);

  @override
  State<_DialogView> createState() => _DialogViewState();
}

class _DialogViewState extends State<_DialogView> {
  var _loader = false;
  var _brand = TextEditingController();
  var _model = TextEditingController();
  var _weight = TextEditingController();
  var _comment = TextEditingController();
  var _colorOrImage = DISC_OPTIONS.first;
  var _color = const Color(0xFFFD131B);
  var _discFile = DocFile();
  var _plastic = Plastic();
  var _plastics = <Plastic>[];
  var _disabledFocusNodes = [FocusNode(), FocusNode()];
  var _discSizeFocusNodes = [FocusNode(), FocusNode(), FocusNode(), FocusNode()];
  var _focusNodes = [FocusNode(), FocusNode()];

  @override
  void initState() {
    _setInitialStates();
    _fetchPlasticsByDiscBrandId();
    // sl<AppAnalytics>().screenView('edit-wishlist-disc-popup');
    _disabledFocusNodes.forEach((item) => item.addListener(() => setState(() {})));
    _discSizeFocusNodes.forEach((item) => item.addListener(() => setState(() {})));
    _focusNodes.forEach((item) => item.addListener(() => setState(() {})));
    super.initState();
  }

  void _setInitialStates() {
    var userDisc = widget.wishlist.userDisc;
    var parentDisc = widget.wishlist.disc;
    _brand.text = parentDisc?.brand?.name ?? 'n/a'.recast;
    _model.text = parentDisc?.name ?? 'n/a'.recast;
    _weight.text = '${userDisc?.weight == null ? 0 : userDisc?.weight.formatDouble}';
    _comment.text = userDisc?.description ?? '';
    if (userDisc?.disc_color != null) _color = userDisc!.disc_color!;
    if (userDisc?.media?.id != null) _colorOrImage = DISC_OPTIONS.last;
  }

  Future<void> _fetchPlasticsByDiscBrandId() async {
    var brandId = widget.wishlist.disc?.discBrandId;
    var plasticId = widget.wishlist.userDisc?.plastic?.id;
    var response = await sl<DiscRepository>().plasticsByDiscBrandId(brandId!);
    if (response.isNotEmpty) _plastics = response;
    var index = _plastics.isEmpty || plasticId == null ? -1 : _plastics.indexWhere((item) => item.id == plasticId);
    if (index >= 0) _plastic = _plastics[index];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var stackList = [_screenView(context), if (_loader) const PositionedLoader()];
    return Container(
      width: Dimensions.dialog_width,
      padding: EdgeInsets.symmetric(horizontal: Dimensions.dialog_padding, vertical: Dimensions.dialog_padding),
      decoration: BoxDecoration(color: primary, borderRadius: DIALOG_RADIUS, boxShadow: const [SHADOW_2]),
      child: Material(color: transparent, shape: DIALOG_SHAPE, child: Stack(children: stackList)),
    );
  }

  Widget _screenView(BuildContext context) {
    var wishlist = widget.wishlist;
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
            if (_plastics.isNotEmpty) ...[
              Text('plastic'.recast, style: TextStyles.text13_600.copyWith(color: lightBlue)),
              const SizedBox(height: 06),
              LabelPlaceholder(
                height: 40,
                background: lightBlue,
                textColor: dark,
                fontSize: 12,
                onTap: _onPlastic,
                hint: 'select_plastic',
                label: _plastic.name ?? '',
                endIcon: SvgImage(image: Assets.svg1.caret_down_1, height: 19, color: dark),
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
              suffixIcon: UnitSuffix(),
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
                          error: ErrorUploadImage(color: lightBlue, discImage: wishlist.userDisc?.media?.url),
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
        const SizedBox(height: 20),
        ElevateButton(
          radius: 04,
          height: 36,
          width: double.infinity,
          onTap: widget.isUpdateAndAdd ? _onSaveAndAddToWishlist : _onSave,
          label: widget.isUpdateAndAdd ? 'save_details_and_add_to_wishlist'.recast.toUpper : 'save_details'.recast.toUpper,
          textStyle: TextStyles.text14_700.copyWith(color: lightBlue, fontWeight: w600, height: 1.15),
        ),
        const SizedBox(height: 02),
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
    var invalidImage = _colorOrImage == 'image' && _discFile.file == null && widget.wishlist.userDisc?.media?.id == null;
    if (invalidImage) return FlushPopup.onWarning(message: 'please_add_your_disc_image'.recast);
    _onUpdateWishlistDisc();
  }

  void _onSaveAndAddToWishlist() {
    var invalidImage = _colorOrImage == 'image' && _discFile.file == null && widget.wishlist.userDisc?.media?.id == null;
    if (invalidImage) return FlushPopup.onWarning(message: 'please_add_your_disc_image'.recast);
    _onAddAndUpdateWishlistDisc();
  }

  Future<int?> _fetchMediaId() async {
    if (_discFile.file == null) return widget.wishlist.userDisc?.media?.id;
    var base64 = 'data:image/jpeg;base64,${_discFile.base64}';
    var mediaBody = {'section': 'disc', 'alt_texts': 'user_disc', 'type': 'image', 'image': base64};
    var response = await sl<UserRepository>().uploadBase64Media(mediaBody);
    return response?.id;
  }

  Future<void> _onUpdateWishlistDisc() async {
    setState(() => _loader = true);
    var mediaId = null as int?;
    var isMediaUpload = _colorOrImage == 'image';
    if (isMediaUpload) mediaId = await _fetchMediaId();
    if (isMediaUpload && mediaId == null) return setState(() => _loader = false);
    var body = _updateDiscBody;
    if (isMediaUpload) body.addAll({'media_id': mediaId});
    var response = await sl<DiscRepository>().updateWishlistDisc(body);
    if (response == null) return setState(() => _loader = false);
    if (widget.onSave != null) widget.onSave!(response, false);
    backToPrevious();
  }

  Future<void> _onAddAndUpdateWishlistDisc() async {
    setState(() => _loader = true);
    var mediaId = null as int?;
    var isMediaUpload = _colorOrImage == 'image';
    if (isMediaUpload) mediaId = await _fetchMediaId();
    if (isMediaUpload && mediaId == null) return setState(() => _loader = false);
    var body = _createDiscBody;
    if (isMediaUpload) body.addAll({'media_id': mediaId});
    var response = await sl<DiscRepository>().createWishlistWithUserDisc(body);
    if (response == null) return setState(() => _loader = false);
    if (widget.onSave != null) widget.onSave!(response, true);
    backToPrevious();
  }

  Map<String, dynamic> get _updateDiscBody {
    var userDisc = widget.wishlist.userDisc;
    var parentDisc = widget.wishlist.disc;
    var userDiscId = widget.wishlist.userDisc?.id;
    var isMediaUpload = _colorOrImage == 'image';
    var colorValue = _color.toARGB32().toRadixString(16).padLeft(8, '0').substring(2);
    return {
      'disc_id': parentDisc?.id,
      'weight': _weight.text,
      'speed': userDisc?.speed ?? parentDisc?.speed,
      'glide': userDisc?.glide ?? parentDisc?.glide,
      'turn': userDisc?.turn ?? parentDisc?.turn,
      'fade': userDisc?.fade ?? parentDisc?.fade,
      'disc_plastic_id': _plastic.id,
      'description': _comment.text,
      'wish_list_id': widget.wishlist.id,
      if (!isMediaUpload) 'color': colorValue,
      if (userDiscId != null) 'user_disc_id': userDiscId,
    };
  }

  Map<String, dynamic> get _createDiscBody {
    var userDisc = widget.wishlist.userDisc;
    var parentDisc = widget.wishlist.disc;
    var isMediaUpload = _colorOrImage == 'image';
    var colorValue = _color.toARGB32().toRadixString(16).padLeft(8, '0').substring(2);
    return {
      'disc_id': parentDisc?.id,
      'weight': _weight.text,
      'speed': userDisc?.speed ?? parentDisc?.speed,
      'glide': userDisc?.glide ?? parentDisc?.glide,
      'turn': userDisc?.turn ?? parentDisc?.turn,
      'fade': userDisc?.fade ?? parentDisc?.fade,
      'disc_plastic_id': _plastic.id,
      'description': _comment.text,
      if (!isMediaUpload) 'color': colorValue,
    };
  }
}
