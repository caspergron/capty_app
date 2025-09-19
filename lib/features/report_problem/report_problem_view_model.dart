import 'dart:async';

import 'package:flutter/foundation.dart';

import 'package:app/di.dart';
import 'package:app/repository/pref_repo.dart';

class ReportProblemViewModel with ChangeNotifier {
  var loader = false;

  void initViewModel() {}

  void disposeViewModel() => loader = false;

  Future<bool> onSendReport({required String title, required String description}) async {
    loader = true;
    notifyListeners();
    final body = {'title': title, 'description': description};
    final response = await sl<PreferencesRepository>().createReport(body);
    loader = false;
    notifyListeners();
    return response != null;
  }

  /*Future<void> extractAllUsedTranslationKeys() async {
    final keysList = APP_STRINGS.keys.toList();
    final buffer = StringBuffer();

    for (final i = 0; i < keysList.length; i++) {
      buffer.write("'${keysList[i]}'");
      if (i != keysList.length - 1) {
        buffer.write(", ");
      }
      if ((i + 1) % 4 == 0 && i != keysList.length - 1) {
        buffer.writeln();
      }
    }
    log(buffer.toString());

  }*/

  /*Future<void> checkUnusedTranslations() async {
    // last unused strings: today, yesterday, flight_numbers
    final usedKeys = <String>{};
    const projectDir = '/Users/md.tanviranwarrafi/RafiTanvir/candy/capty/lib';
    final libDir = Directory(projectDir);

    if (!await libDir.exists()) {
      if (kDebugMode) print('❌ Error: lib/ directory not found at: ${libDir.path}');
      return;
    }

    final dartFiles = libDir.listSync(recursive: true).whereType<File>().where((file) => file.path.endsWith('.dart')).toList();

    for (final file in dartFiles) {
      final content = await file.readAsString();
      for (final key in APP_STRINGS.keys) {
        final pattern = RegExp("['\"]${RegExp.escape(key)}['\"]\\.recast");
        if (pattern.hasMatch(content)) {
          usedKeys.add(key);
        }
      }
    }

    final unusedKeys = APP_STRINGS.keys.toSet().difference(usedKeys);
    if (kDebugMode) print('🛑 Total Translations: ${APP_STRINGS.length}\n');
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
  }*/
}
