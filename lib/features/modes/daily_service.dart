import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../round/round_models.dart';

class DailyLeaderboard
    extends StateNotifier<Map<String, List<RoundSummary>>> {
  DailyLeaderboard() : super(const {});

  List<RoundSummary> record(String key, RoundSummary summary) {
    final list = [...(state[key] ?? const <RoundSummary>[])];
    list.removeWhere((item) => item.score == summary.score &&
        item.completedAt == summary.completedAt);
    list.add(summary);
    list.sort((a, b) => b.score.compareTo(a.score));
    state = {...state, key: list};
    return list;
  }

  List<RoundSummary> forKey(String key) => state[key] ?? const [];
}

final dailyLeaderboardProvider =
    StateNotifierProvider<DailyLeaderboard, Map<String, List<RoundSummary>>>(
  (ref) => DailyLeaderboard(),
);
