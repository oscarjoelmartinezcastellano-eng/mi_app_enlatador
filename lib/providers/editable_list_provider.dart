import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditableListProvider with ChangeNotifier {
  final Map<String, List<Map<String, dynamic>>> _lists = {
    'selladoLatas_list1': [],
    'selladoLatas_list2': [],
  };

  final Map<String, Map<String, bool>> _disabled = {};

  // ==============================
  // Cargar datos desde SharedPreferences
  // ==============================
  Future<void> loadLists() async {
    final prefs = await SharedPreferences.getInstance();
    for (var key in _lists.keys) {
      if (_lists[key]!.isNotEmpty) continue;

      final String? jsonString = prefs.getString('multi_list_$key');
      if (jsonString != null) {
        try {
          List<dynamic> decoded = json.decode(jsonString);
          _lists[key] = decoded.map((e) => Map<String, dynamic>.from(e)).toList();
        } catch (_) {}
      }
    }
    notifyListeners();
  }

  // ==============================
  // CRUD de listas
  // ==============================
  List<Map<String, dynamic>> getList(String id) => _lists[id] ?? [];


  Map<String, dynamic> getAllValues() => Map.from(_lists);


  Future<void> addItem(String id, String value, {Color color = Colors.black}) async {
    _lists.putIfAbsent(id, () => []);

    final newItem = {
      "id": DateTime.now().millisecondsSinceEpoch.toString(), // 🔑 id único
      "value": value,
      "color": color.value, // ✅ Guardamos el color como int
    };

    _lists[id]!.add(newItem);

    await _saveToPrefs(id);
    notifyListeners();
  }

  Future<void> removeItem(String id, String itemId) async {
    _lists[id]?.removeWhere((item) => item["id"] == itemId);
    _disabled[id]?.remove(itemId);

    await _saveToPrefs(id);
    notifyListeners();
  }

  Future<void> updateItem(String id, String itemId, String newValue) async {
    final index = _lists[id]?.indexWhere((item) => item["id"] == itemId);
    if (index != null && index >= 0) {
      _lists[id]![index]["value"] = newValue;
      await _saveToPrefs(id);
      notifyListeners();
    }
  }

  // ==============================
  // Habilitar / Deshabilitar
  // ==============================
  bool isDisabled(String id, String itemId) => _disabled[id]?[itemId] ?? false;

  void disable(String id, String itemId) {
    _disabled.putIfAbsent(id, () => {});
    _disabled[id]![itemId] = true;
    notifyListeners();
  }

  void enable(String id, String itemId) {
    _disabled.putIfAbsent(id, () => {});
    _disabled[id]![itemId] = false;
    notifyListeners();
  }

  // ==============================
  // Limpiar una lista completa
  // ==============================
  Future<void> clearList(String id) async {
    if (_lists.containsKey(id)) {
      _lists[id] = [];        // Limpia en memoria
      _disabled[id] = {};     // Limpia estados de disabled

      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('multi_list_$id'); // Borra del almacenamiento

      notifyListeners();
    }
  }

  // ==============================
  // Persistencia
  // ==============================
  Future<void> _saveToPrefs(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = json.encode(_lists[id]);
    await prefs.setString('multi_list_$id', jsonString);
  }
}
