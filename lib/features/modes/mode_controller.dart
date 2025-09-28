import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'game_mode.dart';

final selectedModeProvider =
    StateProvider<GameModeId>((ref) => GameModeId.classic10);

final modeSettingsProvider =
    Provider.family<ModeSettings, GameModeId>((ref, id) {
  final settings = kDefaultModeSettings[id];
  if (settings == null) {
    throw ArgumentError.value(id, 'id', 'Missing mode settings');
  }
  return settings;
});

class ModePreferences extends StateNotifier<Map<GameModeId, bool>> {
  ModePreferences()
      : super({
          for (final entry in kDefaultModeSettings.entries)
            entry.key: entry.value.timerEnabledByDefault,
        });

  bool isTimerEnabled(GameModeId id) => state[id] ?? false;

  void setTimer(GameModeId id, bool enabled) {
    state = {...state, id: enabled};
  }
}

final modePreferencesProvider =
    StateNotifierProvider<ModePreferences, Map<GameModeId, bool>>(
  (ref) => ModePreferences(),
);

final timerEnabledForModeProvider =
    Provider.family<bool, GameModeId>((ref, id) {
  final prefs = ref.watch(modePreferencesProvider);
  final defaultValue = kDefaultModeSettings[id]?.timerEnabledByDefault ?? false;
  return prefs[id] ?? defaultValue;
});
