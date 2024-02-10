import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/local_storage/cache_helper.dart';

class ThemeProvider extends ChangeNotifier {
  static ThemeProvider get(context, {bool listen = true}) =>
      Provider.of<ThemeProvider>(context, listen: listen);
  ThemeProvider() {
    getTheme();
  }
  bool _isDark = CacheHelper.getBool(key: 'isDark') ?? false;
  bool get getIsDark => _isDark;

  final String themeKey = 'isDark';
  Future<void> setDark({required bool darkValue}) async {
    await CacheHelper.init();
    await CacheHelper.setBool(key: themeKey, value: darkValue);
    _isDark = darkValue;
    log('darkValue : ${darkValue.toString()}');
    notifyListeners();
  }

  Future<bool> getTheme() async {
    await CacheHelper.init();
    await CacheHelper.getData(key: themeKey);
    log('darkValue : ${getIsDark.toString()}');
    notifyListeners();
    return _isDark;
  }

/*  ThemeMode themeMode = ThemeMode.dark;

  bool get isDarkMode => themeMode == ThemeMode.dark;
  getThemeAtInit() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    bool? isDarkTheme = sharedPreferences.getBool("isDark");
    if (isDarkTheme != null) {
      themeMode = ThemeMode.dark;
    } else {
      themeMode = ThemeMode.light;
    }
    notifyListeners();
  }

  void toggleTheme(bool isOn) async {
    themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool(
      "isDark",
      themeMode == ThemeMode.dark,
    ); //Update this as per your condition.
    notifyListeners();
  }*/
}
