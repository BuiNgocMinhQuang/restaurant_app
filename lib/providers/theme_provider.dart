import 'package:app_restaurant/theme/theme.dart';
import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _themeDataStyle = ThemeDataStyle.lightMode;

  ThemeData get themeDataStyle => _themeDataStyle;

  set themeDataStyle(ThemeData themeData) {
    _themeDataStyle = themeData;
    notifyListeners();
  }

  void changeTheme() {
    if (_themeDataStyle == ThemeDataStyle.lightMode) {
      themeDataStyle = ThemeDataStyle.darkMode;
    } else {
      themeDataStyle = ThemeDataStyle.lightMode;
    }
  }
}
