import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/editable_list_provider.dart';

class EditableListWidget extends StatefulWidget {
  final String id;
  final String label;

  const EditableListWidget({super.key, required this.id, required this.label});

  @override
  State<EditableListWidget> createState() => _EditableListWidgetState();
}

class _EditableListWidgetState extends State<EditableListWidget> {
  final Map<String, TextEditingController> _editControllers = {};

  @override
  void dispose() {
    for (var c in _editControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<EditableListProvider>();
    final items = provider.getList(widget.id);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          widget.label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        items.isEmpty
            ? const Center(child: Text('No hay elementos'))
            : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index]; // { "id": "...", "value": "...", "color": ... }
                  final itemId = item["id"] as String;
                  final itemValue = item["value"] as String;
                  final itemColor = Color(item["color"] ?? Colors.black.value);

                  // Crear controller si no existe
                  _editControllers.putIfAbsent(
                      itemId, () => TextEditingController(text: itemValue));
                  final editController = _editControllers[itemId]!;

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: TextField(
                            controller: editController,
                            onChanged: (value) {
                              provider.updateItem(widget.id, itemId, value);
                            },
                            textAlign: TextAlign.center, // 👈 Centrar texto
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 12),
                            ),
                            style: TextStyle(
                              fontSize: 16,
                              color: itemColor, // ✅ Aplica color del provider
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            provider.removeItem(widget.id, itemId);
                            _editControllers.remove(itemId)?.dispose();
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
      ],
    );
  }
}