import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/global_states_provider.dart';
import '../providers/counter_provider.dart';

class EditableCounterWidget extends StatefulWidget {
  final String id;
  final String label;
  final String controlSource;

  const EditableCounterWidget({
    super.key,
    required this.id,
    required this.label,
    required this.controlSource,
  });

  @override
  State<EditableCounterWidget> createState() => _EditableCounterWidgetState();
}

class _EditableCounterWidgetState extends State<EditableCounterWidget> {
  late TextEditingController _controller;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();

    _controller.addListener(() {
      _isEditing = true;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Recuperar valor inicial del provider
    final providerValue =
        context.read<CounterProvider>().getValue(widget.id) ?? 0.0;

    _controller.text = providerValue.toString();
  }

  void _syncWithProvider() {
    final providerValue =
        context.read<CounterProvider>().getValue(widget.id) ?? 0.0;

    if (!_isEditing) {
      _controller.text = providerValue.toString();
    }
  }

  bool _isEnabled(BuildContext context) {
    final counterProvider = context.read<CounterProvider>();

    if (counterProvider.isDisabled(widget.id)) return false;

    if (widget.controlSource == 'global_states_provider') {
      return context.watch<GlobalStatesProvider>().widgetsEnabled;
    }

    return true;
  }

  void _updateCounter(double newValue) {
    if (newValue < 0) newValue = 0;

    context.read<CounterProvider>().setValue(widget.id, newValue);

    _controller.text = newValue.toString();
    _controller.selection = TextSelection.fromPosition(
      TextPosition(offset: _controller.text.length),
    );

    _isEditing = false;
  }

  @override
  Widget build(BuildContext context) {
    final enabled = _isEnabled(context);

    // 🔥 Esto hace que cuando setValue() cambia,
    // el widget se redibuje y se sincronice el controller.
    final providerValue =
        context.watch<CounterProvider>().getValue(widget.id) ?? 0.0;

    _syncWithProvider();

    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.remove),
                onPressed:
                    enabled ? () => _updateCounter(providerValue - 1) : null,
              ),

              SizedBox(
                width: 80,
                height: 40,
                child: TextField(
                  controller: _controller,
                  enabled: enabled,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  textAlign: TextAlign.center,
                  onTap: () {
                    _controller.selection = TextSelection.fromPosition(
                      TextPosition(offset: _controller.text.length),
                    );
                  },
                  onTapOutside: (_) {
                    FocusManager.instance.primaryFocus?.unfocus();
                    _isEditing = false;
                    final parsed = double.tryParse(_controller.text);
                    _updateCounter(parsed ?? 0.0);
                  },
                  onChanged: (value) {
                    final parsed = double.tryParse(value);
                    if (parsed != null) {
                      // solo se guarda en variable local
                    }
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.grey.shade700, width: 1.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.green.shade700, width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.grey.shade700, width: 1.0),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.grey.shade700, width: 1.0),
                    ),
                    filled: true,
                    fillColor: enabled ? Colors.white : Colors.grey.shade200,
                  ),
                ),
              ),

              IconButton(
                icon: const Icon(Icons.add),
                onPressed:
                    enabled ? () => _updateCounter(providerValue + 1) : null,
              ),
            ],
          ),
        ],
      ),
    );
  }
}