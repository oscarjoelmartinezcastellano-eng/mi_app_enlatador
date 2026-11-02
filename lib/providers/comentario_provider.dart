import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ComentarioProvider with ChangeNotifier {
  final Map<String, String> _comentarios = {
    'enlatado_tab1_comentario1': '',
    'enlatado_tab2_comentario1': '',
    'loteLata_comentario1': '',
  };

  /// 🔒 Mapa para controlar habilitado/deshabilitado por id
  final Map<String, bool> _disabled = {};

  /// ==============================
  /// CRUD de Comentarios
  /// ==============================

  Future<void> loadComentarios() async {
    final prefs = await SharedPreferences.getInstance();
    for (final key in _comentarios.keys) {
      _comentarios[key] = prefs.getString('comentario_$key') ?? '';
      _disabled[key] = prefs.getBool('comentario_disabled_$key') ?? false;
    }
    notifyListeners();
  }

  Future<void> setComentario(String id, String value) async {
    if (!_comentarios.containsKey(id)) return;

    _comentarios[id] = value;
    Future.microtask(() => notifyListeners());

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('comentario_$id', value);
  }

  String getComentario(String id) => _comentarios[id] ?? '';

  Map<String, String> getAllComentarios() => Map.from(_comentarios);

  Future<void> limpiarComentariosPorFiltro(String filtro) async {
    final prefs = await SharedPreferences.getInstance();
    for (final key in _comentarios.keys) {
      if (key.contains(filtro)) {
        _comentarios[key] = '';
        await prefs.remove('comentario_$key');
      }
    }
    notifyListeners();
  }

  Future<void> limpiarTodos() async {
    final prefs = await SharedPreferences.getInstance();
    for (final key in _comentarios.keys) {
      _comentarios[key] = '';
      await prefs.remove('comentario_$key');
    }
    notifyListeners();
  }

  // 🚀 --- NUEVO CÓDIGO PARA HABILITAR/DESHABILITAR ---

  /// Ver si un comentario está deshabilitado
  bool isDisabled(String id) => _disabled[id] ?? false;

  /// Deshabilitar un comentario por id
  void disable(String id) {
    _disabled[id] = true;
    notifyListeners();
  }

  /// Habilitar un comentario por id
  void enable(String id) {
    _disabled[id] = false;
    notifyListeners();
  }

  /// Cambiar estado habilitado/deshabilitado
  void setDisabled(String id, bool disabled) {
    _disabled[id] = disabled;
    notifyListeners();
  }

  /// Deshabilitar varios comentarios a la vez
  void disableMany(List<String> ids) {
    for (var id in ids) {
      _disabled[id] = true;
    }
    notifyListeners();
  }

  /// Habilitar varios comentarios a la vez
  void enableMany(List<String> ids) {
    for (var id in ids) {
      _disabled[id] = false;
    }
    notifyListeners();
  }
}