import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../state/locale_controller.dart';
import '../tokens.dart';

class LocaleMenu extends ConsumerWidget {
  const LocaleMenu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final current = ref.watch(localeControllerProvider);
    final controller = ref.read(localeControllerProvider.notifier);
    final supported = AppLocalizations.supportedLocales;

    return PopupMenuButton<Locale>(
      icon: const Icon(
        LucideIcons.languages,
        size: 20,
        color: AppColors.textSecondary,
      ),
      tooltip: l.localeMenuTooltip,
      onSelected: controller.setLocale,
      itemBuilder: (context) {
        return supported
            .map(
              (locale) => CheckedPopupMenuItem<Locale>(
                value: locale,
                checked: locale.languageCode == current.languageCode,
                child: Text(_labelFor(locale, l)),
              ),
            )
            .toList();
      },
    );
  }

  String _labelFor(Locale locale, AppLocalizations l) {
    switch (locale.languageCode) {
      case 'uk':
        return l.localeUkrainian;
      case 'ru':
        return l.localeRussian;
      case 'en':
      default:
        return l.localeEnglish;
    }
  }
}
