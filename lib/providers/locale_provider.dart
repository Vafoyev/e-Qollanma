import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/storage/prefs_storage.dart';

class LocaleNotifier extends Notifier<Locale> {
  @override
  Locale build() {
    return PrefsStorage.getSavedLocale() ?? const Locale('uz');
  }

  Future<void> setLocale(BuildContext context, String langCode) async {
    state = Locale(langCode);
    await context.setLocale(Locale(langCode));
    await PrefsStorage.saveLocale(langCode);
  }
}

final localeProvider = NotifierProvider<LocaleNotifier, Locale>(
  LocaleNotifier.new,
);