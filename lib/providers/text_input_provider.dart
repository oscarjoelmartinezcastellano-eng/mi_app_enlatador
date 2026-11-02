import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TextInputProvider with ChangeNotifier {
  final Map<String, String> _values = {
    'enlatado_tab1_input1': ' ',
    'loteLata_input1': ' ',
    'loteLata_input2': ' ',
  };

  /// 🔒 Mapa para controlar habilitado/deshabilitado por id
  final Map<String, bool> _disabled = {};

  /// ==============================
  /// Carga de valores
  /// ==============================
  Future<void> loadValues() async {
    final prefs = await SharedPreferences.getInstance();
    for (var key in _values.keys) {
      _values[key] = prefs.getString('text_input_$key') ?? _values[key]!;
      _disabled[key] = prefs.getBool('text_input_disabled_$key') ?? false;
    }
    notifyListeners();
  }

  /// ==============================
  /// CRUD de TextInputs
  /// ==============================
  Future<void> setValue(String id, String value) async {
    if (_values[id] != value) {
      _values[id] = value;
      Future.microtask(() => notifyListeners());

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('text_input_$id', value);
    }
  }

  String? getValue(String id) => _values[id];


  Map<String, String> getAllValues() => Map.from(_values);

  Future<void> limpiarTextInputsPorFiltro(String filtro) async {
    final prefs = await SharedPreferences.getInstance();
    for (var key in _values.keys) {
      if (key.contains(filtro)) {
        _values[key] = '';
        await prefs.remove('text_input_$key');
      }
    }
    notifyListeners();
  }

  /// ==============================
  /// 🚀 Habilitar / Deshabilitar
  /// ==============================
  bool isDisabled(String id) => _disabled[id] ?? false;

  void disable(String id) {
    _disabled[id] = true;
    notifyListeners();
  }

  void enable(String id) {
    _disabled[id] = false;
    notifyListeners();
  }

  void setDisabled(String id, bool disabled) {
    _disabled[id] = disabled;
    notifyListeners();
  }

  void disableMany(List<String> ids) {
    for (var id in ids) {
      _disabled[id] = true;
    }
    notifyListeners();
  }

  void enableMany(List<String> ids) {
    for (var id in ids) {
      _disabled[id] = false;
    }
    notifyListeners();
  }
}