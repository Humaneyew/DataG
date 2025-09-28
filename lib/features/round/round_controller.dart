import 'dart:async';
import 'dart:math' as math;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../content/models.dart';
import '../../content/repository.dart';
import '../../analytics/analytics_service.dart';
import '../../analytics/dev_diagnostics.dart';
import '../modes/daily_service.dart';
import '../modes/duel_service.dart';
import '../modes/game_mode.dart';
import '../modes/mode_controller.dart';
import 'round_models.dart';

class RoundState {
  static const _sentinel = Object();

  const RoundState({
    required this.config,
    this.phase = RoundPhase.loading,
    this.questions = const [],
    this.currentIndex = 0,
    this.selectedYear = 0,
    this.selectedEra = Era.ce,
    this.score = 0,
    this.lives = 0,
    this.streak = 0,
    this.bestStreak = 0,
    this.usedHints = const {},
    this.results = const [],
    this.lastResult,
    this.currentHintPenalty = 0,
    this.narrowedRange,
    this.abOptions,
    this.lastDigitsHint,
    this.hintCostMultiplier = 1.0,
    this.lastHintEnabled = true,
    this.adaptiveScalingEnabled = false,
    this.adaptiveRange,
    this.timerEnabled = false,
    this.timeLimit,
    this.questionStartTime,
  });

  final RoundConfig config;
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
  final double hintCostMultiplier;
  final bool lastHintEnabled;
  final bool adaptiveScalingEnabled;
  final YearRange? adaptiveRange;
  final bool timerEnabled;
  final Duration? timeLimit;
  final DateTime? questionStartTime;

  bool get isLoading => phase == RoundPhase.loading;

  bool get isReviewing => phase == RoundPhase.reviewing;

  bool get isCompleted => phase == RoundPhase.completed;

  Question? get currentQuestion =>
      questions.isEmpty ? null : questions[currentIndex];

  int get questionCount => questions.length;

  int get currentMinYear {
    final baseRange = narrowedRange ?? adaptiveRange;
    final question = currentQuestion;
    if (baseRange != null) {
      return baseRange.min;
    }
    if (question == null) return 0;
    return question.minYear;
  }

  int get currentMaxYear {
    final baseRange = narrowedRange ?? adaptiveRange;
    final question = currentQuestion;
    if (baseRange != null) {
      return baseRange.max;
    }
    if (question == null) return 0;
    return question.maxYear;
  }

  bool isHintAvailable(HintType type) {
    if (type == HintType.lastDigits && !lastHintEnabled) {
      return false;
    }
    return true;
  }

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
    double? hintCostMultiplier,
    bool? lastHintEnabled,
    bool? adaptiveScalingEnabled,
    Object? adaptiveRange = _sentinel,
    bool? timerEnabled,
    Object? timeLimit = _sentinel,
    Object? questionStartTime = _sentinel,
  }) {
    return RoundState(
      config: config,
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
      hintCostMultiplier: hintCostMultiplier ?? this.hintCostMultiplier,
      lastHintEnabled: lastHintEnabled ?? this.lastHintEnabled,
      adaptiveScalingEnabled:
          adaptiveScalingEnabled ?? this.adaptiveScalingEnabled,
      adaptiveRange: identical(adaptiveRange, _sentinel)
          ? this.adaptiveRange
          : adaptiveRange as YearRange?,
      timerEnabled: timerEnabled ?? this.timerEnabled,
      timeLimit: identical(timeLimit, _sentinel)
          ? this.timeLimit
          : timeLimit as Duration?,
      questionStartTime: identical(questionStartTime, _sentinel)
          ? this.questionStartTime
          : questionStartTime as DateTime?,
    );
  }
}

class RoundCompletion {
  const RoundCompletion({
    required this.summary,
    this.duelReport,
    this.dailyLeaderboard,
  });

  final RoundSummary summary;
  final DuelReport? duelReport;
  final List<RoundSummary>? dailyLeaderboard;
}

class RoundController extends StateNotifier<RoundState> {
  RoundController({
    required this.categoryId,
    required this.repository,
    required this.config,
    required this.duelCoordinator,
    required this.dailyLeaderboard,
    required this.analytics,
    required this.diagnostics,
  }) : super(RoundState(config: config));

  final String categoryId;
  final ContentRepository repository;
  final RoundConfig config;
  final DuelCoordinator duelCoordinator;
  final DailyLeaderboard dailyLeaderboard;
  final AnalyticsService analytics;
  final DevDiagnosticsService diagnostics;

  bool _initialized = false;

  Future<void> ensureLoaded() async {
    if (_initialized) return;
    _initialized = true;
    await load();
  }

  Future<void> load() async {
    state = state.copyWith(phase: RoundPhase.loading);
    diagnostics.clear();
    unawaited(analytics.setContext(
      mode: config.modeId.key,
      category: categoryId,
    ));
    final questions = await repository.loadByCategory(
      categoryId,
      limit: config.questionCount,
      seed: config.seed,
    );
    if (questions.isEmpty) {
      state = state.copyWith(
        phase: RoundPhase.completed,
        questions: const [],
        score: 0,
        streak: 0,
        bestStreak: 0,
        results: const [],
        lives: config.lives,
      );
      return;
    }
    final first = questions.first;
    final adaptiveRange =
        state.adaptiveScalingEnabled ? _buildAdaptiveRange(first) : null;
    final selectedYear = (adaptiveRange ?? YearRange(first.minYear, first.maxYear))
        .clamp(first.defaultYear);
    state = state.copyWith(
      phase: RoundPhase.playing,
      questions: questions,
      currentIndex: 0,
      selectedYear: selectedYear,
      selectedEra: first.era,
      score: 0,
      lives: config.lives,
      streak: 0,
      bestStreak: 0,
      usedHints: const <HintType>{},
      results: const [],
      currentHintPenalty: 0,
      narrowedRange: null,
      abOptions: null,
      lastDigitsHint: null,
      hintCostMultiplier: 1.0,
      lastHintEnabled: config.allowLastHint,
      adaptiveScalingEnabled: state.adaptiveScalingEnabled,
      adaptiveRange: adaptiveRange,
      timerEnabled: config.timerEnabled,
      timeLimit: config.timerEnabled ? config.timeLimit : null,
      questionStartTime: DateTime.now(),
    );

    unawaited(analytics.setContext(
      mode: config.modeId.key,
      category: categoryId,
      questionId: first.id,
    ));
    unawaited(analytics.logStartRound(
      mode: config.modeId.key,
      category: categoryId,
    ));
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
    if (!state.isHintAvailable(type)) return;

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
        penalty += _hintCost(50);
        break;
      case HintType.abQuiz:
        final options = _buildAbOptions(question);
        abOptions = options;
        penalty += _hintCost(100);
        break;
      case HintType.narrowTimeline:
        newRange = _buildNarrowRange(question);
        selectedYear = newRange.clamp(selectedYear);
        penalty += _hintCost(150);
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

    final hintKey = analytics.hintTypeKey(type);
    unawaited(analytics.logUseHint(type: hintKey));
    diagnostics.logHint(questionId: question.id, hintType: hintKey);
  }

  int _hintCost(int baseCost) {
    final value = (baseCost * state.hintCostMultiplier).round();
    return math.max(1, value);
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
    final match = RegExp(r'(-?\\d+)\\s*[-–]\\s*(-?\\d+)').firstMatch(hint);
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
    final baseScore = math.max(0, 1000 - delta * 2);

    final acceptable = question.acceptableDelta;
    final bonusDelta =
        (acceptable > 0 && delta <= acceptable) ? math.max(acceptable, delta) : delta;

    var bonus = 0;
    if (bonusDelta <= 1) {
      bonus += 200;
    } else if (bonusDelta <= closeHitThreshold) {
      bonus += 100;
    }

    var streak = bonusDelta <= closeHitThreshold ? state.streak + 1 : 0;
    var streakBoostApplied = false;
    var multiplier = 1.0;
    if (streak >= 3) {
      multiplier *= config.streakMultiplier;
      streakBoostApplied = true;
    }

    final totalPointsWithoutTime =
        ((baseScore + bonus) * multiplier).round();

    final elapsed = state.questionStartTime == null
        ? Duration.zero
        : DateTime.now().difference(state.questionStartTime!);
    final timeBonus =
        state.timerEnabled && elapsed <= const Duration(seconds: 5) ? 100 : 0;
    final totalPoints = totalPointsWithoutTime + timeBonus;
    final netPoints = totalPoints - state.currentHintPenalty;
    final bestStreak = math.max(state.bestStreak, streak);

    final result = QuestionResult(
      question: question,
      playerYear: playerYear,
      playerEra: playerEra,
      delta: delta,
      baseScore: baseScore,
      bonusPoints: bonus,
      timeBonus: timeBonus,
      totalPoints: totalPoints,
      hintPenalty: state.currentHintPenalty,
      netPoints: netPoints,
      streakAfterAnswer: streak,
      usedHints: Set<HintType>.unmodifiable(state.usedHints),
      streakBoostApplied: streakBoostApplied,
      answerTime: elapsed,
    );

    final updatedResults = [...state.results, result];
    final difficulty = _resolveDifficulty(updatedResults);

    state = state.copyWith(
      score: state.score + netPoints,
      streak: streak,
      bestStreak: bestStreak,
      phase: RoundPhase.reviewing,
      lastResult: result,
      results: updatedResults,
      currentHintPenalty: 0,
      hintCostMultiplier: difficulty.hintCostMultiplier,
      lastHintEnabled: difficulty.lastHintEnabled,
      adaptiveScalingEnabled: difficulty.adaptiveScalingEnabled,
    );

    final elapsedMillis = elapsed.inMilliseconds;
    unawaited(analytics.logCheckAnswer(
      delta: delta,
      timeSpentMillis: elapsedMillis,
      hintsUsed: result.usedHints.length,
    ));
    diagnostics.logAnswer(
      questionId: question.id,
      delta: delta,
      timeSpent: elapsed,
      hintsUsed: result.usedHints.length,
    );

    return result;
  }

  _DifficultyState _resolveDifficulty(List<QuestionResult> results) {
    if (results.isEmpty) {
      return _DifficultyState.defaults(config.allowLastHint);
    }
    final recent = results
        .skip(results.length >= 3 ? results.length - 3 : 0)
        .toList();
    if (recent.isEmpty) {
      return _DifficultyState.defaults(config.allowLastHint);
    }
    final avg = recent.fold<int>(0, (sum, item) => sum + item.delta) /
        recent.length;
    if (avg > 50) {
      return _DifficultyState(
        hintCostMultiplier: 0.75,
        lastHintEnabled: config.allowLastHint,
        adaptiveScalingEnabled: true,
      );
    }
    if (avg < 10) {
      return _DifficultyState(
        hintCostMultiplier: 1.0,
        lastHintEnabled: false,
        adaptiveScalingEnabled: false,
      );
    }
    return _DifficultyState.defaults(config.allowLastHint);
  }

  bool advance() {
    if (state.phase != RoundPhase.reviewing) {
      return false;
    }
    final isLast = state.currentIndex >= state.questions.length - 1;
    if (isLast) {
      state = state.copyWith(phase: RoundPhase.completed);
      unawaited(analytics.clearQuestionContext());
      return true;
    }
    final nextIndex = state.currentIndex + 1;
    final nextQuestion = state.questions[nextIndex];
    final adaptiveRange = state.adaptiveScalingEnabled
        ? _buildAdaptiveRange(nextQuestion)
        : null;
    final selectedYear =
        (adaptiveRange ?? YearRange(nextQuestion.minYear, nextQuestion.maxYear))
            .clamp(nextQuestion.defaultYear);
    state = state.copyWith(
      phase: RoundPhase.playing,
      currentIndex: nextIndex,
      selectedYear: selectedYear,
      selectedEra: nextQuestion.era,
      usedHints: const <HintType>{},
      narrowedRange: null,
      abOptions: null,
      lastDigitsHint: null,
      lastResult: null,
      currentHintPenalty: 0,
      adaptiveRange: adaptiveRange,
      questionStartTime: DateTime.now(),
    );
    unawaited(analytics.setContext(questionId: nextQuestion.id));
    return false;
  }

  RoundCompletion? buildSummary() {
    if (state.results.isEmpty) {
      return null;
    }
    final totalDelta =
        state.results.fold<int>(0, (sum, result) => sum + result.delta);
    final average = totalDelta / state.results.length;
    final closeHits = state.results
        .where((result) =>
            result.delta <=
            math.max(result.question.acceptableDelta, closeHitThreshold))
        .length;
    final totalTimeBonus =
        state.results.fold<int>(0, (sum, result) => sum + result.timeBonus);

    final summary = RoundSummary(
      score: state.score,
      averageDelta: average,
      bestStreak: state.bestStreak,
      closeHits: closeHits,
      totalQuestions: state.results.length,
      categoryId: categoryId,
      modeId: config.modeId,
      leaderboardKey: config.leaderboardKey,
      completedAt: DateTime.now(),
      timeBonusTotal: totalTimeBonus,
    );

    DuelReport? duelReport;
    List<RoundSummary>? leaderboard;

    if (config.modeId == GameModeId.duel && config.compareLocal) {
      duelReport = duelCoordinator.submit(summary);
    }

    if (config.modeId == GameModeId.daily3 && config.leaderboardKey != null) {
      leaderboard = dailyLeaderboard.record(config.leaderboardKey!, summary);
    }

    unawaited(analytics.logFinishRound(
      score: summary.score,
      averageDelta: summary.averageDelta,
      bestStreak: summary.bestStreak,
      mode: config.modeId.key,
      category: categoryId,
    ));

    return RoundCompletion(
      summary: summary,
      duelReport: duelReport,
      dailyLeaderboard: leaderboard,
    );
  }

  void resetForReplay() {
    _initialized = false;
    unawaited(analytics.clearQuestionContext());
  }
}

class _DifficultyState {
  const _DifficultyState({
    required this.hintCostMultiplier,
    required this.lastHintEnabled,
    required this.adaptiveScalingEnabled,
  });

  factory _DifficultyState.defaults(bool allowLastHint) => _DifficultyState(
        hintCostMultiplier: 1.0,
        lastHintEnabled: allowLastHint,
        adaptiveScalingEnabled: false,
      );

  final double hintCostMultiplier;
  final bool lastHintEnabled;
  final bool adaptiveScalingEnabled;
}

YearRange _buildAdaptiveRange(Question question) {
  final span = math.max(10, question.range ~/ 2);
  final half = span ~/ 2;
  var minYear = question.correctYear - half;
  var maxYear = question.correctYear + (span - half);
  if (minYear < question.minYear) {
    maxYear += question.minYear - minYear;
    minYear = question.minYear;
  }
  if (maxYear > question.maxYear) {
    minYear -= maxYear - question.maxYear;
    maxYear = question.maxYear;
  }
  minYear = minYear.clamp(question.minYear, question.maxYear).toInt();
  maxYear = maxYear.clamp(question.minYear, question.maxYear).toInt();
  return YearRange(minYear, maxYear);
}

class RoundSessionRequest {
  const RoundSessionRequest({required this.categoryId, required this.modeId});

  final String categoryId;
  final GameModeId modeId;

  @override
  bool operator ==(Object other) {
    return other is RoundSessionRequest &&
        other.categoryId == categoryId &&
        other.modeId == modeId;
  }

  @override
  int get hashCode => Object.hash(categoryId, modeId);
}

RoundConfig _buildRoundConfig(
  ModeSettings settings,
  bool timerEnabled,
) {
  final seedData = settings.seedFor(DateTime.now());
  return RoundConfig(
    modeId: settings.id,
    questionCount: settings.questionCount,
    streakMultiplier: settings.streakMultiplier,
    allowLastHint: settings.allowLastHint,
    compareLocal: settings.compareLocal,
    timerEnabled: timerEnabled,
    timeLimit:
        timerEnabled && settings.timerSeconds > 0
            ? Duration(seconds: settings.timerSeconds)
            : null,
    seed: seedData?.seed,
    leaderboardKey: seedData?.leaderboardKey,
    lives: settings.lives,
  );
}

final questionRepositoryProvider = Provider<ContentRepository>((ref) {
  return ContentRepository();
});

final roundControllerProvider = StateNotifierProvider.autoDispose
    .family<RoundController, RoundState, RoundSessionRequest>((ref, request) {
  final repository = ref.watch(questionRepositoryProvider);
  final settings = ref.watch(modeSettingsProvider(request.modeId));
  final timerEnabled = ref.watch(timerEnabledForModeProvider(request.modeId));
  final config = _buildRoundConfig(settings, timerEnabled);
  final duelCoordinator = ref.watch(duelCoordinatorProvider.notifier);
  final dailyBoard = ref.watch(dailyLeaderboardProvider.notifier);
  final controller = RoundController(
    categoryId: request.categoryId,
    repository: repository,
    config: config,
    duelCoordinator: duelCoordinator,
    dailyLeaderboard: dailyBoard,
    analytics: ref.watch(analyticsServiceProvider),
    diagnostics: ref.watch(devDiagnosticsServiceProvider),
  );
  ref.onDispose(controller.resetForReplay);
  controller.ensureLoaded();
  return controller;
});
