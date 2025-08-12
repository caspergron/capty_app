import 'dart:io';

import 'package:app/components/loaders/screen_loader.dart';
import 'package:app/components/menus/back_menu.dart';
import 'package:app/constants/app_strings.dart';
import 'package:app/themes/colors.dart';
import 'package:app/utils/size_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreen extends StatefulWidget {
  final String title;
  final String url;

  const WebViewScreen({required this.title, required this.url});

  @override
  _WebViewScreenState createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  var _loader = true;
  late WebViewController _controller;

  @override
  void initState() {
    // sl<AppAnalytics>().screenView('webview-screen');
    _initializeWebview();
    super.initState();
  }

  void _initializeWebview() {
    late final PlatformWebViewControllerCreationParams params;
    params = const PlatformWebViewControllerCreationParams();
    final controller = WebViewController.fromPlatformCreationParams(params);
    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(NavigationDelegate(onPageFinished: (url) => setState(() => _loader = false)))
      ..addJavaScriptChannel('Toaster', onMessageReceived: (message) {})
      ..loadRequest(Uri.parse(widget.url));
    setState(() => _controller = controller);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        centerTitle: true,
        leading: const BackMenu(),
        title: Text(widget.title),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        color: white,
        width: SizeConfig.width,
        height: SizeConfig.height,
        child: Stack(children: [WebViewWidget(controller: _controller), if (_loader) const ScreenLoader(background: white)]),
      ),
    );
  }
}

Future<void> checkUnusedTranslations() async {
  final usedKeys = <String>{};

  final dartFiles = Directory('lib').listSync(recursive: true).whereType<File>().where((f) => f.path.endsWith('.dart')).toList();

  for (final file in dartFiles) {
    final content = await file.readAsString();
    for (final key in APP_STRINGS.keys) {
      if (content.contains("'$key'") || content.contains('"$key"')) {
        usedKeys.add(key);
      }
    }
  }

  final unusedKeys = APP_STRINGS.keys.toSet().difference(usedKeys);

  if (kDebugMode) print('\n🔍 Scanned ${dartFiles.length} Dart files.');
  if (kDebugMode) print('✅ Used: ${usedKeys.length}');
  if (kDebugMode) print('🛑 Unused: ${unusedKeys.length}\n');

  if (unusedKeys.isNotEmpty) {
    if (kDebugMode) print('--- Unused translation keys ---');
    for (final key in unusedKeys) {
      if (kDebugMode) print('- $key');
    }
  } else {
    if (kDebugMode) print('🎉 All translation keys are used!');
  }
}
