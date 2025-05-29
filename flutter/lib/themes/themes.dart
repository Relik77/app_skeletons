import 'package:flutter/material.dart';
import 'package:sample_project/shared/services/core/storage.service.dart';
import 'package:sample_project/themes/default.theme.dart';
import 'package:sample_project/themes/theme.interface.dart';

class ThemeManager extends ChangeNotifier {
  static final ThemeManager _instance = ThemeManager._();

  final Map<String, ITheme> _themes = {
    "Default": DefaultTheme(),
  };
  ThemeMode _currentThemeMode = ThemeMode.system;

  ITheme _currentTheme = DefaultTheme();

  ITheme get currentTheme => _currentTheme;
  ThemeMode get themeMode => _currentThemeMode;
  set themeMode(ThemeMode mode) {
    _currentThemeMode = mode;
    notifyListeners();
  }

  set currentTheme(ITheme theme) {
    _currentTheme = theme;

    if (_currentTheme.name != theme.name) {
      StorageService.setString("theme", theme.name);
      notifyListeners();
    }
  }

  ThemeManager._() {
    StorageService.getString("theme").then((value) {
      if (value != null) {
        _currentTheme = _themes[value] ?? DefaultTheme();
      }
    });
  }

  void toggleTheme() {
    if (_currentThemeMode == ThemeMode.system) {
      themeMode = ThemeMode.dark;
    } else if (_currentThemeMode == ThemeMode.dark) {
      themeMode = ThemeMode.light;
    } else if (_currentThemeMode == ThemeMode.light) {
      themeMode = ThemeMode.system;
    }
  }

  factory ThemeManager() {
    return _instance;
  }
}
