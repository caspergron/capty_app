import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:app/components/buttons/elevate_button.dart';
import 'package:app/components/loaders/screen_loader.dart';
import 'package:app/components/menus/back_menu.dart';
import 'package:app/di.dart';
import 'package:app/extensions/flutter_ext.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/features/friends/view_models/add_friend_view_model.dart';
import 'package:app/libraries/flush_popup.dart';
import 'package:app/services/validators.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/gradients.dart';
import 'package:app/themes/text_styles.dart';
import 'package:app/utils/dimensions.dart';
import 'package:app/utils/size_config.dart';
import 'package:app/widgets/core/input_field.dart';
import 'package:app/widgets/ui/nav_button_box.dart';
import 'package:app/widgets/ui/phone_prefix.dart';

class AddFriendScreen extends StatefulWidget {
  @override
  State<AddFriendScreen> createState() => _AddFriendScreenState();
}

class _AddFriendScreenState extends State<AddFriendScreen> {
  var _viewModel = AddFriendViewModel();
  var _modelData = AddFriendViewModel();
  var _phone = TextEditingController();
  var _pgdaNUmber = TextEditingController();
  var _focusNodes = [FocusNode(), FocusNode()];
  var _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // sl<AppAnalytics>().screenView('add-friend-screen');
    _focusNodes.forEach((item) => item.addListener(() => setState(() {})));
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => _viewModel.initViewModel());
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _viewModel = Provider.of<AddFriendViewModel>(context, listen: false);
    _modelData = Provider.of<AddFriendViewModel>(context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _viewModel.disposeViewModel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        leading: const BackMenu(),
        title: Text('add_your_friend'.recast),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        width: SizeConfig.width,
        height: SizeConfig.height,
        decoration: BoxDecoration(gradient: BACKGROUND_GRADIENT),
        child: Stack(children: [_screenView(context), if (_modelData.loader) const ScreenLoader()]),
      ),
      bottomNavigationBar: NavButtonBox(
        loader: _modelData.loader,
        childHeight: 42,
        child: ElevateButton(radius: 04, height: 42, label: 'add_friend'.recast.toUpper, onTap: _onAddFriend),
      ),
    );
  }

  void _clearStates() {
    _pgdaNUmber.clear();
    _phone.clear();
    setState(() {});
  }

  Future<void> _onAddFriend() async {
    final isEmpty = _pgdaNUmber.text.isEmpty && _phone.text.isEmpty;
    if (isEmpty) return FlushPopup.onWarning(message: 'please_write_the_pgda_number_or_phone_number_of_your_friend'.recast);
    if (_phone.text.isNotEmpty) {
      if (_modelData.country.id == null) return FlushPopup.onWarning(message: 'please_select_the_country_of_your_friend'.recast);
      final invalidPhone = sl<Validators>().phone(_phone.text, _modelData.country);
      if (invalidPhone != null) return FlushPopup.onWarning(message: invalidPhone);
    }
    final query = _pgdaNUmber.text.isEmpty ? '${_modelData.country.phonePrefix}${_phone.text}' : _pgdaNUmber.text;
    final response = await _viewModel.onAddFriend(query);
    if (response) _clearStates();
  }

  Widget _screenView(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      clipBehavior: Clip.antiAlias,
      padding: EdgeInsets.symmetric(horizontal: Dimensions.screen_padding),
      physics: const BouncingScrollPhysics(),
      children: [
        const SizedBox(height: 16),
        Text(
          'please_let_us_know_your_friend_pgda_number'.recast,
          textAlign: TextAlign.start,
          style: TextStyles.text14_600.copyWith(color: primary),
        ),
        const SizedBox(height: 24),
        Text('your_friends_pdga_number'.recast, style: TextStyles.text14_600.copyWith(color: dark)),
        const SizedBox(height: 06),
        InputField(
          fontSize: 12,
          controller: _pgdaNUmber,
          hintText: '${'ex'.recast}: 125',
          focusNode: _focusNodes.first,
          keyboardType: TextInputType.number,
          enabledBorder: lightBlue,
          focusedBorder: lightBlue,
          onChanged: (v) => setState(() => _phone.clear()),
          borderRadius: BorderRadius.circular(04),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(child: Container(height: 0.5, color: primary.colorOpacity(0.8))),
            const SizedBox(width: 24),
            Text('or'.recast.toUpper, style: TextStyles.text14_600.copyWith(color: primary, height: 1)),
            const SizedBox(width: 24),
            Expanded(child: Container(height: 0.5, color: primary.colorOpacity(0.8))),
          ],
        ),
        const SizedBox(height: 20),
        Text('your_friends_phone_number'.recast, style: TextStyles.text14_600.copyWith(color: dark)),
        const SizedBox(height: 06),
        InputField(
          controller: _phone,
          enabledBorder: lightBlue,
          focusedBorder: lightBlue,
          hintText: 'XXX-XXX-XXXXX',
          focusNode: _focusNodes.last,
          keyboardType: TextInputType.phone,
          onChanged: (v) => setState(() => _pgdaNUmber.clear()),
          borderRadius: BorderRadius.circular(04),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          prefixIcon: PhonePrefix(country: _modelData.country, onChanged: (v) => setState(() => _modelData.country = v)),
        ),
      ],
    );
  }
}
