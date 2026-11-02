import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SelectOptionsProvider with ChangeNotifier {
  final Map<String, String> _selectedValues = {
    'operador': "SELECCIONAR",
    'enlatado_tab1_select1': 'SELECCIONAR',
    'enlatado_tab2_select1': 'SELECCIONAR',
    'loteLata_select1': 'SELECCIONAR',

  };

  final Map<String, List<String>> _optionsMap = {
    'enlatado_tab1_select1': ['SELECCIONAR'],
    'loteLata_select1': ['SELECCIONAR'],
  };

  /// 🔒 Mapa para controlar habilitado/deshabilitado por id
  final Map<String, bool> _disabled = {};

  /// ==============================
  /// Carga de datos
  /// ==============================

  Future<void> loadSelectedValues() async {
    final prefs = await SharedPreferences.getInstance();

    // Cargar valores seleccionados
    for (var key in _selectedValues.keys) {
      _selectedValues[key] =
          prefs.getString('select_option_$key') ?? _selectedValues[key]!;
      _disabled[key] = prefs.getBool('select_option_disabled_$key') ?? false;
    }

    // Cargar listas de opciones
    for (var key in _optionsMap.keys) {
      final String? jsonString = prefs.getString('options_map_$key');
      if (jsonString != null) {
        try {
          List<dynamic> decoded = json.decode(jsonString);
          _optionsMap[key] = decoded.map((e) => e.toString()).toList();
        } catch (e) {
          // Si falla el decode, deja el valor por defecto
        }
      }
    }

    notifyListeners();
  }

  /// ==============================
  /// CRUD de Selects
  /// ==============================

  /// Guarda y actualiza valor seleccionado
  Future<void> setSelectedValue(String id, String value) async {
    if (_selectedValues[id] != value) {
      _selectedValues[id] = value;
      Future.microtask(() => notifyListeners());
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('select_option_$id', value);
    }
  }

  /// Obtiene valor actual seleccionado
  String? getSelectedValue(String id) => _selectedValues[id];

  /// Obtiene todos los valores seleccionados
  Map<String, String> getAllSelectedValues() => Map.from(_selectedValues);

  /// Guarda y actualiza lista de opciones
  Future<void> setOptionsList(String key, List<String> options) async {
    _optionsMap[key] = options;
    Future.microtask(() => notifyListeners());
    final prefs = await SharedPreferences.getInstance();
    final jsonString = json.encode(options);
    await prefs.setString('options_map_$key', jsonString);
  }

  /// Obtiene lista de opciones
  List<String> getOptionsList(String key) {
    return _optionsMap[key] ?? ['SELECCIONAR'];
  }

  /// Limpia selects filtrando por cadena
  Future<void> limpiarSelectsPorFiltro(String filtro) async {
    final prefs = await SharedPreferences.getInstance();
    for (var key in _selectedValues.keys) {
      if (key == "operador") {
        _selectedValues[key] = "SELECCIONAR";
        await prefs.remove('select_option_$key');
      }
      if (key.contains(filtro)) {
        _selectedValues[key] = "SELECCIONAR";
        await prefs.remove('select_option_$key');
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
