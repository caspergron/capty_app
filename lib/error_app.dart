import 'package:flutter/material.dart';

import 'package:app/constants/app_constants.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/text_styles.dart';

class ErrorApp extends StatelessWidget {
  final FlutterErrorDetails errorDetails;
  const ErrorApp(this.errorDetails, {super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: APP_NAME,
      debugShowCheckedModeBanner: false,
      home: _ErrorAppScreen(errorMessage: errorDetails.exceptionAsString()),
    );
  }
}

class _ErrorAppScreen extends StatelessWidget {
  final String errorMessage;
  const _ErrorAppScreen({required this.errorMessage});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: orange,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: white, size: 40),
            const SizedBox(height: 04),
            Text('Error Occurred!', textAlign: TextAlign.center, style: TextStyles.text20_500.copyWith(color: white, fontSize: 18)),
            const SizedBox(height: 06),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(errorMessage, textAlign: TextAlign.center, style: TextStyles.text16_400.copyWith(color: white)),
            ),
          ],
        ),
      ),
    );
  }
}
