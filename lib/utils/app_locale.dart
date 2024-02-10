import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../utils/local_storage/cache_helper.dart';

class AppLocalizations {
  final Locale locale;
  AppLocalizations({required this.locale});

  static final List<Locale> supportedLocales = [
    const Locale('en', ''),
    const Locale('ar', ''),
    // Add more supported locales as needed
  ];

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates =
      const [
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];

  static Locale? localeResolutionCallback(deviceLocale, supportedLocales) {
    if (deviceLocale != null) {
      supportedLocales.map((locale) {
        if (locale.languageCode == deviceLocale.countryCode) {
          CacheHelper.saveData(key: 'lang', value: deviceLocale.languageCode);
        }
      });
      return deviceLocale;
    } else {
      return supportedLocales.first;
    }
  }

  Map<String, String> _loadedLocalizedValues = {};
  Future loadLang() async {
    String langFile =
        await rootBundle.loadString('assets/lang/${locale.languageCode}.json');
    Map<String, dynamic> loadedValues = jsonDecode(langFile);
    _loadedLocalizedValues = loadedValues.map((key, value) {
      return MapEntry(key, value.toString());
    });
  }

  String getTranslated(String key) {
    return _loadedLocalizedValues[key] ?? '';
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ["en", "ar"].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    AppLocalizations appLocalizations = AppLocalizations(locale: locale);
    await appLocalizations.loadLang();
    return appLocalizations;
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

extension TranslateX on String {
  String tr(BuildContext context) {
    return AppLocalizations.of(context)!.getTranslated(this);
  }
}
