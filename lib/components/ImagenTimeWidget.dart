import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/imagen_time_provider.dart';
import '../providers/global_states_provider.dart';

class ImagenTimeWidget extends StatefulWidget {
  final String rutaAsset;
  final String labelArriba;
  final String id;
  final String controlSource;
  final double altura;
  final double ancho;
  final VoidCallback? onPressed;

  const ImagenTimeWidget({
    super.key,
    required this.rutaAsset,
    required this.labelArriba,
    required this.id,
    required this.controlSource,
    required this.altura,
    required this.ancho,
    this.onPressed,
  });

  @override
  State<ImagenTimeWidget> createState() => _ImagenTimeWidgetState();
}

class _ImagenTimeWidgetState extends State<ImagenTimeWidget> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final provider = Provider.of<ImagenTimeProvider>(context, listen: false);

    if (provider.getTime(widget.id).isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        provider.setTime(widget.id, '00:00:00');
      });
    }
  }

  /// ✅ Revisa tanto GlobalStatesProvider como isDisabled en ImagenTimeProvider
  bool _isEnabled(bool widgetsEnabled) {
    if (widget.controlSource == 'global_states_provider') {
      return widgetsEnabled;
    }
    return !context.read<ImagenTimeProvider>().isDisabled(widget.id);
  }

  void _updateTime(bool widgetsEnabled) {
    if (!_isEnabled(widgetsEnabled)) return;

    final now = DateTime.now();
    final formattedTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);

    Provider.of<ImagenTimeProvider>(context, listen: false)
        .setTime(widget.id, formattedTime);

    widget.onPressed?.call();
  }

  @override
  Widget build(BuildContext context) {
    final widgetsEnabled = context.watch<GlobalStatesProvider>().widgetsEnabled;
    final imagenTimeProvider = context.watch<ImagenTimeProvider>();
    final currentTime = imagenTimeProvider.getTime(widget.id);

    // ✅ Evaluamos si está habilitado
    final isEnabled = widget.controlSource == 'global_states_provider'
        ? widgetsEnabled
        : !imagenTimeProvider.isDisabled(widget.id);

    return GestureDetector(
      onTap: isEnabled ? () => _updateTime(widgetsEnabled) : null,
      child: Opacity(
        opacity: isEnabled ? 1.0 : 0.5,
        child: Column(
          children: [
            Text(
              widget.labelArriba,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            Image.asset(
              widget.rutaAsset,
              height: widget.altura,
              width: widget.ancho,
            ),
            // ✅ Si está bloqueado, se muestra el valor actual (ej. "00:00:00")
            Text(currentTime),
          ],
        ),
      ),
    );
  }
}
