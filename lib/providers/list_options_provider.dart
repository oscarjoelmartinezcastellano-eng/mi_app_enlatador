import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListOptionsProvider with ChangeNotifier {
  final Map<String, List<String>> _selectedValues = {
    'enlatado_tab1_list1': [''],
  };

  /// 🔒 Mapa para controlar habilitado/deshabilitado por id
  final Map<String, bool> _disabled = {};

  /// ==============================
  /// CRUD de Listas
  /// ==============================

  /// Cargar valores guardados desde SharedPreferences
  Future<void> loadSelectedValues() async {
    final prefs = await SharedPreferences.getInstance();
    for (var key in _selectedValues.keys) {
      final stored = prefs.getStringList('list_option_$key');
      if (stored != null) {
        _selectedValues[key] = stored;
      }
      _disabled[key] = prefs.getBool('list_option_disabled_$key') ?? false;
    }
    notifyListeners();
  }

  /// Agregar un valor a la lista
  Future<void> addValue(String id, String value) async {
    _selectedValues.putIfAbsent(id, () => []);
    if (!_selectedValues[id]!.contains(value)) {
      _selectedValues[id]!.add(value);
      Future.microtask(() => notifyListeners());
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('list_option_$id', _selectedValues[id]!);
    }
  }

  /// Eliminar un valor de la lista
  Future<void> removeValue(String id, String value) async {
    if (_selectedValues.containsKey(id)) {
      _selectedValues[id]!.remove(value);
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('list_option_$id', _selectedValues[id]!);
    }
  }

  /// Obtener valores actuales para un ID
  List<String> getSelectedValues(String id) => _selectedValues[id] ?? [];

  /// Obtener todos los valores
  Map<String, List<String>> getAllSelectedValues() => Map.from(_selectedValues);

  /// Limpiar listas por filtro
  Future<void> limpiarListsPorFiltro(String filtro) async {
    final prefs = await SharedPreferences.getInstance();
    for (var key in _selectedValues.keys) {
      if (key.contains(filtro)) {
        _selectedValues[key] = [''];
        await prefs.remove('list_option_$key');
      }
    }
    notifyListeners();
  }

  /// ==============================
  /// 🚀 Habilitar / Deshabilitar
  /// ==============================

  /// Ver si una lista está deshabilitada
  bool isDisabled(String id) => _disabled[id] ?? false;

  /// Deshabilitar una lista por id
  void disable(String id) {
    _disabled[id] = true;
    notifyListeners();
  }

  /// Habilitar una lista por id
  void enable(String id) {
    _disabled[id] = false;
    notifyListeners();
  }

  /// Cambiar estado habilitado/deshabilitado
  void setDisabled(String id, bool disabled) {
    _disabled[id] = disabled;
    notifyListeners();
  }

  /// Deshabilitar varias listas a la vez
  void disableMany(List<String> ids) {
    for (var id in ids) {
      _disabled[id] = true;
    }
    notifyListeners();
  }

  /// Habilitar varias listas a la vez
  void enableMany(List<String> ids) {
    for (var id in ids) {
      _disabled[id] = false;
    }
    notifyListeners();
  }
}