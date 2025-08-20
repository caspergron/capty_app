import 'package:app/components/loaders/screen_loader.dart';
import 'package:app/components/menus/back_menu.dart';
import 'package:app/extensions/number_ext.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/features/discs/units/parent_disc_category_list.dart';
import 'package:app/features/player/view_models/tournament_discs_view_model.dart';
import 'package:app/models/user/user.dart';
import 'package:app/preferences/user_preferences.dart';
import 'package:app/themes/gradients.dart';
import 'package:app/utils/dimensions.dart';
import 'package:app/utils/size_config.dart';
import 'package:app/widgets/exception/no_disc_found.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TournamentBagScreen extends StatefulWidget {
  final User player;
  const TournamentBagScreen({required this.player});

  @override
  State<TournamentBagScreen> createState() => _TournamentBagScreenState();
}

class _TournamentBagScreenState extends State<TournamentBagScreen> {
  var _viewModel = TournamentDiscsViewModel();
  var _modelData = TournamentDiscsViewModel();

  @override
  void initState() {
    // sl<AppAnalytics>().screenView('tournament-discs-screen');
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => _viewModel.initViewModel(widget.player));
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _viewModel = Provider.of<TournamentDiscsViewModel>(context, listen: false);
    _modelData = Provider.of<TournamentDiscsViewModel>(context);
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
      appBar: AppBar(
        centerTitle: true,
        leading: const BackMenu(),
        title: Text('${widget.player.first_name}${'extra_s'.recast} ${'tournament_discs'.recast}'),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        width: SizeConfig.width,
        height: SizeConfig.height,
        alignment: Alignment.topCenter,
        decoration: BoxDecoration(gradient: BACKGROUND_GRADIENT),
        child: Stack(children: [_screenView, if (_modelData.loader.loader) const ScreenLoader()]),
      ),
    );
  }

  Widget get _screenView {
    if (_modelData.loader.initial) return const SizedBox.shrink();
    var isMe = widget.player.id != null && widget.player.id == UserPreferences.user.id;
    var name = isMe ? '' : (widget.player.first_name.isEmpty ? 'this_player'.recast : widget.player.first_name);
    var label = 'no_tournament_discs_found';
    var description = isMe ? 'you_have_no_disc_in_your_tournament_bag_please_add_your_disc' : 'has_no_disc_in_the_tournament_bag';
    if (_modelData.categories.isEmpty) return NoDiscFound(height: 10.height, label: label, description: description, name: name);
    return ListView(
      padding: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      physics: const BouncingScrollPhysics(),
      children: [
        const SizedBox(height: 12),
        ParentDiscCategoryList(categories: _modelData.categories),
        SizedBox(height: BOTTOM_GAP),
      ],
    );
    // onItem: (item, index) => _viewModel.onDiscItem(item, index),
  }
}
