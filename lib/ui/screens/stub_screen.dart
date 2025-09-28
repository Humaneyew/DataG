import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../components/app_top_bar.dart';
import '../components/locale_menu.dart';

class StubScreen extends StatelessWidget {
  const StubScreen({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppTopBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text(title),
        actions: const [LocaleMenu()],
      ),
      body: Center(
        child: Text(
          l.stubComingSoon(title),
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
