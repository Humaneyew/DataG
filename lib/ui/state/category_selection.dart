import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../theme/tokens.dart';
import 'strings.dart';

class CategoryDefinition {
  const CategoryDefinition({
    required this.id,
    required this.titleKey,
    required this.colorKey,
    required this.iconKey,
    required this.progress,
    required this.locked,
  });

  factory CategoryDefinition.fromJson(Map<String, dynamic> json) {
    return CategoryDefinition(
      id: json['id'] as String,
      titleKey: json['titleKey'] as String,
      colorKey: json['colorKey'] as String,
      iconKey: json['iconKey'] as String,
      progress: (json['progress'] as num?)?.toDouble() ?? 0,
      locked: json['locked'] as bool? ?? false,
    );
  }

  final String id;
  final String titleKey;
  final String colorKey;
  final String iconKey;
  final double progress;
  final bool locked;

  Color get accentColor =>
      AppColors.categoryColors[colorKey] ?? AppColors.primary;

  IconData get iconData => _CategoryIconResolver.resolve(iconKey);

  String localizedTitle(AppStrings strings) =>
      strings.categoryTitle(titleKey);
}

final categoryListProvider = FutureProvider<List<CategoryDefinition>>((ref) async {
  final bundle = rootBundle;
  final raw = await bundle.loadString('assets/data/categories.json');
  final data = jsonDecode(raw) as List<dynamic>;
  return data
      .map((item) => CategoryDefinition.fromJson(item as Map<String, dynamic>))
      .toList(growable: false);
});

class SelectedCategoryController extends StateNotifier<String> {
  SelectedCategoryController() : super('history') {
    _hydrate();
  }

  static const String _storageKey = 'selected_category';
  SharedPreferences? _preferences;

  Future<void> _hydrate() async {
    final prefs = await SharedPreferences.getInstance();
    _preferences = prefs;
    final stored = prefs.getString(_storageKey);
    if (stored != null && stored.isNotEmpty) {
      state = stored;
    }
  }

  Future<void> select(String id) async {
    state = id;
    final prefs = _preferences ?? await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, id);
  }
}

final selectedCategoryProvider =
    StateNotifierProvider<SelectedCategoryController, String>(
  (ref) => SelectedCategoryController(),
);

class _CategoryIconResolver {
  static IconData resolve(String key) {
    switch (key) {
      case 'bank':
        return Icons.account_balance_rounded;
      case 'basketball':
        return Icons.sports_basketball;
      case 'movie':
        return Icons.movie_creation_rounded;
      case 'palette':
        return Icons.palette_rounded;
      case 'gamepad':
        return Icons.sports_esports_rounded;
      case 'book':
        return Icons.menu_book_rounded;
      case 'public':
        return Icons.public_rounded;
      case 'science':
        return Icons.science_rounded;
      case 'travel':
        return Icons.flight_takeoff_rounded;
      case 'music':
        return Icons.music_note_rounded;
      default:
        return Icons.category_rounded;
    }
  }
}
