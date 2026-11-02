import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/global_states_provider.dart';
import '../providers/list_options_provider.dart';

class ListOptionsButtonWidget extends StatelessWidget {
  final String id;
  final String label;
  final List<String> options;
  final double width;
  final double height;
  final String controlSource;

  const ListOptionsButtonWidget({
    super.key,
    required this.id,
    required this.label,
    required this.options,
    this.width = double.infinity,
    this.height = 40,
    required this.controlSource,
  });

  /// ✅ Ahora revisa tanto GlobalStatesProvider como ListOptionsProvider.isDisabled
  bool _isEnabled(BuildContext context) {
    if (controlSource == 'global_states_provider') {
      return context.watch<GlobalStatesProvider>().widgetsEnabled;
    }
    return !context.read<ListOptionsProvider>().isDisabled(id);
  }

  void _showOptionsModal(
    BuildContext context,
    bool enabled,
    ListOptionsProvider listProvider,
  ) {
    final ScrollController scrollController = ScrollController();
    List<String> tempSelected = List.from(listProvider.getSelectedValues(id));

    showDialog(
      context: context,
      builder: (_) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
          child: SizedBox(
            width: width * 1.2,
            height: MediaQuery.of(context).size.height * 0.6,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Center(
                    child: Text(
                      label,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const Divider(height: 1),
                Expanded(
                  child: StatefulBuilder(
                    builder: (context, setState) {
                      return Scrollbar(
                        controller: scrollController,
                        thumbVisibility: true,
                        child: ListView(
                          controller: scrollController,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          children: options.map((option) {
                            final isChecked = tempSelected.contains(option);
                            return CheckboxListTile(
                              value: isChecked,
                              onChanged: enabled
                                  ? (value) {
                                      setState(() {
                                        if (value == true) {
                                          tempSelected.add(option);
                                        } else {
                                          tempSelected.remove(option);
                                        }
                                      });
                                      if (value == true) {
                                        listProvider.addValue(id, option);
                                      } else {
                                        listProvider.removeValue(id, option);
                                      }
                                    }
                                  : null,
                              title: Text(option),
                              controlAffinity: ListTileControlAffinity.leading,
                              dense: true,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                            );
                          }).toList(),
                        ),
                      );
                    },
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cerrar'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final listProvider = context.watch<ListOptionsProvider>();

    /// ✅ Verificamos habilitación desde provider o global
    final bool enabled = controlSource == 'global_states_provider'
        ? context.watch<GlobalStatesProvider>().widgetsEnabled
        : !listProvider.isDisabled(id);

    final selectedValues = listProvider.getSelectedValues(id);
    final selectedSummary = selectedValues.isEmpty ? '' : selectedValues.join(', ');

    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          SizedBox(
            height: height,
            child: ElevatedButton(
              onPressed: enabled ? () => _showOptionsModal(context, enabled, listProvider) : null,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size(width, height),
                side: BorderSide(color: Colors.grey.shade700, width: 1.0),
              ),
              child: Center(
                child: Text(
                  selectedSummary,
                  style: TextStyle(
                    fontSize: 12,
                    color: enabled ? Colors.black : Colors.black38,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}