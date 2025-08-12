import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:app/components/buttons/elevate_button.dart';
import 'package:app/components/buttons/outline_button.dart';
import 'package:app/components/loaders/positioned_loader.dart';
import 'package:app/constants/app_keys.dart';
import 'package:app/di.dart';
import 'package:app/extensions/flutter_ext.dart';
import 'package:app/extensions/number_ext.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/helpers/file_helper.dart';
import 'package:app/libraries/flush_popup.dart';
import 'package:app/libraries/image_croppers.dart';
import 'package:app/libraries/image_pickers.dart';
import 'package:app/models/public/country.dart';
import 'package:app/models/system/doc_file.dart';
import 'package:app/preferences/app_preferences.dart';
import 'package:app/services/storage_service.dart';
import 'package:app/services/validators.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/fonts.dart';
import 'package:app/themes/text_styles.dart';
import 'package:app/utils/assets.dart';
import 'package:app/utils/dimensions.dart';
import 'package:app/utils/size_config.dart';
import 'package:app/widgets/core/circle_memory_image.dart';
import 'package:app/widgets/core/input_field.dart';
import 'package:app/widgets/core/pop_scope_navigator.dart';
import 'package:app/widgets/library/svg_image.dart';
import 'package:app/widgets/ui/phone_prefix.dart';

Future<void> socialAccountSetupSheet({required Map<String, String> params}) async {
  var context = navigatorKey.currentState!.context;
  var padding = MediaQuery.of(context).viewInsets;
  await showModalBottomSheet(
    context: context,
    isDismissible: false,
    enableDrag: false,
    shape: BOTTOM_SHEET_SHAPE,
    isScrollControlled: true,
    clipBehavior: Clip.antiAlias,
    builder: (builder) => Padding(padding: padding, child: PopScopeNavigator(canPop: false, child: _BottomSheetView(params))),
  );
}

class _BottomSheetView extends StatefulWidget {
  final Map<String, String> params;
  const _BottomSheetView(this.params);

  @override
  State<_BottomSheetView> createState() => _BottomSheetViewState();
}

class _BottomSheetViewState extends State<_BottomSheetView> {
  var _loader = false;
  var _docFile = DocFile();
  var _country = Country();
  var _name = TextEditingController();
  var _email = TextEditingController();
  var _phone = TextEditingController();
  var _focusNodes = [FocusNode(), FocusNode(), FocusNode()];

  @override
  void initState() {
    _fetchCountries();
    _focusNodes.forEach((item) => item.addListener(() => setState(() {})));
    super.initState();
  }

  Future<void> _fetchCountries() async {
    await AppPreferences.fetchCountries();
    _country = sl<StorageService>().user.country_item;
    _name.text = widget.params['name']!;
    _email.text = widget.params['email']!;
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var stackList = [_screenView(context), if (_loader) const PositionedLoader(radius: 20, background: white)];
    return SingleChildScrollView(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(color: primary, width: SizeConfig.width, child: Stack(children: stackList)),
    );
  }

  Widget _screenView(BuildContext context) {
    var desc = 'your_basic_information_helps_us_to_create_a_better_profile_for_you'.recast;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        ListView(
          shrinkWrap: true,
          clipBehavior: Clip.antiAlias,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          physics: const NeverScrollableScrollPhysics(),
          children: [
            Text('${'almost_there'.recast}! 🎉', style: TextStyles.text20_500.copyWith(color: lightBlue)),
            const SizedBox(height: 06),
            Text(desc, textAlign: TextAlign.start, style: TextStyles.text14_400.copyWith(fontSize: 15, color: lightBlue)),
          ],
        ),
        const SizedBox(height: 20),
        const Divider(),
        const SizedBox(height: 20),
        ListView(
          shrinkWrap: true,
          clipBehavior: Clip.antiAlias,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          physics: const NeverScrollableScrollPhysics(),
          children: [
            Center(child: Text('your_profile_image'.recast, style: TextStyles.text20_500.copyWith(color: lightBlue))),
            const SizedBox(height: 16),
            Center(
              child: CircleMemoryImage(
                radius: 16.5.width,
                image: _docFile.unit8List,
                errorWidget: Center(child: SvgImage(image: Assets.svg1.camera, color: mediumBlue, height: 70)),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlineButton(
                    height: 44,
                    background: transparent,
                    label: 'take_photo'.recast.toUpper,
                    onTap: _loader ? null : _pickImageFromCamera,
                    icon: SvgImage(image: Assets.svg1.camera, color: lightBlue, height: 22),
                    textStyle: TextStyles.text16_400.copyWith(color: lightBlue, fontWeight: w500, height: 1.3),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: ElevateButton(
                    height: 44,
                    background: lightBlue,
                    label: 'upload_photo'.recast.toUpper,
                    onTap: _loader ? null : _chooseImageFromGallery,
                    icon: SvgImage(image: Assets.svg1.image_square, color: primary, height: 22),
                    textStyle: TextStyles.text16_400.copyWith(color: primary, fontWeight: w500, height: 1.3),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),
            Text('your_name'.recast, style: TextStyles.text14_600.copyWith(color: lightBlue)),
            const SizedBox(height: 08),
            InputField(
              controller: _name,
              hintText: 'type_here'.recast,
              focusNode: _focusNodes[0],
              keyboardType: TextInputType.name,
              textInputAction: TextInputAction.next,
              textCapitalization: TextCapitalization.words,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              onFieldSubmitted: (value) => FocusScope.of(context).requestFocus(_focusNodes[1]),
            ),
            const SizedBox(height: 16),
            Text('your_email'.recast, style: TextStyles.text14_600.copyWith(color: lightBlue)),
            const SizedBox(height: 08),
            InputField(
              controller: _email,
              hintText: 'type_here'.recast,
              focusNode: _focusNodes[1],
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              onFieldSubmitted: (value) => FocusScope.of(context).requestFocus(_focusNodes[1]),
            ),
            const SizedBox(height: 16),
            Text('your_phone_number'.recast, style: TextStyles.text14_600.copyWith(color: lightBlue)),
            const SizedBox(height: 08),
            InputField(
              controller: _phone,
              hintText: 'XXX-XXX-XXXXX',
              focusNode: _focusNodes[2],
              keyboardType: TextInputType.phone,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              prefixIcon: PhonePrefix(country: _country, onChanged: (v) => setState(() => _country = v)),
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: ElevateButton(
                    height: 44,
                    background: lightBlue,
                    label: 'cancel'.recast.toUpper,
                    onTap: _loader ? null : backToPrevious,
                    textStyle: TextStyles.text16_400.copyWith(color: primary, fontWeight: w500, height: 1.3),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevateButton(
                    height: 44,
                    label: 'save_and_continue'.recast.toUpper,
                    onTap: _loader ? null : _onSaveAndContinue,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Future<void> _pickImageFromCamera() async {
    var file = await sl<ImagePickers>().imageFromCamera();
    if (file == null) return;
    var cropped = await sl<ImageCroppers>().cropImage(image: file, cropType: 'circle');
    if (cropped == null) return;
    setState(() => _loader = true);
    var docFiles = await sl<FileHelper>().renderFilesInModel([File(cropped.path)]);
    if (docFiles.haveList) setState(() => _docFile = docFiles.first);
    setState(() => _loader = false);
  }

  Future<void> _chooseImageFromGallery() async {
    var file = await sl<ImagePickers>().singleImageFromGallery();
    if (file == null) return;
    var cropped = await sl<ImageCroppers>().cropImage(image: file, cropType: 'circle');
    if (cropped == null) return;
    setState(() => _loader = true);
    var docFiles = await sl<FileHelper>().renderFilesInModel([File(cropped.path)]);
    if (docFiles.haveList) setState(() => _docFile = docFiles.first);
    setState(() => _loader = false);
  }

  Future<void> _onSaveAndContinue() async {
    minimizeKeyboard();
    var invalidName = sl<Validators>().name(_name.text);
    if (invalidName != null) return FlushPopup.onWarning(message: invalidName);
    var invalidEmail = sl<Validators>().email(_email.text);
    if (invalidEmail != null) return FlushPopup.onWarning(message: invalidEmail);
    if (_country.id == null) return FlushPopup.onWarning(message: 'please_select_your_country'.recast);
    var invalidPhone = sl<Validators>().email(_phone.text);
    if (invalidPhone != null) return FlushPopup.onWarning(message: invalidPhone);
    /*var provider = widget.credentials['provider']!;
    var providerKey = widget.credentials['providerKey']!;
    Map<String, String> body = {'name': _name.text, 'email': _email.text, 'provider': provider, 'providerKey': providerKey};
    var avatar = _docFile.file == null ? null : _docFile;
    setState(() => _loader = true);
    var response = await sl<AuthRepository>().socialSignup(body, avatar);
    if (response != null) {
      backToPrevious();
      unawaited(sl<Routes>().home().pushAndRemoveUntil());
    }
    setState(() => _loader = false);*/
  }
}
