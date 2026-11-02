import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/global_states_provider.dart';
import '../providers/comentario_provider.dart';

class ComentarioWidget extends StatefulWidget {
  final String id;
  final String label;
  final String controlSource; // 'global_states_provider' o cualquier otro valor

  const ComentarioWidget({
    super.key,
    required this.id,
    required this.label,
    required this.controlSource,
  });

  @override
  State<ComentarioWidget> createState() => _ComentarioWidgetState();
}

class _ComentarioWidgetState extends State<ComentarioWidget> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();

    final comentarioProvider = context.read<ComentarioProvider>();
    _controller = TextEditingController(
      text: comentarioProvider.getComentario(widget.id),
    );

    _controller.addListener(() {
      final enabled = _isWidgetEnabled();
      if (enabled) {
        context.read<ComentarioProvider>().setComentario(
              widget.id,
              _controller.text,
            );
      }
    });
  }

  /// ✅ Revisa tanto GlobalStatesProvider como isDisabled del ComentarioProvider
  bool _isWidgetEnabled() {
    if (widget.controlSource == 'global_states_provider') {
      return context.read<GlobalStatesProvider>().widgetsEnabled;
    }
    return !context.read<ComentarioProvider>().isDisabled(widget.id);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final comentarioProvider = context.watch<ComentarioProvider>();
    final comentario = comentarioProvider.getComentario(widget.id);

    // ✅ Calcular estado habilitado
    final enabled = widget.controlSource == 'global_states_provider'
        ? context.watch<GlobalStatesProvider>().widgetsEnabled
        : !comentarioProvider.isDisabled(widget.id);

    // Mantener sincronizado el controlador
    if (_controller.text != comentario) {
      _controller.text = comentario;
      _controller.selection = TextSelection.fromPosition(
        TextPosition(offset: _controller.text.length),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              widget.label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: _controller,
              maxLines: null,
              enabled: enabled,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: enabled ? Colors.black : Colors.grey.shade500,
              ),
              onTapOutside: (_) {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade700, width: 1.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.green.shade700, width: 2.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade700, width: 1.0),
                ),
                disabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade700, width: 1.0),
                ),
                filled: true,
                fillColor: enabled ? Colors.white : Colors.grey.shade200,
              ),
            ),
          ],
        ),
      ),
    );
  }
}