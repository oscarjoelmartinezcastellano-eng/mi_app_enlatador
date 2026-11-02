import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/select_options_provider.dart';
import '../providers/global_states_provider.dart';

class SelectOptionsWidget extends StatelessWidget {
  final String id;
  final String label;
  final List<String> options;
  final double width;
  final double height;
  final String controlSource;
  final void Function(String)? onChanged;

  const SelectOptionsWidget({
    super.key,
    required this.id,
    required this.label,
    required this.options,
    required this.width,
    required this.height,
    required this.controlSource,
    this.onChanged,
  });

  bool _isWidgetEnabled(BuildContext context, SelectOptionsProvider selectProvider) {
    // Si el SelectOptionsProvider indica que está deshabilitado → false
    if (selectProvider.isDisabled(id)) return false;

    // Si viene de GlobalStatesProvider → retorna widgetsEnabled
    if (controlSource == 'global_states_provider') {
      return context.watch<GlobalStatesProvider>().widgetsEnabled;
    }

    // Por defecto → habilitado
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final selectProvider = context.watch<SelectOptionsProvider>();
    final bool enabled = _isWidgetEnabled(context, selectProvider);
    final selectedValue = selectProvider.getSelectedValue(id) ?? options.first;

    // Inicializar valor por defecto solo si no está definido y el widget está habilitado
    if (selectProvider.getSelectedValue(id) == null && enabled) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        selectProvider.setSelectedValue(id, options.first);
      });
    }

    return SizedBox(
      width: width,
      height: height,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Container(
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(
                  color: enabled ? Colors.grey.shade700 : Colors.grey.shade400,
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(8),
                color: enabled ? Colors.white : Colors.grey.shade200,
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedValue,
                  isExpanded: true,
                  items: options.map((option) {
                    return DropdownMenuItem<String>(
                      value: option,
                      child: Center(
                        child: Text(
                          option,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: enabled
                      ? (newValue) {
                          if (newValue != null) {
                            selectProvider.setSelectedValue(id, newValue);
                            if (onChanged != null) onChanged!(newValue);
                          }
                        }
                      : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}