import 'dart:async';
import 'dart:io';

import 'package:app/components/buttons/elevate_button.dart';
import 'package:app/components/dialogs/image_rotate_dialog.dart';
import 'package:app/components/loaders/screen_loader.dart';
import 'package:app/components/menus/back_menu.dart';
import 'package:app/components/sheets/image_option_sheet.dart';
import 'package:app/di.dart';
import 'package:app/extensions/flutter_ext.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/features/discs/components/disc_request_sent_dialog.dart';
import 'package:app/helpers/file_helper.dart';
import 'package:app/libraries/flush_popup.dart';
import 'package:app/models/system/doc_file.dart';
import 'package:app/repository/disc_repo.dart';
import 'package:app/repository/user_repo.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/fonts.dart';
import 'package:app/themes/gradients.dart';
import 'package:app/themes/text_styles.dart';
import 'package:app/utils/dimensions.dart';
import 'package:app/utils/reg_exps.dart';
import 'package:app/utils/size_config.dart';
import 'package:app/widgets/core/input_field.dart';
import 'package:app/widgets/core/memory_image.dart';
import 'package:app/widgets/exception/error_upload_image.dart';
import 'package:app/widgets/ui/nav_button_box.dart';
import 'package:flutter/material.dart';

class RequestDiscScreen extends StatefulWidget {
  @override
  State<RequestDiscScreen> createState() => _RequestDiscScreenState();
}

class _RequestDiscScreenState extends State<RequestDiscScreen> {
  var _loader = false;
  var _name = TextEditingController();
  var _brand = TextEditingController();
  var _link = TextEditingController();
  var _docFile = DocFile();
  var _focusNodes = [FocusNode(), FocusNode(), FocusNode()];

  @override
  void initState() {
    _focusNodes.forEach((item) => item.addListener(() => setState(() {})));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: const BackMenu(),
        title: Text('request_a_disc'.recast),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        width: SizeConfig.width,
        height: SizeConfig.height,
        decoration: BoxDecoration(gradient: BACKGROUND_GRADIENT),
        child: Stack(children: [_screenView(context), if (_loader) const ScreenLoader()]),
      ),
      bottomNavigationBar: NavButtonBox(childHeight: 42, loader: _loader, child: _navbarAction),
    );
  }

  Widget get _navbarAction {
    var label = 'send_request'.recast.toUpper;
    var style = TextStyles.text14_700.copyWith(color: white, fontWeight: w600, height: 1.15);
    return ElevateButton(radius: 04, height: 42, label: label, loader: _loader, textStyle: style, onTap: _onSendRequest);
  }

  Widget _screenView(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      clipBehavior: Clip.antiAlias,
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: Dimensions.screen_padding),
      children: [
        const SizedBox(height: 14),
        Text('Please give us some info about the discs', style: TextStyles.text14_600.copyWith(color: primary)),
        const SizedBox(height: 12),
        Text('Disc Name', style: TextStyles.text12_600.copyWith(color: primary)),
        const SizedBox(height: 04),
        InputField(
          hintColor: primary,
          controller: _name,
          fillColor: transparent,
          focusNode: _focusNodes[0],
          keyboardType: TextInputType.name,
          textInputAction: TextInputAction.next,
          hintText: 'write_the_name_of_your_disc'.recast,
          onFieldSubmitted: (value) => FocusScope.of(context).requestFocus(_focusNodes[1]),
        ),
        const SizedBox(height: 16),
        Text('Brand', style: TextStyles.text12_600.copyWith(color: primary)),
        const SizedBox(height: 04),
        InputField(
          hintColor: primary,
          controller: _brand,
          fillColor: transparent,
          focusNode: _focusNodes[1],
          keyboardType: TextInputType.name,
          textInputAction: TextInputAction.next,
          hintText: 'write_the_brand_name_of_your_disc'.recast,
          onFieldSubmitted: (value) => FocusScope.of(context).requestFocus(_focusNodes[2]),
        ),
        const SizedBox(height: 16),
        Text('Online link of the disc', style: TextStyles.text12_600.copyWith(color: primary)),
        const SizedBox(height: 04),
        InputField(
          hintColor: primary,
          controller: _link,
          fillColor: transparent,
          focusNode: _focusNodes[2],
          hintText: 'write_the_web_link_of_your_disc'.recast,
        ),
        const SizedBox(height: 16),
        Text('Image of the disc', style: TextStyles.text12_600.copyWith(color: primary)),
        const SizedBox(height: 05),
        Align(
          alignment: Alignment.centerLeft,
          child: ImageMemory(
            radius: 04,
            width: 86,
            height: 86,
            color: dark.colorOpacity(0.15),
            error: const ErrorUploadImage(),
            imagePath: _docFile.unit8List,
            onTap: () => imageOptionSheet(onFile: _onImage, cropType: 'circle_clip'),
          ),
        )
      ],
    );
  }

  Future<void> _onImage(File fileImage) async {
    setState(() => _loader = true);
    var docFiles = await sl<FileHelper>().renderFilesInModel([fileImage]);
    if (docFiles.isEmpty) return setState(() => _loader = false);
    _docFile = docFiles.first;
    if (_docFile.unit8List == null) return setState(() => _loader = false);
    if (Platform.isIOS) await imageRotateDialog(file: _docFile.file!, onChanged: (v) => setState(() => _docFile = v));
    setState(() => _loader = false);
    // unawaited(discCropperDialog(file: file, onChanged: (v) => setState(() => _docFile = v)));
  }

  Future<void> _onSendRequest() async {
    if (_name.text.isEmpty) return FlushPopup.onWarning(message: 'please_write_the_name_of_your_disc'.recast);
    if (_brand.text.isEmpty) return FlushPopup.onWarning(message: 'please_write_the_brand_name_of_your_disc'.recast);
    if (_link.text.isEmpty) return FlushPopup.onWarning(message: 'please_write_the_web_link_of_your_disc'.recast);
    var isValidLink = sl<RegExps>().urlRegExp.hasMatch(_link.text);
    if (!isValidLink) return FlushPopup.onWarning(message: 'please_add_a_valid_link'.recast);
    if (_docFile.unit8List == null) return FlushPopup.onWarning(message: 'please_upload_your_disc_image'.recast);
    var base64 = 'data:image/jpeg;base64,${_docFile.base64}';
    var mediaBody = {'section': 'disc_request', 'alt_texts': 'user_request_disc', 'type': 'image', 'image': base64};
    setState(() => _loader = true);
    var mediaResponse = await sl<UserRepository>().uploadBase64Media(mediaBody);
    if (mediaResponse == null) return setState(() => _loader = false);
    var body = {'name': _name.text, 'brand_name': _brand.text, 'online_link': _link.text, 'media_id': mediaResponse.id};
    var response = await sl<DiscRepository>().requestDisc(body);
    if (!response) return setState(() => _loader = false);
    unawaited(discRequestSentDialog());
    setState(() => _loader = false);
  }
}
