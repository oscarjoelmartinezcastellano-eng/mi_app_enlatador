import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ImagenTimeProvider with ChangeNotifier {
  final Map<String, String> _tiempos = {
    'enlatado_tab1_time1': '00:00:00',
  };

  /// 🔒 Mapa para controlar habilitado/deshabilitado por id
  final Map<String, bool> _disabled = {};

  /// ==============================
  /// CRUD de Tiempos
  /// ==============================

  /// Carga los tiempos guardados desde SharedPreferences
  Future<void> loadTiempos() async {
    final prefs = await SharedPreferences.getInstance();
    for (var key in _tiempos.keys) {
      _tiempos[key] = prefs.getString('imagen_time_$key') ?? '00:00:00';
      _disabled[key] = prefs.getBool('imagen_time_disabled_$key') ?? false;
    }
    notifyListeners();
  }

  /// Establece el tiempo para un identificador y lo guarda
  Future<void> setTime(String id, String time) async {
    _tiempos[id] = time;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('imagen_time_$id', time);
  }

  /// Obtiene el tiempo actual para un identificador
  String getTime(String id) => _tiempos[id] ?? '00:00:00';

  /// Devuelve todos los tiempos
  Map<String, String> getAllTiempos() => Map.from(_tiempos);

  /// Reinicia los tiempos a "00:00:00" y limpia SharedPreferences
  Future<void> limpiarTiemposPorFiltro(String filtro) async {
    final prefs = await SharedPreferences.getInstance();
    for (var key in _tiempos.keys) {
      if (key.contains(filtro)) {
        _tiempos[key] = '00:00:00';
        await prefs.remove('imagen_time_$key');
      }
    }
    notifyListeners();
  }

  Future<void> limpiarTodos() async {
    final prefs = await SharedPreferences.getInstance();
    for (var key in _tiempos.keys) {
      _tiempos[key] = '00:00:00';
      await prefs.remove('imagen_time_$key');
    }
    notifyListeners();
  }

  // 🚀 --- NUEVO CÓDIGO PARA HABILITAR/DESHABILITAR ---

  /// Ver si un tiempo está deshabilitado
  bool isDisabled(String id) => _disabled[id] ?? false;

  /// Deshabilitar un tiempo por id
  void disable(String id) {
    _disabled[id] = true;
    notifyListeners();
  }

  /// Habilitar un tiempo por id
  void enable(String id) {
    _disabled[id] = false;
    notifyListeners();
  }

  /// Cambiar estado habilitado/deshabilitado
  void setDisabled(String id, bool disabled) {
    _disabled[id] = disabled;
    notifyListeners();
  }

  /// Deshabilitar varios tiempos a la vez
  void disableMany(List<String> ids) {
    for (var id in ids) {
      _disabled[id] = true;
    }
    notifyListeners();
  }

  /// Habilitar varios tiempos a la vez
  void enableMany(List<String> ids) {
    for (var id in ids) {
      _disabled[id] = false;
    }
    notifyListeners();
  }
}