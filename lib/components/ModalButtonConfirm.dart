import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/list_options_provider.dart'; // o tu ModalButtonProvider

class ModalButtonConfirm extends StatelessWidget {
  final String id;              // ID único para controlar habilitar/deshabilitar
  final String buttonText;
  final String dialogTitle;
  final Widget dialogContent;   // Puede ser cualquier widget
  final List<Widget> actions;   // Lista dinámica de botones
  final double? width;
  final double? height;
  final Color? buttonColor;     // Color del botón
  final Color? textColor;       // Color del texto del botón
  final bool box;               // Para mostrar o no el modal
  final TextStyle? textStyle;   // Estilo del texto del botón

  const ModalButtonConfirm({
    super.key,
    required this.id,
    this.buttonText = 'Mostrar Modal',
    this.dialogTitle = 'Confirmación',
    this.dialogContent = const Text('¿Estás seguro?'),
    this.actions = const [],
    this.width,
    this.height,
    this.buttonColor,
    this.textColor,
    this.box = true,
    this.textStyle,
  });

  void _showModal(BuildContext context) {
    if (!box) return;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(dialogTitle),
          content: dialogContent,
          actions: actions.isNotEmpty
              ? actions
              : [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancelar'),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Aceptar'),
                  ),
                ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Usamos ListOptionsProvider o el que tenga isDisabled
    final listProvider = context.watch<ListOptionsProvider>();
    final bool isEnabled = !listProvider.isDisabled(id); // Respetar isDisabled

    final button = ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonColor ?? Theme.of(context).primaryColor,
        foregroundColor: textColor ?? Colors.white,
      ),
      onPressed: isEnabled ? () => _showModal(context) : null,
      child: Text(
        buttonText,
        style: textStyle ?? const TextStyle(fontSize: 10),
      ),
    );

    if (width != null || height != null) {
      return SizedBox(
        width: width,
        height: height,
        child: button,
      );
    }

    return button;
  }
}