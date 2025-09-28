import 'dart:math';

import 'package:flutter/services.dart' show rootBundle;

import '../models/question.dart';

class QuestionRepository {
  QuestionRepository();

  List<Question>? _cache;

  Future<List<Question>> _loadAll() async {
    if (_cache != null) {
      return _cache!;
    }
    final raw = await rootBundle.loadString('assets/questions.json');
    _cache = Question.parseList(raw);
    return _cache!;
  }

  Future<List<Question>> loadByCategory(String categoryId, {int limit = 10}) async {
    final all = await _loadAll();
    final filtered = all.where((q) => q.categoryId == categoryId).toList();
    if (filtered.isEmpty) {
      return [];
    }
    final random = Random(categoryId.hashCode);
    filtered.shuffle(random);
    if (filtered.length <= limit) {
      return filtered;
    }
    return filtered.sublist(0, limit);
  }
}
