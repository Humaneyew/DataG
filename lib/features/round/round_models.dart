import 'dart:math' as math;

import 'package:flutter/foundation.dart';

import '../../content/models.dart';
import '../modes/game_mode.dart';

enum RoundPhase { loading, playing, reviewing, completed }

enum HintType { lastDigits, abQuiz, narrowTimeline }

class YearRange {
  const YearRange(this.min, this.max)
      : assert(min <= max, 'Invalid range: min must be <= max');

  final int min;
  final int max;

  int clamp(int value) {
    if (value < min) return min;
    if (value > max) return max;
    return value;
  }
}

const int closeHitThreshold = 5;

@immutable
class QuestionResult {
  const QuestionResult({
    required this.question,
    required this.playerYear,
    required this.playerEra,
    required this.delta,
    required this.baseScore,
    required this.bonusPoints,
    required this.timeBonus,
    required this.totalPoints,
    required this.hintPenalty,
    required this.netPoints,
    required this.streakAfterAnswer,
    required this.usedHints,
    required this.streakBoostApplied,
    required this.answerTime,
  });

  final Question question;
  final int playerYear;
  final Era playerEra;
  final int delta;
  final int baseScore;
  final int bonusPoints;
  final int timeBonus;
  final int totalPoints;
  final int hintPenalty;
  final int netPoints;
  final int streakAfterAnswer;
  final Set<HintType> usedHints;
  final bool streakBoostApplied;
  final Duration answerTime;

  bool get isPerfect => delta <= question.acceptableDelta;

  bool get isCloseHit =>
      delta <= math.max(question.acceptableDelta, closeHitThreshold);
}

class RoundSummary {
  const RoundSummary({
    required this.score,
    required this.averageDelta,
    required this.bestStreak,
    required this.closeHits,
    required this.totalQuestions,
    required this.categoryId,
    required this.modeId,
    this.leaderboardKey,
    this.completedAt,
    this.timeBonusTotal = 0,
  });

  final int score;
  final double averageDelta;
  final int bestStreak;
  final int closeHits;
  final int totalQuestions;
  final String categoryId;
  final GameModeId modeId;
  final String? leaderboardKey;
  final DateTime? completedAt;
  final int timeBonusTotal;
}

class RoundConfig {
  const RoundConfig({
    required this.modeId,
    required this.questionCount,
    required this.streakMultiplier,
    required this.allowLastHint,
    required this.compareLocal,
    required this.timerEnabled,
    required this.timeLimit,
    required this.seed,
    required this.leaderboardKey,
    required this.lives,
  });

  final GameModeId modeId;
  final int questionCount;
  final double streakMultiplier;
  final bool allowLastHint;
  final bool compareLocal;
  final bool timerEnabled;
  final Duration? timeLimit;
  final int? seed;
  final String? leaderboardKey;
  final int lives;
}
