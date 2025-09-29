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
    required this.homeWeeklyTitle,
    required this.homePlayWithFriends,
    required this.homePlayButton,
    required this.homeChangeCategory,
    required this.categoriesTitle,
    required this.categoriesSubtitle,
    required this.categoriesEmpty,
    required this.roundPlaceholderTitle,
    required this.roundPlaceholderSubtitle,
    required this.categorySelectedLabel,
    required this.categoryTitles,
  });

  final Locale locale;
  final String appTitle;
  final String resourcesLives;
  final String resourcesEnergy;
  final String resourcesGems;
  final String resourcesLevel;
  final String homeWeeklyTitle;
  final String homePlayWithFriends;
  final String homePlayButton;
  final String homeChangeCategory;
  final String categoriesTitle;
  final String categoriesSubtitle;
  final String categoriesEmpty;
  final String roundPlaceholderTitle;
  final String roundPlaceholderSubtitle;
  final String categorySelectedLabel;
  final Map<String, String> categoryTitles;

  String categoryTitle(String key) => categoryTitles[key] ?? key;

  static final Map<String, AppStrings> _lookup = <String, AppStrings>{
    'en': AppStrings(
      locale: const Locale('en'),
      appTitle: 'DataG',
      resourcesLives: 'Lives',
      resourcesEnergy: 'Energy',
      resourcesGems: 'Gems',
      resourcesLevel: 'Level',
      homeWeeklyTitle: 'Weekly challenge',
      homePlayWithFriends: 'Play with friends',
      homePlayButton: 'Play',
      homeChangeCategory: 'Change category',
      categoriesTitle: 'Categories',
      categoriesSubtitle: 'Pick your arena and keep the streak alive.',
      categoriesEmpty: 'Categories are not available right now.',
      roundPlaceholderTitle: 'Round in progress',
      roundPlaceholderSubtitle:
          'Gameplay arrives in the next milestone. For now enjoy the premium shell.',
      categorySelectedLabel: 'Selected',
      categoryTitles: const <String, String>{
        'cat_history': 'History',
        'cat_sport': 'Sport',
        'cat_movies': 'Movies',
        'cat_art': 'Art',
        'cat_games': 'Games',
        'cat_books': 'Books',
        'cat_world': 'World',
        'cat_tech': 'Technology',
        'cat_food': 'Cuisine',
        'cat_culture': 'Culture',
        'cat_fashion': 'Fashion',
      },
    ),
    'ru': AppStrings(
      locale: const Locale('ru'),
      appTitle: 'DataG',
      resourcesLives: 'Жизни',
      resourcesEnergy: 'Энергия',
      resourcesGems: 'Кристаллы',
      resourcesLevel: 'Уровень',
      homeWeeklyTitle: 'Еженедельный вызов',
      homePlayWithFriends: 'Играть с друзьями',
      homePlayButton: 'Играть',
      homeChangeCategory: 'Сменить категорию',
      categoriesTitle: 'Категории',
      categoriesSubtitle: 'Выбери свою арену и держи серию.',
      categoriesEmpty: 'Категории недоступны.',
      roundPlaceholderTitle: 'Раунд в разработке',
      roundPlaceholderSubtitle:
          'Игровая логика появится позже. Сейчас — премиальный каркас.',
      categorySelectedLabel: 'Выбрано',
      categoryTitles: const <String, String>{
        'cat_history': 'История',
        'cat_sport': 'Спорт',
        'cat_movies': 'Кино',
        'cat_art': 'Искусство',
        'cat_games': 'Игры',
        'cat_books': 'Книги',
        'cat_world': 'Мир',
        'cat_tech': 'Технологии',
        'cat_food': 'Кухня',
        'cat_culture': 'Культура',
        'cat_fashion': 'Мода',
      },
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
