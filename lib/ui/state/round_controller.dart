import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../content/models.dart';
import '../../content/repository.dart';

enum RoundPhase { loading, playing, reviewing, completed }

enum HintType { lastDigits, abQuiz, narrowTimeline }

class YearRange {
  const YearRange(this.min, this.max);

  final int min;
  final int max;

  int clamp(int value) {
    if (value < min) return min;
    if (value > max) return max;
    return value;
  }
}

class QuestionResult {
  QuestionResult({
    required this.question,
    required this.playerYear,
    required this.playerEra,
    required this.delta,
    required this.baseScore,
    required this.totalPoints,
    required this.hintPenalty,
    required this.netPoints,
    required this.streakAfterAnswer,
    required this.usedHints,
    required this.streakBoostApplied,
  });

  final Question question;
  final int playerYear;
  final Era playerEra;
  final int delta;
  final int baseScore;
  final int totalPoints;
  final int hintPenalty;
  final int netPoints;
  final int streakAfterAnswer;
  final Set<HintType> usedHints;
  final bool streakBoostApplied;

  bool get isPerfect => delta <= question.acceptableDelta;

  bool get isCloseHit =>
      delta <= math.max(question.acceptableDelta, _closeHitThreshold);
}

const int _closeHitThreshold = 5;

class RoundSummary {
  const RoundSummary({
    required this.score,
    required this.averageDelta,
    required this.bestStreak,
    required this.closeHits,
    required this.totalQuestions,
    required this.categoryId,
  });

  final int score;
  final double averageDelta;
  final int bestStreak;
  final int closeHits;
  final int totalQuestions;
  final String categoryId;
}

@immutable
class RoundState {
  static const _sentinel = Object();

  const RoundState({
    this.phase = RoundPhase.loading,
    this.questions = const [],
    this.currentIndex = 0,
    this.selectedYear = 0,
    this.selectedEra = Era.ce,
    this.score = 0,
    this.lives = 3,
    this.streak = 0,
    this.bestStreak = 0,
    this.usedHints = const {},
    this.results = const [],
    this.lastResult,
    this.currentHintPenalty = 0,
    this.narrowedRange,
    this.abOptions,
    this.lastDigitsHint,
  });

  final RoundPhase phase;
  final List<Question> questions;
  final int currentIndex;
  final int selectedYear;
  final Era selectedEra;
  final int score;
  final int lives;
  final int streak;
  final int bestStreak;
  final Set<HintType> usedHints;
  final List<QuestionResult> results;
  final QuestionResult? lastResult;
  final int currentHintPenalty;
  final YearRange? narrowedRange;
  final List<int>? abOptions;
  final String? lastDigitsHint;

  bool get isLoading => phase == RoundPhase.loading;

  bool get isReviewing => phase == RoundPhase.reviewing;

  bool get isCompleted => phase == RoundPhase.completed;

  Question? get currentQuestion =>
      questions.isEmpty ? null : questions[currentIndex];

  int get questionCount => questions.length;

  int get currentMinYear => narrowedRange?.min ?? currentQuestion?.minYear ?? 0;

  int get currentMaxYear => narrowedRange?.max ?? currentQuestion?.maxYear ?? 0;

  RoundState copyWith({
    RoundPhase? phase,
    List<Question>? questions,
    int? currentIndex,
    int? selectedYear,
    Era? selectedEra,
    int? score,
    int? lives,
    int? streak,
    int? bestStreak,
    Set<HintType>? usedHints,
    List<QuestionResult>? results,
    Object? lastResult = _sentinel,
    int? currentHintPenalty,
    Object? narrowedRange = _sentinel,
    Object? abOptions = _sentinel,
    Object? lastDigitsHint = _sentinel,
  }) {
    return RoundState(
      phase: phase ?? this.phase,
      questions: questions ?? this.questions,
      currentIndex: currentIndex ?? this.currentIndex,
      selectedYear: selectedYear ?? this.selectedYear,
      selectedEra: selectedEra ?? this.selectedEra,
      score: score ?? this.score,
      lives: lives ?? this.lives,
      streak: streak ?? this.streak,
      bestStreak: bestStreak ?? this.bestStreak,
      usedHints: usedHints ?? this.usedHints,
      results: results ?? this.results,
      lastResult: identical(lastResult, _sentinel)
          ? this.lastResult
          : lastResult as QuestionResult?,
      currentHintPenalty: currentHintPenalty ?? this.currentHintPenalty,
      narrowedRange: identical(narrowedRange, _sentinel)
          ? this.narrowedRange
          : narrowedRange as YearRange?,
      abOptions: identical(abOptions, _sentinel)
          ? this.abOptions
          : abOptions as List<int>?,
      lastDigitsHint: identical(lastDigitsHint, _sentinel)
          ? this.lastDigitsHint
          : lastDigitsHint as String?,
    );
  }
}

class RoundController extends StateNotifier<RoundState> {
  RoundController({
    required this.categoryId,
    required this.repository,
  }) : super(const RoundState());

  final String categoryId;
  final ContentRepository repository;

  bool _initialized = false;

  Future<void> ensureLoaded() async {
    if (_initialized) return;
    _initialized = true;
    await load();
  }

  Future<void> load() async {
    state = state.copyWith(phase: RoundPhase.loading);
    final questions = await repository.loadByCategory(categoryId);
    if (questions.isEmpty) {
      state = state.copyWith(
        phase: RoundPhase.completed,
        questions: const [],
        score: 0,
        streak: 0,
        bestStreak: 0,
        results: const [],
      );
      return;
    }
    final first = questions.first;
    state = RoundState(
      phase: RoundPhase.playing,
      questions: questions,
      currentIndex: 0,
      selectedYear: first.defaultYear,
      selectedEra: first.era,
      score: 0,
      lives: state.lives,
      streak: 0,
      bestStreak: 0,
      usedHints: const <HintType>{},
      results: const [],
      currentHintPenalty: 0,
      narrowedRange: null,
      abOptions: null,
      lastDigitsHint: null,
    );
  }

  void adjustYear(int delta) {
    final question = state.currentQuestion;
    if (state.phase != RoundPhase.playing || question == null) return;
    final minYear = state.currentMinYear;
    final maxYear = state.currentMaxYear;
    final newYear = _clampInt(state.selectedYear + delta, minYear, maxYear);
    state = state.copyWith(selectedYear: newYear);
  }

  void setYear(int year) {
    final question = state.currentQuestion;
    if (state.phase != RoundPhase.playing || question == null) return;
    final minYear = state.currentMinYear;
    final maxYear = state.currentMaxYear;
    final clamped = _clampInt(year, minYear, maxYear);
    state = state.copyWith(selectedYear: clamped);
  }

  void setEra(Era era) {
    if (state.phase != RoundPhase.playing) return;
    state = state.copyWith(selectedEra: era);
  }

  void useHint(HintType type) {
    final question = state.currentQuestion;
    if (question == null || state.phase != RoundPhase.playing) return;
    if (state.usedHints.contains(type)) return;

    final newUsed = {...state.usedHints, type};
    var penalty = state.currentHintPenalty;
    YearRange? newRange = state.narrowedRange;
    List<int>? abOptions = state.abOptions;
    String? lastDigitsHint = state.lastDigitsHint;
    var selectedYear = state.selectedYear;

    switch (type) {
      case HintType.lastDigits:
        lastDigitsHint =
            question.hints.lastDigits ?? _fallbackLastDigits(question);
        penalty += 50;
        break;
      case HintType.abQuiz:
        final options = _buildAbOptions(question);
        abOptions = options;
        penalty += 100;
        break;
      case HintType.narrowTimeline:
        newRange = _buildNarrowRange(question);
        selectedYear = newRange.clamp(selectedYear);
        penalty += 150;
        break;
    }

    state = state.copyWith(
      usedHints: Set<HintType>.unmodifiable(newUsed),
      currentHintPenalty: penalty,
      narrowedRange: newRange,
      abOptions: abOptions,
      lastDigitsHint: lastDigitsHint,
      selectedYear: selectedYear,
    );
  }

  List<int> _buildAbOptions(Question question) {
    final provided = question.hints.abChoices;
    final options = <int>{};
    for (final choice in provided) {
      final parsed = int.tryParse(choice);
      if (parsed != null) {
        options.add(parsed);
      }
    }
    options.add(question.correctYear);
    if (options.length < 2) {
      final random = math.Random(question.id.hashCode);
      final offset = math.max(2, math.min(80, question.range ~/ 4));
      final delta = random.nextInt(offset) + 1;
      final altValue = (random.nextBool()
              ? question.correctYear + delta
              : question.correctYear - delta)
          .clamp(question.minYear, question.maxYear);
      final alt = altValue is double ? altValue.round() : altValue as int;
      options.add(alt);
    }
    final shuffled = options.toList();
    shuffled.shuffle(math.Random(question.id.hashCode ^ 0x9E3779B9));
    return shuffled;
  }

  YearRange _buildNarrowRange(Question question) {
    final hinted = _parseRangeHint(question);
    if (hinted != null) {
      return hinted;
    }
    final span = math.max(1, question.range);
    final narrowSpan = math.max(5, (span * 0.2).round());
    final half = narrowSpan ~/ 2;
    var minYear = question.correctYear - half;
    var maxYear = question.correctYear + (narrowSpan - half);
    if (minYear < question.minYear) {
      maxYear += question.minYear - minYear;
      minYear = question.minYear;
    }
    if (maxYear > question.maxYear) {
      minYear -= maxYear - question.maxYear;
      maxYear = question.maxYear;
    }
    minYear = _clampInt(minYear, question.minYear, question.maxYear);
    maxYear = _clampInt(maxYear, question.minYear, question.maxYear);
    if (minYear == maxYear) {
      maxYear = math.min(maxYear + 1, question.maxYear);
    }
    return YearRange(minYear, maxYear);
  }

  YearRange? _parseRangeHint(Question question) {
    final hint = question.hints.narrowRange;
    if (hint == null) {
      return null;
    }
    final match = RegExp(r'(-?\d+)\s*[-–]\s*(-?\d+)').firstMatch(hint);
    if (match == null) {
      return null;
    }
    final start = int.tryParse(match.group(1)!);
    final end = int.tryParse(match.group(2)!);
    if (start == null || end == null) {
      return null;
    }
    final minValue = math.min(start, end);
    final maxValue = math.max(start, end);
    final clampedMin =
        _clampInt(minValue, question.minYear, question.maxYear);
    final clampedMax =
        _clampInt(maxValue, question.minYear, question.maxYear);
    if (clampedMin >= clampedMax) {
      return null;
    }
    return YearRange(clampedMin, clampedMax);
  }

  String _fallbackLastDigits(Question question) {
    return (question.correctYear.abs() % 100)
        .toString()
        .padLeft(2, '0');
  }

  int _clampInt(int value, int minValue, int maxValue) {
    if (value < minValue) return minValue;
    if (value > maxValue) return maxValue;
    return value;
  }

  QuestionResult? evaluate() {
    final question = state.currentQuestion;
    if (question == null || state.phase != RoundPhase.playing) {
      return null;
    }
    final playerYear = state.selectedYear;
    final playerEra = state.selectedEra;
    final playerSigned = playerEra.signedYear(playerYear);
    final correctSigned = question.era.signedYear(question.correctYear);
    final delta = (playerSigned - correctSigned).abs();
    final tolerance = question.acceptableDelta;
    final effectiveDelta = math.max(0, delta - tolerance);
    final baseScore = math.max(0, 1000 - effectiveDelta * 2);
    var bonus = 0;
    if (effectiveDelta <= 1) {
      bonus += 200;
    } else if (effectiveDelta <= _closeHitThreshold) {
      bonus += 100;
    }
    var streak =
        effectiveDelta <= _closeHitThreshold ? state.streak + 1 : 0;
    var streakBoostApplied = false;
    var multiplier = 1.0;
    if (streak >= 3) {
      multiplier *= 1.5;
      streakBoostApplied = true;
    }
    final totalPoints = ((baseScore + bonus) * multiplier).round();
    final netPoints = totalPoints - state.currentHintPenalty;
    final bestStreak = math.max(state.bestStreak, streak);

    final result = QuestionResult(
      question: question,
      playerYear: playerYear,
      playerEra: playerEra,
      delta: delta,
      baseScore: baseScore,
      totalPoints: totalPoints,
      hintPenalty: state.currentHintPenalty,
      netPoints: netPoints,
      streakAfterAnswer: streak,
      usedHints: Set<HintType>.unmodifiable(state.usedHints),
      streakBoostApplied: streakBoostApplied,
    );

    final updatedResults = [...state.results, result];

    state = state.copyWith(
      score: state.score + netPoints,
      streak: streak,
      bestStreak: bestStreak,
      phase: RoundPhase.reviewing,
      lastResult: result,
      results: updatedResults,
      currentHintPenalty: 0,
    );

    return result;
  }

  bool advance() {
    if (state.phase != RoundPhase.reviewing) {
      return false;
    }
    final isLast = state.currentIndex >= state.questions.length - 1;
    if (isLast) {
      state = state.copyWith(phase: RoundPhase.completed);
      return true;
    }
    final nextIndex = state.currentIndex + 1;
    final nextQuestion = state.questions[nextIndex];
    state = state.copyWith(
      phase: RoundPhase.playing,
      currentIndex: nextIndex,
      selectedYear: nextQuestion.defaultYear,
      selectedEra: nextQuestion.era,
      usedHints: const <HintType>{},
      narrowedRange: null,
      abOptions: null,
      lastDigitsHint: null,
      lastResult: null,
      currentHintPenalty: 0,
    );
    return false;
  }

  RoundSummary? buildSummary() {
    if (state.results.isEmpty) {
      return null;
    }
    final totalDelta =
        state.results.fold<int>(0, (sum, result) => sum + result.delta);
    final average = totalDelta / state.results.length;
    final closeHits = state.results
        .where((result) =>
            result.delta <=
            math.max(result.question.acceptableDelta, _closeHitThreshold))
        .length;
    return RoundSummary(
      score: state.score,
      averageDelta: average,
      bestStreak: state.bestStreak,
      closeHits: closeHits,
      totalQuestions: state.results.length,
      categoryId: categoryId,
    );
  }

  void resetForReplay() {
    _initialized = false;
  }
}

final questionRepositoryProvider = Provider<ContentRepository>((ref) {
  return ContentRepository();
});

final roundControllerProvider =
    StateNotifierProvider.autoDispose.family<RoundController, RoundState, String>(
  (ref, categoryId) {
    final repository = ref.watch(questionRepositoryProvider);
    final controller = RoundController(
      categoryId: categoryId,
      repository: repository,
    );
    ref.onDispose(controller.resetForReplay);
    controller.ensureLoaded();
    return controller;
  },
);
