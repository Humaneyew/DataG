import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _storageKey = 'player_resources';

class PlayerResources {
  const PlayerResources({
    required this.lives,
    required this.energy,
    required this.gems,
    required this.level,
    required this.xp,
  });

  final int lives;
  final int energy;
  final int gems;
  final int level;
  final int xp;

  PlayerResources copyWith({
    int? lives,
    int? energy,
    int? gems,
    int? level,
    int? xp,
  }) {
    return PlayerResources(
      lives: lives ?? this.lives,
      energy: energy ?? this.energy,
      gems: gems ?? this.gems,
      level: level ?? this.level,
      xp: xp ?? this.xp,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'lives': lives,
        'energy': energy,
        'gems': gems,
        'level': level,
        'xp': xp,
      };

  static PlayerResources fromJson(Map<String, dynamic> json) {
    return PlayerResources(
      lives: json['lives'] as int? ?? 10,
      energy: json['energy'] as int? ?? 15,
      gems: json['gems'] as int? ?? 20460,
      level: json['level'] as int? ?? 10,
      xp: json['xp'] as int? ?? 0,
    );
  }
}

class PlayerResourcesNotifier extends StateNotifier<PlayerResources> {
  PlayerResourcesNotifier() : super(const PlayerResources(lives: 10, energy: 15, gems: 20460, level: 10, xp: 0)) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_storageKey);
    if (raw != null) {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      state = PlayerResources.fromJson(map);
    }
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, jsonEncode(state.toJson()));
  }

  Future<void> gain({int lives = 0, int energy = 0, int gems = 0, int xp = 0}) async {
    state = state.copyWith(
      lives: state.lives + lives,
      energy: state.energy + energy,
      gems: state.gems + gems,
      xp: state.xp + xp,
    );
    await _persist();
  }

  Future<void> spend({int lives = 0, int energy = 0, int gems = 0, int xp = 0}) async {
    state = state.copyWith(
      lives: (state.lives - lives).clamp(0, 999),
      energy: (state.energy - energy).clamp(0, 999),
      gems: (state.gems - gems).clamp(0, 9999999),
      xp: (state.xp - xp).clamp(0, 9999999),
    );
    await _persist();
  }

  Future<void> levelUp() async {
    state = state.copyWith(level: state.level + 1);
    await _persist();
  }
}

final playerResourcesProvider =
    StateNotifierProvider<PlayerResourcesNotifier, PlayerResources>((ref) {
  return PlayerResourcesNotifier();
});
