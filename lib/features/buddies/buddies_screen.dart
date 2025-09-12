import 'package:app/features/buddies/buddies_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BuddiesScreen extends StatefulWidget {
  @override
  State<BuddiesScreen> createState() => _BuddiesScreenState();
}

class _BuddiesScreenState extends State<BuddiesScreen> {
  var _viewModel = BuddiesViewModel();
  // var _modelData = BuddiesViewModel();

  @override
  void initState() {
    // sl<AppAnalytics>().screenView('chat-buddies-screen');
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => _viewModel.initViewModel());
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _viewModel = Provider.of<BuddiesViewModel>(context, listen: false);
    // _modelData = Provider.of<BuddiesViewModel>(context);
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
      body: Container(),
    );
  }
}
