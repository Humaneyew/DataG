import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LocaleController extends StateNotifier<Locale> {
  LocaleController({Locale? initial})
      : super(initial ?? const Locale('ru'));

  void setLocale(Locale locale) {
    if (locale == state) return;
    state = locale;
  }

  void cycleLocale(List<Locale> supported) {
    if (supported.isEmpty) {
      return;
    }
    final index = supported.indexWhere((locale) => locale == state);
    final nextIndex = index == -1
        ? 0
        : (index + 1) % supported.length;
    state = supported[nextIndex];
  }
}

final localeControllerProvider =
    StateNotifierProvider<LocaleController, Locale>((ref) {
  return LocaleController();
});
