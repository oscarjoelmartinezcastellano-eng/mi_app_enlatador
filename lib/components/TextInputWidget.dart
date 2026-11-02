import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/global_states_provider.dart';
import '../providers/text_input_provider.dart';

class TextInputWidget extends StatefulWidget {
  final String id;
  final String label;
  final double width;
  final double height;
  final String controlSource;

  const TextInputWidget({
    super.key,
    required this.id,
    required this.label,
    this.width = double.infinity,
    this.height = 120,
    required this.controlSource,
  });

  @override
  State<TextInputWidget> createState() => _TextInputWidgetState();
}

class _TextInputWidgetState extends State<TextInputWidget> {
  late TextEditingController _controller;
  TextInputProvider? _textInputProvider;
  VoidCallback? _listener;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();

    _listener = () {
      if (_textInputProvider == null) return;

      final newValue = _textInputProvider!.getValue(widget.id) ?? '';

      if (newValue != _controller.text) {
        final selection = _controller.selection;

        _controller.value = TextEditingValue(
          text: newValue,
          selection: TextSelection(
            baseOffset: selection.baseOffset.clamp(0, newValue.length),
            extentOffset: selection.extentOffset.clamp(0, newValue.length),
          ),
        );
      }
    };
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final oldProvider = _textInputProvider;
    _textInputProvider = context.read<TextInputProvider>();

    if (oldProvider != _textInputProvider) {
      oldProvider?.removeListener(_listener!);
      _textInputProvider?.addListener(_listener!);
      _controller.text = _textInputProvider?.getValue(widget.id) ?? '';
    }
  }

  @override
  void dispose() {
    _textInputProvider?.removeListener(_listener!);
    _controller.dispose();
    super.dispose();
  }

  bool _isWidgetEnabled(BuildContext context) {
    final globalEnabled =
        widget.controlSource == 'global_states_provider'
            ? context.watch<GlobalStatesProvider>().widgetsEnabled
            : true;

    final providerEnabled =
        !(_textInputProvider?.isDisabled(widget.id) ?? false);

    return globalEnabled && providerEnabled;
  }

  @override
  Widget build(BuildContext context) {
    final enabled = _isWidgetEnabled(context);

    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Text(
                widget.label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 6),
            Expanded(
              child: TextField(
                controller: _controller,
                enabled: enabled,
                expands: true,
                maxLines: null,
                minLines: null,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
                textAlign: TextAlign.left,
                textAlignVertical: TextAlignVertical.top,
                style: TextStyle(
                  color: enabled
                      ? Colors.black
                      : Colors.grey.shade500,
                ),
                onChanged: enabled
                    ? (value) =>
                        _textInputProvider?.setValue(widget.id, value)
                    : null,
                onTapOutside: (_) =>
                    FocusManager.instance.primaryFocus?.unfocus(),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(10),
                  filled: true,
                  fillColor: enabled
                      ? Colors.white
                      : Colors.grey.shade200,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: Colors.grey.shade700,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: Colors.grey.shade700,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: Colors.green.shade700,
                      width: 2,
                    ),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: Colors.grey.shade500,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}