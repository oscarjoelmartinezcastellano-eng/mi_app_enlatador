import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CounterProvider extends ChangeNotifier {
  final Map<String, double> _counters = {
    'enlatado_tab1_counter1': 0,
    'enlatado_tab2_counter1': 0,
    'enlatado_tab2_counter2': 0,
    'enlatado_tab2_counter3': 0,
    'enlatado_tab2_counter4': 0,
    'enlatado_tab2_counter5': 0,
    'enlatado_tab2_counter6': 0,
    'enlatado_tab2_counter7': 0,
    'enlatado_tab2_counter8': 0,
    'enlatado_tab2_counter9': 0,
    'enlatado_tab2_counter10': 0,
    'loteLata_counter1': 0,
  };

  /// 🔒 Mapa para controlar habilitado/deshabilitado por id
  final Map<String, bool> _disabled = {};

  /// Cargar los valores guardados
  Future<void> loadCounters() async {
    final prefs = await SharedPreferences.getInstance();
    for (var key in _counters.keys) {
      _counters[key] = prefs.getDouble('counter_$key') ?? 0.0;
    }
    notifyListeners();
  }

  /// Establecer un valor y guardarlo
  Future<void> setValue(String id, double value) async {
    _counters[id] = value;
    Future.microtask(() => notifyListeners());

    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('counter_$id', value);
  }

  double? getValue(String id) => _counters[id];

  Map<String, double> getAllValues() => Map.from(_counters);

  Future<void> limpiarContersPorFiltro(String filtro) async {
    final prefs = await SharedPreferences.getInstance();
    for (var key in _counters.keys) {
      if (key.contains(filtro)) {
        _counters[key] = 0.0;
        await prefs.remove('counter_$key');
      }
    }
    notifyListeners();
  }

  // 🚀 --- NUEVO CÓDIGO PARA HABILITAR/DESHABILITAR ---

  /// Ver si un contador está deshabilitado
  bool isDisabled(String id) => _disabled[id] ?? false;

  /// Deshabilitar un contador por id
  void disable(String id) {
    _disabled[id] = true;
    notifyListeners();
  }

  /// Habilitar un contador por id
  void enable(String id) {
    _disabled[id] = false;
    notifyListeners();
  }

  /// Cambiar estado habilitado/deshabilitado
  void setDisabled(String id, bool disabled) {
    _disabled[id] = disabled;
    notifyListeners();
  }

  /// Deshabilitar varios contadores a la vez
  void disableMany(List<String> ids) {
    for (var id in ids) {
      _disabled[id] = true;
    }
    notifyListeners();
  }

  /// Habilitar varios contadores a la vez
  void enableMany(List<String> ids) {
    for (var id in ids) {
      _disabled[id] = false;
    }
    notifyListeners();
  }
}
