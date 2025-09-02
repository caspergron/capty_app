import 'dart:async';

import 'package:app/components/buttons/elevate_button.dart';
import 'package:app/components/loaders/screen_loader.dart';
import 'package:app/components/menus/back_menu.dart';
import 'package:app/components/menus/prefix_menu.dart';
import 'package:app/components/menus/suffix_menu.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/features/address/view_models/add_address_view_model.dart';
import 'package:app/libraries/flush_popup.dart';
import 'package:app/models/address/address.dart';
import 'package:app/models/map/coordinates.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/fonts.dart';
import 'package:app/themes/gradients.dart';
import 'package:app/themes/shadows.dart';
import 'package:app/themes/text_styles.dart';
import 'package:app/utils/assets.dart';
import 'package:app/utils/size_config.dart';
import 'package:app/widgets/core/input_field.dart';
import 'package:app/widgets/library/map_address_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddAddressScreen extends StatefulWidget {
  final Address address;

  const AddAddressScreen({required this.address});

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  var _viewModel = AddAddressViewModel();
  var _modelData = AddAddressViewModel();
  var _search = TextEditingController();
  var _focusNode = FocusNode();
  var _isFirst = true;

  @override
  void initState() {
    // sl<AppAnalytics>().screenView('settings-screen');
    _focusNode.addListener(() => setState(() {}));
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => _viewModel.initViewModel(widget.address));
    if (widget.address.id != null) _search.text = widget.address.addressLine1 ?? '';
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _viewModel = Provider.of<AddAddressViewModel>(context, listen: false);
    _modelData = Provider.of<AddAddressViewModel>(context);
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
      body: Container(
        width: SizeConfig.width,
        height: SizeConfig.height,
        decoration: BoxDecoration(gradient: BACKGROUND_GRADIENT),
        child: Stack(children: [..._screenView(context), if (_modelData.loader) const ScreenLoader()]),
      ),
    );
  }

  List<Widget> _screenView(BuildContext context) {
    var icon = Assets.svg1.close_2;
    return [
      Positioned.fill(child: MapAddressPicker(coordinates: _modelData.centerLocation, onMoveCamera: _onCameraMove)),
      Positioned(left: 16, top: SizeConfig.statusBar + 12, child: const BackMenu()),
      Positioned(
        left: 20,
        right: 20,
        top: SizeConfig.statusBar + 54,
        child: Column(
          children: [
            InputField(
              prefixIcon: PrefixMenu(icon: Assets.svg1.search_2, isFocus: _focusNode.hasFocus),
              controller: _search,
              onTap: _viewModel.suggestions.clear,
              focusNode: _focusNode,
              hintText: 'Search address',
              suffixIcon: _search.text.isEmpty ? null : SuffixMenu(icon: icon, isFocus: _focusNode.hasFocus, onTap: _onClose),
              onChanged: (val) {
                var coordinates = Coordinates(lat: _viewModel.centerLocation.lat, lng: _viewModel.centerLocation.lng);
                val.length >= 4 ? _viewModel.fetchAddressPredictions(val, coordinates) : _viewModel.suggestions.clear();
                setState(() {});
              },
            ),
            if (_viewModel.suggestions.isNotEmpty) const SizedBox(height: 8),
            if (_viewModel.suggestions.isNotEmpty) _GooglePlacesList(suggestions: _modelData.suggestions, onTap: _onPlaceItem),
          ],
        ),
      ),
      if (_modelData.addressInfo != null)
        Positioned(
          left: 20,
          right: 20,
          bottom: 40,
          child: ElevateButton(
            radius: 04,
            height: 42,
            label: 'confirm'.recast.toUpper,
            onTap: () => _viewModel.onCreateOrUpdateAddress(widget.address),
            textStyle: TextStyles.text14_700.copyWith(color: lightBlue, fontWeight: w600, height: 1.15),
          ),
        ),
    ];
  }

  Future<void> _onCameraMove(Coordinates coordinates) async {
    setState(() => _viewModel.centerLocation = coordinates);
    var response = await _viewModel.fetchAddressInfoByCoordinates(coordinates);
    print(response);
    _search.text = '';
    // if (response == null) return;
    if (response == null) {
      if (_isFirst) return setState(() => _isFirst = false);
      return FlushPopup.onInfo(message: 'place_information_not_found'.recast);
    }
    _search.text = response['address'];
    FocusScope.of(context).unfocus();
    _viewModel.suggestions.clear();
    setState(() {});
  }

  void _onClose() {
    _search.clear();
    _viewModel.suggestions.clear();
    _viewModel.addressInfo = null;
    setState(() {});
  }

  Future<void> _onPlaceItem(int index) async {
    var placeId = _viewModel.suggestions[index]['place_id'];
    // FocusScope.of(context).unfocus();
    var response = await _viewModel.fetchAddressInfoByPlaceId(placeId);
    _search.text = '';
    // if (response == null) return;
    if (response == null) return FlushPopup.onInfo(message: 'place_information_not_found'.recast);
    var coordinates = response['coordinates'] as Coordinates;
    _viewModel.centerLocation = coordinates;
    _search.text = response['address'];
    FocusScope.of(context).unfocus();
    _viewModel.suggestions.clear();
    setState(() {});
  }
}

class _GooglePlacesList extends StatelessWidget {
  final List<dynamic> suggestions;
  final Function(int)? onTap;

  const _GooglePlacesList({this.suggestions = const [], this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(color: white, borderRadius: BorderRadius.circular(5), boxShadow: const [SHADOW_1]),
      child: _suggestionsList,
    );
  }

  Widget get _suggestionsList {
    return ListView.builder(
      shrinkWrap: true,
      clipBehavior: Clip.antiAlias,
      padding: EdgeInsets.zero,
      itemCount: suggestions.length,
      itemBuilder: _placeListItem,
    );
  }

  Widget _placeListItem(BuildContext context, int index) {
    var item = suggestions[index];
    var style = TextStyles.text14_400.copyWith(color: primary, height: 1);
    var label = Text(item['description'], maxLines: 2, overflow: TextOverflow.ellipsis, style: style);
    var icon = const Icon(Icons.location_on, size: 20, color: Colors.grey);
    return InkWell(
      onTap: () => onTap == null ? null : onTap!(index),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Row(children: [icon, const SizedBox(width: 10), Expanded(child: label)]),
      ),
    );
  }
}
