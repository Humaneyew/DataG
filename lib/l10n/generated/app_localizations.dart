import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class AppLocalizations {
  AppLocalizations(this.locale) : localeName = locale.languageCode;

  final Locale locale;
  final String localeName;

  static AppLocalizations? of(BuildContext context) =>
      Localizations.of<AppLocalizations>(context, AppLocalizations);

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];

  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ru'),
    Locale('uk'),
  ];

  String get appTitle => _select(
        en: 'Date Guesser',
        ru: 'Угадай дату',
        uk: 'DataG Вікторина',
      );

  String get homeTitle => _select(
        en: 'Pick a challenge',
        ru: 'Выберите испытание',
        uk: 'DataG Вікторина',
      );

  String get homeWeeklyChallengeTitle => _select(
        en: 'Weekly challenge',
        ru: 'Еженедельный вызов',
        uk: 'Тиждень X',
      );

  String get homeStubEventTitle => _select(
        en: 'Weekly challenge',
        ru: 'Еженедельный вызов',
        uk: 'Подія',
      );

  String get homePlayWithFriends => _select(
        en: 'Play with friends',
        ru: 'Играть с друзьями',
        uk: 'Грай з друзями',
      );

  String get homeStubFriendsTitle => _select(
        en: 'Play with friends',
        ru: 'Играть с друзьями',
        uk: 'Друзі',
      );

  String get homePlayButton => _select(
        en: 'Play',
        ru: 'Играть',
        uk: 'Грати',
      );

  String get homeChangeCategory => _select(
        en: 'Change category',
        ru: 'Сменить категорию',
        uk: 'Змінити категорію',
      );

  String get categoriesTitle => _select(
        en: 'Categories',
        ru: 'Категории',
        uk: 'Категорії',
      );

  String get categoriesEmpty => _select(
        en: 'Categories are not available right now.',
        ru: 'Категории недоступны.',
        uk: 'Категорії поки недоступні.',
      );

  String get categoriesBack => _select(
        en: 'Back to home',
        ru: 'Назад на главный экран',
        uk: 'Назад',
      );

  String get roundDetailsComingSoon => _select(
        en: 'More details coming soon.',
        ru: 'Скоро появятся подробности.',
        uk: 'Екран з подробицями з\'явиться пізніше.',
      );

  String get roundTitleFallback => _select(
        en: 'Round',
        ru: 'Раунд',
        uk: 'Раунд',
      );

  String get roundNoQuestions => _select(
        en: 'No questions available yet.',
        ru: 'Вопросов пока нет.',
        uk: 'Немає доступних запитань для цієї категорії.',
      );

  String get roundSubmit => _select(
        en: 'Submit answer',
        ru: 'Ответить',
        uk: 'Перевірити відповідь',
      );

  String roundHintAB(int cost) => _select(
        en: '50/50 (−$cost)',
        ru: '50/50 (−$cost)',
        uk: 'A/B (-$cost)',
      );

  String roundHintLast(int cost) => _select(
        en: 'Last digits (−$cost)',
        ru: 'Последние цифры (−$cost)',
        uk: 'Останні цифри (-$cost)',
      );

  String roundHintNarrow(int cost) => _select(
        en: 'Narrow timeline (−$cost)',
        ru: 'Сузить шкалу (−$cost)',
        uk: 'Звузити (-$cost)',
      );

  String roundLastDigitsHint(String digits) => _select(
        en: 'Last digits: $digits',
        ru: 'Последние цифры: $digits',
        uk: 'Закінчується на $digits',
      );

  String get localeMenuTooltip => _select(
        en: 'Change language',
        ru: 'Сменить язык',
        uk: 'Змінити мову',
      );

  String get localeEnglish => _select(
        en: 'English',
        ru: 'Английский',
        uk: 'Англійська',
      );

  String get localeRussian => _select(
        en: 'Russian',
        ru: 'Русский',
        uk: 'Російська',
      );

  String get localeUkrainian => _select(
        en: 'Ukrainian',
        ru: 'Украинский',
        uk: 'Українська',
      );

  String resultYourAnswer(int year, String era) => _select(
        en: 'Your answer: $year ($era)',
        ru: 'Ваш ответ: $year ($era)',
        uk: 'Твоя відповідь: $year $era',
      );

  String resultCorrectAnswer(int year, String era) => _select(
        en: 'Correct answer: $year ($era)',
        ru: 'Правильный ответ: $year ($era)',
        uk: 'Правильна відповідь: $year $era',
      );

  String resultBaseScore(int score) => _select(
        en: 'Base score: $score',
        ru: 'Базовые очки: $score',
        uk: 'Базові очки: $score',
      );

  String resultBonus(String bonus) => _select(
        en: 'Bonus: $bonus',
        ru: 'Бонус: $bonus',
        uk: 'Бонуси: $bonus',
      );

  String resultHintPenalty(int value) => _select(
        en: 'Hint penalty: -$value',
        ru: 'Штраф за подсказки: -$value',
        uk: 'Штраф за підказки: -$value',
      );

  String resultQuestionPoints(String points) => _select(
        en: 'Question points: $points',
        ru: 'Очки за вопрос: $points',
        uk: 'Очки за запитання: $points',
      );

  String resultHintsPrefix(String hints) => _select(
        en: 'Hints used: $hints',
        ru: 'Использованы подсказки: $hints',
        uk: 'Підказки: $hints',
      );

  String get resultNoHints => _select(
        en: 'No hints used',
        ru: 'Без подсказок',
        uk: 'Без підказок',
      );

  String get resultPerfect => _select(
        en: 'Perfect!',
        ru: 'Идеально!',
        uk: 'Точне влучання!',
      );

  String resultMissedBy(int delta) {
    switch (localeName) {
      case 'ru':
        return 'Промах на $delta лет';
      case 'uk':
        return 'Похибка ${_ukYears(delta)}';
      default:
        return 'Missed by $delta years';
    }
  }

  String resultStreak(int streak) {
    switch (localeName) {
      case 'ru':
        return 'Серия: $streak';
      case 'uk':
        return 'Серія $streak: множник 1,5×!';
      default:
        return 'Streak bonus: $streak';
    }
  }

  String get resultFinish => _select(
        en: 'Finish',
        ru: 'Завершить',
        uk: 'Завершити',
      );

  String get resultNext => _select(
        en: 'Next question',
        ru: 'Следующий вопрос',
        uk: 'Далі',
      );

  String get resultDetails => _select(
        en: 'Details',
        ru: 'Подробнее',
        uk: 'Докладніше',
      );

  String get summaryTitle => _select(
        en: 'Summary',
        ru: 'Итоги',
        uk: 'Підсумки',
      );

  String get summaryHeader => _select(
        en: "Here's how you did",
        ru: 'Ваши результаты',
        uk: 'Раунд завершено!',
      );

  String summaryPoints(int points) => _select(
        en: '$points pts',
        ru: '$points очков',
        uk: '$points очок',
      );

  String summaryAccuracy(String value) => _select(
        en: 'Accuracy: $value',
        ru: 'Точность: $value',
        uk: 'Влучання ≤5 років: $value',
      );

  String summaryAccuracyValue(int hits, int total) => _select(
        en: '$hits / $total correct',
        ru: '$hits из $total',
        uk: '$hits з $total',
      );

  String summaryAverageDelta(String value) => _select(
        en: 'Average miss: $value years',
        ru: 'Среднее отклонение: $value лет',
        uk: 'Середня похибка: $value',
      );

  String summaryBestStreak(int streak) => _select(
        en: 'Best streak: $streak',
        ru: 'Лучшая серия: $streak',
        uk: 'Найкраща серія: $streak',
      );

  String get summaryPlayAgain => _select(
        en: 'Play again',
        ru: 'Сыграть ещё',
        uk: 'Грати ще',
      );

  String get summaryHome => _select(
        en: 'Back to home',
        ru: 'На главный экран',
        uk: 'Додому',
      );

  String get summaryNoValue => '—';

  String get hintLabelLastDigits => _select(
        en: 'Last digits',
        ru: 'Последние цифры',
        uk: 'Останні цифри',
      );

  String get hintLabelAB => _select(
        en: '50/50',
        ru: '50/50',
        uk: 'A/B',
      );

  String get hintLabelNarrow => _select(
        en: 'Narrow timeline',
        ru: 'Сузить шкалу',
        uk: 'Звузити',
      );

  String stubComingSoon(String title) => _select(
        en: '"$title" is coming soon!',
        ru: 'Раздел «$title» скоро появится!',
        uk: 'Екран «$title» з\'явиться пізніше',
      );

  String get stubSoundToggle => _select(
        en: 'Sound effects',
        ru: 'Звуки',
        uk: 'Звукові ефекти',
      );

  String get stubHapticsToggle => _select(
        en: 'Haptic feedback',
        ru: 'Виброотклик',
        uk: 'Вібровідгук',
      );

  String _select({
    required String en,
    String? ru,
    String? uk,
  }) {
    switch (localeName) {
      case 'ru':
        return ru ?? en;
      case 'uk':
        return uk ?? en;
      default:
        return en;
    }
  }

  String _ukYears(int value) {
    final absValue = value.abs();
    final mod10 = absValue % 10;
    final mod100 = absValue % 100;
    if (mod10 == 1 && mod100 != 11) {
      return '$value рік';
    }
    if (mod10 >= 2 && mod10 <= 4 && (mod100 < 12 || mod100 > 14)) {
      return '$value роки';
    }
    return '$value років';
  }
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return AppLocalizations.supportedLocales
        .any((supported) => supported.languageCode == locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(AppLocalizations(locale));
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) =>
      false;
}
