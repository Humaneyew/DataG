import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final feedbackSettingsProvider =
    ChangeNotifierProvider<FeedbackSettings>((ref) {
  return FeedbackSettings.instance;
});

class FeedbackSettings extends ChangeNotifier {
  FeedbackSettings._();

  static final FeedbackSettings instance = FeedbackSettings._();

  bool _hapticsEnabled = true;
  bool _soundEnabled = true;

  bool get hapticsEnabled => _hapticsEnabled;
  bool get soundEnabled => _soundEnabled;

  void setHapticsEnabled(bool value) {
    if (_hapticsEnabled == value) return;
    _hapticsEnabled = value;
    notifyListeners();
  }

  void setSoundEnabled(bool value) {
    if (_soundEnabled == value) return;
    _soundEnabled = value;
    notifyListeners();
  }
}

enum HapticType { light, medium, heavy, selection }

class Haptics {
  const Haptics._();

  static Future<void> play(HapticType type) async {
    if (!FeedbackSettings.instance.hapticsEnabled) {
      return;
    }
    switch (type) {
      case HapticType.light:
        await HapticFeedback.lightImpact();
        break;
      case HapticType.medium:
        await HapticFeedback.mediumImpact();
        break;
      case HapticType.heavy:
        await HapticFeedback.heavyImpact();
        break;
      case HapticType.selection:
        await HapticFeedback.selectionClick();
        break;
    }
  }
}

enum SfxName { tick, pop }

class Sfx {
  const Sfx._();

  static Future<void> play(SfxName name) async {
    if (!FeedbackSettings.instance.soundEnabled) {
      return;
    }
    debugPrint('Sfx.play(${name.name})');
  }
}
