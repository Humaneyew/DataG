import 'dart:convert';
import 'dart:ui';

enum Era { bce, ce }

extension EraX on Era {
  static Era fromString(String value) {
    switch (value.toUpperCase()) {
      case 'BCE':
        return Era.bce;
      case 'CE':
      default:
        return Era.ce;
    }
  }

  String get label => this == Era.bce ? 'BCE' : 'CE';

  int signedYear(int year) => this == Era.bce ? -year : year;

  String labelForLocale(Locale locale) {
    switch (locale.languageCode) {
      case 'uk':
        return this == Era.bce ? 'до н. е.' : 'н. е.';
      case 'ru':
        return this == Era.bce ? 'до н. э.' : 'н. э.';
      default:
        return label;
    }
  }
}

class QuestionHints {
  const QuestionHints({
    this.lastDigits,
    this.abChoices = const [],
    this.narrowRange,
  });

  factory QuestionHints.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const QuestionHints();
    }
    return QuestionHints(
      lastDigits: json['last_digits'] as String?,
      abChoices: (json['ab'] as List<dynamic>? ?? const [])
          .map((value) => value.toString())
          .toList(),
      narrowRange: json['narrow'] as String?,
    );
  }

  final String? lastDigits;
  final List<String> abChoices;
  final String? narrowRange;

  bool get hasAbChoices => abChoices.isNotEmpty;
}

class Question {
  Question({
    required this.id,
    required this.prompts,
    required this.correctYear,
    required this.minYear,
    required this.maxYear,
    required this.era,
    required this.categoryId,
    required this.region,
    required this.tags,
    required this.difficulty,
    required this.acceptableDelta,
    required this.hints,
    required this.source,
    required this.license,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'] as String,
      prompts: (json['prompts'] as Map<String, dynamic>)
          .map((key, value) => MapEntry(key, value.toString())),
      correctYear: json['year'] as int,
      minYear: json['min'] as int,
      maxYear: json['max'] as int,
      era: EraX.fromString(json['era'] as String),
      categoryId: json['category'] as String,
      region: json['region'] as String? ?? 'global',
      tags: (json['tags'] as List<dynamic>? ?? const [])
          .map((value) => value.toString())
          .toList(),
      difficulty: json['difficulty'] as int? ?? 1,
      acceptableDelta: json['acceptable_delta'] as int? ?? 0,
      hints: QuestionHints.fromJson(json['hints'] as Map<String, dynamic>?),
      source: json['source'] as String? ?? '',
      license: json['license'] as String? ?? 'unknown',
    );
  }

  static List<Question> parseList(String jsonStr) {
    final dynamic data = jsonDecode(jsonStr);
    if (data is List) {
      return data
          .map((item) => Question.fromJson(item as Map<String, dynamic>))
          .toList();
    }
    throw const FormatException('Unexpected questions format');
  }

  final String id;
  final Map<String, String> prompts;
  final int correctYear;
  final int minYear;
  final int maxYear;
  final Era era;
  final String categoryId;
  final String region;
  final List<String> tags;
  final int difficulty;
  final int acceptableDelta;
  final QuestionHints hints;
  final String source;
  final String license;

  int get range => maxYear - minYear;

  int get defaultYear => ((minYear + maxYear) / 2).round();

  String promptForLocale(Locale locale) {
    return promptForLanguageCode(locale.languageCode);
  }

  String promptForLanguageCode(String languageCode) {
    return prompts[languageCode] ?? prompts['en'] ?? prompts.values.first;
  }
}

class CategoryInfo {
  const CategoryInfo({
    required this.id,
    required this.file,
    required this.name,
    required this.description,
  });

  factory CategoryInfo.fromJson(Map<String, dynamic> json) {
    return CategoryInfo(
      id: json['id'] as String,
      file: json['file'] as String,
      name: (json['name'] as Map<String, dynamic>)
          .map((key, value) => MapEntry(key, value.toString())),
      description: (json['description'] as Map<String, dynamic>? ?? const {})
          .map((key, value) => MapEntry(key, value.toString())),
    );
  }

  final String id;
  final String file;
  final Map<String, String> name;
  final Map<String, String> description;

  String nameFor(Locale locale) => name[locale.languageCode] ?? name['en'] ?? id;

  String descriptionFor(Locale locale) =>
      description[locale.languageCode] ?? description['en'] ?? '';
}

class ContentIndex {
  ContentIndex({required this.categories});

  factory ContentIndex.fromJson(Map<String, dynamic> json) {
    final categoriesJson = json['categories'];
    if (categoriesJson is List) {
      return ContentIndex(
        categories: categoriesJson
            .map((item) => CategoryInfo.fromJson(item as Map<String, dynamic>))
            .toList(),
      );
    }
    throw const FormatException('Invalid index format');
  }

  final List<CategoryInfo> categories;

  CategoryInfo? findCategory(String id) {
    for (final category in categories) {
      if (category.id == id) {
        return category;
      }
    }
    return null;
  }
}
