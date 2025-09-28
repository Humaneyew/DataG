import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await runZonedGuarded(() async {
    runApp(const ProviderScope(child: DataGApp()));
  }, (error, stack) {
    if (kDebugMode) {
      debugPrint('Unhandled exception: $error');
      debugPrint('$stack');
    }
  });
}
