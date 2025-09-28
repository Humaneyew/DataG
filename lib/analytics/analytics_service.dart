import 'dart:async';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

String _toSnakeCase(String value) {
  return value
      .replaceAllMapped(
        RegExp('([a-z0-9])([A-Z])'),
        (match) => '${match.group(1)}_${match.group(2)}',
      )
      .toLowerCase();
}

class AnalyticsService {
  AnalyticsService({
    FirebaseAnalytics? analytics,
    FirebaseCrashlytics? crashlytics,
  })  : _analytics = analytics ?? FirebaseAnalytics.instance,
        _crashlytics = crashlytics ?? FirebaseCrashlytics.instance;

  final FirebaseAnalytics _analytics;
  final FirebaseCrashlytics _crashlytics;

  Future<void> logAppOpen() => _analytics.logAppOpen();

  Future<void> logStartRound({
    required String mode,
    required String category,
  }) {
    return _analytics.logEvent(
      name: 'start_round',
      parameters: {
        'mode': mode,
        'category': category,
      },
    );
  }

  Future<void> logUseHint({required String type}) {
    return _analytics.logEvent(
      name: 'use_hint',
      parameters: {
        'type': type,
      },
    );
  }

  Future<void> logCheckAnswer({
    required int delta,
    required int timeSpentMillis,
    required int hintsUsed,
  }) {
    return _analytics.logEvent(
      name: 'check_answer',
      parameters: {
        'delta': delta,
        'time_spent': timeSpentMillis,
        'hints_used': hintsUsed,
      },
    );
  }

  Future<void> logFinishRound({
    required int score,
    required double averageDelta,
    required int bestStreak,
    required String mode,
    required String category,
  }) {
    return _analytics.logEvent(
      name: 'finish_round',
      parameters: {
        'score': score,
        'avg_delta': averageDelta,
        'streak_best': bestStreak,
        'mode': mode,
        'category': category,
      },
    );
  }

  Future<void> logOpenEventBanner(String eventId) {
    return _analytics.logEvent(
      name: 'open_event_banner',
      parameters: {'event_id': eventId},
    );
  }

  Future<void> setContext({
    String? mode,
    String? category,
    String? questionId,
  }) async {
    Future<void> setKey(String key, String? value) {
      final safe = value ?? '';
      return _crashlytics.setCustomKey(key, safe);
    }

    final futures = <Future<void>>[];
    if (mode != null) {
      futures.add(setKey('mode', mode));
    }
    if (category != null) {
      futures.add(setKey('category', category));
    }
    if (questionId != null) {
      futures.add(setKey('question_id', questionId));
    }
    await Future.wait(futures);
  }

  Future<void> clearQuestionContext() {
    return _crashlytics.setCustomKey('question_id', '');
  }

  String hintTypeKey(Enum value) => _toSnakeCase(value.name);
}

final analyticsServiceProvider = Provider<AnalyticsService>((ref) {
  return AnalyticsService();
});
