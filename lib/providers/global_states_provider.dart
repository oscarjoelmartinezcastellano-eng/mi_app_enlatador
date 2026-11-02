import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GlobalStatesProvider extends ChangeNotifier {
  static const _prefsKey = 'global_widgets_enabled';

  bool _widgetsEnabled = true;

  bool get widgetsEnabled => _widgetsEnabled;

  /// Carga el estado guardado, si existe, o usa true por defecto
  Future<void> loadWidgetsEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    _widgetsEnabled = prefs.getBool(_prefsKey) ?? true;
    notifyListeners();
  }

  /// Guarda el estado actual
  Future<void> _saveWidgetsEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefsKey, _widgetsEnabled);
  }

  void enableWidgets() {
    _widgetsEnabled = true;
    _saveWidgetsEnabled();
    notifyListeners();
  }

  void disableWidgets() {
    _widgetsEnabled = false;
    _saveWidgetsEnabled();
    notifyListeners();
  }

  void setWidgetsEnabled(bool value) {
    _widgetsEnabled = value;
    _saveWidgetsEnabled();
    notifyListeners();
  }
}