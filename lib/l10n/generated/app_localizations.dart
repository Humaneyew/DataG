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
  ];

  String get appTitle => _select(
        en: 'Date Guesser',
        ru: 'Угадай дату',
      );

  String get homeTitle => _select(
        en: 'Pick a challenge',
        ru: 'Выберите испытание',
      );

  String get homeWeeklyChallengeTitle => _select(
        en: 'Weekly challenge',
        ru: 'Еженедельный вызов',
      );

  String get homeStubEventTitle => _select(
        en: 'Weekly challenge',
        ru: 'Еженедельный вызов',
      );

  String get homePlayWithFriends => _select(
        en: 'Play with friends',
        ru: 'Играть с друзьями',
      );

  String get homeStubFriendsTitle => _select(
        en: 'Play with friends',
        ru: 'Играть с друзьями',
      );

  String get homePlayButton => _select(
        en: 'Play',
        ru: 'Играть',
      );

  String get homeChangeCategory => _select(
        en: 'Change category',
        ru: 'Сменить категорию',
      );

  String get categoriesTitle => _select(
        en: 'Categories',
        ru: 'Категории',
      );

  String get categoriesEmpty => _select(
        en: 'Categories are not available right now.',
        ru: 'Категории недоступны.',
      );

  String get categoriesBack => _select(
        en: 'Back to home',
        ru: 'Назад на главный экран',
      );

  String get roundDetailsComingSoon => _select(
        en: 'More details coming soon.',
        ru: 'Скоро появятся подробности.',
      );

  String get roundTitleFallback => _select(
        en: 'Round',
        ru: 'Раунд',
      );

  String get roundNoQuestions => _select(
        en: 'No questions available yet.',
        ru: 'Вопросов пока нет.',
      );

  String get roundSubmit => _select(
        en: 'Submit answer',
        ru: 'Ответить',
      );

  String roundHintAB(int cost) => _select(
        en: '50/50 (−$cost)',
        ru: '50/50 (−$cost)',
      );

  String roundHintLast(int cost) => _select(
        en: 'Last digits (−$cost)',
        ru: 'Последние цифры (−$cost)',
      );

  String roundHintNarrow(int cost) => _select(
        en: 'Narrow timeline (−$cost)',
        ru: 'Сузить шкалу (−$cost)',
      );

  String roundLastDigitsHint(String digits) => _select(
        en: 'Last digits: $digits',
        ru: 'Последние цифры: $digits',
      );

  String get localeMenuTooltip => _select(
        en: 'Change language',
        ru: 'Сменить язык',
      );

  String get localeEnglish => _select(
        en: 'English',
        ru: 'Английский',
      );

  String get localeRussian => _select(
        en: 'Russian',
        ru: 'Русский',
      );

  String resultYourAnswer(int year, String era) => _select(
        en: 'Your answer: $year ($era)',
        ru: 'Ваш ответ: $year ($era)',
      );

  String resultCorrectAnswer(int year, String era) => _select(
        en: 'Correct answer: $year ($era)',
        ru: 'Правильный ответ: $year ($era)',
      );

  String resultBaseScore(int score) => _select(
        en: 'Base score: $score',
        ru: 'Базовые очки: $score',
      );

  String resultBonus(String bonus) => _select(
        en: 'Bonus: $bonus',
        ru: 'Бонус: $bonus',
      );

  String resultHintPenalty(int value) => _select(
        en: 'Hint penalty: -$value',
        ru: 'Штраф за подсказки: -$value',
      );

  String resultQuestionPoints(String points) => _select(
        en: 'Question points: $points',
        ru: 'Очки за вопрос: $points',
      );

  String resultHintsPrefix(String hints) => _select(
        en: 'Hints used: $hints',
        ru: 'Использованы подсказки: $hints',
      );

  String get resultNoHints => _select(
        en: 'No hints used',
        ru: 'Без подсказок',
      );

  String get resultPerfect => _select(
        en: 'Perfect!',
        ru: 'Идеально!',
      );

  String resultMissedBy(int delta) {
    switch (localeName) {
      case 'ru':
        return 'Промах на $delta лет';
      default:
        return 'Missed by $delta years';
    }
  }

  String resultStreak(int streak) {
    switch (localeName) {
      case 'ru':
        return 'Серия: $streak';
      default:
        return 'Streak bonus: $streak';
    }
  }

  String get resultFinish => _select(
        en: 'Finish',
        ru: 'Завершить',
      );

  String get resultNext => _select(
        en: 'Next question',
        ru: 'Следующий вопрос',
      );

  String get resultDetails => _select(
        en: 'Details',
        ru: 'Подробнее',
      );

  String get summaryTitle => _select(
        en: 'Summary',
        ru: 'Итоги',
      );

  String get summaryHeader => _select(
        en: "Here's how you did",
        ru: 'Ваши результаты',
      );

  String summaryPoints(int points) => _select(
        en: '$points pts',
        ru: '$points очков',
      );

  String summaryAccuracy(String value) => _select(
        en: 'Accuracy: $value',
        ru: 'Точность: $value',
      );

  String summaryAccuracyValue(int hits, int total) => _select(
        en: '$hits / $total correct',
        ru: '$hits из $total',
      );

  String summaryAverageDelta(String value) => _select(
        en: 'Average miss: $value years',
        ru: 'Среднее отклонение: $value лет',
      );

  String summaryBestStreak(int streak) => _select(
        en: 'Best streak: $streak',
        ru: 'Лучшая серия: $streak',
      );

  String get summaryPlayAgain => _select(
        en: 'Play again',
        ru: 'Сыграть ещё',
      );

  String get summaryHome => _select(
        en: 'Back to home',
        ru: 'На главный экран',
      );

  String get summaryNoValue => '—';

  String get hintLabelLastDigits => _select(
        en: 'Last digits',
        ru: 'Последние цифры',
      );

  String get hintLabelAB => _select(
        en: '50/50',
        ru: '50/50',
      );

  String get hintLabelNarrow => _select(
        en: 'Narrow timeline',
        ru: 'Сузить шкалу',
      );

  String stubComingSoon(String title) => _select(
        en: '"$title" is coming soon!',
        ru: 'Раздел «$title» скоро появится!',
      );

  String get stubSoundToggle => _select(
        en: 'Sound effects',
        ru: 'Звуки',
      );

  String get stubHapticsToggle => _select(
        en: 'Haptic feedback',
        ru: 'Виброотклик',
      );

  String _select({
    required String en,
    String? ru,
  }) {
    switch (localeName) {
      case 'ru':
        return ru ?? en;
      default:
        return en;
    }
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
