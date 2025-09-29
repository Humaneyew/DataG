import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'locale_controller.dart';

class AppStrings {
  const AppStrings({
    required this.locale,
    required this.appTitle,
    required this.resourcesLives,
    required this.resourcesEnergy,
    required this.resourcesGems,
    required this.resourcesLevel,
    required this.homeHeadline,
    required this.homeSubheading,
    required this.homePrimaryAction,
    required this.homeSecondaryAction,
    required this.categoriesTitle,
    required this.roundPlaceholderTitle,
    required this.roundPlaceholderSubtitle,
    required this.weeklyBadge,
    required this.modesBadge,
  });

  final Locale locale;
  final String appTitle;
  final String resourcesLives;
  final String resourcesEnergy;
  final String resourcesGems;
  final String resourcesLevel;
  final String homeHeadline;
  final String homeSubheading;
  final String homePrimaryAction;
  final String homeSecondaryAction;
  final String categoriesTitle;
  final String roundPlaceholderTitle;
  final String roundPlaceholderSubtitle;
  final String weeklyBadge;
  final String modesBadge;

  static final Map<String, AppStrings> _lookup = <String, AppStrings>{
    'en': AppStrings(
      locale: const Locale('en'),
      appTitle: 'DataG',
      resourcesLives: 'Lives',
      resourcesEnergy: 'Energy',
      resourcesGems: 'Gems',
      resourcesLevel: 'Level',
      homeHeadline: 'Master the world of knowledge',
      homeSubheading: 'Select a category, choose a mode, and rise through the ranks.',
      homePrimaryAction: 'Start round',
      homeSecondaryAction: 'Browse categories',
      categoriesTitle: 'Pick your realm',
      roundPlaceholderTitle: 'Round in progress',
      roundPlaceholderSubtitle: 'Gameplay arrives in the next milestone. For now enjoy the premium shell.',
      weeklyBadge: 'Weekly',
      modesBadge: 'Modes',
    ),
    'ru': AppStrings(
      locale: const Locale('ru'),
      appTitle: 'DataG',
      resourcesLives: 'Жизни',
      resourcesEnergy: 'Энергия',
      resourcesGems: 'Кристаллы',
      resourcesLevel: 'Уровень',
      homeHeadline: 'Покоряй мир знаний',
      homeSubheading: 'Выбери категорию, настрой режим и продвигайся по лигам.',
      homePrimaryAction: 'Начать раунд',
      homeSecondaryAction: 'Категории',
      categoriesTitle: 'Выбери мир',
      roundPlaceholderTitle: 'Раунд в разработке',
      roundPlaceholderSubtitle: 'Игровая логика появится позже. Сейчас — премиальный каркас.',
      weeklyBadge: 'Неделя',
      modesBadge: 'Режимы',
    ),
  };

  static AppStrings resolve(Locale locale) {
    final languageCode = locale.languageCode.toLowerCase();
    return _lookup[languageCode] ?? _lookup['en']!;
  }

  static List<Locale> get supportedLocales =>
      _lookup.values.map((strings) => strings.locale).toList(growable: false);
}

final stringsProvider = Provider<AppStrings>((ref) {
  final locale = ref.watch(localeControllerProvider);
  return AppStrings.resolve(locale);
});
