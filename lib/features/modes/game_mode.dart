import 'package:intl/intl.dart';

enum GameModeId { classic10, daily3, duel }

extension GameModeIdX on GameModeId {
  String get key {
    switch (this) {
      case GameModeId.classic10:
        return 'classic10';
      case GameModeId.daily3:
        return 'daily3';
      case GameModeId.duel:
        return 'duel';
    }
  }

  String get displayName {
    switch (this) {
      case GameModeId.classic10:
        return 'Classic 10';
      case GameModeId.daily3:
        return 'Daily 3';
      case GameModeId.duel:
        return 'Duel';
    }
  }
}

class ModeSeed {
  const ModeSeed({required this.seed, this.leaderboardKey});

  final int seed;
  final String? leaderboardKey;
}

typedef ModeSeedBuilder = ModeSeed? Function(DateTime now);

class ModeSettings {
  const ModeSettings({
    required this.id,
    required this.questionCount,
    required this.streakMultiplier,
    this.lives = 0,
    this.allowLastHint = true,
    this.compareLocal = false,
    this.timerEnabledByDefault = false,
    this.timerSeconds = 0,
    this.seedBuilder,
  });

  final GameModeId id;
  final int questionCount;
  final double streakMultiplier;
  final int lives;
  final bool allowLastHint;
  final bool compareLocal;
  final bool timerEnabledByDefault;
  final int timerSeconds;
  final ModeSeedBuilder? seedBuilder;

  ModeSeed? seedFor(DateTime now) => seedBuilder?.call(now);
}

ModeSeed _dailySeedBuilder(DateTime now) {
  final date = DateTime.utc(now.year, now.month, now.day);
  final seed = date.millisecondsSinceEpoch;
  final formatted = DateFormat('yyyy-MM-dd').format(date);
  return ModeSeed(seed: seed, leaderboardKey: formatted);
}

const classic10Settings = ModeSettings(
  id: GameModeId.classic10,
  questionCount: 10,
  streakMultiplier: 1.5,
  lives: 0,
  allowLastHint: true,
  timerEnabledByDefault: false,
  timerSeconds: 20,
);

const daily3Settings = ModeSettings(
  id: GameModeId.daily3,
  questionCount: 3,
  streakMultiplier: 1.5,
  lives: 0,
  allowLastHint: true,
  compareLocal: false,
  timerEnabledByDefault: true,
  timerSeconds: 30,
  seedBuilder: _dailySeedBuilder,
);

const duelSettings = ModeSettings(
  id: GameModeId.duel,
  questionCount: 5,
  streakMultiplier: 1.5,
  lives: 0,
  allowLastHint: true,
  compareLocal: true,
  timerEnabledByDefault: false,
  timerSeconds: 20,
);

const Map<GameModeId, ModeSettings> kDefaultModeSettings = {
  GameModeId.classic10: classic10Settings,
  GameModeId.daily3: daily3Settings,
  GameModeId.duel: duelSettings,
};
