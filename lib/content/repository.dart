import 'dart:convert';
import 'dart:math';

import 'package:flutter/services.dart' show AssetBundle, rootBundle;

import 'models.dart';

class ContentRepository {
  ContentRepository({AssetBundle? bundle}) : _bundle = bundle ?? rootBundle;

  final AssetBundle _bundle;
  ContentIndex? _indexCache;
  final Map<String, List<Question>> _categoryCache = {};

  Future<ContentIndex> loadIndex() async {
    if (_indexCache != null) {
      return _indexCache!;
    }
    final raw = await _bundle.loadString('assets/data/index.json');
    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    _indexCache = ContentIndex.fromJson(decoded);
    return _indexCache!;
  }

  Future<List<Question>> loadByCategory(
    String categoryId, {
    int limit = 10,
    int? seed,
  }) async {
    final index = await loadIndex();
    final category = index.findCategory(categoryId);
    if (category == null) {
      throw ArgumentError.value(categoryId, 'categoryId', 'Unknown category');
    }
    final questions = await _loadCategoryQuestions(category);
    if (questions.isEmpty) {
      return const [];
    }
    final random = Random(seed ?? categoryId.hashCode);
    final shuffled = [...questions];
    shuffled.shuffle(random);
    if (limit >= shuffled.length) {
      return shuffled;
    }
    return shuffled.sublist(0, limit);
  }

  Future<Map<String, Question>> loadQuestionMap(String categoryId) async {
    final questions = await loadByCategory(categoryId, limit: 1 << 20);
    return {for (final question in questions) question.id: question};
  }

  Future<List<Question>> _loadCategoryQuestions(CategoryInfo category) async {
    final cached = _categoryCache[category.id];
    if (cached != null) {
      return cached;
    }
    final raw = await _bundle.loadString('assets/data/${category.file}');
    final questions = Question.parseList(raw);
    _categoryCache[category.id] = questions;
    return questions;
  }
}
