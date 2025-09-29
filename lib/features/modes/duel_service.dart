import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../round/round_models.dart';
import 'game_mode.dart';

class DuelReport {
  const DuelReport._({
    required this.playerSummary,
    this.opponentSummary,
    required this.isPending,
    required this.isDraw,
    required this.isPlayerWinner,
    required this.scoreDelta,
  });

  factory DuelReport.pending(RoundSummary summary) => DuelReport._(
        playerSummary: summary,
        opponentSummary: null,
        isPending: true,
        isDraw: false,
        isPlayerWinner: false,
        scoreDelta: 0,
      );

  factory DuelReport.complete({
    required RoundSummary playerSummary,
    required RoundSummary opponentSummary,
  }) {
    final delta = playerSummary.score - opponentSummary.score;
    final isDraw = delta == 0;
    final isPlayerWinner = delta > 0;
    final scoreDelta = delta.abs();
    return DuelReport._(
      playerSummary: playerSummary,
      opponentSummary: opponentSummary,
      isPending: false,
      isDraw: isDraw,
      isPlayerWinner: isPlayerWinner,
      scoreDelta: scoreDelta,
    );
  }

  final RoundSummary playerSummary;
  final RoundSummary? opponentSummary;
  final bool isPending;
  final bool isDraw;
  final bool isPlayerWinner;
  final int scoreDelta;
}

class _DuelMatchState {
  const _DuelMatchState({required this.summary, required this.createdAt});

  final RoundSummary summary;
  final DateTime createdAt;
}

class DuelCoordinator
    extends StateNotifier<Map<String, _DuelMatchState>> {
  DuelCoordinator() : super(const {});

  DuelReport submit(RoundSummary summary) {
    final key = _keyFor(summary);
    final existing = state[key];
    if (existing == null) {
      state = {...state, key: _DuelMatchState(summary: summary, createdAt: DateTime.now())};
      return DuelReport.pending(summary);
    }
    state = {...state}..remove(key);
    return DuelReport.complete(
      playerSummary: summary,
      opponentSummary: existing.summary,
    );
  }

  String _keyFor(RoundSummary summary) {
    final leaderboardKey = summary.leaderboardKey ?? '';
    return '${summary.categoryId}:${summary.modeId.key}:$leaderboardKey';
  }
}

final duelCoordinatorProvider =
    StateNotifierProvider<DuelCoordinator, Map<String, _DuelMatchState>>(
  (ref) => DuelCoordinator(),
);
