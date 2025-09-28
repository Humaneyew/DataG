import 'dart:convert';

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

  String get localizedLabel => this == Era.bce ? 'до н. э.' : 'н. э.';

  int signedYear(int year) => this == Era.bce ? -year : year;
}

class Question {
  Question({
    required this.id,
    required this.prompt,
    required this.correctYear,
    required this.minYear,
    required this.maxYear,
    required this.era,
    required this.categoryId,
    required this.hints,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'] as String,
      prompt: json['prompt'] as String,
      correctYear: json['correctYear'] as int,
      minYear: json['minYear'] as int,
      maxYear: json['maxYear'] as int,
      era: EraX.fromString(json['era'] as String),
      categoryId: json['categoryId'] as String,
      hints: (json['hints'] as List<dynamic>? ?? const [])
          .map((e) => e.toString())
          .toList(),
    );
  }

  static List<Question> parseList(String jsonStr) {
    final dynamic data = jsonDecode(jsonStr);
    if (data is List<dynamic>) {
      return data
          .map((e) => Question.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    throw const FormatException('Unexpected questions format');
  }

  final String id;
  final String prompt;
  final int correctYear;
  final int minYear;
  final int maxYear;
  final Era era;
  final String categoryId;
  final List<String> hints;

  int get range => maxYear - minYear;

  int get defaultYear => ((minYear + maxYear) / 2).round();
}
