import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlayerResources {
  const PlayerResources({
    required this.lives,
    required this.energy,
    required this.gems,
    required this.level,
    required this.xp,
  });

  factory PlayerResources.initial() => const PlayerResources(
        lives: 10,
        energy: 15,
        gems: 20460,
        level: 10,
        xp: 0,
      );

  factory PlayerResources.fromJson(Map<String, dynamic> json) {
    return PlayerResources(
      lives: json['lives'] as int? ?? 10,
      energy: json['energy'] as int? ?? 15,
      gems: json['gems'] as int? ?? 20460,
      level: json['level'] as int? ?? 10,
      xp: json['xp'] as int? ?? 0,
    );
  }

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
}

class PlayerResourcesController extends StateNotifier<PlayerResources> {
  PlayerResourcesController() : super(PlayerResources.initial()) {
    _hydrate();
  }

  static const String _storageKey = 'player_resources';
  SharedPreferences? _preferences;

  Future<void> _hydrate() async {
    final prefs = await SharedPreferences.getInstance();
    _preferences = prefs;
    final stored = prefs.getString(_storageKey);
    if (stored != null) {
      final json = jsonDecode(stored) as Map<String, dynamic>;
      state = PlayerResources.fromJson(json);
    }
  }

  Future<void> _persist(PlayerResources resources) async {
    final prefs = _preferences ?? await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, jsonEncode(resources.toJson()));
  }

  void spend({int lives = 0, int energy = 0, int gems = 0}) {
    final next = state.copyWith(
      lives: ((state.lives - lives).clamp(0, 999)).toInt(),
      energy: ((state.energy - energy).clamp(0, 999)).toInt(),
      gems: ((state.gems - gems).clamp(0, 9999999)).toInt(),
    );
    state = next;
    _persist(next);
  }

  void gain({int lives = 0, int energy = 0, int gems = 0, int xp = 0}) {
    var next = state.copyWith(
      lives: ((state.lives + lives).clamp(0, 999)).toInt(),
      energy: ((state.energy + energy).clamp(0, 999)).toInt(),
      gems: ((state.gems + gems).clamp(0, 9999999)).toInt(),
      xp: ((state.xp + xp).clamp(0, 9999999)).toInt(),
    );
    if (next.xp >= 1000) {
      final levelIncrease = next.xp ~/ 1000;
      final remainingXp = next.xp % 1000;
      next = next.copyWith(
        level: ((next.level + levelIncrease).clamp(0, 999)).toInt(),
        xp: remainingXp,
      );
    }
    state = next;
    _persist(next);
  }
}

final playerResourcesProvider = StateNotifierProvider<PlayerResourcesController, PlayerResources>(
  (ref) => PlayerResourcesController(),
);
