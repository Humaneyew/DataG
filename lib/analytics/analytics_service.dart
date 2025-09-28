import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

String _toSnakeCase(String value) {
  return value
      .replaceAllMapped(
        RegExp('([a-z0-9])([A-Z])'),
        (match) => '${match.group(1)}_${match.group(2)}',
      )
      .toLowerCase();
}

typedef AnalyticsLogger = void Function(
  String name,
  Map<String, Object?> parameters,
);

class AnalyticsService {
  AnalyticsService({AnalyticsLogger? logger})
      : _logger = logger ?? _debugLogger;

  final AnalyticsLogger _logger;
  final Map<String, String> _context = {};

  static void _debugLogger(String name, Map<String, Object?> parameters) {
    if (kDebugMode) {
      debugPrint('AnalyticsEvent($name): $parameters');
    }
  }

  Future<void> logAppOpen() => _log('app_open');

  Future<void> logStartRound({
    required String mode,
    required String category,
  }) {
    return _log('start_round', {
      'mode': mode,
      'category': category,
    });
  }

  Future<void> logUseHint({required String type}) {
    return _log('use_hint', {
      'type': type,
    });
  }

  Future<void> logCheckAnswer({
    required int delta,
    required int timeSpentMillis,
    required int hintsUsed,
  }) {
    return _log('check_answer', {
      'delta': delta,
      'time_spent': timeSpentMillis,
      'hints_used': hintsUsed,
    });
  }

  Future<void> logFinishRound({
    required int score,
    required double averageDelta,
    required int bestStreak,
    required String mode,
    required String category,
  }) {
    return _log('finish_round', {
      'score': score,
      'avg_delta': averageDelta,
      'streak_best': bestStreak,
      'mode': mode,
      'category': category,
    });
  }

  Future<void> logOpenEventBanner(String eventId) {
    return _log('open_event_banner', {'event_id': eventId});
  }

  Future<void> setContext({
    String? mode,
    String? category,
    String? questionId,
  }) {
    if (mode != null) {
      _context['mode'] = mode;
    }
    if (category != null) {
      _context['category'] = category;
    }
    if (questionId != null) {
      _context['question_id'] = questionId;
    }
    return _log('set_context', Map<String, Object?>.from(_context));
  }

  Future<void> clearQuestionContext() {
    _context.remove('question_id');
    return _log('set_context', Map<String, Object?>.from(_context));
  }

  String hintTypeKey(Enum value) => _toSnakeCase(value.name);

  Future<void> _log(String name, [Map<String, Object?> parameters = const {}])
      async {
    _logger(name, parameters);
  }
}

final analyticsServiceProvider = Provider<AnalyticsService>((ref) {
  return AnalyticsService();
});
